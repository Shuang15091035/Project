//
//  JWRectFrameDecals.h
//  June Winter_game
//
//  Created by ddeyes on 15/11/4.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGameObject.h>
#import <jw/JWMesh.h>

@interface JWRectFrameDecals : NSObject

- (id) initWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent InnerWidth:(float)innerWidth innerHeight:(float)innerHeight thickness:(float)thickness uvThickness:(float)uvThickness decalsTexture:(id<JITexture>)decalsTexture;
- (id) initWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent InnerWidth:(float)innerWidth innerHeight:(float)innerHeight thickness:(float)thickness uvThickness:(float)uvThickness decalsFile:(id<JIFile>)decalsFile;
- (void) updateInnerWidth:(float)innerWidth innerHeight:(float)innerHeight;

@property (nonatomic, readonly) id<JIGameObject> decalsObject;

@end
