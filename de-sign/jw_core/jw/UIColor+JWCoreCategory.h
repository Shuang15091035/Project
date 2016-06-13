//
//  UIColor+JWCoreCategory.h
//  June Winter
//
//  Created by GavinLo on 14-3-11.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (JWCoreCategory)

- (UIColor*) initWithARGB:(unsigned long)argb;
- (UIColor*) initWithRGB:(unsigned long)rgb;

+ (UIColor*) colorWithARGB:(unsigned long)argb;
+ (UIColor*) colorWithRGB:(unsigned long)rgb;

@end
