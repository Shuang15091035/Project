//
//  JCTree.h
//  June Winter
//
//  Created by ddeyes on 16/5/6.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCTree__
#define __jw__JCTree__

#include <jw/JCBase.h>

JC_BEGIN

JCULong JCTreeLeftLeafIndex(JCULong currentIndex);
JCULong JCTreeRightLeafIndex(JCULong currentIndex);
JCULong JCTreeParentIndex(JCULong currentIndex);

JC_END

#endif /* __jw__JCTree__ */
