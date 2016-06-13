//
//  JWBoundsQuery.h
//  June Winter_game
//
//  Created by ddeyes on 16/1/15.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWSceneQuery.h>
#import <jw/JCBounds3.h>

@protocol JIBoundsQuery <JISceneQuery>

- (id<JIBoundsQueryResult>) getResultByBounds:(JCBounds3)bounds object:(id<JIGameObject>)object;

@end

@interface JWBoundsQuery : JWSceneQuery <JIBoundsQuery>

@end

@interface JWBoundsQueryResultEntry : JWObject

@property (nonatomic, readwrite) id<JIGameObject> object;

- (id) initWithObject:(id<JIGameObject>)object;

@end

@protocol JIBoundsQueryResult <JIObject>

@property (nonatomic, readonly) NSUInteger numEntries;
- (JWBoundsQueryResultEntry*) entryAt:(NSUInteger)index;
@property (nonatomic, readonly) NSArray<JWBoundsQueryResultEntry*>* entries;

@end
