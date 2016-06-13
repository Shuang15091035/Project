//
//  JWAppUtils.m
//  jw_app
//
//  Created by ddeyes on 15/10/31.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWAppUtils.h"
#import <UIKit/UIKit.h>

static JWDialogOnButtonCheckedBlock g_DialogOnButtonCheckedBlock;

@interface JWAppUtils () <UIAlertViewDelegate>

@end

@implementation JWAppUtils

// NOTE 必须静态封装事件才被触发，醉的一塌糊涂，原因待研究
+ (void)showDialogWithTitle:(NSString *)title message:(NSString *)message onButtonChecked:(JWDialogOnButtonCheckedBlock)onButtonChecked cancelButton:(NSString *)cancelButtonTitle otherButtons:(NSString *)otherButtonTitles, ... {
    g_DialogOnButtonCheckedBlock = [onButtonChecked copy];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    [alertView show];
}

+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (g_DialogOnButtonCheckedBlock != nil) {
        g_DialogOnButtonCheckedBlock(buttonIndex);
    }
}

+ (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    g_DialogOnButtonCheckedBlock = nil;
}

@end
