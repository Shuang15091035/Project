//
//  UITapGestureRecognizer+JWAppCategory.m
//  June Winter
//
//  Created by GavinLo on 14/12/31.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "UITapGestureRecognizer+JWAppCategory.h"
#import "UIScreen+JWCoreCategory.h"
#import "UIDevice+JWCoreCategory.h"

@implementation UITapGestureRecognizer (JWAppCategory)

- (CGPoint)positionInPixels {
    return [[UIScreen mainScreen] pointInPixelsByPoint:[self locationInView:self.view]];
}

@end
