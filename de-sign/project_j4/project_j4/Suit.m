//
//  Suit.m
//  project_mesher
//
//  Created by mac zdszkj on 15/11/26.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Suit.h"
#import "MesherModel.h"
#import "SuitAdapter.h"

@interface Suit () {
    CCVRelativeLayout *lo_suit;
    SuitAdapter *mSuitAdapter;
}

@end

@implementation Suit

- (UIView *)onCreateView:(UIView *)parent {
    [super onCreateView:parent];
    lo_suit = [parent viewWithTag:R_id_lo_room_base];
    mSuitAdapter = [[SuitAdapter alloc] init];
    cv_collection.adapter = mSuitAdapter;
    __block typeof (self)weakSelf = self;
    id<IMesherModel> model = mModel;
    cv_collection.onItemSelected = ^(NSUInteger position, id item, BOOL selected){
        Plan *suitPlan = [model.project suitPlanAtIndex:position];
        Plan *plan = [model.project copySuitPlan:suitPlan];
        model.currentPlan = plan;
        [weakSelf.parentMachine changeStateTo:[States PlanEdit] pushState:NO];
    };
    
    return lo_suit;
}

- (NSArray*)getRoomNames {
    NSArray *subRoomNames = @[@" 全 部 ",
                               @" 一 室 ",
                               @" 二 室 ",
                               @" 三 室 ",
                               @" 其 他 ",
                               ];
    return subRoomNames;
}

- (NSArray*)getRoomTags {
    NSArray *subRoomTags = @[
                              @(R_id_btn_architecture_all),
                              @(R_id_btn_architecture_one),
                              @(R_id_btn_architecture_two),
                              @(R_id_btn_architecture_three),
                              @(R_id_btn_architecture_other),
                              ];
    return subRoomTags;
}

- (void)onStateEnter:(NSDictionary *)data {
    [super onStateEnter:data];
    
    [mModel.project loadSuitPlans];
    if (isFirstTime) {
        [lo_architecture_name addSubview:btn_room_names[0]];
        [buttons add:btn_room_names[0]];
        [rooms add:mModel.project.suitRooms[0]];
        for (NSUInteger i = 1; i < RoomsMaxNum; i++) {
            if (mModel.project.suitRooms[i].count > 0) {
                [lo_architecture_name addSubview:btn_room_names[i]];
                [buttons add:btn_room_names[i]];
                [rg_architecture_button addView:btn_room_names[i]];
                [rooms add:mModel.project.suitRooms[i]];
                btn_room_names[i].layoutParams.marginTop = [MesherModel uiHeightBy:190.0f];
            }
        }
        isFirstTime = NO;
    }
    
    mSuitAdapter.data = mModel.project.suitRooms[0];
    [mSuitAdapter notifyDataSetChanged];
}

- (void)onStateLeave {
    [super onStateLeave];
}

- (void)backToDIY:(id)sender {
    [self.parentMachine changeStateTo:[States DIY] pushState:NO];
}

- (BOOL)onTouchUp:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    for (NSUInteger i = 0; i < RoomsMaxNum; i++) {
        if (touch.view.tag == btn_room_tags[i]) {
            rg_architecture_button.checkedView = touch.view;
            mSuitAdapter.data = mModel.project.suitRooms[i];
            [mSuitAdapter notifyDataSetChanged];
        }
    }
    return YES;
}

#pragma mark - 滑动更新GrideView数据
- (void)swipeUpdateGrideView:(NSInteger)index{
    mSuitAdapter.data = rooms[index];
    [mSuitAdapter notifyDataSetChanged];
}
@end
