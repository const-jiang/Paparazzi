//
//  GZRootViewController.m
//  Paparazzi
//
//  Created by jiangtian on 16-3-31.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//

#import "GZRootViewController.h"
#import "GZCate.h"
#import "GZCateFrame.h"
#import "MJExtension.h"
#import "GZCateCell.h"
#import "SDWebImageManager.h"
#import "FullViewController.h"
#import "FMGVideoPlayView.h"
#import "AFNetworking.h"
#import "GZWebViewController.h"
#import "MJRefresh.h"
#import "GZTool.h"

#define GZNavShowAnimDuration 0.25
#define GZCoverTag 100

@interface GZRootViewController ()<FMGVideoPlayViewDelegate>

@property (nonatomic, strong) NSMutableArray *cateFrames;

#warning 用strong 会不会存在内存泄露？？
@property (nonatomic, strong) FMGVideoPlayView * fmVideoPlayer; // 播放器
/* 全屏控制器 */
@property (nonatomic, strong) FullViewController *fullVc;

@property (nonatomic,strong) GZWebViewController *webViewController;

@end

@implementation GZRootViewController

- (GZWebViewController *)webViewController
{
    if (_webViewController == nil) {
        _webViewController = [[GZWebViewController alloc] init];
    }
    return _webViewController;
}


- (NSMutableArray *)cateFrames
{
    if (!_cateFrames) {
        self.cateFrames = [NSMutableArray array];
    }
    return _cateFrames;
}

- (FullViewController *)fullVc
{
    if (_fullVc == nil) {
        _fullVc = [[FullViewController alloc] init];
    }
    return _fullVc;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"fenlei" target:self action:@selector(leftMenu)];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideo:) name:PlayVideoNotification object:nil];

    [self loadNewDatas];
    
    [self setupRefresh];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PlayVideoNotification object:nil];
}

- (void)setupRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDatas)];
    self.tableView.header.automaticallyChangeAlpha = YES;
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDatas)];
}

- (void)loadNewDatas
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    //修复"Request failed: unacceptable content-type: text/html" 错误
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *url = @"http://v.sogou.com/app/weiyuedu/get_weiyuedu_items/";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cate_id"] = [self cate_id];
    params[@"order_id"] = @"-1";
    params[@"os"] = @"ios";
    params[@"page_size"] = @"100";
    params[@"userKey"] = UserKey;
    
    [mgr POST:url parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
          NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
          
          NSArray *cates = [GZCate objectArrayWithKeyValuesArray:dict[@"data_list"]];
          self.cateFrames = [self cateFramesWithCates:cates];
          
          [self.tableView reloadData];
          
          // 结束刷新
          [self.tableView.header endRefreshing];
          
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"请求失败:%@",error);
          [self.tableView.header endRefreshing];
      }];
    
}

- (void)loadMoreDatas
{
    //order_id大于0时，请求比order_id小的数据
    GZCate *cate = [[self.cateFrames lastObject] cate];
    NSInteger order_id = cate.order_id;
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *url = @"http://v.sogou.com/app/weiyuedu/get_weiyuedu_items/";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cate_id"] = [self cate_id];
    params[@"order_id"] = [NSNumber numberWithInteger:order_id];
    params[@"os"] = @"ios";
    params[@"page_size"] = @"20";
    params[@"userKey"] = UserKey;
    
    [mgr POST:url parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
          NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
          
          NSArray *cates = [GZCate objectArrayWithKeyValuesArray:dict[@"data_list"]];
          [self.cateFrames addObjectsFromArray:[self cateFramesWithCates:cates]];
          
          [self.tableView reloadData];
          [self.tableView.footer endRefreshing];
          
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"请求失败:%@",error);
          [self.tableView.footer endRefreshing];
      }];
}

- (NSString *)cate_id
{
    return @"16";
}

/**
 *  将GZCate模型转为GZCateFrame模型
 */
- (NSMutableArray *)cateFramesWithCates:(NSArray *)cates
{
    NSMutableArray *frames = [NSMutableArray array];
    for (GZCate *cate in cates) {
        GZCateFrame *f = [[GZCateFrame alloc] init];
        f.cate = cate;
        [frames addObject:f];
    }
    return frames;
    
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cateFrames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GZCateCell *cell = [GZCateCell cellWithTableView:tableView];
    
    cell.cateFrame = self.cateFrames[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GZCateFrame *frame = self.cateFrames[indexPath.row];
    return frame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_fmVideoPlayer) {
        [_fmVideoPlayer.player pause];
        [_fmVideoPlayer removeFromSuperview];
        _fmVideoPlayer = nil;
    }
    
    GZCateFrame *frame = self.cateFrames[indexPath.row];
    
    GZWebViewController *webViewController = [[GZWebViewController alloc] init];
    webViewController.url = frame.cate.detail_url;
    [self.navigationController pushViewController:webViewController animated:YES];
  
}


// 根据Cell位置暂停播放
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //暂停播放,但是播放器继续保留，不释放
    if (indexPath.row == _fmVideoPlayer.index) {
        [_fmVideoPlayer.player pause];
        _fmVideoPlayer.playOrPauseBtn.selected = NO;
        [_fmVideoPlayer removeFromSuperview];
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_fmVideoPlayer && indexPath.row == _fmVideoPlayer.index) {
        
        GZCateFrame *cateFrame = self.cateFrames[indexPath.row];
        _fmVideoPlayer.frame = cateFrame.videoViewF;
        [cell.contentView addSubview:_fmVideoPlayer];
    }
    
}

