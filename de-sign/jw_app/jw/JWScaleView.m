//
//  JWScaleView.m
//  June Winter
//
//  Created by GavinLo on 14/12/19.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWScaleView.h"

@interface JWScaleView () <UIScrollViewDelegate>
{
    UIView* mContentView;
    float mCurrentScale;
    float mMinScale;
    float mMaxScale;
    UITapGestureRecognizer* mContentViewDoubleTapGestureRecognizer;
}

@end

@implementation JWScaleView

- (void)dealloc
{
    mContentView = nil;
}

- (instancetype)init
{
    self = [super init];
    if(self != nil)
    {
        [self onInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil)
    {
        [self onInit];
    }
    return self;
}

- (void) onInit
{
    mMinScale = 1.0f;
    mMaxScale = 2.0f;
    mCurrentScale = mMinScale;
    
    self.userInteractionEnabled = YES;
    self.minimumZoomScale = mMinScale;
    self.maximumZoomScale = mMaxScale;
    self.decelerationRate = 1.0f;
    self.delegate = self;
//    self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
}

- (UIView *)contentView
{
    return mContentView;
}

- (void)setContentView:(UIView *)contentView
{
    [mContentView removeGestureRecognizer:mContentViewDoubleTapGestureRecognizer];
    mContentViewDoubleTapGestureRecognizer = nil;
    [mContentView removeFromSuperview];
    mContentView = nil;
    if(contentView == nil)
        return;
    
    contentView.userInteractionEnabled = YES;
//    contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
    [self addSubview:contentView];
    
    mContentViewDoubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onContentDoubleTap:)];
    mContentViewDoubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [contentView addGestureRecognizer:mContentViewDoubleTapGestureRecognizer];
    
    mContentView = contentView;
    CGSize contentSize = contentView.frame.size;
    self.contentSize = contentSize;
}

- (float)maxScale
{
    return mMaxScale;
}

- (void)setMaxScale:(float)maxScale
{
    mMaxScale = maxScale;
    self.maximumZoomScale = maxScale;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return mContentView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    mCurrentScale = scale;
}

-(void) onContentDoubleTap:(UIGestureRecognizer*)doubleTap
{
    if(mCurrentScale == mMaxScale)
    {
        mCurrentScale = mMinScale;
        [self setZoomScale:mCurrentScale animated:YES];
        return;
    }
    
    if(mCurrentScale == mMinScale)
    {
        mCurrentScale = mMaxScale;
        [self setZoomScale:mCurrentScale animated:YES];
        return;
    }
    
    CGFloat avgScale = mMinScale + (mMaxScale - mMinScale) / 2.0f;
    
    if(mCurrentScale >= avgScale)
    {
        mCurrentScale = mMaxScale;
        [self setZoomScale:mCurrentScale animated:YES];
        return;
    }
    
    mCurrentScale = mMinScale;
    [self setZoomScale:mCurrentScale animated:YES];
}

- (UITapGestureRecognizer *)contentViewDoubleTapGestureRecognizer
{
    return mContentViewDoubleTapGestureRecognizer;
}

@end
