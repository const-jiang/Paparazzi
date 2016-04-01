//
//  GZCatePictureView.h
//  GouZai_TableViewCell
//
//  Created by jiangtian on 16-3-25.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GZCateFrame;
@interface GZCatePictureView : UIImageView

+ (instancetype)pictureView;

@property (nonatomic, strong) GZCateFrame *cateFrame;

@end
