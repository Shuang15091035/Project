//
//  JWRadioViewGroup.h
//  jw_app
//
//  Created by ddeyes on 15/10/26.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^JWRadioViewGroupOnCheckedBlock)(BOOL checked, NSUInteger index, UIView* view);

@interface JWRadioViewGroup : NSObject

+ (id) group;
- (void) addView:(UIView*)view;
- (void) removeView:(UIView*)view;
@property (nonatomic, readwrite) NSUInteger checkedIndex;
@property (nonatomic, readwrite) UIView* checkedView;

@property (nonatomic, readwrite) JWRadioViewGroupOnCheckedBlock onChecked;

@end
