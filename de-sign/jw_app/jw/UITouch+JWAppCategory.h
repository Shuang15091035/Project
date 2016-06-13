//
//  UITouch+JWAppCategory.h
//  June Winter
//
//  Created by GavinLo on 14/11/12.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITouch (JWAppCategory)

@property (nonatomic, readonly) CGPoint position;
@property (nonatomic, readonly) CGPoint deltaPosition;
@property (nonatomic, readonly) CGPoint positionInPixels;
@property (nonatomic, readonly) CGPoint deltaPositionInPixels;

+ (CGPoint) getFocusPositionInPixelsByTouches:(NSSet*)touches;

@end
