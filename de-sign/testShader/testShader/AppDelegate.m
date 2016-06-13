//
//  AppDelegate.m
//  testShader
//
//  Created by mac zdszkj on 16/2/24.
//  Copyright © 2016年 mac zdszkj. All rights reserved.
//

#import "AppDelegate.h"
#import <ctrlcv/ctrlcv_core.h>
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (CCVStateController *)onCreateMainController{
    ViewController *view = [[ViewController alloc]init];
    return view;
}

- (void)onCreated{
    [CCVCorePluginSystem instance].imageSystem = [CCVImageSystem system];
    [CCVCorePluginSystem instance].imageCache = [CCVImageCache cache];
    [CCVCorePluginSystem instance].log = [CCVLog log];
    [CCVCorePluginSystem instance].log.logUi = [CCVToastLogUi logUi];
    
    [self.appMachine addState:[CCVControllerState stateWithController:self.mainController parent:self.navigationController containerId:0] withName:@"shader"];
    [self.appMachine changeStateTo:@"shader"];
}



@end
