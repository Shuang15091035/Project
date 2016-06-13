//
//  UITextField+JWUiCategory.h
//  jw_app
//
//  Created by mac zdszkj on 15/12/21.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWUiCommon.h>

@interface UITextField (JWUiCategory)

//@property (nonatomic, readwrite) CGFloat textSize;
@property (nonatomic, readwrite) CGFloat textFieldTextSize;
- (CGSize) measureText;
- (CGSize) measureTextConstrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGSize) textSizeWithOptions:(JWUiFitOptions)options;
- (void) fitTextWithOptions:(JWUiFitOptions)options;

@end
