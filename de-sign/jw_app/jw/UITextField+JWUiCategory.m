//
//  UITextField+JWUiCategory.m
//  jw_app
//
//  Created by mac zdszkj on 15/12/21.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "UITextField+JWUiCategory.h"
#import <jw/JCMath.h>
#import <jw/JCFlags.h>

@implementation UITextField (JWUiCategory)

- (CGFloat)textFieldTextSize {
    // NOTE 操蛋的iOS，iphone4s上居然在UILabel内部出现textSize这个属性名字，故避免重名
    return self.font.pointSize;
}

- (void)setTextFieldTextSize:(CGFloat)textFieldTextSize {
    // NOTE 操蛋的iOS，iphone4s上居然在UILabel内部出现textSize这个属性名字，故避免重名
    self.font = [self.font fontWithSize:textFieldTextSize];
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
