//
//  JWAppDelegate.h
//  June Winter
//
//  Created by GavinLo on 14-2-13.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <jw/JWAppStateMachine.h>
#import <jw/JWAppState.h>
#import <jw/JWControllerState.h>

/**
 * app代理,系统定义的程序入口
 */
@interface JWAppDelegate : UIResponder <UIApplicationDelegate>
{
    id<JIStateMachine> mAppMachine;
    UINavigationController* mNavigationController;
    JWStateController* mMainController;
}

@property (nonatomic, strong) UIWindow *window;

/**
 * 全局状态机
 */
@property (nonatomic, readonly) id<JIStateMachine> appMachine;

/**
 * 导航的UIViewController
 */
@property (nonatomic, readonly) UINavigationController* navigationController;

/**
 * 主UIViewController
 *
 */
@property (nonatomic, readonly) JWStateController* mainController;

/**
 * 主JWStateController(程序开始进入的UIViewController)
 * 利用这个返回的JWStateController创建UINavigationController
 * **需要子类实现
 */
- (JWStateController*) onCreateMainController;

/**
 * 可在这里做app的初始化工作,如创建状态等
 * **需要子类实现
 */
- (void) onCreated;

@end
