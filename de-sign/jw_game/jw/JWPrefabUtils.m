//
//  JWPrefabUtils.m
//  June Winter_game
//
//  Created by ddeyes on 15/11/3.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWPrefabUtils.h"
#import <jw/JWFile.h>
#import <jw/JWGameContext.h>
#import <jw/JWGameObject.h>
#import <jw/JWMesh.h>
#import <jw/JWMeshRenderer.h>
#import <jw/JWMeshManager.h>
#import <jw/JWTexture.h>
#import <jw/JWVideoTexture.h>
#import <jw/JWTextureManager.h>
#import <jw/JWVideoTextureManager.h>
#import <jw/JWMaterial.h>
#import <jw/JWMaterialManager.h>

@implementation JWPrefabUtils

+ (id<JIGameObject>)createGridsWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent startRow:(NSInteger)startRow startColumn:(NSInteger)startColumn numRows:(NSUInteger)numRows numColumns:(NSUInteger)numColumns gridWidth:(float)gridWidth gridHeight:(float)gridHeight color:(JCColor)color {
    
    id<JIGameObject> gridsObject = [context createObject];
    gridsObject.parent = parent;
    NSString* gridsName = [NSString stringWithFormat:@"grids_%@", @(gridsObject.hash)];
    gridsObject.Id = gridsName;
    gridsObject.name = gridsName;
    id<JIMesh> gridsMesh = (id<JIMesh>)[context.meshManager createFromFile:[JWFile fileWithName:gridsName content:nil]];
    [gridsMesh gridsStartRow:startRow startColumn:startColumn numRows:numRows numColumns:numColumns gridWidth:gridWidth gridHeight:gridHeight color:color];
    [gridsMesh load];
    id<JIMeshRenderer> gridsRenderer = [context createMeshRenderer];
    gridsRenderer.mesh = gridsMesh;
    [gridsObject addComponent:gridsRenderer];
    
    return gridsObject;
}

+ (id<JIGameObject>)createSpriteWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent rect:(JCRectF)rect texture:(id<JITexture>)texture {
    
    id<JIGameObject> spriteObject = [context createObject];
    spriteObject.parent = parent;
    NSString* spriteName = [NSString stringWithFormat:@"sprite_%@", @(spriteObject.hash)];
    id<JIMesh> spriteMesh = (id<JIMesh>)[context.meshManager createFromFile:[JWFile fileWithName:spriteName content:nil]];
    [spriteMesh spriteRect:rect color:JCColorNull()];
    [spriteMesh load];
    [texture load];
    id<JIMaterial> spriteMat = (id<JIMaterial>)[context.materialManager createFromFile:[JWFile fileWithName:spriteName content:nil]];
    spriteMat.diffuseTexture = texture;
    spriteMat.depthCheck = NO;
    [spriteMat load];
    id<JIMeshRenderer> spriteRenderer = [context createMeshRenderer];
    spriteRenderer.renderOrder = JWRenderOrderBackgroundDefault;
    spriteRenderer.mesh = spriteMesh;
    spriteRenderer.material = spriteMat;
    [spriteObject addComponent:spriteRenderer];
    
    return spriteObject;
}

+ (id<JIGameObject>)createSpriteWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent rect:(JCRectF)rect textureFile:(id<JIFile>)textureFile {
    
    id<JITexture> spriteTex = (id<JITexture>)[context.textureManager createFromFile:textureFile];
    return [JWPrefabUtils createSpriteWithContext:context parent:parent rect:rect texture:spriteTex];
}

+ (id<JIGameObject>)createVideoBackgroundWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent rect:(JCRectF)rect {
    id<JIGameObject> videoObject = [context createObject];
    videoObject.parent = parent;
    NSString* videoName = [NSString stringWithFormat:@"video_%@", @(videoObject.hash)];
    id<JIMesh> videoMesh = (id<JIMesh>)[context.meshManager createFromFile:[JWFile fileWithName:videoName content:nil]];
    [videoMesh spriteRect:rect color:JCColorNull()];
    [videoMesh load];
    id<JIVideoTexture> videoTexture = (id<JIVideoTexture>)[context.videoTextureManager createFromFile:[JWFile fileWithName:videoName content:nil]];
    id<JIMaterial> videoMat = (id<JIMaterial>)[context.materialManager createFromFile:[JWFile fileWithName:videoName content:nil]];
    videoMat.videoTexture = videoTexture;
    videoMat.depthCheck = NO;
    [videoMat load];
    id<JIMeshRenderer> videoRenderer = [context createMeshRenderer];
    videoRenderer.renderOrder = JWRenderOrderBackgroundDefault;
    videoRenderer.mesh = videoMesh;
    videoRenderer.material = videoMat;
    [videoObject addComponent:videoRenderer];
    return videoObject;
}

@end
