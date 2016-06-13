//
//  JWBoneInfluence.h
//  jw_core
//
//  Created by GavinLo on 15/5/1.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWObject.h>
#import <jw/JCSkeleton.h>

@interface JWBoneInfluence : JWObject

+ (id) boneInfluence;
@property (nonatomic, readwrite) JCBoneInfluence boneInfluence;

@end
