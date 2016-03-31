//
//  GZGaoxiaoViewController.m
//  Paparazzi
//
//  Created by jiangtian on 16-3-31.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//

#import "GZGaoxiaoViewController.h"

@interface GZGaoxiaoViewController ()

@end

@implementation GZGaoxiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"gaoxiao"];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:image];
    self.navigationItem.titleView = titleView;
}



@end
