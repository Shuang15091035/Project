//
//  AppDelegate.m
//  demo_custom_furniture
//
//  Created by ddeyes on 16/5/27.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "AppDelegate.h"
#import "Showcase.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (JWStateController *)onCreateMainController {
    return [[Showcase alloc] init];
}

- (void)onCreated {
    [JWCorePluginSystem instance].imageSystem = [JWImageSystem system];
    [JWCorePluginSystem instance].imageCache = [JWImageCache cache];
    [JWCorePluginSystem instance].log = [JWLog log];
    [JWCorePluginSystem instance].log.logUi = [JWToastLogUi logUi];
    
    [self.appMachine addState:[JWControllerState stateWithController:self.mainController parent:self.navigationController containerId:0] withName:@"Showcase"];
    [self.appMachine changeStateTo:@"Showcase"];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskLandscapeRight;
}

@end
