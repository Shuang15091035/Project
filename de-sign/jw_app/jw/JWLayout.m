//
//  JWLayout.m
//  June Winter
//
//  Created by GavinLo on 14/12/21.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWLayout.h"
#import <jw/JCFlags.h>
#import <jw/JCMath.h>
#import "UIView+JWUiLayout.h"
#import "UIScreen+JWCoreCategory.h"
#import "UILabel+JWUiCategory.h"
#import "UIButton+JWUiCategory.h"
#import "UITextField+JWUiCategory.h"
#import "UISlider+JWUiCategory.h"

@interface JWLayout () {
    BOOL mClickable;
}

@end

@implementation JWLayout

+ (id)layout {
    return [[self alloc] init];
}

// NOTE super init会调用initWithFrame，故这样实现会导致子类重写init时重复调用initWithFrame（2次），所以没有必要重写init，子类同理
//- (instancetype)init {
//    self = [super init];
//    if (self != nil) {
//        [self onInit];
//    }
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self onInit];
    }
    return self;
}

- (void) onInit {
    // layout一般不处理事件,但是需要传递事件,就好像能戳穿似的
    mClickable = NO;
}

@synthesize clickable = mClickable;

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView* hitView = [super hitTest:point withEvent:event];
    if(!mClickable && hitView == self)
            return nil;
    return hitView;
}

+ (void)handleWidthHeightForView:(UIView *)view {
    JWLayoutParams* layoutParams = view.layoutParams;
    if (!layoutParams.enabled) {
        return;
    }
    
    CGRect frame = view.frame;
    UIView* parent = view.superview;
    CGRect parentFrame = parent.frame;
    
    CGFloat newWidth = frame.size.width;
    CGFloat newHeight = frame.size.height;
    
    // TODO 子控件的frame应该在父控件的innerFrame里面
    if (layoutParams.width == JWLayoutMatchParent) {
        newWidth = parentFrame.size.width - layoutParams.marginLeft - layoutParams.marginRight;
    } else if(layoutParams.width == JWLayoutWrapContent) {
        [JWLayout handleWidthWrapContentForView:view];
        newWidth = view.frame.size.width;
    } else if(layoutParams.width > 0.0f) {
        newWidth = layoutParams.width;
    }
    if (layoutParams.height == JWLayoutMatchParent) {
        newHeight = parentFrame.size.height - layoutParams.marginTop - layoutParams.marginBottom;
    } else if(layoutParams.height == JWLayoutWrapContent) {
        [JWLayout handleHeightWrapContentForView:view];
        newHeight = view.frame.size.height;
    } else if(layoutParams.height > 0.0f) {
        newHeight = layoutParams.height;
    }
    
    // NOTE 防止多次调用layoutSubviews
    if (!JCEqualsfe(newWidth, frame.size.width, 1.0f) || !JCEqualsfe(newHeight, frame.size.height, 1.0f)) {
        CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, newWidth, newHeight);
        view.frame = newFrame;
    }
    
#pragma mark padding处理
    CGRect bounds = view.bounds;
    if (layoutParams.paddingLeft != 0.0f || layoutParams.paddingTop != 0.0f || layoutParams.paddingRight != 0.0f || layoutParams.paddingBottom != 0.0f) {
        CGRect newBounds = CGRectMake(layoutParams.paddingLeft, layoutParams.paddingTop, view.frame.size.width - (layoutParams.paddingLeft + layoutParams.paddingRight), view.frame.size.height - (layoutParams.paddingTop + layoutParams.paddingBottom));
        view.bounds = newBounds;
    }
}

