//
//  OrderListAdapter.m
//  project_mesher
//
//  Created by ddeyes on 15/10/23.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "OrderListAdapter.h"
#import "PlanOrder.h"
#import "MesherModel.h"

@interface OrderListViewItem : NSObject {
    UIImageView* img_image;
    UILabel* tv_name;
    UILabel* tv_count;
    UILabel* tv_total;
    CCVImageOptions* opt_img_image;
}

- (UIView *)onCreateView:(NSBundle *)bundle parent:(UIView *)parent;

@end

@implementation OrderListViewItem

- (UIView *)onCreateView:(NSBundle *)bundle parent:(UIView *)parent {
    
    CCVRelativeLayout* lo_view = [CCVRelativeLayout layout];
    lo_view.layoutParams.width = CCVLayoutMatchParent;
    lo_view.layoutParams.height = [MesherModel uiHeightBy:230.0f];
    [parent addSubview:lo_view];
    
//    CCVLinearLayout* view = [CCVLinearLayout layout];
//    view.layoutParams.width = CCVLayoutMatchParent;
//    view.layoutParams.height = CCVLayoutMatchParent;
//    view.orientation = CCVLayoutOrientationHorizontal;
//    [lo_view addSubview:view];
    
    img_image = [[UIImageView alloc] init];
    CGFloat img_width = [MesherModel uiWidthBy:180.0f];
    CGFloat img_height = [MesherModel uiHeightBy:180.0f];
    CGFloat img_size = img_width > img_height ? img_width : img_height;
    img_image.layoutParams.width = img_size;
    img_image.layoutParams.height = img_size;
    img_image.layoutParams.alignment = CCVLayoutAlignCenterVertical | CCVLayoutAlignParentLeft;
    img_image.layoutParams.marginLeft = [MesherModel uiWidthBy:36.0f];
    [lo_view addSubview:img_image];
    opt_img_image = [CCVImageOptions options];
    opt_img_image.requestWidth = img_size;
    opt_img_image.requestHeight = img_size;
    
    tv_name = [[UILabel alloc] init];
    tv_name.layoutParams.width = CCVLayoutWrapContent;
    tv_name.layoutParams.height = CCVLayoutWrapContent;
    tv_name.layoutParams.alignment = CCVLayoutAlignCenterVertical | CCVLayoutAlignParentLeft;
    tv_name.layoutParams.marginLeft = [MesherModel uiWidthBy:336.0f];
    tv_name.textAlignment = NSTextAlignmentLeft;
    [lo_view addSubview:tv_name];
    
    CCVRelativeLayout* lo_count = [CCVRelativeLayout layout];
    img_width = [MesherModel uiWidthBy:60.0f];
    img_height = [MesherModel uiHeightBy:60.0f];
    img_size = img_width > img_height ? img_width : img_height;
    lo_count.layoutParams.width = img_size;
    lo_count.layoutParams.height = img_size;
    lo_count.layoutParams.alignment = CCVLayoutAlignCenterVertical | CCVLayoutAlignParentRight;
    //lo_count.layoutParams.marginLeft = [MesherModel uiWidthBy:175.0f];
    lo_count.layoutParams.marginRight = [MesherModel uiWidthBy:380.0f];
    [lo_view addSubview:lo_count];
    UIImage* bg_count = [UIImage imageNamed:@"img_order_list_count"];
    UIImageView* img_bg_count = [[UIImageView alloc] initWithImage:bg_count];
    img_bg_count.layoutParams.width = CCVLayoutMatchParent;
    img_bg_count.layoutParams.height = CCVLayoutMatchParent;
    [lo_count addSubview:img_bg_count];
    tv_count = [[UILabel alloc] init];
    tv_count.layoutParams.width = CCVLayoutMatchParent;
    tv_count.layoutParams.height = CCVLayoutMatchParent;
    tv_count.labelTextSize = 12;
    tv_count.textColor = [UIColor colorWithARGB:R_color_order_list_item_count];
    tv_count.textAlignment = NSTextAlignmentCenter;
    [lo_count addSubview:tv_count];
    
    tv_total = [[UILabel alloc] init];
    tv_total.layoutParams.width = CCVLayoutWrapContent;
    tv_total.layoutParams.height = CCVLayoutWrapContent;
    //tv_total.layoutParams.marginLeft = [MesherModel uiWidthBy:175.0f];
    tv_total.layoutParams.alignment = CCVLayoutAlignCenterVertical | CCVLayoutAlignParentRight;
    tv_total.layoutParams.marginRight = [MesherModel uiWidthBy:130.0f];
    tv_total.labelTextSize = 12;
    tv_total.textColor = [UIColor colorWithARGB:R_color_order_list_item_total];
    tv_total.textAlignment = NSTextAlignmentCenter;
    [lo_view addSubview:tv_total];
    
    UIView* line = [[UIView alloc] init];
    line.layoutParams.width = CCVLayoutMatchParent;
    line.layoutParams.height = 1;
    line.layoutParams.alignment = CCVLayoutAlignParentBottom;
    line.backgroundColor = [UIColor colorWithARGB:R_color_order_list_item_line];
    [lo_view addSubview:line];
    
    return lo_view;
}

