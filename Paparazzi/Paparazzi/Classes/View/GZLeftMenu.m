//
//  GZLeftMenu.m
//  Paparazzi
//
//  Created by jiangtian on 16-3-31.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//

#import "GZLeftMenu.h"

@interface GZLeftMenu()

@property (nonatomic,strong) UIButton *selectedButton;

@end

@implementation GZLeftMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIImage *image = [UIImage imageNamed:@"DogLogo"];
        UIImageView *dogLogo = [[UIImageView alloc] initWithImage:image];
        dogLogo.x = 0;
        dogLogo.y = 0;
        [self addSubview:dogLogo];
        
        image = [UIImage imageNamed:@"DogTitle"];
        UIImageView *dogTitle = [[UIImageView alloc] initWithImage:image];
        dogTitle.x = CGRectGetMaxX(dogLogo.frame) + 5;
        dogTitle.y = 5;
        [self addSubview:dogTitle];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"V1.1.0";
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = JTRGBColor(168, 162, 101);
        label.x = dogTitle.x + 2;
        label.y = CGRectGetMaxY(dogTitle.frame) + 7;
        label.size = [label.text sizeWithFont:label.font];
        [self addSubview:label];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = JTRGBColor(236, 209, 37);
        line.x = 0;
        line.y = CGRectGetMaxY(dogLogo.frame);
        line.width = GZLeftMenuW;
        line.height = 1;
        [self addSubview:line];
        
        
        CGFloat maxY = CGRectGetMaxY(line.frame);
        CGFloat buttonH = [UIImage imageNamed:@"i-1"].size.height + 24;
        
        //狗仔推荐
        UIButton *button = [self setupBtnWithIcon:@"i-1" title:@"狗仔推荐"];
        button.x = 0;
        button.y = maxY + 10;
        button.width = GZLeftMenuW;
        button.height = buttonH;
        button.tag = 0;
        
        self.selectedButton = button;
        
        //冷知识
        maxY = CGRectGetMaxY(button.frame);
        button = [self setupBtnWithIcon:@"i-3" title:@"冷知识"];
        button.x = 0;
        button.y = maxY;
        button.width = GZLeftMenuW;
        button.height = buttonH;
        button.tag = 1;
        
        //精彩视频
        maxY = CGRectGetMaxY(button.frame);
        button = [self setupBtnWithIcon:@"i-7" title:@"精彩视频"];
        button.x = 0;
        button.y = maxY;
        button.width = GZLeftMenuW;
        button.height = buttonH;
        button.tag = 2;
        
        //深扒解密
        maxY = CGRectGetMaxY(button.frame);
        button = [self setupBtnWithIcon:@"i-2" title:@"深扒解密"];
        button.x = 0;
        button.y = maxY;
        button.width = GZLeftMenuW;
        button.height = buttonH;
        button.tag = 3;
        
        //搞笑段子
        maxY = CGRectGetMaxY(button.frame);
        button = [self setupBtnWithIcon:@"i-5" title:@"搞笑段子"];
        button.x = 0;
        button.y = maxY;
        button.width = GZLeftMenuW;
        button.height = buttonH;
        button.tag = 4;
        
        //奇闻异事
        maxY = CGRectGetMaxY(button.frame);
        button = [self setupBtnWithIcon:@"i-4" title:@"奇闻异事"];
        button.x = 0;
        button.y = maxY;
        button.width = GZLeftMenuW;
        button.height = buttonH;
        button.tag = 5;
        
        //我的收藏
        maxY = CGRectGetMaxY(button.frame);
        button = [[UIButton alloc] init];
        image = [UIImage imageNamed:@"wujiaoxing"];
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:image forState:UIControlStateHighlighted];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setTitle:@"我的收藏" forState:UIControlStateNormal];
        [button setTitleColor:JTRGBColor(124, 124, 124) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
        button.x = 0;
        button.y = maxY + 75;
        button.width = GZLeftMenuW;
        button.height = image.size.height + 30;
        [self addSubview:button];
   
        line = [[UIView alloc] init];
        line.backgroundColor = JTRGBColor(236, 209, 37);
        line.x = 0;
        line.y = button.y;
        line.width = GZLeftMenuW;
        line.height = 1;
        [self addSubview:line];
   
        line = [[UIView alloc] init];
        line.backgroundColor = JTRGBColor(236, 209, 37);
        line.x = 0;
        line.y = CGRectGetMaxY(button.frame);
        line.width = GZLeftMenuW;
        line.height = 1;
        [self addSubview:line];
        
    }
    return self;
}

- (UIButton *)setupBtnWithIcon:(NSString *)icon title:(NSString *)title
{
    UIButton *button = [[UIButton alloc] init];
    UIImage *image = [UIImage imageNamed:icon];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateHighlighted];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:18],
                          NSForegroundColorAttributeName:JTRGBColor(65, 65, 65)
                          };
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:title attributes:dic];
    [button setAttributedTitle:attr forState:UIControlStateNormal];
    
    dic = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
            NSForegroundColorAttributeName:JTRGBColor(4, 4, 4)
            };
    attr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@＞",title] attributes:dic];
    [button setAttributedTitle:attr forState:UIControlStateSelected];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
    
    [self addSubview:button];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}


- (void)setDelegate:(id<GZLeftMenuDelegate>)delegate
{
     _delegate = delegate;
    
    [self buttonClick:_selectedButton];
}

- (void)buttonClick:(UIButton *)button
{
    _selectedButton.selected = NO;
    button.selected = YES;
    
    if ([self.delegate respondsToSelector:@selector(leftMenu:didSelectedButtonFromIndex:toIndex:)]) {
        [self.delegate leftMenu:self didSelectedButtonFromIndex:(int)self.selectedButton.tag toIndex:(int)button.tag];
    }

    _selectedButton = button;
}

@end
