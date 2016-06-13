//
//  JWStateController.h
//  June Winter
//
//  Created by GavinLo on 14-2-13.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <jw/JWAppState.h>
#import <jw/JWAppStateMachine.h>

@protocol JIStateControllerUtils <NSObject>

- (void) toggleFullscreen;

@end

/**
 * 把UIViewController包装成一个状态,需要配合JWControllerState使用
 */
@interface JWStateController : UIViewController <JIAppState, JIStateControllerUtils>
{
    id<JIStateMachine> mAppMachine;
    id<JIStateMachine> mParentMachine;
    id<JIStateMachine> mSubMachine;
}

- (void) onPrepare;
- (void) onLowMemory;

@property (nonatomic, readonly) id<JIStateMachine> appMachine;

- (void) notifyParent:(id<JIStateMachine>)parentMachine;

@end
