//
//  JWMojingCamera.m
//  June Winter
//
//  Created by mac zdszkj on 16/3/4.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWMojingCamera.h"
#import "JWMojingManager.h"
#import <jw/jcgl.h>
#import <jw/JCGLContext.h>
#import <jw/JCGLRenderTarget.h>
#import <jw/JWGLGameFrame.h>
#import <jw/JWGameContext.h>
#import <jw/JWGameEngine.h>
#import <jw/JWGamePluginSystem.h>
#import <jw/JWRenderPlugin.h>
#import <jw/JWGameScene.h>
#import <jw/JWGameObject.h>
#import <jw/UIView+JWUiCategory.h>
#import <MojingSDK/MojingIOSAPI.h>

@interface JWMojingCamera(){
    JCGLRenderTarget mRenderTarget;
    GLuint mEyeTextures[2];
    MojingType mMojingType;
}

@end

@implementation JWMojingCamera

- (id)initWithContext:(id<JIGameContext>)context {
    self = [super initWithContext:context];
    if (self != nil) {
        mRenderTarget = JCGLRenderTargetNull();
        mMojingType = MojingTypeUnknown;
    }
    return self;
}

- (BOOL)preRender {
    JWGLGameFrame* gameFrame = (JWGLGameFrame*)mContext.engine.frame;
    JCGLRenderTargetRefC renderTargetOrigin = gameFrame.glSurfaceView.renderTarget;
    return JCGLRenderTargetIsValid(renderTargetOrigin) ? YES : NO;
}

- (BOOL)preRenderCamera:(id<JICamera>)camera atIndex:(NSUInteger)idx {
    
    MojingType mojingType = [JWMojingManager instance].mojingType;
    if (mojingType == MojingType2 || mojingType == MojingTypeXiaoD) {
//        if (JCGLRenderTargetIsValid(&mRenderTarget)) {
//            // 还原全局MSAA设置
//            GLsizei MSAALevel = mRenderTarget.MSAALevel;
//            JCGLRenderTargetDelete(&mRenderTarget);
//            mContext.engine.pluginSystem.renderPlugin.MSAA = MSAALevel;
//        }
        JCGLRenderTargetDelete(&mRenderTarget);
        // 还原fovy和viewport
        self.fovy = self.fovy;
        self.viewport = self.viewport;
        // 绑定原来的framebuffer
//        JWGLGameFrame* gameFrame = (JWGLGameFrame*)mContext.engine.frame;
//        JCGLRenderTargetRefC renderTargetOrigin = gameFrame.glSurfaceView.renderTarget;
//        JCGLRenderTargetBind(renderTargetOrigin);
        return YES;
    }
//    GLsizei MSAALevel = 0;
//    if (mMojingType != mojingType) {
//        // 修改全局MSAA设置
//        MSAALevel = (GLsizei)mContext.engine.pluginSystem.renderPlugin.MSAA;
//        JCGLRenderTargetDelete(&mRenderTarget);
//        mContext.engine.pluginSystem.renderPlugin.MSAA = 0;
//    }
//    mMojingType = mojingType;
    GLsizei MSAALevel = (GLsizei)[JWMojingManager instance].MSAALevel;
    
    int eyeParams[3] = {0, 0, 0};
    int eyeTextureId = MojingSDK_API_GetEyeTexture((int)idx + 1, eyeParams);
    if (eyeTextureId == JCTextureInvalidId) {
        return NO;
    }
    int texWidth = eyeParams[0];
    int texHeight = eyeParams[1];
//    int texFormat = eyeParams[2];

    JCGLRenderTargetCreateTexture(&mRenderTarget, texWidth, texHeight, JCTextureInvalidId, JCGLRenderTargetDepthFormatDefault, MSAALevel);
    JCGLRenderTargetBindTexture(&mRenderTarget, eyeTextureId);
    
    // 这里调用没有效果
    //glClear(GL_DEPTH_BUFFER_BIT);
    
    camera.fovy = MojingSDK_API_GetMojingWorldFOV();
    camera.viewport = JCViewportMakeReal(0, 0, texWidth, texHeight);
    mEyeTextures[idx] = eyeTextureId;
    
    // 清除场景
    id<JIGameScene> scene = self.host.scene;
    if (scene != nil) {
        const JCColor clearColor = scene.clearColor;
        JCGLClearColor(clearColor.r, clearColor.g, clearColor.b, clearColor.a);
    } else {
        JCGLClearColor(0, 0, 0, 1);
    }
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    return JCGLRenderTargetIsValid(&mRenderTarget) ? YES : NO;
}

- (void)postRenderCamera:(id<JICamera>)camera atIndex:(NSUInteger)idx {
    
    MojingType mojingType = [JWMojingManager instance].mojingType;
    if (mojingType == MojingType2 || mojingType == MojingTypeXiaoD) {
        return;
    }
    
    // TODO 这里需要清除depth buffer，不然左眼texture在渲染时会受到右眼depth buffer的残留影响，但左眼渲染前也有调用glClear，原因不明，估这样处理一下
    glClear(GL_DEPTH_BUFFER_BIT);
    JCGLRenderTargetPresent(&mRenderTarget);
    //JCGLRenderTargetUnbind(&mRenderTarget);
}

- (void)postRender {
    
    MojingType mojingType = [JWMojingManager instance].mojingType;
    if (mojingType == MojingType2 || mojingType == MojingTypeXiaoD) {
        return;
    }
    
    JWGLGameFrame* gameFrame = (JWGLGameFrame*)mContext.engine.frame;
    JCGLRenderTargetRefC renderTargetOrigin = gameFrame.glSurfaceView.renderTarget;
    JCGLRenderTargetBind(renderTargetOrigin);
    
    JCGLClearColor(0, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    CGRect frame = gameFrame.glSurfaceView.frameInPixels;
    glViewport(0, 0, frame.size.width, frame.size.height);
    
    MojingSDK_API_DrawTexture(mEyeTextures[0], mEyeTextures[1]);
}


@end
