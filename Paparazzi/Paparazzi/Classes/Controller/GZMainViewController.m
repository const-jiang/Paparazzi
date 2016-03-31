//
//  GZMainViewController.m
//  Paparazzi
//
//  Created by jiangtian on 16-3-31.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//

#import "GZMainViewController.h"
#import "GZLeftMenu.h"

@interface GZMainViewController ()<GZLeftMenuDelegate>

@end

@implementation GZMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:253/255.0 green:223/255.0 blue:16/255.0 alpha:1.0];
    
    
    GZLeftMenu *menu = [[GZLeftMenu alloc] init];
    menu.x = 30;
    menu.y = 60;
    menu.width = GZLeftMenuW;
    menu.height = GZLeftMenuH;
    
    menu.delegate = self;
    
    [self.view addSubview:menu];
}


- (void)leftMenu:(GZLeftMenu *)menu didSelectedButtonFromIndex:(int)fromIndex toIndex:(int)toIndex
{
    NSLog(@"fromIndex:%d  toIndex:%d",fromIndex,toIndex);
}

@end
