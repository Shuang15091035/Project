//
//  JWGL20SurfaceView.h
//  jw_opengl
//
//  Created by ddeyes on 16/3/31.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <jw/JWGLRenderer.h>
#import <jw/JCGLRenderTarget.h>

@interface JWGL20SurfaceView : UIControl

- (void) drawFrame;
@property (nonatomic, readonly) EAGLContext* glContext;
@property (nonatomic, readwrite) id<JIGLRenderer> renderer;
@property (nonatomic, readwrite) NSUInteger MSAALevel;
@property (nonatomic, readonly) id<JIEventQueue> eventQueue;
@property (nonatomic, readonly) JCGLRenderTargetRefC renderTarget;

@end
