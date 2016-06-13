//
//  JWGLResource.h
//  June Winter
//
//  Created by GavinLo on 14/10/24.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWResource.h>

@protocol JIGLResource <NSObject>

// 使资源绑定到渲染环境中，数据加载到显存
- (BOOL) bind;
- (void) unbind;

@end

//@interface JWGLResource : JWResource
//
//- (BOOL) bind;
//- (void) unbind;
//
//@end
