//
//  UIView+JWAdapterItemView.m
//  jw_app
//
//  Created by ddeyes on 15/10/19.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "UIView+JWAdapterItemView.h"
#import "JWCategoryVariables.h"

@interface JWAdapterItemViewExtra () {
    id<JIViewHolder> mHolder;
}

@end

@implementation JWAdapterItemViewExtra

@synthesize holder = mHolder;

@end

@implementation UIView (JWAdapterItemView)

- (JWAdapterItemViewExtra *)extra {
    JWAdapterItemViewExtra* e = [JWCategoryVariables hackTarget:self byClass:[JWAdapterItemViewExtra class]];
    return e;
}

@end
