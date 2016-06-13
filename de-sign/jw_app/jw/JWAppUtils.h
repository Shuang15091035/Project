//
//  JWAppUtils.h
//  jw_app
//
//  Created by ddeyes on 15/10/31.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWDialog.h>

@interface JWAppUtils : NSObject

+ (void) showDialogWithTitle:(NSString*)title message:(NSString*)message onButtonChecked:(JWDialogOnButtonCheckedBlock)onButtonChecked  cancelButton:(NSString*)cancelButtonTitle otherButtons:(NSString*)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
