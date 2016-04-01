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

- (NSDictionary *)requestParams
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cate_id"] = @"32";
    params[@"order_id"] = @"-1";
    params[@"os"] = @"ios";
    params[@"page_size"] = @"100";
    params[@"userKey"] = @"13A2E4B8-06B2-428F-93CB-BC8F9EA0A065";
    return params;
}

@end
