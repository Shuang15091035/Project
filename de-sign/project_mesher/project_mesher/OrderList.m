//
//  OrderList.m
//  project_mesher
//
//  Created by MacMini on 15/10/12.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "OrderList.h"
#import "ProductList.h"
#import "MesherModel.h"
#import "GamePhotographer.h"
#import "OrderListAdapter.h"
#import <jw/JCMath.h>

@interface OrderList (){
    OrderListAdapter* mOrderListAdapter;
    JWCollectionView *cv_order;
    UILabel* tv_total;
}

@end

@implementation OrderList

- (UIView *)onCreateView:(UIView *)parent{
    
    JWRelativeLayout *lo_order_list = [JWRelativeLayout layout];
    lo_order_list.layoutParams.width = JWLayoutMatchParent;
    lo_order_list.layoutParams.height = JWLayoutMatchParent;
    lo_order_list.backgroundColor = [UIColor whiteColor];
    [parent addSubview:lo_order_list];
    
    //标题lo
    JWRelativeLayout *lo_order_title = [JWRelativeLayout layout];
    lo_order_title.layoutParams.width = JWLayoutMatchParent;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        lo_order_title.layoutParams.height = [MesherModel uiHeightBy:100.0f];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        lo_order_title.layoutParams.height = [MesherModel uiHeightBy:150.0f];
    }
    lo_order_title.backgroundColor = [UIColor colorWithARGB:R_color_order_title_bg_color];
    [lo_order_list addSubview:lo_order_title];
    
