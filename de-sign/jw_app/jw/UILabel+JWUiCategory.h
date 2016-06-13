//
//  UILabel+JWUiCategory.h
//  June Winter
//
//  Created by GavinLo on 15/1/6.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWUiCommon.h>

@interface UILabel (JWUiCategory)

//@property (nonatomic, readwrite) CGFloat textSize;
//@property (nonatomic, readwrite) JWTextStyle textStyle;
@property (nonatomic, readwrite) CGFloat labelTextSize;
@property (nonatomic, readwrite) JWTextStyle labelTextStyle;

- (CGSize) measureText;
- (CGSize) measureTextConstrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGSize) textSizeWithOptions:(JWUiFitOptions)options;
- (void) fitTextWithOptions:(JWUiFitOptions)options;

@end
