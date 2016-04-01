//
//  GZCate.h
//  GouZai_TableViewCell
//
//  Created by jiangtian on 16-3-24.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GZCateInfo,GZPicture;
@interface GZCate : NSObject

@property (nonatomic, strong) GZCateInfo *cate_info;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *content;

@property (nonatomic, strong) GZPicture *pic;

@property (nonatomic, assign) NSInteger hate_count;
@property (nonatomic, assign) NSInteger agree_count;
@property (nonatomic, assign) NSInteger collect_count;

@property (nonatomic, assign) NSInteger key_id;


@property (nonatomic, assign) NSInteger page_type;

@property (nonatomic,copy) NSString *video_url;

@property (nonatomic,copy) NSString *detail_url;

@end

