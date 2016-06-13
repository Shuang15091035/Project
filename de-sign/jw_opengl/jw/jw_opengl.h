//
//  jw_opengl.h
//  jw_opengl
//
//  Created by GavinLo on 15/1/20.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#ifndef JW_OPENGL_VERSION
#define JW_OPENGL_VERSION 3
#endif

#if JW_OPENGL_VERSION == 2
#import <jw/JWGL20Plugin.h>
#elif JW_OPENGL_VERSION == 3
#import <jw/JWGL30Plugin.h>
#endif
