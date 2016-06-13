//
//  JWEntity.h
//  June Winter
//
//  Created by GavinLo on 14-5-2.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWObject.h>

@protocol JIIdentifiable <NSObject>

@property (nonatomic, readwrite) NSString* Id;

@end

@protocol JINameable <NSObject>

@property (nonatomic, readwrite) NSString* name;

@end

@protocol JIEntity <JIObject, JIIdentifiable, JINameable>

@end

@interface JWEntity : JWObject <JIEntity>
{
    NSString* mId;
    NSString* mName;
}

@end
