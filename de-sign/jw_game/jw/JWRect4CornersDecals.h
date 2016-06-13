//
//  JWRect4CornersDecals.h
//  June Winter_game
//
//  Created by ddeyes on 15/11/5.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGameObject.h>
#import <jw/JWMesh.h>

@interface JWRect4CornersDecals : NSObject

- (id) initWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent innerWidth:(float)innerWidth innerHeight:(float)innerHeight cornerOffsetX:(float)cornerOffsetX cornerOffsetY:(float)cornerOffsetY thickness:(float)thickness cornerOffsetU:(float)cornerOffsetU cornerOffsetV:(float)cornerOffsetV uvThickness:(float)uvThickness decalsTexture:(id<JITexture>)decalsTexture;
- (id) initWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent innerWidth:(float)innerWidth innerHeight:(float)innerHeight cornerOffsetX:(float)cornerOffsetX cornerOffsetY:(float)cornerOffsetY thickness:(float)thickness cornerOffsetU:(float)cornerOffsetU cornerOffsetV:(float)cornerOffsetV uvThickness:(float)uvThickness decalsFile:(id<JIFile>)decalsFile;
- (void) updateInnerWidth:(float)innerWidth innerHeight:(float)innerHeight;

@property (nonatomic, readonly) id<JIGameObject> decalsObject;

@end
