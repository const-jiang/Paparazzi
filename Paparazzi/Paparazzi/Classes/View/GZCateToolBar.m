//
//  GZCateToolBar.m
//  GouZai_TableViewCell
//
//  Created by jiangtian on 16-3-25.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//

#import "GZCateToolBar.h"
#import "GZCate.h"
#import "UIView+Extension.h"
#import "GZCateFrame.h"
#import "AFNetworking.h"
#import "GZShareViewController.h"

@interface GZCateToolBar()
@property (nonatomic, weak) UIButton *agreeBtn;
@property (nonatomic, weak) UIButton *hateBtn;
@property (nonatomic, weak) UIButton *collectBtn;
@property (nonatomic, weak) UIButton *shareBtn;
@end

@implementation GZCateToolBar

+ (instancetype)toolbar
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIButton *but = [[UIButton alloc] init];
        [but setImage:[UIImage imageNamed:@"agree"] forState:UIControlStateNormal];
        but.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
        [but setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        but.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:but];
        self.agreeBtn = but;
        [but addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        but = [[UIButton alloc] init];
        [but setImage:[UIImage imageNamed:@"hate"] forState:UIControlStateNormal];
        but.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
        [but setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        but.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:but];
        self.hateBtn = but;
        [but addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        but = [[UIButton alloc] init];
        [but setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
        [self addSubview:but];
        self.collectBtn = but;
        [but addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        but = [[UIButton alloc] init];
        [but setImage:[UIImage imageNamed:@"Share"] forState:UIControlStateNormal];
        [self addSubview:but];
        self.shareBtn = but;
        [but addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)buttonClick:(UIButton *)button
{
    
    return ;
    
    NSString *count_category ;
    
    if (button == self.agreeBtn) {
        count_category = @"2";
    }
    else if (button == self.hateBtn){
        count_category = @"0";
    }
    else if (button == self.collectBtn){
        count_category = @"1";
    }
   
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"count_category"] = count_category;
    params[@"key_id"] = [NSNumber numberWithInteger:self.cate.key_id];
    params[@"operation_type"] = @"0";
    params[@"os"] = @"ios";
    params[@"userKey"] = UserKey;
    
    NSString *url = @"http://v.sogou.com/app/weiyuedu/add_count_by_keyid/";
    [mgr POST:url parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
          
          [self.agreeBtn setTitle:[dict[@"agree_count"] stringValue] forState:UIControlStateNormal];
          [self.hateBtn setTitle:[dict[@"hate_count"] stringValue] forState:UIControlStateNormal];
          
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"请求失败:%@",error);
      }];
}

- (void)shareButtonClick:(UIButton *)button
{
   [[GZShareViewController sharedViewController] show];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int btnCount = (int)self.subviews.count;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = self.height;
    for (int i = 0; i < btnCount; i++) {
        UIButton *btn = self.subviews[i];
        btn.x = i * btnW;
        btn.y = 0;
        btn.width = btnW;
        btn.height = btnH;
    }
    
}

- (void)setCate:(GZCate *)cate
{
    _cate = cate;

    [self.agreeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)cate.agree_count] forState:UIControlStateNormal];
    
     [self.hateBtn setTitle:[NSString stringWithFormat:@"%ld",(long)cate.hate_count] forState:UIControlStateNormal];
}



@end
