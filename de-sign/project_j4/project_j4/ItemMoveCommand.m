//
//  ItemMoveCommand.m
//  project_mesher
//
//  Created by MacMini on 15/10/18.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "ItemMoveCommand.h"
#import "Plan.h"

@interface ItemMoveCommand () {
    Plan *mPlan;
    
    id<ICVGameObject> mObject;
    CCCVector3 mOriginPosition;
    CCCVector3 mDestPosition;
    
    id<ICVTransform> mOriginTransform;
    id<ICVTransform> mDestTransform;
}

@end

@implementation ItemMoveCommand

@synthesize plan = mPlan;
@synthesize object = mObject;
@synthesize originPosition = mOriginPosition;
@synthesize destPosition = mDestPosition;

@synthesize originTransform = mOriginTransform;
@synthesize destTransform = mDestTransform;

- (void)todo {
    if (mObject == nil) {
        return ;
    }
    // 对象位置变动                   目标位置点                世界坐标系
    [mObject.transform setPositionV:mDestPosition inSpace:CCVTransformSpaceWorld];
    [mPlan itemOverlap:mObject];
}

- (void)undo {
    if (mObject == nil) {
        return ;
    }
    // 对象位置变动                   原来位置点                世界坐标系
    [mObject.transform setPositionV:mOriginPosition inSpace:CCVTransformSpaceWorld];
    [mPlan itemOverlap:mObject];
}

@end
