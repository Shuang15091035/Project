//
//  JCSkeleton.h
//  June Winter
//
//  Created by GavinLo on 15/4/21.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCSkeleton__
#define __jw__JCSkeleton__

#include <jw/JCBase.h>
#include <jw/JCMatrix4.h>

JC_BEGIN

typedef enum  {
    
    JCMaxBonesPreVertex = 4,
    JCMaxBoneTransformComponentsPreVertex = JCMaxBonesPreVertex * JCMatrix4NumComponents,
    
}JCSkeletonConstants;

typedef struct {
    
    JCInt boneIndex;
    JCFloat weight;
    
}JCBoneInfluence;

JCBoneInfluence JCBoneInfluenceZero();
JCBoneInfluence JCBoneInfluenceInvalid();
JCBoneInfluence JCBoneInfluenceMake(JCInt boneIndex, JCFloat weight);
bool JCBoneInfluenceIsValid(const JCBoneInfluence* boneInfluence);

typedef struct {
    
    JCMatrix4 boneTransforms[JCMaxBonesPreVertex]; // 每一个bone的几何变换
    JCUInt numBones;
    
}JCSkeleton;

typedef JCSkeleton* JCSkeletonRef;
typedef const JCSkeleton* JCSkeletonRefC;

JCSkeleton JCSkeletonMake(JCUInt numBones);
bool JCSkeletonSetBoneTransform(JCSkeletonRef skeleton, JCUInt boneIndex, JCMatrix4 boneMatrix);
void JCSkeletonDeepCopy(JCSkeletonRef dst, JCSkeletonRefC src);
JCULong JCSkeletonGetBoneTransformComponents(JCSkeletonRefC skeleton, JCFloat* components, JCULong componentOffset);

JC_END

#endif /* defined(__jw__JCSkeleton__) */
