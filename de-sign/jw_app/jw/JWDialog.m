//
//  JWDialog.m
//  jw_app
//
//  Created by ddeyes on 15/10/31.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWDialog.h"
#import <UIKit/UIKit.h>

@interface JWDialog () <UIAlertViewDelegate> {
    UIAlertView* mAlertView;
    JWDialogOnButtonCheckedBlock mOnButtonChecked;
}

@end

@implementation JWDialog

+ (id)dialogWithTitle:(NSString *)title message:(NSString *)message onButtonChecked:(JWDialogOnButtonCheckedBlock)onButtonChecked cancelButton:(NSString *)cancelButtonTitle otherButtons:(NSString *)otherButtonTitles, ... {
    return [[self alloc] initWithTitle:title message:message onButtonChecked:onButtonChecked cancelButton:cancelButtonTitle otherButtons:otherButtonTitles, nil];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message onButtonChecked:(JWDialogOnButtonCheckedBlock)onButtonChecked cancelButton:(NSString *)cancelButtonTitle otherButtons:(NSString *)otherButtonTitles, ... {
    self = [super init];
    if (self != nil) {
        mAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
        mOnButtonChecked = onButtonChecked;
    }
    return self;
}

- (void)onDestroy {
    mAlertView = nil;
    [super onDestroy];
}

- (void)show {
    [mAlertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (mOnButtonChecked != nil) {
        mOnButtonChecked(buttonIndex);
    }
}

@end
