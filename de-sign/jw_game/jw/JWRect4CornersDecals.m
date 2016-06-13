//
//  JWRect4CornersDecals.m
//  June Winter_game
//
//  Created by ddeyes on 15/11/5.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWRect4CornersDecals.h"
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

@interface JWRect4CornersDecals () {
    id<JIGameObject> mDecalsObject;
    id<JIMesh> mDecalsMesh;
    float mCornerOffsetX;
    float mCornerOffsetY;
    float mThickness;
    float mCornerOffsetU;
    float mCornerOffsetV;
    float mUVThickness;
}

@end

@implementation JWRect4CornersDecals

- (id)initWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent innerWidth:(float)innerWidth innerHeight:(float)innerHeight cornerOffsetX:(float)cornerOffsetX cornerOffsetY:(float)cornerOffsetY thickness:(float)thickness cornerOffsetU:(float)cornerOffsetU cornerOffsetV:(float)cornerOffsetV uvThickness:(float)uvThickness decalsTexture:(id<JITexture>)decalsTexture {
    self = [super init];
    if (self != nil) {
        mDecalsObject = [context createObject];
        mDecalsObject.parent = parent;
        
        NSString* decalsName = [NSString stringWithFormat:@"decals_%@", @(mDecalsObject.hash)];
        mDecalsObject.Id = decalsName;
        mDecalsObject.name = decalsName;
        
        mDecalsMesh = (id<JIMesh>)[context.meshManager createFromFile:[JWFile fileWithName:decalsName content:nil]];
        [mDecalsMesh decalsRect4CornersInnerWidth:innerWidth innerHeight:innerHeight cornerOffsetX:cornerOffsetX cornerOffsetY:cornerOffsetY thickness:thickness cornerOffsetU:cornerOffsetU cornerOffsetV:cornerOffsetV uvThickness:uvThickness];
        [mDecalsMesh load];
        
        [decalsTexture load];
        NSString* decalsMaterialName = [NSString stringWithFormat:@"mat_%@", decalsName];
        id<JIMaterial> decalsMaterial = (id<JIMaterial>)[context.materialManager createFromFile:[JWFile fileWithName:decalsMaterialName content:nil]];
        decalsMaterial.diffuseTexture = decalsTexture;
        decalsMaterial.alphaTexture = decalsTexture;
        [decalsMaterial setBlendingSrcFactor:JCBlendFactorSrcAlpha andDstFactor:JCBlendFactorOneMinusSrcAlpha];
        [decalsMaterial load];
        
        id<JIMeshRenderer> decalsRenderer = [context createMeshRenderer];
        decalsRenderer.mesh = mDecalsMesh;
        decalsRenderer.material = decalsMaterial;
        [mDecalsObject addComponent:decalsRenderer];
        
        mCornerOffsetX = cornerOffsetX;
        mCornerOffsetY = cornerOffsetY;
        mThickness = thickness;
        mCornerOffsetU = cornerOffsetU;
        mCornerOffsetV = cornerOffsetV;
        mUVThickness = uvThickness;
    }
    return self;
}

- (id)initWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent innerWidth:(float)innerWidth innerHeight:(float)innerHeight cornerOffsetX:(float)cornerOffsetX cornerOffsetY:(float)cornerOffsetY thickness:(float)thickness cornerOffsetU:(float)cornerOffsetU cornerOffsetV:(float)cornerOffsetV uvThickness:(float)uvThickness decalsFile:(id<JIFile>)decalsFile {
    id<JITexture> decalsTexture = (id<JITexture>)[context.textureManager createFromFile:decalsFile];
    return [self initWithContext:context parent:parent innerWidth:innerWidth innerHeight:innerHeight cornerOffsetX:cornerOffsetX cornerOffsetY:cornerOffsetY thickness:thickness cornerOffsetU:cornerOffsetU cornerOffsetV:cornerOffsetV uvThickness:uvThickness decalsTexture:decalsTexture];
}

- (void)updateInnerWidth:(float)innerWidth innerHeight:(float)innerHeight {
    [mDecalsMesh decalsRect4CornersUpdateInnerWidth:innerWidth innerHeight:innerHeight cornerOffsetX:mCornerOffsetX cornerOffsetY:mCornerOffsetY thickness:mThickness cornerOffsetU:mCornerOffsetU cornerOffsetV:mCornerOffsetV uvThickness:mUVThickness];
}

- (id<JIGameObject>)decalsObject {
    return mDecalsObject;
}

@end
