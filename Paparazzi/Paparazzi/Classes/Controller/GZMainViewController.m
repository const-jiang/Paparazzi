//
//  GZMainViewController.m
//  Paparazzi
//
//  Created by jiangtian on 16-3-31.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//

#import "GZMainViewController.h"
#import "GZLeftMenu.h"
#import "GZTuijianViewController.h"
#import "GZLengzishiViewController.h"
#import "GZVideoViewController.h"
#import "GZJiemiViewController.h"
#import "GZGaoxiaoViewController.h"
#import "GZQiwenViewController.h"
#import "KKNavigationController.h"

@interface GZMainViewController ()<GZLeftMenuDelegate>

@end

@implementation GZMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationBar *appearance = [UINavigationBar appearance];
    
//    [appearance setBackgroundColor:GZThemeColor];
    [appearance setBackgroundImage:[UIImage imageWithColor:GZThemeColor] forBarMetrics:UIBarMetricsDefault];

    
    self.view.backgroundColor = GZThemeColor;
    
    GZRootViewController *vc = nil;
    vc = [[GZTuijianViewController alloc] init];
    [self addChildViewController:[[KKNavigationController alloc] initWithRootViewController:vc]];
    
    vc = [[GZLengzishiViewController alloc] init];
    [self addChildViewController:[[KKNavigationController alloc] initWithRootViewController:vc]];
    
    vc = [[GZVideoViewController alloc] init];
    [self addChildViewController:[[KKNavigationController alloc] initWithRootViewController:vc]];
    
    vc = [[GZJiemiViewController alloc] init];
    [self addChildViewController:[[KKNavigationController alloc] initWithRootViewController:vc]];
    
    vc = [[GZGaoxiaoViewController alloc] init];
    [self addChildViewController:[[KKNavigationController alloc] initWithRootViewController:vc]];
    
    vc = [[GZQiwenViewController alloc] init];
    [self addChildViewController:[[KKNavigationController alloc] initWithRootViewController:vc]];

    
    GZLeftMenu *menu = [[GZLeftMenu alloc] init];
   [self.view insertSubview:menu atIndex:0];
    
    // menu.delegate的设置需在addChildViewController之后，否则会引起数组越界错误
    menu.delegate = self;
}


- (void)leftMenu:(GZLeftMenu *)menu didSelectedButtonFromIndex:(int)fromIndex toIndex:(int)toIndex
{
    
    UINavigationController *oldNav = self.childViewControllers[fromIndex];
    [oldNav.view removeFromSuperview];
    
    UINavigationController *newNav = self.childViewControllers[toIndex];
    [self.view addSubview:newNav.view];
    
    newNav.view.transform = oldNav.view.transform;
    newNav.view.layer.shadowColor = [UIColor blackColor].CGColor;
    newNav.view.layer.shadowOffset = CGSizeMake(-4, -4);
    newNav.view.layer.shadowOpacity = 0.2;
    
    GZRootViewController *rootViewController = (GZRootViewController *)newNav.topViewController;
    [rootViewController coverClick];
    
}

// 不支持屏幕旋转
- (BOOL)shouldAutorotate
{
    return NO;
}

@end
