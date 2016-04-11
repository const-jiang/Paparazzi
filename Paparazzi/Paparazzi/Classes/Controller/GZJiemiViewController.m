//
//  GZJiemiViewController.m
//  Paparazzi
//
//  Created by jiangtian on 16-3-31.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//  深扒解密

#import "GZJiemiViewController.h"

@interface GZJiemiViewController ()

@end

@implementation GZJiemiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"jiemi"];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:image];
    self.navigationItem.titleView = titleView;
}

- (NSString *)cate_id
{
    return @"8";
}

@end
