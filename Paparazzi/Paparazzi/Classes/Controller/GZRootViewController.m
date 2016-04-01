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
    
//    self.tableView.backgroundColor = JTRandomColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"fenlei" target:self action:@selector(leftMenu)];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideo:) name:PlayVideoNotification object:nil];

     [self loadNewDatas];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PlayVideoNotification object:nil];
}

- (void)loadNewDatas
{
    
    // 1.创建一个请求操作管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    //修复"Request failed: unacceptable content-type: text/html" 错误
    // 声明：不要对服务器返回的数据进行解析，直接返回data即可。(默认返回JSON)
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 3.发送一个POST请求
    NSString *url = @"http://v.sogou.com/app/weiyuedu/get_weiyuedu_items/";
    [mgr POST:url parameters:[self requestParams]
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
          // 解析服务器返回的JSON数据
          NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
          
          NSArray *cates = [GZCate objectArrayWithKeyValuesArray:dict[@"data_list"]];
          self.cateFrames = [self cateFramesWithCates:cates];
          
          [self.tableView reloadData];
          
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          
          // 请求失败的时候调用调用这个block
          NSLog(@"请求失败:%@",error);
      }];
    
}

- (NSDictionary *)requestParams
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cate_id"] = @"16";
    params[@"order_id"] = @"-1";
    params[@"os"] = @"ios";
    params[@"page_size"] = @"100";
    params[@"userKey"] = @"13A2E4B8-06B2-428F-93CB-BC8F9EA0A065";
    return params;
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
    // 获得cell
    GZCateCell *cell = [GZCateCell cellWithTableView:tableView];
    
    // 给cell传递模型数据
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
    
    
#warning 这样写存在bug,看看怎么解决
    //如果webViewController 并不是用到时就创建一个新的时，会出现bug，具体现象就是，点击cell后webView会显示上一次的内容，然后加载新的内容
    //    GZCateFrame *frame = self.cateFrames[indexPath.row];
    //    [self presentViewController:self.webViewController animated:YES completion:^{
    //        [self.webViewController loadURL:frame.cate.detail_url];
    //    }];
    
    
    GZCateFrame *frame = self.cateFrames[indexPath.row];
    GZWebViewController *webViewController = [[GZWebViewController alloc] init];
    
    [self presentViewController:webViewController animated:YES completion:^{
        [webViewController loadURL:frame.cate.detail_url];
    }];
    
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
        // 创建一个请求操作管理者
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        
        // 声明：不要对服务器返回的数据进行解析，直接返回data即可。默认返回JSON
        mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSDictionary *jsonDic = @{
                                  @"appendix" : @{
                                          @"site" : @"",
                                          @"nextStep" : @""
                                          },
                                  @"cmd_results" : @[
                                          @""
                                          ],
                                  @"mobileInfo" : @{
                                          @"manufacturer" : @"apple",
                                          @"model" : @"iPhone",
                                          @"systemver" : @"9.2.1",
                                          @"type" : @"ios",
                                          @"appver" : @"4"
                                          },
                                  @"resource" : @{
                                          @"url" : videoURL,
                                          @"mplay_link" : @"",
                                          @"cookie" : @""
                                          }
                                  };
        
        NSString *jsonStr = [self dataToJsonString:jsonDic];
        
        // 设置请求参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"data"] = jsonStr;
        
        NSString *url = @"http://v.sogou.com/playservice/";
        [mgr POST:url parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
              
              NSArray *result_data =  dict[@"result_data"];
              if (result_data.count) {
                  
                  NSString *urlString =  result_data[0][@"videos"][0];
                  
                  if (_fmVideoPlayer) {
                      [_fmVideoPlayer.player pause];
                      [_fmVideoPlayer removeFromSuperview];
                      _fmVideoPlayer = nil;
                  }
                  
                  _fmVideoPlayer = [FMGVideoPlayView videoPlayView];
                  _fmVideoPlayer.delegate = self;
                  
                  _fmVideoPlayer.index = index;
                  [_fmVideoPlayer setUrlString:urlString];
                  _fmVideoPlayer.frame = cateFrame.videoViewF;
                  [cell.contentView addSubview:_fmVideoPlayer];
                  
                  [_fmVideoPlayer.player play];
                  [_fmVideoPlayer showToolView:NO];
                  _fmVideoPlayer.playOrPauseBtn.selected = YES;
              }

              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"请求失败:%@",error);
          }];
        
    }
   
}


-(NSString*)dataToJsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (void)videoplayViewSwitchOrientation:(BOOL)isFull{
    if (isFull) { //me: 全屏
        [self presentViewController:self.fullVc animated:NO completion:^{
            [self.fullVc.view addSubview:self.fmVideoPlayer];
            _fmVideoPlayer.center = self.fullVc.view.center;
            
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                _fmVideoPlayer.frame = self.fullVc.view.bounds;
                
            } completion:nil];
        }];
    } else { //me: 退出全屏
        [self.fullVc dismissViewControllerAnimated:NO completion:^{
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_fmVideoPlayer.index inSection:0];
            GZCateCell *cell = (GZCateCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell.contentView addSubview:_fmVideoPlayer];
            _fmVideoPlayer.frame = cell.cateFrame.videoViewF;
            
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
        CGFloat translateX = 200 - leftMenuMargin;
        
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
