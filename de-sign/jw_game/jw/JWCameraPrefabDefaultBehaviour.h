//
//  JWCameraPrefabDefaultBehaviour.h
//  June Winter
//
//  Created by GavinLo on 14/11/12.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWBehaviour.h>

@interface JWCameraPrefabDefaultBehaviour : JWBehaviour
{
    id<JICameraPrefab> mCameraPrefab;
}

- (id) initWithContext:(id<JIGameContext>)context cameraPrefab:(id<JICameraPrefab>)cameraPrefab;

@end
