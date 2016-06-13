//
//  JWMeshRenderer.h
//  June Winter
//
//  Created by GavinLo on 14/10/21.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWRenderable.h>

@protocol JIMeshRenderer <JIRenderable>

@property (nonatomic, readwrite) id<JIMesh> mesh;
@property (nonatomic, readwrite) id<JISkeleton> skeleton;

@end

@interface JWMeshRenderer : JWRenderable <JIMeshRenderer> {
    id<JIMesh> mMesh;
    id<JISkeleton> mSkeleton;
}

@end
