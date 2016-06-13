//
//  JWARImageTarget.m
//  June Winter_game
//
//  Created by GavinLo on 15/3/5.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWARImageTarget.h"

#import "JWARSystem.h"
#import "JWARImageTracker.h"
#import "JWGameObject.h"

@interface JWOnARImageTargetListener () {
    JWOnARImageTargetBeenFoundBlock mOnARImageTargetBeenFound;
}

@end

@implementation JWOnARImageTargetListener

- (JWOnARImageTargetBeenFoundBlock)onARImageTargetBeenFound {
    return mOnARImageTargetBeenFound;
}

- (void)setOnARImageTargetBeenFound:(JWOnARImageTargetBeenFoundBlock)onARImageTargetBeenFound {
    mOnARImageTargetBeenFound = onARImageTargetBeenFound;
}

- (void)onARImageTarget:(id<JIARImageTarget>)imageTarget beenFound:(BOOL)found {
    if (mOnARImageTargetBeenFound != nil) {
        mOnARImageTargetBeenFound(imageTarget, found);
    }
}

@end

@implementation JWARImageTarget

@synthesize visible = mVisible;

- (void)toggleExtendedTracking:(BOOL)onOff {
    
}

@synthesize dataSet = mDataSet;

- (void)onARTransformChanged:(JCMatrix4)matrix {
    mHost.transform.matrix = matrix;
}

@synthesize listener = mListener;

- (void)onAddToHost:(id<JIGameObject>)host {
    [super onAddToHost:host];
    id<JIARSystem> arSystem = mContext.arSystem;
    [arSystem.imageTracker registerImageTarget:self];
}

@end