+ (void)handleWidthWrapContentForView:(UIView *)view {
    CGRect frame = view.frame;
    UIView* parent = view.superview;
    CGRect parentFrame = parent.frame;
    JWLayoutParams* layoutParams = view.layoutParams;
    JWLayoutOrientation orientation = layoutParams.orientation;
    
    CGFloat newWidth = frame.size.width;
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel* label = (UILabel*)view;
        CGSize size = [label textSizeWithOptions:JWUiFitOptionWidth];
        newWidth = size.width;
    } else if([view isKindOfClass:[UIButton class]]) {
        UIButton* button = (UIButton*)view;
        CGSize size = [button contentSizeWithOptions:JWUiFitOptionWidth];
        newWidth = size.width;
    } else if([view isKindOfClass:[UIImageView class]]) {
        UIImageView* imageView = (UIImageView*)view;
        CGSize size = imageView.image.size;
        newWidth = size.width;
    } else if([view isKindOfClass:[UITextField class]]) {
        UITextField* textField = (UITextField*)view;
        CGSize size = [textField textSizeWithOptions:JWUiFitOptionWidth];
        newWidth = size.width;
    } else if([view isKindOfClass:[UISlider class]]) {
        UISlider* slider = (UISlider*)view;
        CGSize size = [slider contentSizeWithOptions:JWUiFitOptionWidth];
        newWidth = size.width;
    } else {
        if (orientation == JWLayoutOrientationNone || orientation == JWLayoutOrientationVertical) {
            newWidth = 0.0f;
            for (UIView* child in view.subviews) {
                [JWLayout handleWidthHeightForView:child];
                CGFloat ow = child.outerWidth;
                if (ow > newWidth) {
                    newWidth = ow;
                }
            }
        } else {
            newWidth = 0.0f;
            for (UIView* child in view.subviews) {
                [JWLayout handleWidthHeightForView:child];
                CGFloat ow = child.outerWidth;
                newWidth += ow;
            }
        }
    }
    
#pragma mark padding处理
    newWidth += layoutParams.paddingLeft + layoutParams.paddingRight;
    
    // NOTE 防止多次调用layoutSubviews
    if (!JCEqualsfe(newWidth, frame.size.width, 1.0f)) {
        view.frame = CGRectMake(frame.origin.x, frame.origin.y, newWidth, frame.size.height);
    }
}

+ (void)handleHeightWrapContentForView:(UIView *)view {
    CGRect frame = view.frame;
    UIView* parent = view.superview;
    CGRect parentFrame = parent.frame;
    JWLayoutParams* layoutParams = view.layoutParams;
    JWLayoutOrientation orientation = layoutParams.orientation;
    
    CGFloat newHeight = frame.size.height;
    if([view isKindOfClass:[UILabel class]]) {
        UILabel* label = (UILabel*)view;
        CGSize size = [label textSizeWithOptions:JWUiFitOptionHeight];
        newHeight = size.height;
    } else if([view isKindOfClass:[UIButton class]]) {
        UIButton* button = (UIButton*)view;
        CGSize size = [button contentSizeWithOptions:JWUiFitOptionHeight];
        newHeight = size.height;
    } else if([view isKindOfClass:[UIImageView class]]) {
        UIImageView* imageView = (UIImageView*)view;
        CGSize size = imageView.image.size;
        newHeight = size.height;
    } else if([view isKindOfClass:[UITextField class]]) {
        UITextField* textField = (UITextField*)view;
        CGSize size = [textField textSizeWithOptions:JWUiFitOptionHeight];
        newHeight = size.height;
    } else if([view isKindOfClass:[UISlider class]]) {
        UISlider* slider = (UISlider*)view;
        CGSize size = [slider contentSizeWithOptions:JWUiFitOptionHeight];
        newHeight = size.height;
    } else {
        if (orientation == JWLayoutOrientationNone || orientation == JWLayoutOrientationHorizontal) {
            newHeight = 0.0f;
            for (UIView* child in view.subviews) {
                [JWLayout handleWidthHeightForView:child];
                CGFloat oh = child.outerHeight;
                if (oh > newHeight) {
                    newHeight = oh;
                }
            }
        } else {
            newHeight = 0.0f;
            for (UIView* child in view.subviews) {
                [JWLayout handleWidthHeightForView:child];
                CGFloat oh = child.outerHeight;
                newHeight += oh;
            }
        }
    }
    
#pragma mark padding处理
    newHeight += layoutParams.paddingTop + layoutParams.paddingBottom;
    
    // NOTE 防止多次调用layoutSubviews
    if (!JCEqualsfe(newHeight, frame.size.height, 1.0f)) {
        view.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, newHeight);
    }
}

