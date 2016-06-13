//
//  JWRadioViewGroup.m
//  jw_app
//
//  Created by ddeyes on 15/10/26.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWRadioViewGroup.h"
#import <jw/NSMutableArray+JWArrayList.h>

@interface JWRadioViewGroup () {
    NSMutableArray* mViews;
    NSUInteger mCheckedIndex;
    UIView* mCheckedView;
    JWRadioViewGroupOnCheckedBlock mOnChecked;
}

@end

@implementation JWRadioViewGroup

+ (id)group {
    return [[self alloc] init];
}

- (void)addView:(UIView *)view {
    if (view == nil) {
        return;
    }
    if (mViews == nil) {
        mViews = [NSMutableArray array];
    }
    [mViews add:view];
}

- (void)removeView:(UIView *)view {
    if (view == nil) {
        return;
    }
    if (mViews == nil) {
        return;
    }
    [mViews remove:view];
}

- (NSUInteger)checkedIndex {
    return mCheckedIndex;
}

- (void)setCheckedIndex:(NSUInteger)checkedIndex
{
    if (mViews == nil || mViews.count == 0) {
        return;
    }
    
    for(NSUInteger i = 0; i < mViews.count; i++) {
        UIView* view = [mViews at:i];
        BOOL checked = NO;
        if (checkedIndex == i) {
            mCheckedIndex = i;
            mCheckedView = view;
            checked = YES;
        }
        if(mOnChecked != nil)
            mOnChecked(checked, i, view);
    }
}

- (UIView *)checkedView {
    return mCheckedView;
}

- (void)setCheckedView:(UIView *)checkedView {
    if (mViews == nil || mViews.count == 0) {
        return;
    }
    
    for (NSUInteger i = 0; i < mViews.count; i++) {
        UIView* view = [mViews at:i];
        BOOL checked = NO;
        if(checkedView == view)
        {
            mCheckedIndex = i;
            mCheckedView = view;
            checked = YES;
        }
        if(mOnChecked != nil)
            mOnChecked(checked, i, view);
    }
}

- (JWRadioViewGroupOnCheckedBlock)onChecked {
    return mOnChecked;
}

- (void)setOnChecked:(JWRadioViewGroupOnCheckedBlock)onChecked {
    mOnChecked = onChecked;
}

@end
