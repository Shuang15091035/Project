//
//  JCColor.h
//  June Winter
//
//  Created by GavinLo on 14-10-14.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCColor__
#define __jw__JCColor__

#include <jw/JCBase.h>

JC_BEGIN

typedef struct {
    
    float r;
    float g;
    float b;
    float a;
    
}JCColor;

typedef JCColor* JCColorRef;
typedef const JCColor* JCColorRefC;

JCColor JCColorBlack();
JCColor JCColorWhite();
JCColor JCColorRed();
JCColor JCColorGreen();
JCColor JCColorBlue();
JCColor JCColorYellow();
JCColor JCColorGray();
JCColor JCColorTransparent();
JCColor JCColorNull();

JCColor JCColorMake(float r, float g, float b, float a);
JCColor JCColorFromARGB(JCULong argb);
JCULong JCColorToARGB(JCColorRefC color);
void JCColorSetf(JCColorRef color, float r, float g, float b, float a);
JCColor JCColorMulScalar(JCColorRefC color, float scalar);
void JCColorBound(JCColorRef color);
JCColor JCColorInverse(JCColorRefC color);
bool JCColorEquals(JCColorRefC l, JCColorRefC r);

/**
 * 透明色视为null,即JCColorTransparent()
 */
bool JCColorIsNull(JCColorRefC color);
bool JCColorIsWhite(JCColorRefC color);

/**
 * 颜色是否存在透明（alpha值不为1或者不接近1）
 */
bool JCColorHasAlpha(JCColorRefC color);

void JCColorToArray(JCColor color, JCOut float* array);
void JCColorToRGBABytes(JCColorRefC color, JCOut JCByte* bytes);

JC_END

#endif /* defined(__jw__JCColor__) */
