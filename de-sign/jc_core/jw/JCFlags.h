//
//  JCFlags.h
//  June Winter
//
//  Created by GavinLo on 14/11/22.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCFlags__
#define __jw__JCFlags__

#include <jw/JCBase.h>

typedef unsigned long JCFlag;

JC_BEGIN

JC_INLINE JCFlag JCFlagsAdd(JCFlag flag, JCFlag add)
{
    return flag | add;
}

JC_INLINE JCFlag JCFlagsRemove(JCFlag flag, JCFlag remove)
{
    return flag & (~remove);
}

JC_INLINE JCFlag JCFlagsSet(JCFlag flag, int offset, bool value)
{
    const int op = 0x1 << offset;
    if(value)
        return JCFlagsAdd(flag, op);
    else
        return JCFlagsRemove(flag, op);
}

JC_INLINE bool JCFlagsTest(JCFlag flag, JCFlag test)
{
    return (flag & test) != 0;
}

JC_INLINE bool JCFlagsIsSet(JCFlag flag, int offset)
{
    JCFlag test = 0x1 << offset;
    return (flag & test) != 0;
}

JC_END

#endif /* defined(__jw__JCFlags__) */
