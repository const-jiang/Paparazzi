//
//  GZPicture.h
//  GouZai_TableViewCell
//
//  Created by jiangtian on 16-3-24.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GZPicture : NSObject

@property (nonatomic, assign) NSInteger width;

@property (nonatomic, assign) NSInteger height;

@property (nonatomic, copy) NSString *small_url;

@property (nonatomic, assign, getter = isGif) BOOL is_gif;

@end

