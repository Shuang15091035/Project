//
//  JWVector4.h
//  June Winter
//
//  Created by GavinLo on 14/11/7.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWObject.h>
#import <jw/JCVector4.h>

@interface JWVector4 : JWObject

- (id)initWithX:(float)x Y:(float)y Z:(float)z W:(float)w;
+ (id) vector;
+ (id) vectorWithX:(float)x Y:(float)y Z:(float)z W:(float)w;
@property (nonatomic, readwrite) JCVector4 vector;
+ (JCVector4) cvector4FromString:(NSString*)string;

@end
