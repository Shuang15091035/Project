//
//  JWVector3.h
//  June Winter
//
//  Created by GavinLo on 14/11/7.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWObject.h>
#import <jw/JCVector3.h>
#import <jw/JWVector2.h>

@interface JWVector3 : JWObject

- (id) initWithX:(float)x Y:(float)y Z:(float)z;
+ (id) vector;
+ (id) vectorWithX:(float)x Y:(float)y Z:(float)z;
@property (nonatomic, readwrite) JCVector3 vector;
+ (JCVector3) cvector3FromString:(NSString*)string;

@end
