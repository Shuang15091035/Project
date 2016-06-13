//
//  JWDialog.h
//  jw_app
//
//  Created by ddeyes on 15/10/31.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWObject.h>

typedef void (^JWDialogOnButtonCheckedBlock)(NSInteger buttonIndex);

/**
 * NOTE **封装系统对话框，这样的封装对话框可以正常显示，但是不触发事件，原因待研究**
 * 使用AppUtils.showDialogWithTitle代替
 */
@interface JWDialog : JWObject

+ (id) dialogWithTitle:(NSString*)title message:(NSString*)message onButtonChecked:(JWDialogOnButtonCheckedBlock)onButtonChecked  cancelButton:(NSString*)cancelButtonTitle otherButtons:(NSString*)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
- (id) initWithTitle:(NSString*)title message:(NSString*)message onButtonChecked:(JWDialogOnButtonCheckedBlock)onButtonChecked  cancelButton:(NSString*)cancelButtonTitle otherButtons:(NSString*)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
- (void) show;

@end
