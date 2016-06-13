//
//  ItemCreateCommand.m
//  project_mesher
//
//  Created by MacMini on 15/11/4.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "ItemCreateCommand.h"
#import "MesherModel.h"

@interface ItemCreateCommand () {
    id<JIGameObject> mObject;
    Plan *mPlan;
    BOOL mWillDeleteObject;
    id<JIGameObject> mGridsObject;
}

@end

@implementation ItemCreateCommand

@synthesize object = mObject;
@synthesize plan = mPlan;
@synthesize gridsObject = mGridsObject;

- (void)onDestroy {
    if (mWillDeleteObject) {
        [mPlan destroyObject:mObject];
    }
    [super onDestroy];
}

- (void)todo {
    if (mObject == nil) {
        return;
    }
    [mPlan addObject:mObject];
    mObject.visible = YES;
    mWillDeleteObject = NO;
    Item* item = [Data getItemFromInstance:mObject];
    if (item != nil && item.product != nil && item.product.area == AreaArchitecture) {
        [mObject setQueryMask:SelectedMaskCannotSelect recursive:YES];
        mGridsObject.visible = NO;
    }
}

- (void)undo {
    if (mObject == nil) {
        return;
    }
    [mPlan removeObject:mObject];
    mObject.visible = NO;
    mWillDeleteObject = YES;
    Item* item = [Data getItemFromInstance:mObject];
    if (item != nil && item.product != nil && item.product.area == AreaArchitecture) {
        [mObject setQueryMask:SelectedMaskCannotSelect recursive:YES];
        mGridsObject.visible = YES;
    }
}

@end
