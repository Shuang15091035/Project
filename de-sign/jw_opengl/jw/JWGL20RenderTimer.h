//
//  JWGL20RenderTimer.h
//  June Winter
//
//  Created by GavinLo on 14-5-4.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGL20Predef.h>
#import <jw/JWRenderTimer.h>

@interface JWGL20RenderTimer : JWRenderTimer

@property (nonatomic, readwrite) id<JIGLRenderer> renderer;
@property (nonatomic, readwrite) JWGL20GameFrame* gameFrame;

- (id<JIGLRenderer>) newDefaultRenderer;

@end
