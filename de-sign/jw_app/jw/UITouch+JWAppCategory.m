//
//  UITouch+JWAppCategory.m
//  June Winter
//
//  Created by GavinLo on 14/11/12.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "UITouch+JWAppCategory.h"
#import "UIScreen+JWCoreCategory.h"
#import "UIDevice+JWCoreCategory.h"

@implementation UITouch (JWAppCategory)

- (CGPoint)position {
    return [self locationInView:self.view];
}

- (CGPoint)deltaPosition {
    CGPoint currentPosition = [self locationInView:self.view];
    CGPoint previousPosition = [self previousLocationInView:self.view];
    return CGPointMake(currentPosition.x - previousPosition.x, currentPosition.y - previousPosition.y);
}

- (CGPoint)positionInPixels {
    return [[UIScreen mainScreen] pointInPixelsByPoint:[self locationInView:self.view]];
}

- (CGPoint)deltaPositionInPixels
{
    CGPoint currentPosition = [self locationInView:self.view];
    CGPoint previousPosition = [self previousLocationInView:self.view];
    return [[UIScreen mainScreen] pointInPixelsByPoint:CGPointMake(currentPosition.x - previousPosition.x, currentPosition.y - previousPosition.y)];
}

+ (CGPoint)getFocusPositionInPixelsByTouches:(NSSet *)touches
{
    CGPoint sfp = CGPointZero;
    if(touches == nil)
        return sfp;
    NSUInteger count = touches.count;
    if(count == 0)
        return sfp;
    
    for(UITouch* touch in touches)
    {
        CGPoint sp = [touch positionInPixels];
        sfp.x += sp.x;
        sfp.y += sp.y;
    }
    sfp.x /= count;
    sfp.y /= count;
    
    return sfp;
}

@end
