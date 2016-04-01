//
//  GZCatePictureView.m
//  GouZai_TableViewCell
//
//  Created by jiangtian on 16-3-25.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//

#import "GZCatePictureView.h"
#import "GZCateFrame.h"
#import "UIView+Extension.h"
#import "GZPicture.h"
#import "GZCate.h"
#import "UIImageView+WebCache.h"

#import "DACircularProgressView.h"

@interface GZCatePictureView()

/** gif标识 */
@property (weak, nonatomic) UIImageView *gifView;
/** 查看大图按钮 */
@property (weak, nonatomic) UIButton *seeBigButton;
/** 进度条控件 */
@property (weak, nonatomic) DACircularProgressView *progressView;

@property (weak, nonatomic) UILabel *progressLabel;


@end


@implementation GZCatePictureView

+ (instancetype)pictureView
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        
        UIImageView *gifView = [[UIImageView alloc] init];
        UIImage *gifImage = [UIImage imageNamed:@"GIF"];
        gifView.image = gifImage;
        [self addSubview:gifView];
        self.gifView = gifView;
        
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
        UIImage *image = [UIImage imageNamed:@"Open"];
        [but setImage:image forState:UIControlStateNormal];
        but.titleLabel.font = [UIFont systemFontOfSize:15];
        [but setTitleColor:[UIColor colorWithRed:253/255.0 green:226/255.0 blue:12/255.0 alpha:1.0] forState:UIControlStateNormal];
        but.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [self addSubview:but];
        self.seeBigButton  = but;

        DACircularProgressView *progressView = [[DACircularProgressView alloc] init];
        progressView.trackTintColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
        progressView.progressTintColor = [UIColor whiteColor];
        progressView.thicknessRatio = 1.0f;
        [self addSubview:progressView];
        self.progressView = progressView;
        
        UILabel *progressLabel = [[UILabel alloc] init];
        progressLabel.textColor = [UIColor whiteColor];
        progressLabel.font = [UIFont systemFontOfSize:16];
        progressLabel.text = @"加载中...";
        progressLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:progressLabel];
        self.progressLabel = progressLabel;
        
        
        self.backgroundColor = [UIColor grayColor];
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    _gifView.width = _gifView.image.size.width;
    _gifView.height = _gifView.image.size.height;
    _gifView.x = 5;
    _gifView.y = 5;
    
    _progressView.width = 100;
    _progressView.height = _progressView.width;
    _progressView.centerX = self.width/2;
    _progressView.centerY = self.height/2;
    
    _progressLabel.height = 30;
    _progressLabel.width = self.width;
    _progressLabel.x = 0;
    _progressLabel.y = CGRectGetMaxY(_progressView.frame);
    
    _seeBigButton.width = self.width;
    _seeBigButton.height = 45;
    _seeBigButton.x = 0;
    _seeBigButton.y = self.height - _seeBigButton.height;
    
}


- (void)setCateFrame:(GZCateFrame *)cateFrame
{
    _cateFrame = cateFrame;
    
     [self.progressView setProgress:0.f animated:YES];
    
    // 设置图片
    [self sd_setImageWithURL:[NSURL URLWithString:cateFrame.cate.pic.small_url] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        self.progressView.hidden = NO;
        self.progressLabel.hidden = NO;
        
        // 显示进度值
        [self.progressView setProgress:1.0 * receivedSize / expectedSize animated:YES];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
        self.progressLabel.hidden = YES;
        
        // 如果是大图片, 才需要进行绘图处理
        if (cateFrame.isBigPicture ){
            // 开启图形上下文
            UIGraphicsBeginImageContextWithOptions(cateFrame.picViewF.size, YES, 0.0);
            
            // 将下载完的image对象绘制到图形上下文
            CGFloat width = cateFrame.picViewF.size.width;
            CGFloat height = width * image.size.height / image.size.width;
            [image drawInRect:CGRectMake(0, 0, width, height)];
            
            // 获得图片
            self.image = UIGraphicsGetImageFromCurrentImageContext();
            
            // 结束图形上下文
            UIGraphicsEndImageContext();
        }
        
        if (cateFrame.cate.page_type == 6) {
            self.seeBigButton.hidden = NO;
            [self.seeBigButton setTitle:@"查看全文" forState:UIControlStateNormal];
        }else if (cateFrame.isBigPicture){
            self.seeBigButton.hidden = NO;
            [self.seeBigButton setTitle:@"点击查看全图" forState:UIControlStateNormal];
        }else{
            self.seeBigButton.hidden = YES;
        }
 
    }];
    
    // 判断是否为gif
    self.gifView.hidden = !cateFrame.cate.pic.is_gif;
  
}

@end
