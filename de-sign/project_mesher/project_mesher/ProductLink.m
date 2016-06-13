//
//  ProductLink.m
//  project_mesher
//
//  Created by MacMini on 15/10/20.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "ProductLink.h"
#import "MesherModel.h"
#import "Data.h"

@interface ProductLink () {
    UIWebView *wv_item;
    Product* mProduct;
}

@end

@implementation ProductLink

- (UIView *)onCreateView:(UIView *)parent{
    JWRelativeLayout *lo_item_link = [JWRelativeLayout layout];
    lo_item_link.layoutParams.width = JWLayoutMatchParent;
    lo_item_link.layoutParams.height = JWLayoutMatchParent;
    [parent addSubview:lo_item_link];
    
    wv_item = [[UIWebView alloc] init];
    wv_item.layoutParams.width = JWLayoutMatchParent;
    wv_item.layoutParams.height = JWLayoutMatchParent;
    //wv_item.backgroundColor = [UIColor redColor];
    [lo_item_link addSubview:wv_item];
    
    UIImage *btn_close_n = [UIImage imageByResourceDrawable:@"btn_close_n"];
    UIImageView *btn_close = [[UIImageView alloc] initWithImage:btn_close_n];
    btn_close.tag = R_id_btn_close;
    btn_close.layoutParams.width = JWLayoutWrapContent;
    btn_close.layoutParams.height = JWLayoutWrapContent;
    btn_close.layoutParams.alignment = JWLayoutAlignParentLeft | JWLayoutAlignParentTop;
    btn_close.layoutParams.marginLeft = [MesherModel uiWidthBy:80.0f];
    btn_close.layoutParams.marginTop = [MesherModel uiHeightBy:80.0f];
    [lo_item_link addSubview:btn_close];
    
    btn_close.userInteractionEnabled = YES;
    [self.gestureEventBinder bindEventsWithType:JWGestureTypeSingleTap toView:btn_close willBindSubviews:NO andFilter:nil];
    
    return lo_item_link;
}

- (BOOL)onPreCondition {
    Item* item = [Data getItemFromInstance:mModel.selectedObject];
    if (item == nil || item.product == nil) {
        return NO;
    }
    mProduct = item.product;
    return YES;
}

- (void)onStateEnter:(NSDictionary *)data{
    [super onStateEnter:data];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:mProduct.link]];
    [wv_item loadRequest:request];
}

- (void)onSingleTap:(UITapGestureRecognizer *)singleTap{
    switch (singleTap.view.tag){
        case R_id_btn_close: {
            [self.parentMachine revertState];
            break;
        }
        default:
            break;
    }
}


@end
