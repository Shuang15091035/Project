//
//  JWScrollBar.h
//  jw_app
//
//  Created by ddeyes on 16/4/22.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWFrameLayout.h>

@interface JWScrollBar : JWFrameLayout

@property (nonatomic, readwrite) CGFloat position;
@property (nonatomic, readwrite) UIImage* backgroundImage;
@property (nonatomic, readwrite) UIImage* barImage;

@end
