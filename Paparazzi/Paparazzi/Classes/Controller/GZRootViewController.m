//
//  GZRootViewController.m
//  Paparazzi
//
//  Created by jiangtian on 16-3-31.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//

#import "GZRootViewController.h"

#define GZNavShowAnimDuration 3
#define GZCoverTag 100

@interface GZRootViewController ()

@end

@implementation GZRootViewController

+ (void)initialize
{
    UINavigationBar *appearance = [UINavigationBar appearance];
    
//    [appearance setBackgroundColor:GZThemeColor];
     [appearance setBackgroundImage:[UIImage imageWithColor:GZThemeColor] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = JTRandomColor;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"fenlei" target:self action:@selector(leftMenu)];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesture];
}


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


// 导航控制器view上面有遮盖

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
