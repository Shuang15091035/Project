//
//  JWToast.m
//  June Winter
//
//  Created by GavinLo on 14-3-16.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWToast.h"

@implementation JWToast

- (JWToast *)initWithText:(NSString *)text
{
    self = [super init];
    if(self != nil)
    {
        mView = [JWToast viewForText:text];
    }
    return self;
}

+ (JWToast *)makeText:(NSString *)text
{
    return [[JWToast alloc] initWithText:text];
}

- (void)show
{
    if(mView == nil)
        return;
    
    [mView.superview bringSubviewToFront:mView];
    mView.hidden = NO;
    mView.alpha = 0;
    [UIView animateWithDuration:1 animations:^{
        mView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2 animations:^{
            mView.alpha = 0;
        } completion:^(BOOL finished) {
            mView.hidden = YES;
            [mView removeFromSuperview];
        }];
    }];
}

@synthesize view = mView;

+ (UIView*) viewForText:(NSString*)text
{
    if(text == nil)
        return nil;
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height * 0.8, [UIScreen mainScreen].bounds.size.width * 0.8, [UIScreen mainScreen].bounds.size.height * 0.1)];
    view.layer.cornerRadius = 10;
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    UILabel* lb_text = [[UILabel alloc] init];
    lb_text.numberOfLines = 0;
    lb_text.font = [UIFont systemFontOfSize:16];
    lb_text.lineBreakMode = NSLineBreakByWordWrapping;
    lb_text.textColor = [UIColor whiteColor];
    lb_text.backgroundColor = [UIColor clearColor];
    lb_text.alpha = 1;
    lb_text.text = text;
    
    CGFloat maxTextWidth = [UIScreen mainScreen].bounds.size.width * 0.8;
    CGFloat maxTextHeight = [UIScreen mainScreen].bounds.size.height * 0.8;
    CGSize maxTextSize = CGSizeMake(maxTextWidth, maxTextHeight);
    CGSize expectedTextSize = [JWToast sizeForString:text font:lb_text.font constrainedToSize:maxTextSize lineBreakMode:lb_text.lineBreakMode];
    lb_text.frame = CGRectMake(10, 10, expectedTextSize.width, expectedTextSize.height);
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat viewX = screenBounds.origin.x + ((screenBounds.size.width - expectedTextSize.width) / 2) - 10;
    CGFloat viewY = screenBounds.origin.y + (screenBounds.size.height * 0.9 - expectedTextSize.height) - 20;
    CGFloat viewWidth = expectedTextSize.width + 20;
    CGFloat viewHeight = expectedTextSize.height + 20;
    view.frame = CGRectMake(viewX, viewY, viewWidth, viewHeight);

    [view addSubview:lb_text];
    
    // 添加到window
    id<UIApplicationDelegate> ad = [UIApplication sharedApplication].delegate;
    [ad.window addSubview:view];
//    SEL windowSelector = @selector(window);
//    NSMethodSignature* windowMethodSignature = [[ad class] instanceMethodSignatureForSelector:windowSelector];
//    if(windowMethodSignature != nil)
//    {
//        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:windowMethodSignature];
//        invocation.selector = windowSelector;
//        invocation.target = ad;
//        [invocation invoke];
//        UIWindow* window = nil;
//        [invocation getReturnValue:&window];
//        [window addSubview:view];
//    }
    
    return view;
}

+ (CGSize)sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    if ([UIDevice currentDevice].systemVersion.floatValue > 7.0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = lineBreakMode;
        NSDictionary* attributes = @{
                                     NSFontAttributeName:font,
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        CGRect boundingRect = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        return CGSizeMake(ceilf(boundingRect.size.width), ceilf(boundingRect.size.height));
    } else {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        return [string sizeWithFont:font constrainedToSize:constrainedSize lineBreakMode:lineBreakMode];
#pragma GCC diagnostic pop
    }
}

@end
