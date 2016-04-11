//
//  GZLengzishiViewController.m
//  Paparazzi
//
//  Created by jiangtian on 16-3-31.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//  冷知识

#import "GZLengzishiViewController.h"

@interface GZLengzishiViewController ()

@end

@implementation GZLengzishiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"lengzhishi"];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:image];
    self.navigationItem.titleView = titleView;
}

- (NSString *)cate_id
{
    return @"1";
}

@end
