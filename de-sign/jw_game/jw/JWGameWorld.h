//
//  JWGameWorld.h
//  June Winter
//
//  Created by GavinLo on 14-5-2.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGamePredef.h>
#import <jw/JWObject.h>
#import <jw/JWTimer.h>
#import <jw/JWMutableArray.h>
#import <jw/JWGameEvents.h>
#import <jw/JCViewport.h>

@protocol JIGameWorld <JIObject, JITimeUpdatable, JIGameEvents>

- (void) addScene:(id<JIGameScene>)scene;
- (void) removeScene:(id<JIGameScene>)scene;
- (void) removeAllScenes;
@property (nonatomic, readonly) id<JIGameScene> currentScene;
- (BOOL) changeSceneById:(NSString*)sceneId;
- (id<JIGameScene>) getSceneById:(NSString*)sceneId;

@end

@interface JWGameWorld : JWObject <JIGameWorld>
{
    id<JIGameContext> mContext;
    id<JIGameScene> mCurrentScene;
    id<JIUList> mScenes;
}

- (JCViewport) onGameFrameChangedWidth:(float)width andHeight:(float)height;

@end
