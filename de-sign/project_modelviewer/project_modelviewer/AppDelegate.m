//
//  AppDelegate.m
//  project_modelviewer
//
//  Created by GavinLo on 15/1/23.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "AppDelegate.h"

#import "ModelViewer.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (CCVStateController *)onCreateMainController
{
    return [[ModelViewer alloc] init];
}

- (void)onCreated
{
    [CCVCorePluginSystem instance].imageSystem = [CCVImageSystem system];
    [CCVCorePluginSystem instance].imageCache = [CCVImageCache cache];
    [CCVCorePluginSystem instance].log = [CCVLog log];
    [CCVCorePluginSystem instance].log.logUi = [CCVToastLogUi logUi];
    
    [self.appMachine addState:[CCVControllerState stateWithController:self.mainController parent:self.navigationController containerId:0] withName:@"ModelViewer"];
    [self.appMachine changeStateTo:@"ModelViewer"];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskLandscapeRight;
}

@end
