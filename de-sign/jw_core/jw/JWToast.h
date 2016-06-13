//
//  JWToast.h
//  June Winter
//
//  Created by GavinLo on 14-3-16.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JWToast : NSObject
{
    UIView* mView;
}

- (JWToast*) initWithText:(NSString*)text;
+ (JWToast*) makeText:(NSString*)text;
- (void) show;

@property (nonatomic, readwrite) UIView* view;

@end
