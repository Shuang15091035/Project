//
//  UIScreen+JWCoreCategory.m
//  June Winter
//
//  Created by GavinLo on 15/1/8.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "UIScreen+JWCoreCategory.h"
#import "UIDevice+JWCoreCategory.h"

@implementation UIScreen (JWCoreCategory)

//+ (void)load
//{
//    // 在iOS8之前，当设备朝向发生改变时，控件坐标系会自动调整到相对于该朝向的坐标系。
//    // 永远以用户站立时，右手方向为x轴和屏幕宽度的方向，垂直向下为y轴和屏幕高度的方向。
//    // 故在代码中使用UITouch的locationInView:nil风险很大，因为没有自适应，而locationInView:self.view则会跟view一样自动调整坐标系。
//    // 这边处理一下bounds
////    if(![[UIDevice currentDevice] systemVersionGE:[UIDevice Version80]])
////    {
////        static dispatch_once_t onceToken;
////        dispatch_once(&onceToken, ^{
////            method_exchangeImplementations(class_getInstanceMethod([self class], @selector(bounds)), class_getInstanceMethod([self class], @selector(boundsOriginBeforeIOS8)));
////            method_exchangeImplementations(class_getInstanceMethod([self class], @selector(boundsFixBeforeIOS8)), class_getInstanceMethod([self class], @selector(bounds)));
////        });
////    }
//}
//
//- (CGRect)boundsOriginBeforeIOS8
//{
//    // exchange bounds implementation
//    return CGRectZero;
//}

- (CGRect)boundsFixBeforeIOS8 {
    CGRect bounds = self.bounds;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        return bounds;
    }
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        CGSize size = bounds.size;
        size = CGSizeMake(size.height, size.width);
        bounds = CGRectMake(bounds.origin.x, bounds.origin.y, size.width, size.height);
    }
    return bounds;
}

- (CGRect)statusBarFrame {
    return [UIApplication sharedApplication].statusBarFrame;
}

- (CGRect)navigationBarFrame {
    id<UIApplicationDelegate> ad = [UIApplication sharedApplication].delegate;
    
    // NOTE 这样获取navigationController可能存在问题
    SEL navigationControllerSelector = @selector(navigationController);
    NSMethodSignature* navigationControllerSignature = [[ad class] instanceMethodSignatureForSelector:navigationControllerSelector];
    if (navigationControllerSignature != nil) {
        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:navigationControllerSignature];
        invocation.selector = navigationControllerSelector;
        invocation.target = ad;
        [invocation invoke];
        UINavigationController* nc = nil;
        [invocation getReturnValue:&nc];
        if (nc == nil) {
            return CGRectZero;
        }
        return nc.navigationBar.frame;
    }
    
    return CGRectZero;
}

- (CGRect)frameForDisplayContent {
    CGRect bounds = self.bounds;
    CGFloat x = bounds.origin.x;
    CGFloat y = bounds.origin.y;
    CGFloat w = bounds.size.width;
    CGFloat h = bounds.size.height;
    
    CGFloat sbh = self.statusBarFrame.size.height;
    CGFloat nbh = self.navigationBarFrame.size.height;
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0) {
        h -= sbh + nbh;
    }
    CGRect f = CGRectMake(x, y, w, h);
    return f;
}

- (CGRect)frameForMaxDisplayContent {
    CGRect bounds = self.bounds;
    CGFloat x = bounds.origin.x;
    CGFloat y = bounds.origin.y;
    CGFloat w = bounds.size.width;
    CGFloat h = bounds.size.height;
    
    CGFloat sbh = self.statusBarFrame.size.height;
    CGFloat nbh = self.navigationBarFrame.size.height;
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0) {
        y -= nbh;
        h -= sbh;
    }
    CGRect f = CGRectMake(x, y, w, h);
    return f;
}

- (CGRect)frameUnderStatusBar {
    CGRect bounds = self.bounds;
    CGFloat x = bounds.origin.x;
    CGFloat y = bounds.origin.y;
    CGFloat w = bounds.size.width;
    CGFloat h = bounds.size.height;
    
    CGFloat sbh = self.statusBarFrame.size.height;
    CGFloat nbh = self.navigationBarFrame.size.height;
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0) {
        y -= nbh;
        h -= sbh;
    } else {
        y += sbh;
        h -= sbh;
    }
    CGRect f = CGRectMake(x, y, w, h);
    return f;
}

- (CGRect)frameUnderNavigationBar {
    CGRect bounds = self.bounds;
    CGFloat x = bounds.origin.x;
    CGFloat y = bounds.origin.y;
    CGFloat w = bounds.size.width;
    CGFloat h = bounds.size.height;
    
    CGFloat sbh = self.statusBarFrame.size.height;
    CGFloat nbh = self.navigationBarFrame.size.height;
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0) {
        h -= sbh + nbh;
    } else {
        y += sbh + nbh;
        h -= sbh + nbh;
    }
    CGRect f = CGRectMake(x, y, w, h);
    return f;
}

- (CGRect)fullFrame {
    CGRect bounds = self.bounds;
    CGFloat x = bounds.origin.x;
    CGFloat y = bounds.origin.y;
    CGFloat w = bounds.size.width;
    CGFloat h = bounds.size.height;
    
    CGFloat sbh = self.statusBarFrame.size.height;
    CGFloat nbh = self.navigationBarFrame.size.height;
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0) {
        y -= sbh + nbh;
    }
    CGRect f = CGRectMake(x, y, w, h);
    return f;
}

- (CGFloat)widthByScale:(CGFloat)scale {
    //return self.bounds.size.width * scale;
    return self.boundsByOrientation.size.width * scale;
}

- (CGFloat)heightByScale:(CGFloat)scale {
    //return self.bounds.size.height * scale;
    return self.boundsByOrientation.size.height * scale;
}

- (CGPoint)pointInPixelsByPoint:(CGPoint)point {
    // TODO 由于iOS系统返回的触摸位置是没有经过设备缩放(如retina屏幕)处理的,故这里处理一下,
    // 但可能会有不需要处理的原始位置的使用场景,可以考虑添加其他方法获取
    GLfloat scale = [UIScreen mainScreen].scale;
    return CGPointMake(point.x * scale, point.y * scale);
}

- (CGPoint)pointByPointInPixels:(CGPoint)pointInPixels {
    GLfloat scale = [UIScreen mainScreen].scale;
    return CGPointMake(pointInPixels.x / scale, pointInPixels.y / scale);
}

- (CGRect)boundsByOrientation
{
    return [self boundsFixBeforeIOS8];
}

- (CGRect)boundsInPixels {
    CGRect bounds = self.boundsByOrientation;
//    CGRect bounds = self.bounds;
    GLfloat scale = [UIScreen mainScreen].scale;
    bounds.origin.x *= scale;
    bounds.origin.y *= scale;
    bounds.size.width *= scale;
    bounds.size.height *= scale;
    return bounds;
}
 
- (CGFloat)getRelativeWidth:(CGFloat)width
{
    if(width < 1.0f && width > -1.0f)
        width = self.boundsByOrientation.size.width * width;
    return width;
}

- (CGFloat)getRelativeHeight:(CGFloat)height
{
    if(height < 1.0f && height > -1.0f)
        height = self.boundsByOrientation.size.height * height;
    return height;
}

@end
