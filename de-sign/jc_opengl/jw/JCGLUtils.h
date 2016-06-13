//
//  JCGLUtils.h
//  June Winter
//
//  Created by GavinLo on 14/12/12.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCGLUtils__
#define __jw__JCGLUtils__

#include <jw/JCBase.h>

JC_BEGIN

bool JCGLProject(JCFloat objX, JCFloat objY, JCFloat objZ, JCFloat* model, int modelOffset, JCFloat* project, int projectOffset, int* view, int viewOffset, JCOut JCFloat* win, int winOffset);
bool JCGLUnproject(JCFloat winX, JCFloat winY, JCFloat winZ, JCFloat* model, int modelOffset, JCFloat* project, int projectOffset, int* view, int viewOffset, JCOut JCFloat* obj, int objOffset);

JC_END

#endif /* defined(__jw__JCGLUtils__) */
