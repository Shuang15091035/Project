//
//  JWMutableArray.m
//  June Winter
//
//  Created by GavinLo on 14-4-12.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWMutableArray.h"
//#import "JWAsyncUtils.h"
//
//@interface JWMutableArray ()
//{
//    BOOL mNeedToResort;
//}
//
//@end
//
//@implementation JWMutableArray
//
//+ (instancetype)array
//{
//    
//    return [[JWMutableArray alloc] init];
//}
//
//- (void)addObject:(id)anObject
//{
//    [JWAsyncUtils runOnMainQueue:^{
//        [super addObject:anObject];
//    }];
//}
//
//- (BOOL)addUnique:(id)object
//{
//    if([self containsObject:object])
//        return NO;
//    [self add:object];
//    mNeedToResort = YES;
//    return YES;
//}
//
//- (void)sortBy:(NSComparator)comparator
//{
//    if(mNeedToResort)
//    {
//        [self sortUsingComparator:comparator];
//        mNeedToResort = NO;
//    }
//}
//
//- (void)notifyResort
//{
//    mNeedToResort = YES;
//}
//
//@end
