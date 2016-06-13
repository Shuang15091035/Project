//
//  JWLabel.h
//  jw_app
//
//  Created by ddeyes on 16/4/15.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWFrameLayout.h>
#import <jw/JWUiCommon.h>

@interface JWLabel : JWFrameLayout

@property (nonatomic, readwrite) NSString* text;
@property (nonatomic, readwrite) CGFloat textSize;
@property (nonatomic, readwrite) UIColor* textColor;
@property (nonatomic, readwrite) NSTextAlignment textAlignment;
@property (nonatomic, readwrite) UIFont* font;
- (void) fitTextWithOptions:(JWUiFitOptions)options;

@end
