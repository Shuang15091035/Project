//
//  UILongPressGestureRecognizer+JWAppCategory.h
//  jw_app
//
//  Created by ddeyes on 15/10/25.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILongPressGestureRecognizer (JWAppCategory)

@property (nonatomic, readonly) CGPoint position;
- (CGPoint) positionInView:(UIView*)view;
@property (nonatomic, readonly) CGPoint positionInPixels;
- (CGPoint) positionInPixelsInView:(UIView*)view;

@end
