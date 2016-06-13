//
//  JWObject.m
//  June Winter
//
//  Created by GavinLo on 14-2-12.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWObject.h"
#import "NSString+JWCoreCategory.h"
#import "NSMutableDictionary+JWCoreCategory.h"

@implementation JWObject

- (void)onCreate
{

}

- (void)onDestroy
{
    
}

+ (id)UndefinedValue
{
    return [NSNull null];
}

//- (id)valueForUndefinedKey:(NSString *)key
//{
//    return [JWObject UndefinedValue];
//}
//
//- (void)setNilValueForKey:(NSString *)key
//{
//    
//}

+ (BOOL)is:(id)a equalsTo:(id)b
{
    return (a == nil) ? (b == nil) : [a isEqual:b];
}

@end

@implementation JWSerializeObject

- (NSDictionary *)serializeMembers
{
    return nil;
}

//- (NSDictionary *)serializeMembersWith:(SEL)serializeSelector
//{
//    if([self respondsToSelector:serializeSelector])
//        return [self performSelector:serializeSelector];
//    else
//        return [self serializeMembers];
//}

- (NSDictionary *)serializeMethod:(NSInteger)methodId
{
    return [self serializeMembers];
}

- (void)setStringValue:(NSString *)value withClass:(Class)valueClass forKey:(NSString *)key
{
    if(value == nil)
        return;
    
    if(valueClass == [NSNumber class])
    {
        NSNumber* n = [NSString toNumber:value];
        if(n != nil)
            [self setValue:n forKey:key];
    }
    else if(valueClass == [NSString class])
    {
        [self setValue:value forKey:key];
    }
}

- (NSDictionary *)mergeSerializeInfos:(NSArray *)infos
{
    if(infos == nil)
        return nil;
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    for(NSDictionary* d in infos)
        [dict addAll:d];
    return dict;
}

@end

@interface JWSerializeInfo ()
{
    NSString* mName;
    Class mClass;
    Class mArrayClass;
}

@end

@implementation JWSerializeInfo

@synthesize name = mName;
@synthesize objClass = mClass;
@synthesize arrayClass = mArrayClass;

- (id)initWithClass:(Class)objClass
{
    return [self initWithArrayName:nil arrayClass:nil itemClass:objClass];
}

- (id)initWithName:(NSString *)name objClass:(Class)objClass
{
    return [self initWithArrayName:name arrayClass:nil itemClass:objClass];
}

- (id)initWithArrayClass:(Class)arrayClass itemClass:(Class)itemClass
{
    return [self initWithArrayName:nil arrayClass:arrayClass itemClass:itemClass];
}

- (id)initWithArrayName:(NSString *)name arrayClass:(Class)arrayClass itemClass:(Class)itemClass
{
    self = [super init];
    if(self != nil)
    {
        mName = name;
        mArrayClass = arrayClass;
        mClass = itemClass;
    }
    return self;
}

+ (id)objectWithClass:(Class)objClass
{
    return [[JWSerializeInfo alloc] initWithClass:objClass];
}

+ (id)objectWithName:(NSString *)name objClass:(Class)objClass
{
    return [[JWSerializeInfo alloc] initWithName:name objClass:objClass];
}

+ (id)arrayWithClass:(Class)arrayClass itemClass:(Class)itemClass
{
    return [[JWSerializeInfo alloc] initWithArrayClass:arrayClass itemClass:itemClass];
}

+ (id)arrayWithName:(NSString *)name arrayClass:(Class)arrayClass itemClass:(Class)itemClass
{
    return [[JWSerializeInfo alloc] initWithArrayName:name arrayClass:arrayClass itemClass:itemClass];
}

@end