//
//  GZShareViewController.m
//  Paparazzi
//
//  Created by jiangtian on 16-4-10.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//

#import "GZShareViewController.h"
#import "JTButton.h"

#define ShareViewHeight 240

@interface GZShareViewController ()
@property (nonatomic,strong) UIButton *cover;
@end

@implementation GZShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat w = screenW;
    CGFloat h = ShareViewHeight;
    CGFloat x = 0;
    CGFloat y = [UIScreen mainScreen].bounds.size.height;
    self.view.frame = CGRectMake(x, y, w, h);
    
    UILabel *label = [[UILabel alloc] init];
    UIFont *font = [UIFont systemFontOfSize:19];
    label.font = font;
    label.text = @"分享给朋友";
    label.textAlignment = NSTextAlignmentCenter;
    CGSize textSize = [label.text sizeWithFont:font];
    x = 0;
    y = 25;
    w = screenW;
    h = textSize.height;
    label.frame = CGRectMake(x, y, w, h);
    [self.view addSubview:label];
    
    CGFloat margin = 20;
    CGFloat buttonW = (screenW - margin*2)/3;
    CGFloat buttonH = 47 + 25;
    CGFloat buttonY = CGRectGetMaxY(label.frame) + 20;
    
    CGFloat buttonX = margin;
    JTButton *button = [[JTButton alloc] init];
    [button setTitle:@"微信朋友圈" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"share_0"] forState:UIControlStateNormal];
    button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    [self.view addSubview: button];
    
    buttonX = CGRectGetMaxX(button.frame);
    button = [[JTButton alloc] init];
    [button setTitle:@"微信好友" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"share_1"] forState:UIControlStateNormal];
    button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    [self.view addSubview: button];
    
    buttonX = CGRectGetMaxX(button.frame);
    button = [[JTButton alloc] init];
    [button setTitle:@"QQ好友" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"share_2"] forState:UIControlStateNormal];
    button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    [self.view addSubview: button];
    
    
    UIButton *cancelButton = [[UIButton alloc] init];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    UIColor *color = JTColor(135, 135, 135);
    [cancelButton setTitleColor:color forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:19];
    x = margin + 10;
    y = CGRectGetMaxY(button.frame) + 30;
    w = screenW - x*2;
    h = 35;
    cancelButton.frame = CGRectMake(x, y, w, h);
    [self.view addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    
    [cancelButton.layer setCornerRadius:5];
    [cancelButton.layer setBorderWidth:0.5];
    [cancelButton.layer setBorderColor:color.CGColor];
    
}

- (UIButton *)cover
{
    if (_cover == nil) {
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
        
        UIButton *cover = [[UIButton alloc] init];
        cover.backgroundColor = JTColorRGBA(50, 50, 50, 0.5);
        cover.frame = CGRectMake(0, 0, screenW, screenH);
        [cover addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
        _cover = cover;
    }
    return _cover;
}

- (void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.cover];
    [self.cover addSubview:self.view];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.y = [UIScreen mainScreen].bounds.size.height - ShareViewHeight;
    }];
}

- (void)dismiss:(id)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.y = [UIScreen mainScreen].bounds.size.height;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self.cover removeFromSuperview];
    }];
}


#pragma mark - 单例模式
static id _instance;

+ (id)allocWithZone:(struct _NSZone *)zone
{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

+ (instancetype)sharedViewController
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return _instance;
}

@end
