//
//  JWLinearLayout.m
//  June Winter
//
//  Created by GavinLo on 14/12/19.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWLinearLayout.h"
#import "UIView+JWUiLayout.h"
#import <jw/JCMath.h>

@interface JWLinearLayout ()
{
    JWLayoutOrientation mOrientation;
}

@end

@implementation JWLinearLayout

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil)
    {
        self.orientation = JWLayoutOrientationHorizontal;
    }
    return self;
}

- (JWLayoutOrientation)orientation {
    return mOrientation;
}

- (void)setOrientation:(JWLayoutOrientation)orientation {
    mOrientation = orientation;
    self.layoutParams.orientation = orientation;
}

- (void)layoutSubviews {
    if (!self.superview.hasLayoutParams) { // 如果父层不是layout框架中的控件，则首先处理自己
        [JWLayout handleWidthHeightForView:self];
    }
    CGFloat totalWeight = 0.0f;
    CGFloat lastOffset = 0.0f;
    for (UIView* child in self.subviews) {
        JWLayoutParams* layoutParams = child.layoutParams;
        if (!layoutParams.enabled) {
            continue;
        }
        [JWLayout handleWidthHeightForView:child];
        [JWLayout handleAlignmentForView:child];
        CGRect frame = child.frame;
        CGFloat offset = 0.0f;
        if (!child.isHidden) {
            // 线性排列
            switch (mOrientation) {
                case JWLayoutOrientationHorizontal: {
                    lastOffset += layoutParams.marginLeft;
                    offset = lastOffset;
                    lastOffset += frame.size.width + layoutParams.marginRight;
                    if (!JCEqualsfe(offset, frame.origin.x, 1.0f)) {
                        child.frame = CGRectMake(offset, frame.origin.y, frame.size.width, frame.size.height);
                    }
                    break;
                }
                case JWLayoutOrientationVertical: {
                    lastOffset += layoutParams.marginTop;
                    offset = lastOffset;
                    lastOffset += frame.size.height + layoutParams.marginBottom;
                    if (!JCEqualsfe(offset, frame.origin.y, 1.0f)) {
                        child.frame = CGRectMake(frame.origin.x, offset, frame.size.width, frame.size.height);
                    }
                    break;
                }
                default:
                    break;
            }
        }
        totalWeight += layoutParams.weight;
        //[JWLayout handleAlignmentForView:child];
    }
    
    // 排列子view之后重新处理自己的width,height
    CGFloat remain = 0.0f;
    CGRect frame = self.frame;
    switch (mOrientation) {
        case JWLayoutOrientationHorizontal: {
            remain = frame.size.width - lastOffset;
            break;
        }
        case JWLayoutOrientationVertical: {
            remain = frame.size.height - lastOffset;
            break;
        }
        default:
            break;
    }
    
    // 处理weight(按比例分割parent剩余的空间)
    if (totalWeight > 0.0f && remain != 0.0f) {
        lastOffset = 0.0f;
        for (UIView* child in self.subviews) {
            JWLayoutParams* layoutParams = child.layoutParams;
            if (!layoutParams.enabled || child.isHidden) {
                continue;
            }
            
            CGRect frame = child.frame;
            CGFloat offset = 0.0f;
            CGFloat size = 0.0f;
            // 线性排列
            switch (mOrientation) {
                case JWLayoutOrientationHorizontal: {
                    lastOffset += layoutParams.marginLeft;
                    offset = lastOffset;
                    size = frame.size.width + remain * (layoutParams.weight / totalWeight);
                    lastOffset += size + layoutParams.marginRight;
                    if (!JCEqualsfe(offset, frame.origin.x, 1.0f) || !JCEqualsfe(size, frame.size.width, 1.0f)) {
                        child.frame = CGRectMake(offset, frame.origin.y, size, frame.size.height);
                    }
                    break;
                }
                case JWLayoutOrientationVertical: {
                    lastOffset += layoutParams.marginTop;
                    offset = lastOffset;
                    size = frame.size.height + remain * (layoutParams.weight / totalWeight);
                    lastOffset += size + layoutParams.marginBottom;
                    if (!JCEqualsfe(offset, frame.origin.y, 1.0f) || !JCEqualsfe(size, frame.size.height, 1.0f)) {
                        child.frame = CGRectMake(frame.origin.x, offset, frame.size.width, size);
                    }
                    break;
                }
                default:
                    break;
            }
        }
    }
}

@end
