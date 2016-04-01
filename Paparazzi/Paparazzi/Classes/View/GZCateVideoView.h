//
//  GZCateVideoView.h
//  GouZai_TableViewCell
//
//  Created by jiangtian on 16-3-26.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GZCateFrame;
@interface GZCateVideoView : UIImageView

+ (instancetype)videoView;

@property (nonatomic, strong) GZCateFrame *cateFrame;

@end
