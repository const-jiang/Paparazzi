//
//  GZCateFrame.m
//  GouZai_TableViewCell
//
//  Created by jiangtian on 16-3-24.
//  Copyright (c) 2016年 jiangtian. All rights reserved.
//

#import "GZCateFrame.h"
#import "GZCate.h"
#import "GZPicture.h"
#import "GZCateInfo.h"
#import "NSString+Extension.h"

@implementation GZCateFrame

- (void)setCate:(GZCate *)cate
{
    _cate = cate;
    
    // cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    //cate_infoLabel
    CGSize cate_infoLabelSize = [self sizeWithSting:cate.cate_info.name Font:GZCateCellCateInfoFont maxW:MAXFLOAT];
    CGFloat cate_infoLabelX = cellW - cate_infoLabelSize.width - GZCateCellBorderW;
    CGFloat cate_infoLabelY = GZCateCellBorderW;
    self.cate_infoLabelF = (CGRect){{cate_infoLabelX, cate_infoLabelY}, cate_infoLabelSize};
    
    //cate_infoView
    CGFloat cate_infoViewW = cate.cate_info.width/2;
    CGFloat cate_infoViewH = cate.cate_info.height/2;
    CGFloat cate_infoViewX = cate_infoLabelX - cate_infoViewW - 3;
    CGFloat cate_infoViewY = CGRectGetMidY(self.cate_infoLabelF) - cate_infoViewH/2;
    self.cate_infoViewF = CGRectMake(cate_infoViewX, cate_infoViewY, cate_infoViewW, cate_infoViewH);
    
    
    //name
    CGFloat nameX = GZCateCellBorderW;
    CGFloat nameY = CGRectGetMaxY(self.cate_infoLabelF) + GZCateCellBorderW;
    CGFloat nameW = cellW - 2 * GZCateCellBorderW;
//    CGSize  nameSize = [cate.name sizeWithFont:GZCateCellNameFont maxW:nameW];
    CGSize nameSize = [self sizeWithSting:cate.name Font:GZCateCellNameFont maxW:nameW];
    self.nameLabelF = (CGRect){{nameX, nameY}, nameSize};
    
    CGFloat maxY = CGRectGetMaxY(self.nameLabelF);
    
    //content
    if (cate.content.length) {
        
        CGFloat contentX = GZCateCellBorderW;
        CGFloat contentY = CGRectGetMaxY(self.nameLabelF) + GZCateCellBorderW;
        CGFloat contentW = cellW - 2 * GZCateCellBorderW;
        CGSize contentSize = [self sizeWithSting:cate.content Font:GZCateCellContentFont maxW:contentW];
        CGFloat contentH = contentSize.height;
        
        //content最多只能有3行
        CGSize size = [self sizeWithSting:@"算出一行的size" Font:GZCateCellContentFont maxW:contentW];
        CGFloat maxHeight = size.height * 3;
        if (contentH > maxHeight) {
            contentH = maxHeight;
        }
        
        self.contentLabelF = CGRectMake(contentX, contentY, contentW, contentH);
        
        maxY = CGRectGetMaxY(self.contentLabelF);
    }
    
    
    //pic
    if (cate.pic.small_url.length) {
        CGFloat picX = 0;
        CGFloat picY = maxY + GZCateCellBorderW;
        CGFloat picW = cellW;
        CGFloat picH = picW * cate.pic.height/cate.pic.width;
        //图片是否过大
        if (picH > GZCateCellPictureMaxH) {
            picH = GZCateCellPictureBreakH;
            self.bigPicture = YES;
        }
        
        if (cate.page_type == 5) {
            //如果是视频
             self.videoViewF =  CGRectMake(picX, picY, picW, picH);
             maxY = CGRectGetMaxY(self.videoViewF);
        }else{
            self.picViewF =  CGRectMake(picX, picY, picW, picH);
            maxY = CGRectGetMaxY(self.picViewF);
        }
   
    }
    
    CGFloat toolBarX = 0;
    CGFloat toolBarY = maxY;
    CGFloat toolBarW = cellW;
    CGFloat toolBarH = GZCateToolBarHeight;
    self.toolBarF = CGRectMake(toolBarX, toolBarY, toolBarW, toolBarH);
    
    maxY = CGRectGetMaxY(self.toolBarF);
    
    // Cell之间的间距
    CGFloat bottomViewX = 0;
    CGFloat bottomViewY = maxY;
    CGFloat bottomViewW = cellW;
    CGFloat bottomViewH = 7;
    self.bottomViewF = CGRectMake(bottomViewX, bottomViewY, bottomViewW, bottomViewH);
    
    self.cellHeight = CGRectGetMaxY(self.bottomViewF);
}


- (CGSize)sizeWithSting:(NSString *)str  Font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


@end
