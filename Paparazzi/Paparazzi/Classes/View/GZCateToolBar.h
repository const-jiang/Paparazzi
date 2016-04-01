//
//  GZCateToolBar.h
//  GouZai_TableViewCell
//
//  Created by jiangtian on 16-3-25.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GZCate;

@interface GZCateToolBar : UIView

+ (instancetype)toolbar;

@property (nonatomic, strong) GZCate *cate;

@end
