//
//  InspiratedCameraBehaviour.m
//  project_mesher
//
//  Created by mac zdszkj on 16/4/15.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "InspiratedCameraBehaviour.h"
#import "MesherModel.h"

@interface InspiratedCameraBehaviour () {
    id<IMesherModel> mModel;
}

@end

@implementation InspiratedCameraBehaviour

- (id)initWithContext:(id<JIGameContext>)context AndModel:(id<IMesherModel>)model {
    self = [super initWithContext:context];
    if (self) {
        mModel = model;
    }
    return self;
}

- (void)onPinch:(UIPinchGestureRecognizer *)pinch {
    switch (pinch.state) {
        case UIGestureRecognizerStateBegan: {
            break;
        }
        case UIGestureRecognizerStateChanged: {
            JCVector3 position = [mModel.inspiratedCamera.host.transform positionInSpace:JWTransformSpaceWorld];
            position.z += (1.0f - pinch.scale);
            [mModel.inspiratedCamera.host.transform setPosition:position inSpace:JWTransformSpaceWorld];
            //JCVector3 position = [mModel.inspiratedCamera.host.transform positionInSpace:JWTransformSpaceWorld];
            position = [mModel.inspiratedCamera.host.transform positionInSpace:JWTransformSpaceWorld];
            NSLog(@"%f,%f,%f",position.x,position.y,position.z);
            pinch.scale = 1.0f;
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            pinch.scale = 1.0f;
        }
        default:
            break;
    }
}


@end
