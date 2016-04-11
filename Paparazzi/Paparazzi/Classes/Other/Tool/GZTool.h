//
//  GZTool.h
//  Paparazzi
//
//  Created by jiangtian on 16-4-11.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GZTool : NSObject

/**
 *  根据GZCate中的video_url获得视频实际播放的地址
 */
+ (void)parseVideoURL:(NSString *)videoURL  success:(void (^)(NSString * url))success failure:(void (^)(NSError *error))failure;

@end
