//
//  JCCamera.h
//  June Winter
//
//  Created by ddeyes on 16/1/10.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCCamera__
#define __jw__JCCamera__

#include <jw/JCBase.h>
#include <jw/JCVector3.h>

JC_BEGIN

typedef struct {
    
    JCVector3 position;
    
}JCCamera;

typedef JCCamera* JCCameraRef;
typedef const JCCamera* JCCameraRefC;

JCCamera JCCameraMake();

JC_END

#endif /* defined(__jw__JCCamera__) */
