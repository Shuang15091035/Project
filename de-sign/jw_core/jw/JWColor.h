//
//  JWColor.h
//  June Winter
//
//  Created by GavinLo on 14/11/20.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWObject.h>
#import <jw/JCColor.h>

@interface JWColor : JWObject

+ (id) color;
@property (nonatomic, readwrite) JCColor color;
+ (JCColor) ccolorFromString:(NSString*)string;

@end
