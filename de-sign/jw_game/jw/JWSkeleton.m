//
//  JWSkeleton.m
//  June Winter_game
//
//  Created by GavinLo on 15/5/1.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWSkeleton.h"
#import <jw/JWMatrix4.h>
#import <jw/JWGameObject.h>

@interface JWSkeleton () {
    NSMutableArray* mBones;
    NSMutableArray* mBoneBaseMatrices;
    BOOL mBonesDirty;
    JCSkeleton mSkeleton;
}

@end

@implementation JWSkeleton

//- (instancetype)init {
//    self = [super init];
//    if (self != nil) {
//        mSkeleton = JCSkeletonMake();
//    }
//    return self;
//}

- (void)makeWithNumBones:(NSUInteger)numBones {
    if (mBones == nil) {
        mBones = [NSMutableArray array];
    }
    [mBones removeAllObjects];
    for (NSUInteger i = 0; i < numBones; i++) {
        [mBones addObject:[NSNull null]];
    }
    if (mBoneBaseMatrices == nil) {
        mBoneBaseMatrices = [NSMutableArray array];
    }
    for (NSUInteger i = 0; i < numBones; i++) {
        [mBoneBaseMatrices add:nil];
    }
    //JCSkeletonInit(&mSkeleton, numBones);
    mSkeleton = JCSkeletonMake((JCUInt)numBones);
}

- (void)setBone:(id<JIGameObject>)bone atIndex:(NSUInteger)index {
    [mBones replaceObjectAtIndex:index withObject:bone];
    mBonesDirty = YES;
}

- (void)setBoneBaseMatrix:(JCMatrix4)matrix atIndex:(NSUInteger)index {
    JWMatrix4* m = [mBoneBaseMatrices at:index];
    if (m == nil) {
        m = [JWMatrix4 matrix];
    }
    m.matrix = matrix;
    [mBoneBaseMatrices replaceObjectAtIndex:index withObject:m];
}

- (JCSkeletonRef)cskeleton {
    //if (mBonesDirty) {
        for (NSUInteger i = 0; i < mBones.count; i++) {
            id<JIGameObject> bone = [mBones objectAtIndex:i];
            JWMatrix4* baseMatrix = [mBoneBaseMatrices objectAtIndex:i];
            JCMatrix4 bm = baseMatrix.matrix;
            JCMatrix4 btm = bone.transform.matrix;
            JCMatrix4 boneMatrix = JCMatrix4Rmul(&bm, &btm);
            JCUInt boneIndex = (JCUInt)i;
            boneMatrix = JCMatrix4Transpose(&boneMatrix); // NOTE 转置为列矩阵
            JCSkeletonSetBoneTransform(&mSkeleton, boneIndex, boneMatrix);
        }
        mBonesDirty = NO;
    //}
    return &mSkeleton;
}

@end
