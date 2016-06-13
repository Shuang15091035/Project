//
//  JCGLRenderUtils.h
//  June Winter
//
//  Created by GavinLo on 14/10/20.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCGLRenderUtils__
#define __jw__JCGLRenderUtils__

#include <jw/JCBase.h>
#include <jw/JCMesh.h>
#include <jw/JCMaterial.h>
#include <jw/JCTexture.h>
#include <jw/JCGLContext.h>
#include <jw/JCGLVBO.h>
#include <jw/JCGLEffect.h>
#include <jw/JCLight.h>

JC_BEGIN

//bool JCGLDrawVBO(JCRenderOperation operation, JCGLVertexVBORefC vertexVbo, JCGLIndexVBORefC indexVbo, JCMatrix4 matrix, JCMaterialRefC material, JCGLEffectRefC effect, JCCameraRefC camera, JCSkeletonRefC skeleton);
bool JCGLDrawMesh(JCMeshRefC mesh, JCGLVertexVBORefC vertexVbo, JCGLIndexVBORefC indexVbo, JCMatrix4 matrix, JCStretch stretch, JCMaterialRefC material, JCGLEffectRefC effect, JCCameraRefC camera, JCSkeletonRefC skeleton);

JC_END

#endif /* defined(__jw__JCGLRenderUtils__) */
