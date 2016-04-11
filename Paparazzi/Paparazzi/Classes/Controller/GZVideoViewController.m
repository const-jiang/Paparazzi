//
//  GZVideoViewController.m
//  Paparazzi
//
//  Created by jiangtian on 16-3-31.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//  精彩视频

#import "GZVideoViewController.h"

@interface GZVideoViewController ()

@end

@implementation GZVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"shipin"];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:image];
    self.navigationItem.titleView = titleView;
}

- (NSString *)cate_id
{
    return @"2";
}

@end
