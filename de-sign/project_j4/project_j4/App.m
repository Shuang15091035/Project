//
//  App.m
//  project_mesher
//
//  Created by MacMini on 15/10/12.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "App.h"

#import "Mesher.h"

@implementation App

- (CCVStateController *)onCreateMainController{
    Mesher *mesherController = [[Mesher alloc]init];
    return mesherController;
}

- (void)onCreated{
    [CCVCorePluginSystem instance].imageSystem = [CCVImageSystem system];
    [CCVCorePluginSystem instance].imageCache = [CCVImageCache cache];
    [CCVCorePluginSystem instance].log = [CCVLog log];
    [CCVCorePluginSystem instance].log.logUi = [CCVToastLogUi logUi];
    
    [self.appMachine addState:[CCVControllerState stateWithController:self.mainController parent:self.navigationController containerId:0] withName:[States Mesher]];
    [self.appMachine changeStateTo:[States Mesher]];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskLandscapeRight;
}

@end
