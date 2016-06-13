//
//  ItemLongPressRotateCommand.m
//  project_mesher
//
//  Created by mac zdszkj on 15/12/17.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "ItemLongPressRotateCommand.h"

@interface ItemLongPressRotateCommand () {
    id<ICVGameObject> mObject;
    float mAngle;
}

@end

@implementation ItemLongPressRotateCommand

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
