//
//  JWSkeleton.h
//  June Winter_game
//
//  Created by GavinLo on 15/5/1.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGamePredef.h>
#import <jw/JWObject.h>
#import <jw/JCSkeleton.h>

@protocol JISkeleton <JIObject>

- (void) makeWithNumBones:(NSUInteger)numBones;
- (void) setBone:(id<JIGameObject>)bone atIndex:(NSUInteger)index;
- (void) setBoneBaseMatrix:(JCMatrix4)matrix atIndex:(NSUInteger)index;
@property (nonatomic, readonly) JCSkeletonRef cskeleton;

@end

@interface JWSkeleton : JWObject <JISkeleton>

@end
