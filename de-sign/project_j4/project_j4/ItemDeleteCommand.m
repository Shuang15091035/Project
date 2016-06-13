//
//  ItemDeleteCommand.m
//  project_mesher
//
//  Created by mac zdszkj on 15/11/6.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "ItemDeleteCommand.h"
#import "MesherModel.h"

@interface ItemDeleteCommand () {
    id<ICVGameObject> mObject;
    Plan *mPlan;
    BOOL mWillDeleteObject;
}

@end

@implementation ItemDeleteCommand

- (void)onDestroy {
    if (mWillDeleteObject) {
        [CCVCoreUtils destroyObject:mObject];
    }
    [super onDestroy];
}

@synthesize object = mObject;
@synthesize plan = mPlan;

- (void)todo {
    if (mObject == nil) {
        return;
    }
    [mPlan removeObject:mObject];
    mObject.visible = NO;
    mWillDeleteObject = YES;
    mObject.queryMask = [MesherModel CanNotSelectMask];
}

- (void)undo {
    if (mObject == nil) {
        return;
    }
    [mPlan addObject:mObject];
    mObject.visible = YES;
    mWillDeleteObject = NO;
    mObject.queryMask = [MesherModel CanSelectMask];
}

@end
