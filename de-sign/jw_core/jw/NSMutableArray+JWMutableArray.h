//
//  NSMutableArray+JWMutableArray.h
//  June Winter
//
//  Created by GavinLo on 14-5-23.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL (^JWIsEqualComparatorBlock)(id obj1, id obj2);

@interface NSMutableArray (JWMutableArray)

- (BOOL) addObject:(id)anObject likeASet:(BOOL)unique willIngoreNil:(BOOL)willIngoreNil;
- (BOOL) addObject:(id)anObject likeASetUseComparator:(JWIsEqualComparatorBlock)comparator willIngoreNil:(BOOL)willIngoreNil;
- (void) addObjectsFromArray:(NSArray *)otherArray likeASet:(BOOL)unique willIngoreNil:(BOOL)willIngoreNil;

@end
