//
//  UILabel+JWUiCategory.m
//  June Winter
//
//  Created by GavinLo on 15/1/6.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "UILabel+JWUiCategory.h"
#import <jw/JCMath.h>
#import <jw/JCFlags.h>
#import "JWLayout.h"
#import "UIView+JWUiLayout.h"
#import <objc/runtime.h>
#import "UIDevice+JWCoreCategory.h"

@implementation UILabel (JWUiCategory)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod([self class], @selector(setText:)), class_getInstanceMethod([self class], @selector(setTextOrigin:)));
        method_exchangeImplementations(class_getInstanceMethod([self class], @selector(setTextByLayout:)), class_getInstanceMethod([self class], @selector(setText:)));
    });
}

- (void) setTextOrigin:(NSString *)text
{
    // exchange setText implementation
}

- (void)setTextByLayout:(NSString *)text
{
    [self setTextOrigin:text];
    if ([self.superview isKindOfClass:[JWLayout class]] && (self.hasLayoutParams && self.layoutParams.enabled)) {
        [self.superview setNeedsLayout];
    }
}

- (CGFloat)labelTextSize {
    // NOTE 操蛋的iOS，iphone4s上居然在UILabel内部出现textSize这个属性名字，故避免重名
    return self.font.pointSize;
}

- (void)setLabelTextSize:(CGFloat)labelTextSize {
    // NOTE 操蛋的iOS，iphone4s上居然在UILabel内部出现textSize这个属性名字，故避免重名
    self.font = [self.font fontWithSize:labelTextSize];
}

- (JWTextStyle)labelTextStyle {
    // TODO
    // NOTE 操蛋的iOS，iphone4s上居然在UILabel内部出现textStyle这个属性名字，故避免重名
    return JWTextStyleNormal;
}

- (void)setLabelTextStyle:(JWTextStyle)labelTextStyle {
    // NOTE 操蛋的iOS，iphone4s上居然在UILabel内部出现textStyle这个属性名字，故避免重名
    switch(labelTextStyle)
    {
        case JWTextStyleNormal:
        {
            UIFontDescriptor* fd = [self.font.fontDescriptor fontDescriptorWithSymbolicTraits:0];
            self.font = [UIFont fontWithDescriptor:fd size:self.labelTextSize];
            break;
        }
        case JWTextStyleBold:
        {
            UIFontDescriptor* fd = [self.font.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
            self.font = [UIFont fontWithDescriptor:fd size:self.labelTextSize];
            break;
        }
        case JWTextStyleItalic:
        {
            UIFontDescriptor* fd = [self.font.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
            self.font = [UIFont fontWithDescriptor:fd size:self.labelTextSize];
            break;
        }
        case JWTextStyleBoldItalic:
        {
            UIFontDescriptor* fd = [self.font.fontDescriptor fontDescriptorWithSymbolicTraits:(UIFontDescriptorTraitBold | UIFontDescriptorTraitItalic)];
            self.font = [UIFont fontWithDescriptor:fd size:self.labelTextSize];
            break;
        }
    }
}

- (CGSize)measureText {
    CGSize textSize = CGSizeZero;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        textSize = [self.text sizeWithAttributes:@{NSFontAttributeName : self.font}];
    } else {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        textSize = [self.text sizeWithFont:self.font];
#pragma GCC diagnostic pop
    }
    return textSize;
}

- (CGSize)measureTextConstrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode {
    CGSize textSize = CGSizeZero;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineBreakMode:lineBreakMode];
//        textSize = [self.text sizeWithAttributes:@{
//                                                   NSFontAttributeName : self.font,
//                                                   NSParagraphStyleAttributeName: paragraphStyle,
//                                                   }];
        
        textSize = [self.text boundingRectWithSize:size options:NSStringDrawingUsesFontLeading attributes:@{
                                                                                                           NSFontAttributeName : self.font,
                                                                                                           NSParagraphStyleAttributeName: paragraphStyle,
                                                                                                           } context:nil].size;
    } else {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        textSize = [self.text sizeWithFont:self.font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma GCC diagnostic pop
    }
    return textSize;
}

- (CGSize)textSizeWithOptions:(JWUiFitOptions)options {
    UIView* parent = self.superview;
    CGRect parentFrame = parent.frame;
    CGRect frame = self.frame;
    CGFloat newWidth = frame.size.width;
    CGFloat newHeight = frame.size.height;
    CGSize textSize = [self measureText];
    CGSize sizeToFit = [self measureTextConstrainedToSize:parentFrame.size lineBreakMode:NSLineBreakByWordWrapping];
    
    if (JCFlagsTest(options, JWUiFitOptionWidth)) {
        if (sizeToFit.width == 0.0f) {
            newWidth = 0.0f;
        } else if (JCEqualsfe(textSize.width, sizeToFit.width, 1.0f)) {
            newWidth = textSize.width + 1.0f; // NOTE 加1避免ui计算误差
        } else {
            //label.numberOfLines = (NSInteger)((size.width - 0.1f) / sizeToFit.width) + 1;
            newWidth = sizeToFit.width + 1.0f; // NOTE 加1避免ui计算误差
        }
    }
    if (JCFlagsTest(options, JWUiFitOptionHeight)) {
        if (sizeToFit.height == 0.0f) {
            newHeight = 0.0f;
        } else if (JCEqualsfe(textSize.height, sizeToFit.height, 1.0f)) {
            newHeight = textSize.height + 1.0f; // NOTE 加1避免ui计算误差
        } else {
            newHeight = sizeToFit.height + 1.0f; // NOTE 加1避免ui计算误差
        }
    }
    return CGSizeMake(newWidth, newHeight);
}

- (void)fitTextWithOptions:(JWUiFitOptions)options {
    CGRect frame = self.frame;
    CGSize newSize = [self textSizeWithOptions:options];
    // NOTE 防止多次调用layoutSubviews
    if (!JCEqualsfe(newSize.width, frame.size.width, 1.0f) || !JCEqualsfe(newSize.height, frame.size.height, 1.0f)) {
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, newSize.width, newSize.height);
    }
}

@end
