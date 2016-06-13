//
//  JWVector4.m
//  June Winter
//
//  Created by GavinLo on 14/11/7.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWVector4.h"
#import "NSArray+JWCoreCategory.h"

@interface JWVector4 () {
    JCVector4 mVector;
}

@end

@implementation JWVector4

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        mVector = JCVector4Zero();
    }
    return self;
}

- (id)initWithX:(float)x Y:(float)y Z:(float)z W:(float)w {
    self = [super init];
    if (self != nil) {
        mVector = JCVector4Make(x, y, z, w);
    }
    return self;
}

+ (id)vector {
    return [[self alloc] init];
}

+ (id)vectorWithX:(float)x Y:(float)y Z:(float)z W:(float)w {
    return [[self alloc] initWithX:x Y:y Z:z W:w];
}

@synthesize vector = mVector;

+ (JCVector4)cvector4FromString:(NSString *)string {
    JCVector4 vector = JCVector4Zero();
    NSArray* vectors = [string componentsSeparatedByString:@" "];
    if(vectors.count > 0)
        vector.x = [[vectors at:0] floatValue];
    if(vectors.count > 1)
        vector.y = [[vectors at:1] floatValue];
    if(vectors.count > 2)
        vector.z = [[vectors at:2] floatValue];
    if(vectors.count > 3)
        vector.w = [[vectors at:3] floatValue];
    return vector;
}

@end
