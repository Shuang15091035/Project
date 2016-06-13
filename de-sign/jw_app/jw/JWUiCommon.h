//
//  JWUiCommon.h
//  jw_app
//
//  Created by ddeyes on 16/4/16.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JWTextStyle) {
    JWTextStyleNormal,
    JWTextStyleBold,
    JWTextStyleItalic,
    JWTextStyleBoldItalic,
};

typedef NS_OPTIONS(NSUInteger, JWUiFitOptions) {
    JWUiFitOptionWidth =  0x1 << 0,
    JWUiFitOptionHeight = 0x1 << 1,
    JWUiFitOptionSize = JWUiFitOptionWidth | JWUiFitOptionHeight,
};
