//
//  JWMatrix4.m
//  June Winter
//
//  Created by GavinLo on 14/11/7.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWMatrix4.h"
#import "NSArray+JWCoreCategory.h"

@interface JWMatrix4 () {
    JCMatrix4 mMatrix;
}

@end

@implementation JWMatrix4

+ (id)matrix {
    return [[self alloc] init];
}

@synthesize matrix = mMatrix;

+ (JCMatrix4)cmatrix4FromString:(NSString *)string {
    JCMatrix4 matrix = JCMatrix4Identity();
    NSArray* matrices = [string componentsSeparatedByString:@" "];
    for (NSUInteger i = 0; i < JCMatrix4NumComponents; i++) {
        if(matrices.count > i) {
            matrix.m[i] = [[matrices at:i] floatValue];
        }
    }
    return matrix;
}

@end
