//
//  JTButton.m
//  Paparazzi
//
//  Created by jiangtian on 16-4-10.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//

#import "JTButton.h"

// 按钮高度的比例
#define kImageBiLi 0.75

@implementation JTButton

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        
//        self.imageView.backgroundColor = [UIColor redColor];
//        self.titleLabel.backgroundColor = [UIColor yellowColor];
        
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = contentRect.size.height * kImageBiLi;
    CGFloat titleWidth = contentRect.size.width;
    CGFloat titleHeight = contentRect.size.height - titleY;
    
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}


- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageWidth = contentRect.size.width;
    CGFloat imageHeight = contentRect.size.height * kImageBiLi;
    
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}

@end
