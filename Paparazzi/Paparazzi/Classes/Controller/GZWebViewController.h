//
//  GZWebViewController.h
//  GouZai_TableViewCell
//
//  Created by jiangtian on 16-3-28.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZWebViewController : UIViewController

//看看是否需要用单例模式
//+ (instancetype)shareWebViewController;

@property (nonatomic,strong) NSString *url;

@end
