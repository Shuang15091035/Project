//
//  JWEffectManager.h
//  June Winter
//
//  Created by GavinLo on 14/10/21.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWResourceManager.h>

@protocol JIEffectManager <JIResourceManager>

- (id<JIEffect>) createByGameObject:(id<JIGameObject>)gameObject mesh:(id<JIMesh>)mesh material:(id<JIMaterial>)material lights:(id<NSFastEnumeration>)lights;

@end

@interface JWEffectManager : JWResourceManager <JIEffectManager>

@end
