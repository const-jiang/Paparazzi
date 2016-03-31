//
//  GZLeftMenu.h
//  Paparazzi
//
//  Created by jiangtian on 16-3-31.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GZLeftMenu;

@protocol GZLeftMenuDelegate <NSObject>
@optional
- (void)leftMenu:(GZLeftMenu *)menu didSelectedButtonFromIndex:(int)fromIndex toIndex:(int)toIndex;
@end


@interface GZLeftMenu : UIView

@property (nonatomic, weak) id<GZLeftMenuDelegate> delegate;

@end
