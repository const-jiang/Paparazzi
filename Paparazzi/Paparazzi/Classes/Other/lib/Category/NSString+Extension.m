//
//  NSString+Extension.m
//  05-UIWebView01-基本使用
//
//  Created by jiangtian on 16-3-28.
//  Copyright (c) 2016年 heima. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)


/**
    截取 fromString 与 toString 之间的部分；
    如果toString为nil或toString没有找到，截取fromString之后的部分
 */
- (NSString *)substringFromSting:(NSString *)fromString toString:(NSString *)toString
{
    
    /*
     rl=&agr=1234&cate_list=****&key_id=122260
     
     &agr=    &
     
     (3,5)   8
     
     
     1234&cate_list=****&key_id=122260
     
     (4,1)
     
     */

    
    
    NSRange range = [self rangeOfString:fromString];
    NSString *subString = [self substringFromIndex:range.location + range.length ];
  
    if (toString == nil) {
        return subString;
    }
    
    range = [subString rangeOfString:toString];
    if (range.length) {
       return [subString substringToIndex:range.location];
    }
    else{
        return subString;
    }
 }

@end


