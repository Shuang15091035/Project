//
//  JWPageControl.h
//  jw_app
//
//  Created by ddeyes on 16/4/21.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWLinearLayout.h>

@interface JWPageControl : JWLinearLayout

@property (nonatomic, readwrite) NSUInteger numberOfPages;
@property (nonatomic, readwrite) NSUInteger currentPage;
@property (nonatomic, readwrite) UIImage* pageIndicatorImage;
@property (nonatomic, readwrite) UIImage* currentPageIndicatorImage;
@property (nonatomic, readwrite) CGFloat indicatorSpacing;

@end
