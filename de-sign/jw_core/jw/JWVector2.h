//
//  JWVector2.h
//  jw_core
//
//  Created by ddeyes on 15/10/26.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWObject.h>
#import <jw/JCVector2.h>

@interface JWVector2 : JWObject

+ (id) vector;
@property (nonatomic, readwrite) JCVector2 vector;
+ (JCVector2) cvector2FromString:(NSString*)string;

@end
