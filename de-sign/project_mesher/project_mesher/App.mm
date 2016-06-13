//
//  App.m
//  project_mesher
//
//  Created by MacMini on 15/10/12.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "App.h"

#import "Mesher.h"

@interface App() {
    UIInterfaceOrientationMask mOrientationMask;
}

@end

@implementation App

@synthesize orientationMask = mOrientationMask;

- (JWStateController *)onCreateMainController{
    Mesher *mesherController = [[Mesher alloc]init];
    return mesherController;
}

//- (void)applicationDidBecomeActive:(UIApplication *)application {
//    MojingSDK_API_StartTracker(100);
//    MojingSDK_API_AppResume();
//    MojingSDK_API_AppPageStart(@"MojingSDKForiOSDemo");
//}
//
//- (void)applicationWillResignActive:(UIApplication *)application
//{
//    MojingSDK_API_StopTracker();
//    MojingSDK_API_AppPause();
//    MojingSDK_API_AppPageEnd(@"MojingSDKForiOSDemo");
//}

- (void)onCreated{
    [JWCorePluginSystem instance].imageSystem = [JWImageSystem system];
    [JWCorePluginSystem instance].imageCache = [JWImageCache cache];
    [JWCorePluginSystem instance].log = [JWLog log];
    [JWCorePluginSystem instance].log.logUi = [JWToastLogUi logUi];
    
    [self.appMachine addState:[JWControllerState stateWithController:self.mainController parent:self.navigationController containerId:0] withName:[States Mesher]];
    [self.appMachine changeStateTo:[States Mesher]];
    
    mOrientationMask = UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return mOrientationMask;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // NOTE 阻止iCloud备份document中的数据
    [JWFileUtils addSkipBackupAttributeToItemAtPath:[JWFileUtils documentDirPath]];
    [JWFileUtils addSkipBackupAttributeToItemAtPath:[JWFileUtils libraryDirPath]];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