- (void) setRecord:(OrderItem*)orderItem {
    Item *item = orderItem.item;
    img_image.image = nil;
    if (item.preview != nil){
        [[CCVCorePluginSystem instance].imageCache getBy:item.preview options:opt_img_image async:YES onGet:^(UIImage *image) {
            img_image.image = image;
        }];
    }
    tv_name.text = [NSString stringWithFormat:@"%@ %@", item.product == nil ? @"未知产品" : item.product.name, item.name];
    tv_count.text = [NSString stringWithFormat:@"%@", @(orderItem.count)];
    tv_total.text = [NSString stringWithFormat:@"%.2f", orderItem.totalPrice];
}

@end

@interface OrderListViewArea : NSObject {
    UILabel* tv_area;
    UILabel* tv_total;
}

- (UIView *)onCreateView:(NSBundle *)bundle parent:(UIView *)parent;

@end

@implementation OrderListViewArea

- (UIView *)onCreateView:(NSBundle *)bundle parent:(UIView *)parent {
    
    CCVRelativeLayout* lo_view = [CCVRelativeLayout layout];
    lo_view.layoutParams.width = CCVLayoutMatchParent;
    lo_view.layoutParams.height = [MesherModel uiHeightBy:100.0f];
    [parent addSubview:lo_view];
    
//    CCVLinearLayout* view = [[CCVLinearLayout alloc] init];
//    view.layoutParams.width = CCVLayoutMatchParent;
//    view.layoutParams.height = CCVLayoutMatchParent;
//    view.orientation = CCVLayoutOrientationHorizontal;
//    [lo_view addSubview:view];
    
    tv_area = [[UILabel alloc] init];
    tv_area.layoutParams.width = CCVLayoutWrapContent;
    tv_area.layoutParams.height = CCVLayoutWrapContent;
    //tv_area.layoutParams.weight = 1;
    tv_area.layoutParams.alignment = CCVLayoutAlignParentLeft | CCVLayoutAlignCenterVertical;
    tv_area.layoutParams.marginLeft = [MesherModel uiWidthBy:60.0f];
    tv_area.labelTextSize = 15;
    tv_area.textColor = [UIColor colorWithARGB:R_color_order_list_area];
    tv_area.textAlignment = NSTextAlignmentLeft;
    [lo_view addSubview:tv_area];
    
    UILabel* tv_total_text = [[UILabel alloc] init];
    tv_total_text.layoutParams.width = CCVLayoutWrapContent;
    tv_total_text.layoutParams.height = CCVLayoutWrapContent;
    tv_total_text.layoutParams.alignment = CCVLayoutAlignParentRight | CCVLayoutAlignCenterVertical;
    tv_total_text.layoutParams.marginRight = [MesherModel uiWidthBy:280.0f];
    tv_total_text.text = @"合计：¥";
    tv_total_text.labelTextSize = 12;
    tv_total_text.textColor = [UIColor colorWithARGB:R_color_order_list_area_total_text];
    tv_total_text.textAlignment = NSTextAlignmentCenter;
    [lo_view addSubview:tv_total_text];
    
    tv_total = [[UILabel alloc] init];
    tv_total.layoutParams.width = CCVLayoutWrapContent;
    tv_total.layoutParams.height = CCVLayoutWrapContent;
    tv_total.layoutParams.alignment = CCVLayoutAlignParentRight | CCVLayoutAlignCenterVertical;
    tv_total.layoutParams.rightOf = tv_total_text;
    tv_total.labelTextSize = 12;
    tv_total.textColor = [UIColor colorWithARGB:R_color_order_list_area_total];
    tv_total.textAlignment = NSTextAlignmentCenter;
    [lo_view addSubview:tv_total];
    
    UIView* line = [[UIView alloc] init];
    line.layoutParams.width = CCVLayoutMatchParent;
    line.layoutParams.height = 1;
    line.layoutParams.alignment = CCVLayoutAlignParentBottom;
    line.backgroundColor = [UIColor colorWithARGB:R_color_order_list_item_line];
    [lo_view addSubview:line];
    
    return lo_view;
}

