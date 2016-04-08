//
//  GZCateCell.m
//  GouZai_TableViewCell
//
//  Created by jiangtian on 16-3-24.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//

#import "GZCateCell.h"
#import "GZCateFrame.h"
#import "GZCate.h"
#import "GZPicture.h"
#import "GZCateInfo.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "GZCateToolBar.h"
#import "GZCatePictureView.h"
#import "GZCateVideoView.h"

#define GZCateCellContentFontColor [UIColor colorWithRed:98/255.0 green:98/255.0 blue:98/255.0 alpha:1.0]

@interface GZCateCell()

@property (nonatomic, weak) UILabel *cate_infoLabel;
@property (nonatomic, weak) UIImageView *cate_infoView;

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *contentLabel;

@property (nonatomic, weak) GZCatePictureView *picView;
@property (nonatomic, weak) GZCateVideoView *videoView;

@property (nonatomic, weak) GZCateToolBar *toolBar;

/** Cell之间的间距*/
@property (nonatomic, weak) UIView *bottomView;

@end

@implementation GZCateCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cate";
    GZCateCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[GZCateCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}

/**
 *  cell的初始化方法，一个cell只会调用一次
 *  一般在这里添加所有可能显示的子控件，以及子控件的一次性设置
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        // 点击cell的时候不要变色
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupSubViews];
    }
    
    return self;
}

- (void)setupSubViews
{
    UIImageView *cate_infoView = [[UIImageView alloc] init];
    cate_infoView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:cate_infoView];
    self.cate_infoView = cate_infoView;
    
    UILabel *cate_infoLabel = [[UILabel alloc] init];
    cate_infoLabel.font = GZCateCellCateInfoFont;
    cate_infoLabel.textColor = GZCateCellContentFontColor;
    [self.contentView addSubview:cate_infoLabel];
    self.cate_infoLabel = cate_infoLabel;

    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = GZCateCellNameFont;
    nameLabel.numberOfLines = 0;
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = GZCateCellContentFont;
    contentLabel.numberOfLines = 3;
    contentLabel.textColor = GZCateCellContentFontColor;
    contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    GZCatePictureView *picView = [GZCatePictureView pictureView];
    [self.contentView addSubview:picView];
    self.picView = picView;

    GZCateVideoView *videoView = [GZCateVideoView videoView];
    [self.contentView addSubview:videoView];
    self.videoView = videoView;
 
    GZCateToolBar *toolBar = [GZCateToolBar toolbar];
    [self.contentView addSubview:toolBar];
    self.toolBar = toolBar;
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1.0];
    [self.contentView addSubview:bottomView];
    self.bottomView = bottomView;
}

- (void)setCateFrame:(GZCateFrame *)cateFrame
{   
    _cateFrame = cateFrame;
    
    GZCate *cate = cateFrame.cate;
    
    [self.cate_infoView sd_setImageWithURL:[NSURL URLWithString:cate.cate_info.imgUrl]];
    self.cate_infoView.frame = cateFrame.cate_infoViewF;
    
    self.cate_infoLabel.text = cate.cate_info.name;
    self.cate_infoLabel.frame = cateFrame.cate_infoLabelF;
    
    self.nameLabel.text = cate.name;
    self.nameLabel.frame = cateFrame.nameLabelF;
    
    //如果content有值
    if (cate.content.length) {
        self.contentLabel.hidden = NO;
        self.contentLabel.text = cate.content;
        self.contentLabel.frame = cateFrame.contentLabelF;
    }else{
        self.contentLabel.hidden = YES;
    }
    
    
    //如果有图片
    if (cate.pic.small_url.length) {
        
        if (cate.page_type == 5) {
            //如果是视频
            self.picView.hidden = YES;
            self.videoView.hidden = NO;
            self.videoView.frame = cateFrame.videoViewF;
            self.videoView.cateFrame = cateFrame;
        }else{
            self.videoView.hidden = YES;
            self.picView.hidden = NO;
            self.picView.frame = cateFrame.picViewF;
            self.picView.cateFrame = cateFrame;
        }
    
    }else{
       self.picView.hidden = YES;
       self.videoView.hidden = YES;
    }
    
    self.toolBar.cate = cate;
    self.toolBar.frame = cateFrame.toolBarF;
    
    self.bottomView.frame = cateFrame.bottomViewF;

}


@end
