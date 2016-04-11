//
//  NSString+Extension.m
//  Paparazzi
//
//  Created by jiangtian on 16-3-31.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0) {
        return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    } else {
        return [self sizeWithFont:font constrainedToSize:maxSize];
    }
}

- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font maxW:MAXFLOAT];
}

/**
 截取 fromString 与 toString 之间的部分；
 如果toString为nil或toString没有找到，截取fromString之后的部分
 */
- (NSString *)substringFromSting:(NSString *)fromString toString:(NSString *)toString
{
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
