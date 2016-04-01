//
//  GZCate.m
//  GouZai_TableViewCell
//
//  Created by jiangtian on 16-3-24.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//

#import "GZCate.h"

@implementation GZCate

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
                @"cate_info" : @"cate_infos[0]",
                @"pic" : @"pics[0]"
                
             };
}

@end
