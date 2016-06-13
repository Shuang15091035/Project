//
//  JWAnalogStick.m
//  jw_app
//
//  Created by ddeyes on 16/1/6.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWAnalogStick.h"
#import "UITouch+JWAppCategory.h"
#import "UIView+JWUiLayout.h"
#import <jw/JCFlags.h>

@interface JWAnalogStick () {
    UIImageView* mBackground;
    UIImageView* mStick;
    JWAnalogStickDirection mDirection;
    id<JWOnAnalogStickEventListener> mListener;
}

@end

@implementation JWAnalogStick

+ (id)analogStick {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self setupView];
    }
    return self;
}

- (void) setupView {
    self.clickable = YES;
    self.layoutParams.width = JWLayoutWrapContent;
    self.layoutParams.height = JWLayoutWrapContent;
    
    mBackground = [[UIImageView alloc] init];
    mBackground.layoutParams.width = JWLayoutWrapContent;
    mBackground.layoutParams.height = JWLayoutWrapContent;
    mBackground.layoutParams.alignment = JWLayoutAlignCenterInParent;
    [self addSubview:mBackground];
    
    mStick = [[UIImageView alloc] init];
    mStick.layoutParams.width = JWLayoutWrapContent;
    mStick.layoutParams.height = JWLayoutWrapContent;
    mStick.layoutParams.alignment = JWLayoutAlignCenterInParent;
    [self addSubview:mStick];
    
    mDirection = JWAnalogStickDirectionAll;
}

- (UIImageView *)backgroundView {
    return mBackground;
}

- (UIImageView *)stickView {
    return mStick;
}

@synthesize listener = mListener;

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    mStick.layoutParams.alignment = JWLayoutAlignNone; // 开始互动后，变为自由移动
    UITouch* touch = [touches anyObject];
    [self moveStick:touch.position];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    [self moveStick:touch.position];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self resetStick];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self resetStick];
}

- (void) moveStick:(CGPoint)position {
    CGSize bs = self.frame.size;
    if (mBackground.image != nil) {
        bs = mBackground.frame.size;
    }
    CGSize fs = mStick.frame.size;
    CGFloat bhw = bs.width * 0.5f;
    CGFloat bhh = bs.height * 0.5f;
    CGFloat fhw = fs.width * 0.5f;
    CGFloat fhh = fs.height * 0.5f;
    
    if (JCFlagsTest(mDirection, JWAnalogStickDirectionHorizontal)) {
        if (position.x - fhw < 0.0f) {
            position.x = fhw;
        } else if (position.x + fhw > bs.width) {
            position.x = bs.width - fhw;
        }
    } else {
        position.x = bs.width;
    }
    if (JCFlagsTest(mDirection, JWAnalogStickDirectionVertical)) {
        if (position.y - fhh < 0.0f) {
            position.y = fhh;
        } else if (position.y + fhh > bs.height) {
            position.y = bs.height - fhh;
        }
    } else {
        position.y = bs.height;
    }
    
    CGFloat stickOffsetX = position.x - fhw;
    CGFloat stickOffsetY = position.y - fhh;
    mStick.frame = CGRectMake(stickOffsetX, stickOffsetY, mStick.frame.size.width, mStick.frame.size.height);
    
    if (mListener != nil) {
        CGFloat offsetX = position.x - bhw;
        CGFloat offsetY = -(position.y - bhh);
        [mListener analogStick:self didOffset:CGPointMake(offsetX, offsetY)];
    }
}

- (void)resetStick {
    CGSize bs = self.frame.size;
    if (mBackground.image != nil) {
        bs = mBackground.frame.size;
    }
    CGSize fs = mStick.frame.size;
    
    CGFloat stickOffsetX = (bs.width - fs.width) * 0.5f;
    CGFloat stickOffsetY = (bs.height - fs.height) * 0.5f;
    mStick.frame = CGRectMake(stickOffsetX, stickOffsetY, mStick.frame.size.width, mStick.frame.size.height);
    
    if (mListener != nil) {
        [mListener analogStickDidReset:self];
    }
}

@end
