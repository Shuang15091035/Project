//
//  JWLayout.h
//  June Winter
//
//  Created by GavinLo on 14/12/21.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <jw/JWLayoutParams.h>

@interface JWLayout : UIControl

+ (id) layout;
@property (nonatomic, readwrite) BOOL clickable;

+ (void) handleWidthHeightForView:(UIView*)view;
+ (void) handleWidthWrapContentForView:(UIView*)view;
+ (void) handleHeightWrapContentForView:(UIView*)view;
+ (void) handleAlignmentForView:(UIView*)view;
+ (void) handleRelationsForView:(UIView*)view;

@end
