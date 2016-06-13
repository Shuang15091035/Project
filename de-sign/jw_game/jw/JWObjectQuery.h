//
//  JWObjectQuery.h
//  June Winter_game
//
//  Created by mac zdszkj on 16/1/19.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWSceneQuery.h>
#import <jw/JWGameObject.h>

@protocol JIObjectQuery <JISceneQuery>

- (id<JIObjectQueryResult>) getResultByObject:(id<JIGameObject>)object inObject:(id<JIGameObject>)inObject;

@end

@interface JWObjectQuery : JWSceneQuery <JIObjectQuery>

@end

@interface JWObjectQueryResultEntry : JWObject

@property (nonatomic, readwrite) id<JIGameObject> object;

- (id) initWithObject:(id<JIGameObject>)object;

@end

@protocol JIObjectQueryResult <JIObject>

@property (nonatomic, readonly) NSUInteger numEntries;
- (JWObjectQueryResultEntry*) entryAt:(NSUInteger)index;
@property (nonatomic, readonly) NSArray<JWObjectQueryResultEntry*>* entries;

@end
