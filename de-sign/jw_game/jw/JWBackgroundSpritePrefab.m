//
//  JWBackgroundSpritePrefab.m
//  jw_game
//
//  Created by mac zdszkj on 16/4/7.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWBackgroundSpritePrefab.h"
#import <jw/JWTextureManager.h>
#import <jw/JWMeshManager.h>
#import <jw/JWMaterialManager.h>
#import <jw/JWMesh.h>
#import <jw/JWTexture.h>
#import <jw/JWMaterial.h>
#import <jw/JWMeshRenderer.h>

@interface JWBackgroundSpritePrefab () {
    id<JIGameObject> mSpriteObject;
    id<JIMaterial> mSpriteMaterial;
}

@end

@implementation JWBackgroundSpritePrefab

+ (id)spriteWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent rect:(JCRectF)rect texture:(id<JITexture>)texture {
    return [[self alloc] initWithContext:context parent:parent rect:rect texture:texture];
}

+ (id)spriteWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent rect:(JCRectF)rect textureFile:(id<JIFile>)textureFile {
    return [[self alloc] initWithContext:context parent:parent rect:rect textureFile:textureFile];
}

- (id)initWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent rect:(JCRectF)rect texture:(id<JITexture>)texture {
    self = [super init];
    if (self != nil) {
        mSpriteObject = [context createObject];
        mSpriteObject.parent = parent;
        NSString* spriteName = [NSString stringWithFormat:@"sprite_%@", @(mSpriteObject.hash)];
        id<JIMesh> spriteMesh = (id<JIMesh>)[context.meshManager createFromFile:[JWFile fileWithName:spriteName content:nil]];
        [spriteMesh spriteRect:rect color:JCColorNull()];
        [spriteMesh load];
        [texture load];
        mSpriteMaterial = (id<JIMaterial>)[context.materialManager createFromFile:[JWFile fileWithName:spriteName content:nil]];
        mSpriteMaterial.diffuseTexture = texture;
        mSpriteMaterial.depthCheck = NO;
        [mSpriteMaterial load];
        id<JIMeshRenderer> spriteRenderer = [context createMeshRenderer];
        spriteRenderer.renderOrder = JWRenderOrderBackgroundDefault;
        spriteRenderer.mesh = spriteMesh;
        spriteRenderer.material = mSpriteMaterial;
        [mSpriteObject addComponent:spriteRenderer];
    }
    return self;
}

- (id)initWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent rect:(JCRectF)rect textureFile:(id<JIFile>)textureFile {
    id<JITexture> spriteTex = (id<JITexture>)[context.textureManager createFromFile:textureFile];
    return [self initWithContext:context parent:parent rect:rect texture:spriteTex];
}

- (id<JIGameObject>)spriteObject {
    return mSpriteObject;
}

- (id<JITexture>)spriteTexture {
    return mSpriteMaterial.diffuseTexture;
}

- (void)setSpriteTexture:(id<JITexture>)spriteTexture {
    mSpriteMaterial.diffuseTexture = spriteTexture;
}

- (id<JIFile>)spriteTextureFile {
    if (mSpriteMaterial.diffuseTexture == nil) {
        return nil;
    }
    return mSpriteMaterial.diffuseTexture.file;
}

- (void)setSpriteTextureFile:(id<JIFile>)spriteTextureFile {
    id<JIGameContext> context = mSpriteObject.context;
    id<JITexture> spriteTex = (id<JITexture>)[context.textureManager createFromFile:spriteTextureFile];
    mSpriteMaterial.diffuseTexture = spriteTex;
    [spriteTex load];
}

@end
