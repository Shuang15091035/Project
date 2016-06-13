//
//  JWGL20Mesh.h
//  June Winter
//
//  Created by GavinLo on 14/10/21.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWMesh.h>
#import <jw/JWGLResource.h>
#import <jw/JCGLVBO.h>

@interface JWGL20Mesh : JWMesh <JIGLResource>

@property (nonatomic, readonly) JCGLVertexVBORefC vertexVbo;
@property (nonatomic, readonly) JCGLIndexVBORefC indexVbo;

//- (void) setMesh:(JCMesh)mesh;

@end
