//
//  JCObfuscate.h
//  June Winter
//
//  Created by ddeyes on 15/11/27.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCObfuscate__
#define __jw__JCObfuscate__

#include <jw/JCBase.h>
#include <jw/JCVector2.h>
#include <jw/JCVector3.h>
#include <jw/JCVector4.h>
#include <jw/JCQuaternion.h>

JC_BEGIN

JCVector2 JCVector2Encode(JCVector2 v);
JCVector2 JCVector2Decode(JCVector2 v);
JCVector3 JCVector3Encode(JCVector3 v);
JCVector3 JCVector3Decode(JCVector3 v);
JCVector4 JCVector4Encode(JCVector4 v);
JCVector4 JCVector4Decode(JCVector4 v);
JCQuaternion JCQuaternionEncode(JCQuaternion q);
JCQuaternion JCQuaternionDecode(JCQuaternion q);

JC_END

#endif /* defined(__jw__JCObfuscate__) */
