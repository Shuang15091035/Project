//
//  AppDelegate.m
//  DesignFun
//
//  Created by qianfeng on 15/9/29.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "AppDelegate.h"
#import "MilitaryViewController.h"
#import "DFCommunityController.h"
#import "DFPictureController.h"

@interface AppDelegate (){
    
    NSArray *_imageArray;
    NSArray *_imageAry;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
     self.window.backgroundColor = [UIColor whiteColor];
     [self.window makeKeyAndVisible];
   
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    [[UITabBarItem appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor],NSForegroundColorAttributeName, nil] forState:(UIControlStateSelected)];
    
      [[UINavigationBar appearance]setBarTintColor: [UIColor colorWithRed:148/255.0 green:182/255.0 blue:222/255.0 alpha:1]];
    
    [[UITabBar appearance]setBarTintColor:[UIColor colorWithRed:148/255.0 green:182/255.0 blue:222/255.0 alpha:1]];
    
    
    NSArray *nameArr = @[@"军事",@"图片",@"论坛",@"我的"];
    NSArray *VCArrName = @[@"MilitaryViewController",@"DFPictureController",@"DFCommunityController",@"SettingViewController"];
    NSMutableArray *array = [NSMutableArray array];
    for (int index = 0; index < nameArr.count; index++) {
        UIViewController *viewController = [[NSClassFromString(VCArrName[index]) alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        viewController.title = nameArr[index];

        [array addObject:nav];
    }
    tabBarController.viewControllers = array;
    
    self.window.rootViewController = tabBarController;
    
    _imageAry = @[@"main_home_normal",@"main_pic_normal",@"main_forum_normal",@"main_user_normal"];
    _imageArray = @[@"main_home_press",@"main_pic_press",@"main_forum_press",@"main_user_press"];
    for (int i = 0; i < tabBarController.viewControllers.count; i++) {
        
        
        UIImage *norImage = [[UIImage imageNamed:_imageAry[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *image =  [[UIImage imageNamed:_imageArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UITabBarItem *tabBarItem = tabBarController.tabBar.items[i];
        
        [tabBarItem setImage:norImage];
        [tabBarItem setSelectedImage:image];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
