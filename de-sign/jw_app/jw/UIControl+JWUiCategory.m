//
//  UIControl+JWUiCategory.m
//  June Winter
//
//  Created by GavinLo on 14-3-13.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "UIControl+JWUiCategory.h"

@implementation UIControl (JWUiCategory)

- (void)removeAllTargets
{
    NSArray* subviews = self.subviews;
    if(subviews != nil)
    {
        for(UIView* view in subviews)
        {
            if([view isKindOfClass:[UIControl class]])
            {
                UIControl* control = (UIControl*)view;
                [control removeAllTargets];
            }
        }
    }
    [self removeTarget:nil action:NULL forControlEvents:UIControlEventAllTouchEvents];
}

@end
