//
//  JWScaleView.h
//  June Winter
//
//  Created by GavinLo on 14/12/19.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWScaleView : UIScrollView

@property (nonatomic, readwrite) UIView* contentView;
@property (nonatomic, readwrite) float maxScale;

@property (nonatomic, readonly) UITapGestureRecognizer* contentViewDoubleTapGestureRecognizer;

@end
