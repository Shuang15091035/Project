//
//  JWRectFrameDecals.m
//  June Winter_game
//
//  Created by ddeyes on 15/11/4.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWRectFrameDecals.h"
#import <jw/JWFile.h>
#import <jw/JWGameContext.h>
#import <jw/JWGameObject.h>
#import <jw/JWMesh.h>
#import <jw/JWMeshRenderer.h>
#import <jw/JWMeshManager.h>
#import <jw/JWTexture.h>
#import <jw/JWTextureManager.h>
#import <jw/JWMaterial.h>
#import <jw/JWMaterialManager.h>

@interface JWRectFrameDecals () {
    id<JIGameObject> mDecalsObject;
    id<JIMesh> mDecalsMesh;
    float mThickness;
    float mUVThickness;
}

@end

@implementation JWRectFrameDecals

- (id)initWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent InnerWidth:(float)innerWidth innerHeight:(float)innerHeight thickness:(float)thickness uvThickness:(float)uvThickness decalsTexture:(id<JITexture>)decalsTexture {
    self = [super init];
    if (self != nil) {
        mDecalsObject = [context createObject];
        mDecalsObject.parent = parent;
        
        NSString* decalsName = [NSString stringWithFormat:@"decals_%@", @(mDecalsObject.hash)];
        mDecalsObject.Id = decalsName;
        mDecalsObject.name = decalsName;
        
        mDecalsMesh = (id<JIMesh>)[context.meshManager createFromFile:[JWFile fileWithName:decalsName content:nil]];
        [mDecalsMesh decalsRectFrameInnerWidth:innerWidth innerHeight:innerHeight thickness:thickness uvThickness:uvThickness];
        [mDecalsMesh load];
        
        [decalsTexture load];
        NSString* decalsMaterialName = [NSString stringWithFormat:@"mat_%@", decalsName];
        id<JIMaterial> decalsMaterial = (id<JIMaterial>)[context.materialManager createFromFile:[JWFile fileWithName:decalsMaterialName content:nil]];
        decalsMaterial.diffuseTexture = decalsTexture;
        decalsMaterial.transparent = YES;
        [decalsMaterial setBlendingSrcFactor:JCBlendFactorOne andDstFactor:JCBlendFactorOneMinusSrcAlpha];
        [decalsMaterial load];
        
        id<JIMeshRenderer> decalsRenderer = [context createMeshRenderer];
        decalsRenderer.mesh = mDecalsMesh;
        decalsRenderer.material = decalsMaterial;
        [mDecalsObject addComponent:decalsRenderer];
        
        mThickness = thickness;
        mUVThickness = uvThickness;
    }
    return self;
}

- (id)initWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent InnerWidth:(float)innerWidth innerHeight:(float)innerHeight thickness:(float)thickness uvThickness:(float)uvThickness decalsFile:(id<JIFile>)decalsFile {
    id<JITexture> decalsTexture = (id<JITexture>)[context.textureManager createFromFile:decalsFile];
    return [self initWithContext:context parent:parent InnerWidth:innerWidth innerHeight:innerHeight thickness:thickness uvThickness:uvThickness decalsTexture:decalsTexture];
}

- (void)updateInnerWidth:(float)innerWidth innerHeight:(float)innerHeight {
    [mDecalsMesh decalsRectFrameUpdateInnerWidth:innerWidth innerHeight:innerHeight thickness:mThickness uvThickness:mUVThickness];
}

- (id<JIGameObject>)decalsObject {
    return mDecalsObject;
}

@end
