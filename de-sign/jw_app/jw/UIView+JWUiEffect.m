//
//  UIView+JWUiEffect.m
//  jw_app
//
//  Created by ddeyes on 16/4/15.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "UIView+JWUiEffect.h"
#import "JWCategoryVariables.h"
#import "JWLayout.h"
#import <jw/JCFlags.h>

@interface UIView (JWUiEffectPrivate)

@property (nonatomic, readonly) JWUiEffectParams* effectParams;

@end

@implementation UIView (JWUiEffect)

- (JWUiEffectParams *)effectParams {
    JWUiEffectParams* ep = [JWCategoryVariables hackTarget:self byClass:[JWUiEffectParams class]];
    return ep;
}

- (void)breathWithCycle:(NSTimeInterval)cycle range:(CGFloat)range loop:(BOOL)loop {
    if (loop) {
        self.effectParams.animationFlags = JCFlagsAdd(self.effectParams.animationFlags, JWUiEffectTypeBreath);
    }
    NSTimeInterval halfCycle = cycle * 0.5f;
    [UIView animateWithDuration:halfCycle delay:0.0f options:(UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction) animations:^{
        self.transform = CGAffineTransformMakeScale(range, range);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:halfCycle delay:0.0f options:(UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction) animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (!JCFlagsTest(self.effectParams.animationFlags, JWUiEffectTypeBreath)) {
                return;
            }
            [self breathWithCycle:cycle range:range loop:loop];
        }];
    }];
}

- (void)stopEffectByType:(JWUiEffectType)type {
    self.effectParams.animationFlags = JCFlagsRemove(self.effectParams.animationFlags, JWUiEffectTypeBreath);
}

@end
