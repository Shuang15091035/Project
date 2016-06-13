//
//  UIPanGestureRecognizer+JWAppCategory.m
//  jw_app
//
//  Created by ddeyes on 15/10/27.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "UIPanGestureRecognizer+JWAppCategory.h"
#import "UIScreen+JWCoreCategory.h"
#import "UIDevice+JWCoreCategory.h"

@implementation UIPanGestureRecognizer (JWAppCategory)

- (CGPoint)positionInPixels {
    return [[UIScreen mainScreen] pointInPixelsByPoint:[self locationInView:self.view]];
}

//- (CGPoint)deltaPositionInPixels {
//    return [[UIScreen mainScreen] pointInPixelsByPoint:[self translationInView:self.view]];
//}

@end
