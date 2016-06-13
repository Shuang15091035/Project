//
//  JWVector3.m
//  June Winter
//
//  Created by GavinLo on 14/11/7.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWVector3.h"
#import "NSArray+JWCoreCategory.h"

@interface JWVector3 () {
    JCVector3 mVector;
}

@end

@implementation JWVector3

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        mVector = JCVector3Zero();
    }
    return self;
}

- (id)initWithX:(float)x Y:(float)y Z:(float)z {
    self = [super init];
    if (self != nil) {
        mVector = JCVector3Make(x, y, z);
    }
    return self;
}

+ (id)vector {
    return [[self alloc] init];
}

+ (id)vectorWithX:(float)x Y:(float)y Z:(float)z {
    return [[self alloc] initWithX:x Y:y Z:z];
}

@synthesize vector = mVector;

+ (JCVector3)cvector3FromString:(NSString *)string {
    JCVector3 vector = JCVector3Zero();
    NSArray* vectors = [string componentsSeparatedByString:@" "];
    if (vectors.count > 0) {
        vector.x = [[vectors at:0] floatValue];
    }
    if (vectors.count > 1) {
        vector.y = [[vectors at:1] floatValue];
    }
    if (vectors.count > 2) {
        vector.z = [[vectors at:2] floatValue];
    }
    return vector;
}

@end
