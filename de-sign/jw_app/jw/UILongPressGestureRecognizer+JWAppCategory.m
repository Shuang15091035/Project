//
//  UILongPressGestureRecognizer+JWAppCategory.m
//  jw_app
//
//  Created by ddeyes on 15/10/25.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "UILongPressGestureRecognizer+JWAppCategory.h"
#import "UIScreen+JWCoreCategory.h"
#import "UIDevice+JWCoreCategory.h"

@implementation UILongPressGestureRecognizer (JWAppCategory)

- (CGPoint)position  {
    return [self locationInView:self.view];
}

- (CGPoint)positionInView:(UIView *)view {
    return [self locationInView:view];
}

- (CGPoint)positionInPixels {
    return [[UIScreen mainScreen] pointInPixelsByPoint:[self locationInView:self.view]];
}

- (CGPoint)positionInPixelsInView:(UIView *)view {
    return [[UIScreen mainScreen] pointInPixelsByPoint:[self locationInView:view]];
}

@end
