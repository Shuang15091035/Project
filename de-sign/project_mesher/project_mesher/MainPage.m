//
//  FirstTime.m
//  project_mesher
//
//  Created by mac zdszkj on 15/11/23.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "MainPage.h"
#import "MesherModel.h"

@interface MainPage () {
    JWRelativeLayout *lo_main_ground;
    JWRelativeLayout *lo_launchScreen;
    UIImageView *img_launchScreen;
}

@end

@implementation MainPage

- (UIView *)onCreateView:(UIView *)parent {
    
    lo_main_ground = [JWRelativeLayout layout];
    lo_main_ground.tag = R_id_lo_main_ground;
    lo_main_ground.layoutParams.width = JWLayoutMatchParent;
    lo_main_ground.layoutParams.height = JWLayoutMatchParent;
    [parent addSubview:lo_main_ground];
    
//    UIImage *bg_enter_ipad = [UIImage imageByResourceDrawable:@"bg_enter_ipad.png"];
//    UIImage *bg_enter_iphone = [UIImage imageByResourceDrawable:@"bg_enter_iphone.png"];
//    UIImageView *img_enter = [[UIImageView alloc] init];
//    img_enter.layoutParams.width = JWLayoutMatchParent;
//    img_enter.layoutParams.height = JWLayoutMatchParent;
//    [lo_main_ground addSubview:img_enter];
//    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
//        img_enter.image = bg_enter_ipad;
//    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
//        img_enter.image = bg_enter_iphone;
//    }
    
    JWRelativeLayout *lo_suit = [JWRelativeLayout layout];
    lo_suit.tag = R_id_left_lo_suit;
    lo_suit.layoutParams.width = 0.5;
    lo_suit.layoutParams.height = JWLayoutMatchParent;
    lo_suit.layoutParams.alignment = JWLayoutAlignParentLeft;
    [lo_main_ground addSubview:lo_suit];
    lo_suit.clickable = YES;
    [self.gestureEventBinder bindEventsWithType:JWGestureTypeSingleTap toView:lo_suit willBindSubviews:NO andFilter:nil];
    
    JWRelativeLayout *lo_DIY = [JWRelativeLayout layout];
    lo_DIY.tag = R_id_right_lo_DIY;
    lo_DIY.layoutParams.width = 0.5;
    lo_DIY.layoutParams.height = JWLayoutMatchParent;
    lo_DIY.layoutParams.alignment = JWLayoutAlignParentRight;
    [lo_main_ground addSubview:lo_DIY];
    lo_DIY.clickable = YES;
    [self.gestureEventBinder bindEventsWithType:JWGestureTypeSingleTap toView:lo_DIY willBindSubviews:NO andFilter:nil];
    
    lo_main_ground.clickable = YES;
    [self.gestureEventBinder bindEventsWithType:JWGestureTypeSingleTap toView:lo_main_ground willBindSubviews:NO andFilter:nil];
    lo_launchScreen = [JWRelativeLayout layout];
    lo_launchScreen.layoutParams.width = JWLayoutMatchParent;
    lo_launchScreen.layoutParams.height = JWLayoutMatchParent;
    lo_launchScreen.backgroundColor = [UIColor colorWithARGB:0xff35c6ff];
    [lo_main_ground addSubview:lo_launchScreen];
    
    UIImage *img_launch = [UIImage imageByResourceDrawable:@"img_launch"];
    img_launchScreen = [[UIImageView alloc] initWithImage:img_launch];
    img_launchScreen.contentMode = UIViewContentModeScaleAspectFit; // 图片等比缩放
    img_launchScreen.layoutParams.width = JWLayoutMatchParent;//[MesherModel uiWidthBy:1850.0f];
    img_launchScreen.layoutParams.height = JWLayoutMatchParent;//[MesherModel uiHeightBy:1500.0f];
    img_launchScreen.layoutParams.alignment = JWLayoutAlignCenterInParent;
    [lo_launchScreen addSubview:img_launchScreen];
    
    return lo_main_ground;
}

- (void)onStateEnter:(NSDictionary *)data {
    [super onStateEnter:data];
    
    if (mModel.launchIndex == 0){
        [UIView animateWithDuration:1.0 animations:^{
            lo_launchScreen.alpha = 0.99;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1.0 animations:^{ // 类方法实现UIView的动画效果
                lo_launchScreen.alpha = 0;
            } completion:^(BOOL finished) {
                lo_launchScreen.hidden = YES;
                mModel.launchIndex++;
            }];
        }];
    } else if (mModel.launchIndex != 0) {
        lo_launchScreen.hidden = YES;
    }

    lo_main_ground.hidden = NO;
}

- (void)onStateLeave {
    lo_main_ground.hidden = YES;
    [super onStateLeave];
}

- (void)onSingleTap:(UITapGestureRecognizer *)singleTap {
    switch (singleTap.view.tag) {
        case R_id_left_lo_suit: {
            // TODO
            [self.parentMachine changeStateTo:[States Suit] pushState:NO];
            //[[[JWCorePluginSystem instance].log withType:JWLogTypeUi] log:@"敬请期待"];
            break;
        }
        case R_id_right_lo_DIY: {
            [self.parentMachine changeStateTo:[States DIY] pushState:NO];
//            [mModel.project loadPlans];
//            if (mModel.project.numPlans == 0) {
//                mModel.currentPlan = [mModel.project createPlan];
//                [mModel.project savePlans];
//                [self.parentMachine changeStateTo:[States PlanEdit] pushState:NO];
//                //[self.parentMachine changeStateTo:[States RoomShape]];
//            } else {
//                [self.parentMachine changeStateTo:[States DIY] pushState:NO];
//            }
            break;
        }
        default:
            break;
    }
}

@end
