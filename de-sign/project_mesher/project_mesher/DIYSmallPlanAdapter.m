//
//  DIYSmallPlanAdapter.m
//  project_mesher
//
//  Created by mac zdszkj on 15/12/11.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "DIYSmallPlanAdapter.h"
#import "DIY.h"
#import "MesherModel.h"

@interface DIYSmallViewHolder : JWViewHolder {
    UIImageView *img_image;
    JWImageOptions *opt_img_image;
    JWRelativeLayout *lo_selected;
}

@end

@implementation DIYSmallViewHolder

- (UIView *)onCreateView:(NSBundle *)bundle viewType:(NSUInteger)viewType parent:(UIView *)parent {
    JWRelativeLayout *lo_view = [JWRelativeLayout layout];
    lo_view.layoutParams.width = [MesherModel uiWidthBy:150.0f];
    lo_view.layoutParams.height = [MesherModel uiHeightBy:100.0f];
    [parent addSubview:lo_view];
    
    img_image = [[UIImageView alloc] init];
    img_image.layoutParams.width = [MesherModel uiWidthBy:140.0f];
    img_image.layoutParams.height = [MesherModel uiHeightBy:100.0f];
    img_image.layoutParams.alignment = JWLayoutAlignCenterHorizontal;
    [lo_view addSubview:img_image];
    
    lo_selected = [JWRelativeLayout layout];
    lo_selected.layoutParams.width = [MesherModel uiWidthBy:140.0f];
    lo_selected.layoutParams.height = [MesherModel uiHeightBy:100.0f];
    lo_selected.layoutParams.alignment = JWLayoutAlignCenterHorizontal;
    lo_selected.hidden = YES;
    [lo_view addSubview:lo_selected];
    
    JWRelativeLayout *lo_top = [JWRelativeLayout layout];
    lo_top.layoutParams.width = JWLayoutMatchParent;
    lo_top.layoutParams.height = 3;
    lo_top.layoutParams.alignment = JWLayoutAlignParentTop;
    lo_top.backgroundColor = [UIColor colorWithARGB:0xffdd9347];
    [lo_selected addSubview:lo_top];
    
    JWRelativeLayout *lo_left = [JWRelativeLayout layout];
    lo_left.layoutParams.width = 3;
    lo_left.layoutParams.height = JWLayoutMatchParent;
    lo_left.layoutParams.alignment = JWLayoutAlignParentLeft;
    lo_left.backgroundColor = [UIColor colorWithARGB:0xffdd9347];
    [lo_selected addSubview:lo_left];
    
    JWRelativeLayout *lo_bottom = [JWRelativeLayout layout];
    lo_bottom.layoutParams.width = JWLayoutMatchParent;
    lo_bottom.layoutParams.height = 3;
    lo_bottom.layoutParams.alignment = JWLayoutAlignParentBottom;
    lo_bottom.backgroundColor = [UIColor colorWithARGB:0xffdd9347];
    [lo_selected addSubview:lo_bottom];
    
    JWRelativeLayout *lo_right = [JWRelativeLayout layout];
    lo_right.layoutParams.width = 3;
    lo_right.layoutParams.height = JWLayoutMatchParent;
    lo_right.layoutParams.alignment = JWLayoutAlignParentRight;
    lo_right.backgroundColor = [UIColor colorWithARGB:0xffdd9347];
    [lo_selected addSubview:lo_right];
    
    return lo_view;
}

- (void)setRecord:(id)record {
    Plan *plan = record;
    img_image.image = nil;
    [[JWCorePluginSystem instance].imageCache getBy:plan.preview options:nil async:YES onGet:^(UIImage *image) {
        img_image.image = image;
    }];
}

- (void) onSelected:(BOOL)selected {
    if (selected) {
        lo_selected.hidden = NO;
    }else {
        lo_selected.hidden = YES;
    }
}

@end

@implementation DIYSmallPlanAdapter

- (id<JIViewHolder>)onCreateViewHolder {
    return [[DIYSmallViewHolder alloc] init];
}

- (CGSize)getViewSizeAt:(NSUInteger)position {
    CGSize size = CGSizeMake([MesherModel uiWidthBy:150.0f], [MesherModel uiHeightBy:100.0f]);
    return size;
}

@end
