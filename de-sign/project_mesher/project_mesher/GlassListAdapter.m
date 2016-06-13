//
//  GlassListAdapter.m
//  project_mesher
//
//  Created by mac zdszkj on 16/3/23.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "GlassListAdapter.h"
#import "MesherModel.h"
#import "Glass.h"

@interface GlassListViewHolder : JWViewHolder {
    JWRelativeLayout *lo_view;
    UIImageView* img_image_n;
    UIImageView* img_image_h;
}

@end

@implementation GlassListViewHolder

- (UIView *)onCreateView:(NSBundle *)bundle viewType:(NSUInteger)viewType parent:(UIView *)parent {
    lo_view = [JWRelativeLayout layout];
    lo_view.layoutParams.width = [MesherModel uiWidthBy:193.0f];
    lo_view.layoutParams.height = [MesherModel uiHeightBy:140.0f];
    
    img_image_n = [[UIImageView alloc] init];
    img_image_n.layoutParams.width = [MesherModel uiWidthBy:190.0f];
    img_image_n.layoutParams.height = [MesherModel uiHeightBy:140.0f];
    img_image_n.layoutParams.alignment = JWLayoutAlignParentLeft;
    [lo_view addSubview:img_image_n];

    img_image_h = [[UIImageView alloc] init];
    img_image_h.layoutParams.width = [MesherModel uiWidthBy:190.0f];
    img_image_h.layoutParams.height = [MesherModel uiHeightBy:140.0f];
    img_image_h.layoutParams.alignment = JWLayoutAlignParentLeft;
    img_image_h.hidden = YES;
    [lo_view addSubview:img_image_h];
    
    return lo_view;
}

- (void)setRecord:(id)record {
    Glass *glass = record;
    img_image_n.image = glass.normalImage;
    img_image_h.image = glass.highlightImage;
}

- (void) onSelected:(BOOL)selected {
    if (selected) {
        img_image_h.hidden = NO;
    }else {
        img_image_h.hidden = YES;
    }
}

@end

@implementation GlassListAdapter

- (id<JIViewHolder>)onCreateViewHolder {
    return [[GlassListViewHolder alloc] init];
}

- (CGSize)getViewSizeAt:(NSUInteger)position {
    CGSize size = CGSizeMake([MesherModel uiWidthBy:193.0f], [MesherModel uiHeightBy:140.0f]);
    return size;
}

@end
