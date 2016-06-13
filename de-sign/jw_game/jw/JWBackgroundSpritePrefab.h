//
//  JWBackgroundSpritePrefab.h
//  jw_game
//
//  Created by mac zdszkj on 16/4/7.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGameObject.h>
#import <jw/JWMaterial.h>
#import <jw/JCRect.h>

@interface JWBackgroundSpritePrefab : JWObject

+ (id) spriteWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent rect:(JCRectF)rect texture:(id<JITexture>)texture;
+ (id) spriteWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent rect:(JCRectF)rect textureFile:(id<JIFile>)textureFile;
- (id) initWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent rect:(JCRectF)rect texture:(id<JITexture>)texture;
- (id) initWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent rect:(JCRectF)rect textureFile:(id<JIFile>)textureFile;

@property (nonatomic, readonly) id<JIGameObject> spriteObject;
//@property (nonatomic, readonly) id<JIMaterial> spriteMaterial;
@property (nonatomic, readwrite) id<JITexture> spriteTexture;
@property (nonatomic, readwrite) id<JIFile> spriteTextureFile;

@end