//    UIImage *bg_title_linear = [UIImage imageByResourceDrawable:@"img_order_title"];
//    UIImageView *bg_title_l = [[UIImageView alloc] initWithImage:bg_title_linear];
//    bg_title_l.layoutParams.width = JWLayoutMatchParent;
//    bg_title_l.layoutParams.height = JWLayoutMatchParent;
//    [lo_order_title addSubview:bg_title_l];
    
    //返回按钮
    UIImage *btn_back_n = [UIImage imageByResourceDrawable:@"btn_back_white"];
    UIImageView *btn_back = [[UIImageView alloc] initWithImage:btn_back_n];
    btn_back.tag = R_id_btn_back;
    btn_back.layoutParams.width = JWLayoutWrapContent;
    btn_back.layoutParams.height = JWLayoutWrapContent;
    btn_back.layoutParams.alignment = JWLayoutAlignParentLeft | JWLayoutAlignCenterVertical;
    btn_back.layoutParams.marginLeft = [MesherModel uiWidthBy:10.0f];
    [lo_order_title addSubview:btn_back];
    
    CGFloat titleTextSize = 0.0f;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        titleTextSize = 20;
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        titleTextSize = 15;
    }
    
    //标题文字
    UILabel *tv_title = [[UILabel alloc] init];
    tv_title.layoutParams.width = JWLayoutWrapContent;
    tv_title.layoutParams.height = JWLayoutWrapContent;
    tv_title.layoutParams.alignment = JWLayoutAlignCenterInParent;
    tv_title.text = @"账 单";
    tv_title.labelTextSize = titleTextSize;
    tv_title.textColor = [UIColor whiteColor];
    [lo_order_title addSubview:tv_title];
    
    const CGFloat totalTextSize = 15;
    
    // 确认付款layout
    JWRelativeLayout* lo_pay = [JWRelativeLayout layout];
    lo_pay.layoutParams.width = JWLayoutMatchParent;
    lo_pay.layoutParams.height = [self uiHeightBy:290.0f];
    lo_pay.layoutParams.alignment = JWLayoutAlignParentBottom;
    [lo_order_list addSubview:lo_pay];
    
    // 预付定金10%
    UIButton* btn_pay = [[UIButton alloc] init];
    btn_pay.hidden = YES;
    btn_pay.layoutParams.width = [self uiWidthBy:450.0f];
    btn_pay.layoutParams.height = [self uiHeightBy:100.0f];
    btn_pay.layoutParams.alignment = JWLayoutAlignParentBottomRight;
    btn_pay.layoutParams.marginRight = [self uiWidthBy:120.0f];
    btn_pay.layoutParams.marginBottom = [self uiHeightBy:30.0f];
    btn_pay.backgroundColor = [UIColor colorWithARGB:R_color_order_title_bg_pay_color];
    btn_pay.text = @"预付定金10%";
    btn_pay.buttonTextSize = totalTextSize;
    [btn_pay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lo_pay addSubview:btn_pay];
    
    // 总价
    JWRelativeLayout* lo_total = [JWRelativeLayout layout];
    lo_total.layoutParams.width = JWLayoutMatchParent;
    lo_total.layoutParams.height = [self uiHeightBy:100.0f];
    lo_total.layoutParams.above = btn_pay;
    lo_total.backgroundColor = [UIColor clearColor];
    [lo_pay addSubview:lo_total];
    
    // 总价：¥
    UILabel* tv_total_text = [[UILabel alloc] init];
    tv_total_text.layoutParams.width = JWLayoutWrapContent;
    tv_total_text.layoutParams.height = JWLayoutWrapContent;
    tv_total_text.layoutParams.alignment = JWLayoutAlignParentRight;
    tv_total_text.layoutParams.marginRight = [self uiWidthBy:350.0f];
    tv_total_text.labelTextSize = totalTextSize;
    tv_total_text.text = @"总价：￥";
    tv_total_text.textColor = [UIColor colorWithARGB:R_color_total_text];
    [lo_total addSubview:tv_total_text];
    
    // 总价格
    tv_total = [UILabel new];
    tv_total.layoutParams.width = JWLayoutWrapContent;
    tv_total.layoutParams.height = JWLayoutWrapContent;
    tv_total.layoutParams.rightOf = tv_total_text;
    tv_total.labelTextSize = totalTextSize;
    tv_total.textColor = [UIColor colorWithARGB:R_color_total_price];
    [lo_total addSubview:tv_total];
    
    // 分割线
    UIView* line = [UIView new];
    line.layoutParams.width = JWLayoutMatchParent;
    line.layoutParams.height = 1;
    line.layoutParams.alignment = JWLayoutAlignParentTop;
    line.backgroundColor = [UIColor colorWithARGB:R_color_order_list_line];
    [lo_pay addSubview:line];
    
    // 报价单列表
    cv_order = [JWCollectionView collectionView];
    cv_order.backgroundColor = [UIColor whiteColor]; // collectionView的背景默认无色 需要手动设置
    cv_order.layoutParams.width = JWLayoutMatchParent;
    cv_order.layoutParams.height = JWLayoutMatchParent;
    cv_order.layoutParams.above = lo_pay;
    cv_order.layoutParams.below = lo_order_title;
    [lo_order_list addSubview:cv_order];
    cv_order.allowsSelection = NO;
    mOrderListAdapter = [[OrderListAdapter alloc] init];
    cv_order.adapter = mOrderListAdapter;
    
    btn_back.userInteractionEnabled = YES;
    [self.gestureEventBinder bindEventsWithType:JWGestureTypeSingleTap toView:btn_back willBindSubviews:NO andFilter:nil];
    btn_pay.userInteractionEnabled = YES;
    [self.gestureEventBinder bindEventsWithType:JWGestureTypeSingleTap toView:btn_pay willBindSubviews:NO andFilter:nil];
    
    return lo_order_list;
}

- (void)onSingleTap:(UITapGestureRecognizer *)singleTap{
    switch (singleTap.view.tag) {
        case R_id_btn_back:{
            [self.parentMachine revertState];
            break;
        }
        case R_id_btn_pay:{
            // TODO 跳转到支付页面
            break;
        }
        default:
            break;
    }
}

- (void)onStateEnter:(NSDictionary *)data{
    [super onStateEnter:data];
    mOrderListAdapter.data = mModel.currentPlan.order.areaAndItems;
    [mOrderListAdapter notifyDataSetChanged];
    tv_total.text = [NSString stringWithFormat:@"%.2f", mModel.currentPlan.order.totalPrice];
}

@end
