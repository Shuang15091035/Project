//
//  JWRayQuery.h
//  June Winter
//
//  Created by GavinLo on 14/12/10.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWSceneQuery.h>
#import <jw/JCRay3.h>

@protocol JIRayQuery <JISceneQuery>

@property (nonatomic, readwrite) BOOL willSortByDistance;
- (id<JIRayQueryResult>) getResultByRay:(JCRay3)ray object:(id<JIGameObject>)object;

@end

@interface JWRayQuery : JWSceneQuery <JIRayQuery>
{
    BOOL mWillSortByDistance;
}

@end

@interface JWRayQueryResultEntry : JWObject

@property (nonatomic, readwrite) id<JIGameObject> object;
@property (nonatomic, readwrite) float distance;

- (id) initWithObject:(id<JIGameObject>)object distance:(float)distance;

@end

@protocol JIRayQueryResult <JIObject>

@property (nonatomic, readonly) NSUInteger numEntries;
- (JWRayQueryResultEntry*) entryAt:(NSUInteger)index;
@property (nonatomic, readonly) NSArray* entries;

@end