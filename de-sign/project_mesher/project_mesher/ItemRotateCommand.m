//
//  ItemRotateCommand.m
//  project_mesher
//
//  Created by MacMini on 15/10/22.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "ItemRotateCommand.h"

@interface ItemRotateCommand () {
    id<JIGameObject> mObject;
    float mAngle;
}

@end

@implementation ItemRotateCommand

@synthesize object = mObject;
@synthesize angle = mAngle;

- (void)todo {
    if (mObject == nil) {
        return;
    }
    [mObject.transform rotateUpDegrees:mAngle];
}

- (void)undo {
    if (mObject == nil) {
        return;
    }
    [mObject.transform rotateUpDegrees:-mAngle];
}

@end