+ (void)handleAlignmentForView:(UIView *)view {
    JWLayoutParams* layoutParams = view.layoutParams;
    if (!layoutParams.enabled) {
        return;
    }
    
    CGRect frame = view.frame;
    UIView* parent = view.superview;
    CGRect parentFrame = parent.frame;
    NSUInteger align = layoutParams.alignment;
    
    CGFloat newX = frame.origin.x;
    CGFloat newY = frame.origin.y;
    
    if (align != JWLayoutAlignNone) {
        if (JCFlagsTest(align, JWLayoutAlignParentLeft)) {
            newX = layoutParams.marginLeft;
        }
        if (JCFlagsTest(align, JWLayoutAlignParentTop)) {
            newY = layoutParams.marginTop;
        }
        if (JCFlagsTest(align, JWLayoutAlignParentRight)) {
            newX = (parentFrame.size.width - frame.size.width) - layoutParams.marginRight;
        }
        if (JCFlagsTest(align, JWLayoutAlignParentBottom)) {
            newY = (parentFrame.size.height - frame.size.height) - layoutParams.marginBottom;
        }
        if (JCFlagsTest(align, JWLayoutAlignCenterHorizontal)) {
            newX = (parentFrame.size.width - frame.size.width) / 2.0f;
        }
        if (JCFlagsTest(align, JWLayoutAlignCenterVertical)) {
            newY = (parentFrame.size.height - frame.size.height) / 2.0f;
        }
    }
    
    // NOTE 防止多次调用layoutSubviews
    if (!JCEqualsfe(newX, frame.origin.x, 1.0f) || !JCEqualsfe(newY, frame.origin.y, 1.0f)) {
        view.frame = CGRectMake(newX, newY, frame.size.width, frame.size.height);
    }
}

+ (void)handleRelationsForView:(UIView *)view {
    JWLayoutParams* layoutParams = view.layoutParams;
    if (!layoutParams.enabled) {
        return;
    }
    
    CGRect frame = view.frame;
//    UIView* parent = view.superview;
//    CGRect parentFrame = parent.frame;
    
    CGFloat newX = frame.origin.x;
    CGFloat newY = frame.origin.y;
    CGFloat newH = frame.size.height;
    
    UIView* relView = nil;
    relView = layoutParams.rightOf;
    if (relView != nil) {
        CGRect relFrame = relView.frame;
        newX = relFrame.origin.x + relFrame.size.width + layoutParams.marginLeft;
    }
    relView = layoutParams.below;
    if (relView != nil) {
        CGRect relFrame = relView.frame;
        newY = relFrame.origin.y + relFrame.size.height + layoutParams.marginTop;
    }
    relView = layoutParams.leftOf;
    if (relView != nil) {
        CGRect relFrame = relView.frame;
        newX = relFrame.origin.x - (frame.size.width + layoutParams.marginRight);
    }
    relView = layoutParams.above;
    if (relView != nil) {
        CGRect relFrame = relView.frame;
        //newY = relFrame.origin.y - (frame.size.height + layoutParams.marginBottom);
        float rt = relFrame.origin.y;
        float top = 0.0f;
        if (layoutParams.below != nil) {
            top = newY;
            newH = rt - top;
        } else {
            top = 0.0f;
            //newY = top;
        }
        newY = relFrame.origin.y - (newH + layoutParams.marginBottom);
    }
    // NOTE 防止多次调用layoutSubviews
    if (!JCEqualsfe(newX, frame.origin.x, 1.0f) || !JCEqualsfe(newY, frame.origin.y, 1.0f) || !JCEqualsfe(newH, frame.size.height, 1.0f)) {
        view.frame = CGRectMake(newX, newY, frame.size.width, newH);
    }
}

@end