- (void) setRecord:(OrderArea*)orderArea {
    tv_area.text = [Data areaToString:orderArea.area];
    tv_total.text = [NSString stringWithFormat:@"%.2f", orderArea.totalPrice];
}

@end

@interface OrderListViewHolder : CCVViewHolder {
    OrderListViewItem* mOrderListViewItem;
    OrderListViewArea* mOrderListViewArea;
}

@end

typedef NS_ENUM(NSInteger, OrderListViewType) {
    OrderListViewTypeItem = 0,
    OrderListViewTypeArea = 1,
    OrderListViewTypeNum = 2,
};

@implementation OrderListViewHolder

- (UIView *)onCreateView:(NSBundle *)bundle viewType:(NSUInteger)viewType parent:(UIView *)parent {
    if (viewType == OrderListViewTypeItem) {
        mOrderListViewItem = [[OrderListViewItem alloc] init];
        return [mOrderListViewItem onCreateView:bundle parent:parent];
    } else if (viewType == OrderListViewTypeArea) {
        mOrderListViewArea = [[OrderListViewArea alloc] init];
        return [mOrderListViewArea onCreateView:bundle parent:parent];
    }
    return nil;
}

- (void)setRecord:(id)record {
    if ([record isKindOfClass:[OrderItem class]]) {
        [mOrderListViewItem setRecord:record];
    } else if ([record isKindOfClass:[OrderArea class]]) {
        [mOrderListViewArea setRecord:record];
    }
}

//- (CGSize)getViewSize:(NSUInteger)viewType {
//    CGSize size = CGSizeZero;
//    if (viewType == OrderListViewTypeItem) {
//        size.height = [MesherModel uiHeightBy:230.0f];
//    } else if (viewType == OrderListViewTypeArea) {
//        size.height = [MesherModel uiHeightBy:100.0f];
//    }
//    size.width = size.height;
//    return size;
//}

@end

@implementation OrderListAdapter

- (id<ICVViewHolder>)onCreateViewHolder {
    return [[OrderListViewHolder alloc] init];
}

- (NSUInteger)getViewTypeCount {
    return OrderListViewTypeNum;
}

- (NSUInteger)getViewTypeAt:(NSUInteger)position {
    CCVObject* orderItem = [self getItemAt:position];
    if ([orderItem isKindOfClass:[OrderItem class]]) {
        return OrderListViewTypeItem;
    } else if ([orderItem isKindOfClass:[OrderArea class]]) {
        return OrderListViewTypeArea;
    }
    return 0;
}

- (CGSize)getViewSizeAt:(NSUInteger)position {
    CGSize size = CGSizeZero;
    NSUInteger viewType = [self getViewTypeAt:position];
    if (viewType == OrderListViewTypeItem) {
        size.height = [MesherModel uiHeightBy:230.0f];
    } else if (viewType == OrderListViewTypeArea) {
        size.height = [MesherModel uiHeightBy:100.0f];
    }
    size.width = [UIScreen mainScreen].boundsByOrientation.size.width;
    return size;
}

@end
