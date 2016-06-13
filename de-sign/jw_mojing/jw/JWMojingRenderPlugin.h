//
//  JWMojingRenderPlugin.h
//  June Winter
//
//  Created by mac zdszkj on 16/3/4.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/jw_opengl.h>

#if JW_OPENGL_VERSION == 2
@interface JWMojingRenderPlugin : JWGL20Plugin

@end

#elif JW_OPENGL_VERSION == 3
@interface JWMojingRenderPlugin : JWGL30Plugin

@end
#endif
