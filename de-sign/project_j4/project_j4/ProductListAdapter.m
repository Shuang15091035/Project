//
//  ProductListAdapter.m
//  project_mesher
//
//  Created by MacMini on 15/10/13.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "ProductListAdapter.h"
#import "Item.h"
#import "MesherModel.h"

@interface ProductViewHolder : CCVViewHolder {
    
    CCVRelativeLayout* view;
    UIImageView* img_image;
    CCVImageOptions* opt_img_image;
    UILabel* tv_name;
}

@end

@implementation ProductViewHolder

- (UIView *)onCreateView:(NSBundle *)bundle viewType:(NSUInteger)viewType parent:(UIView *)parent{
    view = [CCVRelativeLayout layout];
    view.layoutParams.width = [MesherModel uiWidthBy:240.0f];
    view.layoutParams.height = [MesherModel uiHeightBy:328.0f];
    view.backgroundColor = [UIColor clearColor];
    
    img_image = [[UIImageView alloc] init];
    [view addSubview:img_image];
    img_image.layoutParams.width = [MesherModel uiWidthBy:180.0f];
    img_image.layoutParams.height = img_image.layoutParams.width; //[MesherModel uiHeightBy:248.0f];
    img_image.layoutParams.alignment = CCVLayoutAlignParentTop | CCVLayoutAlignCenterHorizontal;
    img_image.layoutParams.marginTop = [MesherModel uiHeightBy:20.0f];
//    opt_img_image = [CCVImageOptions options];
//    opt_img_image.requestWidth = [MesherModel uiWidthBy:180.0f];
//    opt_img_image.requestHeight = opt_img_image.requestWidth; //[MesherModel uiHeightBy:248.0f];
    opt_img_image = nil;
    
    tv_name = [[UILabel alloc] init];
    [view addSubview:tv_name];
    tv_name.layoutParams.width = CCVLayoutWrapContent;
    tv_name.layoutParams.height = CCVLayoutWrapContent;
    tv_name.layoutParams.alignment = CCVLayoutAlignParentTop | CCVLayoutAlignCenterHorizontal;
    tv_name.layoutParams.below = img_image;
    tv_name.labelTextSize = 12;
    tv_name.textColor = [UIColor whiteColor];
//    tv_name.textColor = [UIColor colorWithARGB:R_color_product_name];
    tv_name.shadowColor = [UIColor colorWithARGB:R_color_product_name];
    tv_name.shadowOffset = CGSizeMake(1, 1);
    
    UIView* img_line = [[UIView alloc] init];
    img_line.layoutParams.width = CCVLayoutMatchParent;
    img_line.layoutParams.height = 1;
    img_line.layoutParams.alignment = CCVLayoutAlignParentBottom;
    img_line.backgroundColor = [UIColor colorWithARGB:R_color_product_list_line];
    [view addSubview:img_line];
    
    return view;
}

//传值
- (void)setRecord:(id)record {
    Product* product = record;
    img_image.image = nil;
    if (product.preview != nil){
        [[CCVCorePluginSystem instance].imageCache getBy:product.preview options:nil async:YES onGet:^(UIImage *image) {
            img_image.image = image;
        }];
    }
    tv_name.text = product.name;
}

@end

@implementation ProductListAdapter

- (id<ICVViewHolder>)onCreateViewHolder {
    return [[ProductViewHolder alloc] init];
}

- (CGSize)getViewSizeAt:(NSUInteger)position {
    CGSize size = CGSizeMake([MesherModel uiWidthBy:240.0f], [MesherModel uiHeightBy:328.0f]);
    return size;
}

@end

