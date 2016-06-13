//
//  JWMatrix4.h
//  June Winter
//
//  Created by GavinLo on 14/11/7.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWObject.h>
#import <jw/JCMatrix4.h>

@interface JWMatrix4 : JWObject

+ (id) matrix;
@property (nonatomic, readwrite) JCMatrix4 matrix;
+ (JCMatrix4) cmatrix4FromString:(NSString*)string;

@end
