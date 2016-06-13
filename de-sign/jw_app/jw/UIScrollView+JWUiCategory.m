//
//  UIScrollView+JWUiCategory.m
//  jw_app
//
//  Created by ddeyes on 16/4/22.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "UIScrollView+JWUiCategory.h"

@implementation UIScrollView (JWUiCategory)

- (CGPoint)scrollNormalizedPosition {
    CGSize contentSize = self.contentSize;
    CGSize frameSize = self.frame.size;
    CGPoint contentOffset = self.contentOffset;
    CGPoint scrollSize = CGPointMake(contentSize.width - frameSize.width, contentSize.height - frameSize.height);
    CGPoint scrollPosition = CGPointMake(contentOffset.x / scrollSize.x, contentOffset.y / scrollSize.y);
    return scrollPosition;
}

@end
