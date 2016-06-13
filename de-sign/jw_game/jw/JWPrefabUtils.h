//
//  JWPrefabUtils.h
//  June Winter_game
//
//  Created by ddeyes on 15/11/3.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <jw/JWGamePredef.h>
#import <jw/JWFile.h>
#import <jw/JCColor.h>
#import <jw/JCRect.h>

@interface JWPrefabUtils : NSObject

+ (id<JIGameObject>) createGridsWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent startRow:(NSInteger)startRow startColumn:(NSInteger)startColumn numRows:(NSUInteger)numRows numColumns:(NSUInteger)numColumns gridWidth:(float)gridWidth gridHeight:(float)gridHeight color:(JCColor)color;
+ (id<JIGameObject>) createSpriteWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent rect:(JCRectF)rect texture:(id<JITexture>)texture;
+ (id<JIGameObject>) createSpriteWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent rect:(JCRectF)rect textureFile:(id<JIFile>)textureFile;
+ (id<JIGameObject>) createVideoBackgroundWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent rect:(JCRectF)rect;

@end
