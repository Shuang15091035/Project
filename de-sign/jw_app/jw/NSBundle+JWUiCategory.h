//
//  NSBundle+JWUiCategory.h
//  June Winter
//
//  Created by GavinLo on 14-3-4.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSBundle (JWUiCategory)

- (UIView*) loadXibNamed:(NSString*)name owner:(id)owner options:(NSDictionary*)options;

@end
