//
//  JWInertialNavigationSystem.h
//  jw_core
//
//  Created by GavinLo on 15/3/29.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWObject.h>
#import <jw/JCInertialNavigationSystem.h>

@protocol JIInertialNavigationSystem;

typedef void (^OnInertialNavigationSystemUpdateBlock)(id<JIInertialNavigationSystem> ins);

@protocol JIInertialNavigationSystem <JIObject>

- (BOOL) start;
- (void) stop;
@property (nonatomic, readonly) JCInertialNavigationSystemResult result;
@property (nonatomic, readwrite) OnInertialNavigationSystemUpdateBlock onUpdate;

@end

@interface JWInertialNavigationSystem : JWObject <JIInertialNavigationSystem>

@end
