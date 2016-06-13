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

@interface DIYSmallViewHolder : CCVViewHolder {
    UIImageView *img_image;
    CCVImageOptions *opt_img_image;
    CCVRelativeLayout *lo_selected;
}

@end

@implementation DIYSmallViewHolder

- (UIView *)onCreateView:(NSBundle *)bundle viewType:(NSUInteger)viewType parent:(UIView *)parent {
    CCVRelativeLayout *lo_view = [CCVRelativeLayout layout];
    lo_view.layoutParams.width = [MesherModel uiWidthBy:150.0f];
    lo_view.layoutParams.height = [MesherModel uiHeightBy:100.0f];
    [parent addSubview:lo_view];
    
    img_image = [[UIImageView alloc] init];
    img_image.layoutParams.width = [MesherModel uiWidthBy:140.0f];
    img_image.layoutParams.height = [MesherModel uiHeightBy:100.0f];
    img_image.layoutParams.alignment = CCVLayoutAlignCenterHorizontal;
    [lo_view addSubview:img_image];
    
    lo_selected = [CCVRelativeLayout layout];
    lo_selected.layoutParams.width = [MesherModel uiWidthBy:140.0f];
    lo_selected.layoutParams.height = [MesherModel uiHeightBy:100.0f];
    lo_selected.layoutParams.alignment = CCVLayoutAlignCenterHorizontal;
    lo_selected.hidden = YES;
    [lo_view addSubview:lo_selected];
    
    CCVRelativeLayout *lo_top = [CCVRelativeLayout layout];
    lo_top.layoutParams.width = CCVLayoutMatchParent;
    lo_top.layoutParams.height = 3;
    lo_top.layoutParams.alignment = CCVLayoutAlignParentTop;
    lo_top.backgroundColor = [UIColor colorWithARGB:0xffff6749];
    [lo_selected addSubview:lo_top];
    
    CCVRelativeLayout *lo_left = [CCVRelativeLayout layout];
    lo_left.layoutParams.width = 3;
    lo_left.layoutParams.height = CCVLayoutMatchParent;
    lo_left.layoutParams.alignment = CCVLayoutAlignParentLeft;
    lo_left.backgroundColor = [UIColor colorWithARGB:0xffff6749];
    [lo_selected addSubview:lo_left];
    
    CCVRelativeLayout *lo_bottom = [CCVRelativeLayout layout];
    lo_bottom.layoutParams.width = CCVLayoutMatchParent;
    lo_bottom.layoutParams.height = 3;
    lo_bottom.layoutParams.alignment = CCVLayoutAlignParentBottom;
    lo_bottom.backgroundColor = [UIColor colorWithARGB:0xffff6749];
    [lo_selected addSubview:lo_bottom];
    
    CCVRelativeLayout *lo_right = [CCVRelativeLayout layout];
    lo_right.layoutParams.width = 3;
    lo_right.layoutParams.height = CCVLayoutMatchParent;
    lo_right.layoutParams.alignment = CCVLayoutAlignParentRight;
    lo_right.backgroundColor = [UIColor colorWithARGB:0xffff6749];
    [lo_selected addSubview:lo_right];
    
    return lo_view;
}

- (void)setRecord:(id)record {
    Plan *plan = record;
    img_image.image = nil;
    [[CCVCorePluginSystem instance].imageCache getBy:plan.preview options:nil async:YES onGet:^(UIImage *image) {
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

- (id<ICVViewHolder>)onCreateViewHolder {
    return [[DIYSmallViewHolder alloc] init];
}

- (CGSize)getViewSizeAt:(NSUInteger)position {
    CGSize size = CGSizeMake([MesherModel uiWidthBy:150.0f], [MesherModel uiHeightBy:100.0f]);
    return size;
}

@end