- (void)playVideo:(NSNotification *)notification
{
    GZCateFrame *cateFrame = notification.userInfo[@"cateFrame"];
    NSUInteger index = [self.cateFrames indexOfObject:cateFrame];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    GZCateCell *cell = (GZCateCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        NSString *videoURL =  cateFrame.cate.video_url;
        [GZTool parseVideoURL:videoURL success:^(NSString *url) {
            
            if (_fmVideoPlayer) {
                [_fmVideoPlayer.player pause];
                [_fmVideoPlayer removeFromSuperview];
                _fmVideoPlayer = nil;
            }
            
            _fmVideoPlayer = [FMGVideoPlayView videoPlayView];
            _fmVideoPlayer.delegate = self;
            
            _fmVideoPlayer.index = index;
            [_fmVideoPlayer setUrlString:url];
            _fmVideoPlayer.frame = cateFrame.videoViewF;
            [cell.contentView addSubview:_fmVideoPlayer];
            
            [_fmVideoPlayer.player play];
            [_fmVideoPlayer showToolView:NO];
            _fmVideoPlayer.playOrPauseBtn.selected = YES;
            
        } failure:^(NSError *error) {
            NSLog(@"请求失败:%@",error);
        }];
    }
   
}

- (void)videoplayViewSwitchOrientation:(BOOL)isFull{
    if (isFull) { //全屏
        [self presentViewController:self.fullVc animated:NO completion:^{
            [self.fullVc.view addSubview:self.fmVideoPlayer];
            _fmVideoPlayer.center = self.fullVc.view.center;
            
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                _fmVideoPlayer.frame = self.fullVc.view.bounds;
                
            } completion:nil];
        }];
        
      } else { // 退出全屏
          
          /*
            ios8中，在全屏播放视频的情况下，旋转屏幕会提前加载GZLengzishiViewController、GZVideoViewController等控制器的view，而此时ScreenW和ScreenH为被旋转后屏幕的宽和高。因此在计算GZCateCell宽度时，需要比较ScreenW和ScreenH的值，选择小的作为GZCateCell的宽度
           */
          
          // ios8中会出现下面这种情况,此时需要对屏幕进行强制旋转
          if (self.interfaceOrientation != UIInterfaceOrientationPortrait) {
              
              [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
              
              /*
               对rootViewController的interfaceOrientation进行赋值，rootViewController的子控制器的interfaceOrientation都会改变
               
               如果只对self.navigationController的interfaceOrientation进行赋值，self.navigationController.interfaceOrientation、self.interfaceOrientation 并不会改变
               */
              [[[[UIApplication sharedApplication] keyWindow] rootViewController] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"interfaceOrientation"];
          }

        [self.fullVc dismissViewControllerAnimated:NO completion:^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_fmVideoPlayer.index inSection:0];
            GZCateCell *cell = (GZCateCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell.contentView addSubview:_fmVideoPlayer];
            _fmVideoPlayer.frame = cell.cateFrame.videoViewF;
            
//             NSLog(@"--[UIScreen mainScreen].bounds:%@",NSStringFromCGRect([UIScreen mainScreen].bounds));
//
//            NSLog(@"self.interfaceOrientation:%ld",self.interfaceOrientation);
//            NSLog(@"self.navigationController.interfaceOrientation:%ld",self.navigationController.interfaceOrientation);
//             UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
//            NSLog(@"keyWindow.rootViewController.interfaceOrientation:%ld",keyWindow.rootViewController.interfaceOrientation);
//            
//            NSLog(@"UIDevice.orientation:%ld",[[UIDevice currentDevice] orientation]);
            
        }];
    }
}

#pragma mark -实现抽屉效果
- (void)swipe:(UISwipeGestureRecognizer *)swipeGesture
{
    [self leftMenu];
}

- (void)leftMenu
{
    [UIView animateWithDuration:GZNavShowAnimDuration animations:^{
        
        UIView *navView = self.navigationController.view;
        
        // 缩放比例
        CGFloat navH = [UIScreen mainScreen].bounds.size.height - 2 * 60;
        CGFloat scale = navH / [UIScreen mainScreen].bounds.size.height;
        
        // 菜单左边的间距
        CGFloat leftMenuMargin = [UIScreen mainScreen].bounds.size.width * (1 - scale) * 0.5;
        CGFloat translateX = 230 - leftMenuMargin;
        
        CGFloat topMargin = [UIScreen mainScreen].bounds.size.height * (1 - scale) * 0.5;
        CGFloat translateY = topMargin - 60;
        
        // 缩放
        CGAffineTransform scaleForm = CGAffineTransformMakeScale(scale, scale);
        // 平移
        CGAffineTransform translateForm = CGAffineTransformTranslate(scaleForm, translateX / scale, -translateY / scale);
       
        navView.transform = translateForm;
        
        // 添加遮盖
        UIView *cover = [[UIView alloc] init];
        cover.tag = GZCoverTag;
        cover.frame = navView.bounds;
        [navView addSubview:cover];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClickOnCoverView:)];
        [cover addGestureRecognizer:tap];
        
        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tapClickOnCoverView:)];
        swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [cover addGestureRecognizer:swipeGesture];
    }];
}

- (void)tapClickOnCoverView:(UITapGestureRecognizer *)gesture
{
    [self coverClick:gesture.view];
}

- (void)coverClick:(UIView *)cover
{
    [UIView animateWithDuration:GZNavShowAnimDuration animations:^{
        self.navigationController.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [cover removeFromSuperview];
    }];
}

- (void)coverClick
{
    // 遮盖的view可能不存在
    //    NSLog(@"-- coverClick %@",[self.navigationController.view viewWithTag:HMCoverTag]);
    [self coverClick:[self.navigationController.view viewWithTag:GZCoverTag]];
}


@end
