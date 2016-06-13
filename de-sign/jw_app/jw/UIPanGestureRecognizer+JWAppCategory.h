//
//  UIPanGestureRecognizer+JWAppCategory.h
//  jw_app
//
//  Created by ddeyes on 15/10/27.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPanGestureRecognizer (JWAppCategory)

@property (nonatomic, readonly) CGPoint positionInPixels;
//@property (nonatomic, readonly) CGPoint deltaPositionInPixels;

@end
