//
//  GZCateCell.h
//  GouZai_TableViewCell
//
//  Created by jiangtian on 16-3-24.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GZCateFrame;
@interface GZCateCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) GZCateFrame *cateFrame;

@end
