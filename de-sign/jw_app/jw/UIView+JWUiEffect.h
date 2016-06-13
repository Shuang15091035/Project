//
//  UIView+JWUiEffect.h
//  jw_app
//
//  Created by ddeyes on 16/4/15.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <jw/JWUiEffectParams.h>

typedef NS_OPTIONS(NSUInteger, JWUiEffectType) {
    JWUiEffectTypeBreath = 0x1 << 0,
};

@interface UIView (JWUiEffect)

//@property (nonatomic, readonly) JWUiEffectParams* effectParams;
- (void) breathWithCycle:(NSTimeInterval)cycle range:(CGFloat)range loop:(BOOL)loop;
- (void) stopEffectByType:(JWUiEffectType)type;

@end
