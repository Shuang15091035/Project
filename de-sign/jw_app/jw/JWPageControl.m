//
//  JWPageControl.m
//  jw_app
//
//  Created by ddeyes on 16/4/21.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWPageControl.h"
#import "UIView+JWUiLayout.h"

@interface JWPageControl () {
    NSUInteger mNumberOfPages;
    NSUInteger mCurrentPage;
    UIImage* mPageIndicatorImage;
    UIImage* mCurrentPageIndicatorImage;
    CGFloat mIndicatorSpacing;
}

@end

@implementation JWPageControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        mIndicatorSpacing = 5;
    }
    return self;
}

- (NSUInteger)numberOfPages {
    return mNumberOfPages;
}

- (void)setNumberOfPages:(NSUInteger)numberOfPages {
    if (numberOfPages == mNumberOfPages) {
        return;
    }
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (NSUInteger i = 0; i < numberOfPages; i++) {
        UIImageView* img_page = [[UIImageView alloc] init];
        img_page.layoutParams.width = JWLayoutWrapContent;
        img_page.layoutParams.width = JWLayoutWrapContent;
        if (i == numberOfPages - 1) {
            img_page.layoutParams.marginRight = 0;
        } else {
            img_page.layoutParams.marginRight = mIndicatorSpacing;
        }
        [self addSubview:img_page];
    }
    mNumberOfPages = numberOfPages;
    [self updateImages];
}

- (NSUInteger)currentPage {
    return mCurrentPage;
}

- (void)setCurrentPage:(NSUInteger)currentPage {
    if (currentPage == mCurrentPage) {
        return;
    }
    mCurrentPage = currentPage;
    [self updateImages];
}

- (void) updateImages {
    NSArray<UIView*>* subviews = self.subviews;
    for (NSUInteger i = 0; i < subviews.count; i++) {
        UIImageView* img_page = [subviews objectAtIndex:i];
        if (i == mCurrentPage) {
            img_page.image = mCurrentPageIndicatorImage;
        } else {
            img_page.image = mPageIndicatorImage;
        }
    }
    if (self.superview != nil) {
        [self.superview setNeedsLayout];
    }
}

- (UIImage *)pageIndicatorImage {
    return mPageIndicatorImage;
}

- (void)setPageIndicatorImage:(UIImage *)pageIndicatorImage {
    mPageIndicatorImage = pageIndicatorImage;
    [self updateImages];
}

- (UIImage *)currentPageIndicatorImage {
    return mCurrentPageIndicatorImage;
}

- (void)setCurrentPageIndicatorImage:(UIImage *)currentPageIndicatorImage {
    mCurrentPageIndicatorImage = currentPageIndicatorImage;
    [self updateImages];
}

- (CGFloat)indicatorSpacing {
    return mIndicatorSpacing;
}

- (void)setIndicatorSpacing:(CGFloat)indicatorSpacing {
    if (indicatorSpacing == mIndicatorSpacing) {
        return;
    }
    mIndicatorSpacing = indicatorSpacing;
    [self updateImages];
}

@end
