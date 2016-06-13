//
//  RoomShape.m
//  project_mesher
//
//  Created by mac zdszkj on 15/11/27.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "RoomShape.h"
#import "Common.h"
#import "MesherModel.h"
#import "RoomShapeAdapter.h"

@interface RoomShape () {
    JWRelativeLayout *lo_room_shape;
    RoomShapeAdapter *mRoomAdapter;

}

@end

@implementation RoomShape

- (UIView *)onCreateView:(UIView *)parent {
    [super onCreateView:parent];
    lo_room_shape = [parent viewWithTag:R_id_lo_room_base];
    mRoomAdapter = [[RoomShapeAdapter alloc] init];
    cv_collection.adapter = mRoomAdapter;
    __block typeof (self)weakSelf = self;
    id<IMesherModel> model = mModel;
    cv_collection.onItemSelected = ^(NSUInteger position, id item, BOOL selected){
//         = [model.project createPlan];
        model.currentPlan = [model.project createPlan];
        Plan *p = [model.currentRoomShapes at:position];
        model.currentPlan.type = p.type;
        model.currentPlan.scene.data = p.scene.data;
//        model.currentPlan = [model.project copyBasePlan:p];
        [model.project savePlans];
//        model.roomItem = [model.currentRoomShapes at:position];
        model.currentPlan.isCreate = YES;
        model.currentPlan.isCreatedPlan = YES;
        [weakSelf.parentMachine changeStateTo:[States PlanEdit] pushState:NO];
    };
    return lo_room_shape;
}

- (NSArray*)getRoomNames {
    NSArray *subRoomNames = @[@" 基 础 ",
                              @" 一 室 ",
                              @" 二 室 ",
                              @" 三 室 ",
                              @" 其 他 ",
                              ];
    return subRoomNames;
}

- (NSArray*)getRoomTags {
    NSArray *subRoomTags = @[
                             @(R_id_btn_room_shape_base),
                             @(R_id_btn_room_shape_one),
                             @(R_id_btn_room_shape_two),
                             @(R_id_btn_room_shape_three),
                             @(R_id_btn_room_shape_other),
                             ];
    return subRoomTags;
}


- (void)onStateEnter:(NSDictionary *)data {
    [super onStateEnter:data];
    
    if (isFirstTime) {
        [mModel.project loadBasePlans];
        [lo_architecture_name addSubview:btn_room_names[0]];
        [buttons add:btn_room_names[0]];
        [rooms add:mModel.project.shapeRooms[0]];
        for (NSUInteger i = 1; i < RoomsMaxNum; i++) {
            if (mModel.project.shapeRooms[i].count > 0) {
                [lo_architecture_name addSubview:btn_room_names[i]];
                [buttons add:btn_room_names[i]];
                [rg_architecture_button addView:btn_room_names[i]];
                [rooms add:mModel.project.shapeRooms[i]];
                btn_room_names[i].layoutParams.marginTop = [MesherModel uiHeightBy:190.0f];
            }
        }
        isFirstTime = NO;
    }
    
    mModel.currentRoomShapes = mModel.project.shapeRooms[0];
    mRoomAdapter.data = mModel.currentRoomShapes;
    [mRoomAdapter notifyDataSetChanged];
}

- (void)onStateLeave {
    [super onStateLeave];
}

- (BOOL)onTouchUp:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    for (NSUInteger i = 0; i < RoomsMaxNum; i++) {
        if (touch.view.tag == btn_room_tags[i]) {
            rg_architecture_button.checkedView = touch.view;
            mModel.currentRoomShapes = mModel.project.shapeRooms[i];
            mRoomAdapter.data = mModel.project.shapeRooms[i];
            [mRoomAdapter notifyDataSetChanged];
        }
    }
    return YES;
}

#pragma mark - 滑动更新GrideView数据
- (void)swipeUpdateGrideView:(NSInteger)index{
    mModel.currentRoomShapes = rooms[index];
    mRoomAdapter.data = rooms[index];
    [mRoomAdapter notifyDataSetChanged];
}

@end
