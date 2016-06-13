//
//  UIView+JWUiLayout.h
//  June Winter
//
//  Created by GavinLo on 14/12/19.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <jw/JWLayoutParams.h>

@interface UIView (JWUiLayout)

/**
 * layout框架中，所有的view都会有JWLayoutParams，这个可以作为判断是否为框架中控件的依据
 */
@property (nonatomic, readonly) BOOL hasLayoutParams;

@property (nonatomic, readonly) JWLayoutParams* layoutParams;
@property (nonatomic, readwrite) CGFloat outerWidth;
@property (nonatomic, readwrite) CGFloat outerHeight;
@property (nonatomic, readwrite) CGFloat innerWidth;
@property (nonatomic, readwrite) CGFloat innerHeight;
@property (nonatomic, readwrite) BOOL visible;

@end
