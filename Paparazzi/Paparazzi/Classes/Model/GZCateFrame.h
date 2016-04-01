//
//  GZCateFrame.h
//  GouZai_TableViewCell
//
//  Created by jiangtian on 16-3-24.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//

@class GZCate;
@interface GZCateFrame : NSObject

@property (nonatomic, strong) GZCate *cate;

@property (nonatomic, assign) CGRect cate_infoLabelF;
@property (nonatomic, assign) CGRect cate_infoViewF;

@property (nonatomic, assign) CGRect nameLabelF;

@property (nonatomic, assign) CGRect contentLabelF;

@property (nonatomic, assign) CGRect picViewF;

@property (nonatomic, assign) CGRect videoViewF;

@property (nonatomic, assign) CGRect toolBarF;

@property (nonatomic, assign) CGRect bottomViewF;


/** 图片是否太大 */
@property (nonatomic, assign, getter=isBigPicture) BOOL bigPicture;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;

@end
