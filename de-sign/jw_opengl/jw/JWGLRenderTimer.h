//
//  JWGLRenderTimer.h
//  jw_opengl
//
//  Created by ddeyes on 16/4/3.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGLPredef.h>
#import <jw/JWRenderTimer.h>

@interface JWGLRenderTimer : JWRenderTimer

@property (nonatomic, readwrite) id<JIGLRenderer> renderer;
@property (nonatomic, readwrite) JWGLGameFrame* gameFrame;

- (id<JIGLRenderer>) newDefaultRenderer;

@end
