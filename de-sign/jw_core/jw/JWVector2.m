//
//  JWVector2.m
//  jw_core
//
//  Created by ddeyes on 15/10/26.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWVector2.h"
#import "NSArray+JWCoreCategory.h"

@interface JWVector2 () {
    JCVector2 mVector;
}

@end

@implementation JWVector2

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        mVector = JCVector2Zero();
    }
    return self;
}

+ (id)vector {
    return [[self alloc] init];
}

@synthesize vector = mVector;

+ (JCVector2)cvector2FromString:(NSString *)string {
    JCVector2 vector = JCVector2Zero();
    NSArray* vectors = [string componentsSeparatedByString:@" "];
    if (vectors.count > 0) {
        vector.x = [[vectors at:0] floatValue];
    }
    if (vectors.count > 1) {
        vector.y = [[vectors at:1] floatValue];
    }
    return vector;
}

@end
