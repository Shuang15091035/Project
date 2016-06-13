//
//  JWGLGameFrame.h
//  jw_opengl
//
//  Created by ddeyes on 16/4/3.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGameFrame.h>
#import <jw/JWGLSurfaceView.h>

@interface JWGLGameFrame : JWGameFrame

- (id) initWithEngine:(id<JIGameEngine>)engine version:(EAGLRenderingAPI)version;
@property (nonatomic, readonly) JWGLSurfaceView* glSurfaceView;

@end
