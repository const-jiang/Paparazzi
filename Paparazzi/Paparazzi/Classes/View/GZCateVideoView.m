//
//  GZCateVideoView.m
//  GouZai_TableViewCell
//
//  Created by jiangtian on 16-3-26.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//

#import "GZCateVideoView.h"
#import "UIView+Extension.h"
#import "UIImageView+WebCache.h"
#import "GZPicture.h"
#import "GZCate.h"
#import "GZCateFrame.h"

@interface GZCateVideoView()
@property (weak, nonatomic) UIButton *playButton;

@end

@implementation GZCateVideoView

+ (instancetype)videoView
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"videoplay"];
        [playButton setImage:image forState:UIControlStateNormal];
         playButton.size = image.size;
        [self addSubview:playButton];
        self.playButton = playButton;
        [playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.playButton.centerX = self.width/2;
    self.playButton.centerY = self.height/2;
    
}

- (void)setCateFrame:(GZCateFrame *)cateFrame
{
    _cateFrame = cateFrame;
    
    [self sd_setImageWithURL:[NSURL URLWithString:cateFrame.cate.pic.small_url]];
    
}


- (void)playButtonClick:(UIButton *)button
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:PlayVideoNotification
                          object:self
                        userInfo:@{@"cateFrame":self.cateFrame}];
}


@end
