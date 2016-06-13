//
//  JCBase.h
//  June Winter
//
//  Created by GavinLo on 14-3-29.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef jw_JCBase_h
#define jw_JCBase_h

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>

#include <stdbool.h>
#include <float.h>

#if !defined(JC_EXTERN)
#  if defined(__cplusplus)
#   define JC_EXTERN extern "C"
#  else
#   define JC_EXTERN extern
#  endif
#endif /* !defined(JC_EXTERN) */

#if !defined(JC_BEGIN)
#  if defined(__cplusplus)
#   define JC_BEGIN extern "C" {
#  else
#   define JC_BEGIN
#  endif
#endif /* !defined(JC_BEGIN) */
#if !defined(JC_END)
#  if defined(__cplusplus)
#   define JC_END }
#  else
#   define JC_END
#  endif
#endif /* !defined(JC_END) */

#if !defined(JC_INLINE)
# if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 199901L
#  define JC_INLINE static inline
# elif defined(__cplusplus)
#  define JC_INLINE static inline
# elif defined(__GNUC__)
#  define JC_INLINE static __inline__
# else
#  define JC_INLINE static
# endif
#endif

//#if !defined(JC_FLOAT_TYPE)
//# if defined(__LP64__) && __LP64__
//#  define JC_FLOAT_TYPE double
//#  define JC_USE_DOUBLE 1
//# else
//#  define JC_FLOAT_TYPE float
//#  define JC_USE_DOUBLE 0
//# endif
//#endif /* !defined(JC_FLOAT_TYPE) */
//typedef JC_FLOAT_TYPE JCFloat;
typedef float JCFloat; // 暂不适用double

#define JCTrue true
#define JCFalse false
#define JCYes true
#define JCNo false
typedef bool JCBool;

typedef unsigned char JCByte;
typedef char JCInt8;
typedef unsigned char JCUInt8;
typedef short JCShort;
typedef unsigned short JCUShort;
typedef int JCInt;
typedef unsigned int JCUInt;
typedef long JCLong;
typedef unsigned long JCULong;
typedef void* JCObjectRef;
typedef const void* JCObjectRefC;
typedef char* JCStringRef;
typedef const char* JCStringRefC;

#define JCByteMax UCHAR_MAX
#define JCUShortMax USHRT_MAX
#define JCULongMax ULONG_MAX

typedef enum {
    
    JCBits = 8,
    
    JCShortBytes = sizeof(JCShort),
    JCUShortBytes = sizeof(JCUShort),
    JCIntBytes = sizeof(JCInt),
    JCUIntBytes = sizeof(JCUInt),
    JCLongBytes = sizeof(JCLong),
    JCULongBytes = sizeof(JCULong),
    JCFloatBytes = sizeof(float),
    JCDoubleBytes = sizeof(double),
    JCByteBytes = sizeof(JCByte),
    
    JCShortBits = sizeof(JCShort) * JCBits,
    JCUShortBits = sizeof(JCUShort) * JCBits,
    JCIntBits = sizeof(JCInt) * JCBits,
    JCUIntBits = sizeof(JCUInt) * JCBits,
    JCLongBits = sizeof(JCLong) * JCBits,
    JCULongBits = sizeof(JCULong) * JCBits,
    JCFloatBits = sizeof(float) * JCBits,
    JCDoubleBits = sizeof(double) * JCBits,
    JCByteBits = sizeof(JCByte) * JCBits,
    
    JCKilobytes = 1024,
    JCMegabytes = 1024 * 1024,
    JCGigabytes = 1024 * 1024 * 1024,
    
}JCTypeConstants;

#define JCOut

#if !defined(JCString)
#define JCString(name, size) char name[size]
#endif

// 定义多行字符串（支持宏展）
#if !defined(JCStringify)
#define _JCStringify(_x) # _x
#define JCStringify(_x) _JCStringify(_x)
#endif

// 定义多行字符串（不支持宏展）
#if !defined(JCQuote)
#define JCQuote(...) #__VA_ARGS__
#endif

#if !defined(JCN2)
#define JCN2(a) \n a \n
#endif
#if !defined(JCDefine)
#define JCDefine(a) \n a \n
#endif
#if !defined(JCIf)
#define JCIf(a) \n a \n
#endif
#if !defined(JCElse)
#define JCElse(a) \n a \n
#endif
#if !defined(JCEndIf)
#define JCEndIf(a) \n a \n
#endif

#if !defined(l____l)
#define l____l
#endif
#if !defined(l________l)
#define l________l
#endif
#if !defined(l____________l)
#define l____________l
#endif

#endif
