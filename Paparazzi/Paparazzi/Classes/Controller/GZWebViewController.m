//
//  GZWebViewController.m
//  GouZai_TableViewCell
//
//  Created by jiangtian on 16-3-28.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//

#import "GZWebViewController.h"
#import "GZCateToolBar.h"
#import "AFNetworking.h"
#import "FMGVideoPlayView.h"
#import "FullViewController.h"
#import "GZCate.h"
#import "GZTool.h"

@interface GZWebViewController () <UIWebViewDelegate, UISearchBarDelegate,FMGVideoPlayViewDelegate>

@property (weak, nonatomic) UIWebView *webView;
@property (weak, nonatomic) GZCateToolBar *toolBar;
@property (weak, nonatomic) UIButton *backButton;

@property (nonatomic, strong) FMGVideoPlayView * fmVideoPlayer; // 播放器
/* 全屏控制器 */
@property (nonatomic, strong) FullViewController *fullVc;


@end

@implementation GZWebViewController

- (FullViewController *)fullVc
{
    if (_fullVc == nil) {
        _fullVc = [[FullViewController alloc] init];
    }
    return _fullVc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = JTColor(165, 165, 165);
    
    UIWebView *webView = [[UIWebView alloc] init];
    [self.view addSubview:webView];
    self.webView = webView;
    webView.frame = CGRectMake(0, 0, GZScreenW, GZScreenH - GZCateToolBarHeight -1);
    webView.scrollView.bounces = NO;
    
    
    GZCateToolBar *toolBar = [GZCateToolBar toolbar];
    [self.view addSubview:toolBar];
    self.toolBar = toolBar;
    toolBar.frame = CGRectMake(0, GZScreenH - GZCateToolBarHeight, GZScreenW, GZCateToolBarHeight);
    
    UIButton *backButton = [[UIButton alloc] init];
    UIImage *image = [UIImage imageNamed:@"fanhui"];
    [backButton setImage:image forState:UIControlStateNormal];
    backButton.frame = CGRectMake(20, 25, image.size.width, image.size.height);
    [self.view addSubview:backButton];
    self.backButton = backButton;
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    self.webView.backgroundColor = [UIColor whiteColor];
    
    if (self.url) {
        [self loadURL:self.url];
    }
    
}

- (void)loadURL:(NSString *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    self.webView.delegate = self;
    [self.webView loadRequest:request];
}

-(void)back:(UIButton *)button
{
     if ([self.webView  canGoBack]) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
#warning 当没有这个代理方法时，webView加载的网页中很多时候没有图片，为什么会出现这种现象？？？？
    //URL解码
    NSString *urlStr = [request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    /*
     视频：type=101
     http://action/?url=http://www.miaopai.com/show/kBbd6lE7UVgPDio11L5tMQ__.htm&type=101
     
     普通链接：type=100
     http://action/?url=http://v.sogou.com/app/weiyuedu/detail/?id=67481&article_id=-1&has_user=0&type=100
     
     quanzi    http://action/?type=301
     weixin    http://action/?type=303
     qq        http://action/?type=300
     
     其他：
     URL:http://action/?video_url=&agree_count=2&cate_list.....
     URL中包含 agree_count  hate_count 等信息
     
     */
    
    
    NSRange range = [urlStr rangeOfString:@"http://action/?" options:NSAnchoredSearch];
    if (range.length == 0) {
        return YES;
    }
    
    //去掉 "http://action/?" 部分
    urlStr = [urlStr substringFromIndex:range.length];
    
    // 截取后的urlStr的值可能有下面几种情况
    // urlStr:   url=http://*********&type=101
    // urlStr:   type=301
    // urlStr:   video_url=&agree_count=1&cate_list=****
    
    
    if ([urlStr hasPrefix:@"url="]) {
        
        int type = [[urlStr substringFromSting:@"&type=" toString:nil] intValue];
        if (type == 101) {
            // 点击的是视频
            NSString *video_url = [urlStr substringFromSting:@"url=" toString:@"&"];
//            NSLog(@"点击的是视频:%@",video_url);
            
            [self playVideoWithURL:video_url];
            
        }else{
            // 点击的是普通链接
            NSString *page_url = [urlStr substringFromSting:@"url=" toString:@"&"];
            
//            NSLog(@"点击的是普通链接:%@",page_url);
            
            // 加载对应的页面
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:page_url]];
            [self.webView loadRequest:request];
        }
    }
    else if ([urlStr hasPrefix:@"type="]){
        int type = [[urlStr substringFromSting:@"type=" toString:nil] intValue];
        if (type == 301) {
            // 朋友圈
            NSLog(@"朋友圈");
        }
        else if (type == 303){
            // 微信
            NSLog(@"微信");
            
        }else if (type == 300){
            // qq
            NSLog(@"qq");
        }
        
        
    }else if ([urlStr rangeOfString:@"&agree_count"].length){
        
        GZCate *cate = [[GZCate alloc] init];
        cate.agree_count = [[urlStr substringFromSting:@"&agree_count=" toString:@"&"] integerValue];
        cate.hate_count = [[urlStr substringFromSting:@"&hate_count=" toString:@"&"] integerValue];
        cate.collect_count = [[urlStr substringFromSting:@"&collect_count=" toString:@"&"] integerValue];
        cate.key_id = [[urlStr substringFromSting:@"&key_id=" toString:@"&"] integerValue];
        
        self.toolBar.cate = cate;

    }
    
    return NO;
}

- (void)playVideoWithURL:(NSString *)video_url
{
    [GZTool parseVideoURL:video_url success:^(NSString *url) {
        
        _fmVideoPlayer = [FMGVideoPlayView videoPlayView];
        _fmVideoPlayer.delegate = self;
        
        [_fmVideoPlayer setUrlString:url];
        
        [_fmVideoPlayer.player play];
        [_fmVideoPlayer showToolView:NO];
        _fmVideoPlayer.playOrPauseBtn.selected = YES;
        //解决全屏播放时，点击两次才能退出的问题
        _fmVideoPlayer.switchOrientationBut.selected = YES;
        
        [self presentViewController:self.fullVc animated:NO completion:^{
            [self.fullVc.view addSubview:self.fmVideoPlayer];
            _fmVideoPlayer.center = self.fullVc.view.center;
            
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                _fmVideoPlayer.frame = self.fullVc.view.bounds;
                
            } completion:nil];
        }];

        
    } failure:^(NSError *error) {
        NSLog(@"请求失败:%@",error);
    }];
}

- (void)videoplayViewSwitchOrientation:(BOOL)isFull{
    if (!isFull) { // 退出全屏
        
        [_fmVideoPlayer.player pause];
        [_fmVideoPlayer removeFromSuperview];
        _fmVideoPlayer = nil;
        
        // ios8中会出现这种情况
        if (self.interfaceOrientation != UIInterfaceOrientationPortrait) {
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
            
            [[[[UIApplication sharedApplication] keyWindow] rootViewController] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"interfaceOrientation"];
        }
        
        [self.fullVc dismissViewControllerAnimated:NO completion:^{
        }];
    }
}

@end
