//
//  UIView+JWAdapterItemView.h
//  jw_app
//
//  Created by ddeyes on 15/10/19.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <jw/JWViewHolder.h>

@interface JWAdapterItemViewExtra : NSObject

@property (nonatomic, readwrite) id<JIViewHolder> holder;

@end

@interface UIView (JWAdapterItemView)

@property (nonatomic, readonly) JWAdapterItemViewExtra* extra;

@end
