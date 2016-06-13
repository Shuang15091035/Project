//
//  JWARImageTarget.h
//  June Winter_game
//
//  Created by GavinLo on 15/3/5.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGamePredef.h>
#import <jw/JWComponent.h>
#import <jw/JCMatrix4.h>

@protocol JIOnARImageTargetListener <NSObject>

- (void) onARImageTarget:(id<JIARImageTarget>)imageTarget beenFound:(BOOL)found;

@end

typedef void (^JWOnARImageTargetBeenFoundBlock)(id<JIARImageTarget> imageTarget, BOOL found);

@interface JWOnARImageTargetListener : NSObject <JIOnARImageTargetListener>

@property (nonatomic, readwrite) JWOnARImageTargetBeenFoundBlock onARImageTargetBeenFound;

@end

@protocol JIARImageTarget <JIComponent>

@property (nonatomic, readwrite, getter=isVisible) BOOL visible;
- (void) toggleExtendedTracking:(BOOL)onOff;
@property (nonatomic, readwrite) id<JIARDataSet> dataSet;
- (void) onARTransformChanged:(JCMatrix4)matrix;
@property (nonatomic, readwrite) id<JIOnARImageTargetListener> listener;

@end

@interface JWARImageTarget : JWComponent <JIARImageTarget> {
    BOOL mVisible;
    id<JIARDataSet> mDataSet;
    id<JIOnARImageTargetListener> mListener;
}

@end
