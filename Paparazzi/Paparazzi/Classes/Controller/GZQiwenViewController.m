//
//  GZQiwenViewController.m
//  Paparazzi
//
//  Created by jiangtian on 16-3-31.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//  奇闻异事

#import "GZQiwenViewController.h"

@interface GZQiwenViewController ()

@end

@implementation GZQiwenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"qiwen"];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:image];
    self.navigationItem.titleView = titleView;
}

- (NSString *)cate_id
{
    return @"32";
}
@end
