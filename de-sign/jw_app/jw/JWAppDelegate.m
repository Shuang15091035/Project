//
//  JWAppDelegate.m
//  June Winter
//
//  Created by GavinLo on 14-2-13.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWAppDelegate.h"
#import "JWAppStateMachine.h"
#import "JWCoreUtils.h"
#import "JWStateController.h"
#import "UIScreen+JWCoreCategory.h"
#import <jw/JWFileUtils.h>

@interface JWAppDelegate ()

@end

@implementation JWAppDelegate

- (id<JIStateMachine>)appMachine
{
    if(mAppMachine == nil)
        mAppMachine = [[JWAppStateMachine alloc] init];
    return mAppMachine;
}

- (UINavigationController *)navigationController
{
    return mNavigationController;
}

- (JWStateController *)mainController
{
    return mMainController;
}

- (JWStateController *)onCreateMainController
{
    return nil;
}

- (void)onCreated
{
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    mMainController = [self onCreateMainController];
    mNavigationController = [[UINavigationController alloc] initWithRootViewController:mMainController];
    [self onCreated];
    
    // window需要原始屏幕的bounds,这里不能调用boundsByOrientation
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:bounds];
    self.window.rootViewController = mNavigationController;
    //[self.window addSubview:mNavigationController.view];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [JWCoreUtils destroyObject:mAppMachine];
    mAppMachine = nil;
}

@end
