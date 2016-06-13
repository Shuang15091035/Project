//
//  JCMath.h
//  June Winter
//
//  Created by GavinLo on 14/10/28.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCMath__
#define __jw__JCMath__

#include <jw/JCBase.h>
#include <math.h>

JC_BEGIN

#define JCPi 3.1415926536f
#define JC2Pi 6.2831853072f
#define JCPi2 1.5707963268f
#define JCDeg2RadFactor 0.01745329251f
#define JCRad2DegFactor 57.2957795131f

#define JCEpsilon 0.00001f

#define JCMax(x, y) ((x) > (y) ? (x) : (y))
#define JCMin(x, y) ((x) < (y) ? (x) : (y))

float JCSinf(float radians);
//JCFloat JCSin(JCFloat radians);
float JCCosf(float radians);
//JCFloat JCCos(JCFloat radians);
float JCTanf(float radians);
float JCAsinf(float f);
float JCAcosf(float f);
float JCAtan2f(float dy, float dx);
float JCAbsf(float f);
float JCSqrtf(float f);
float JCInvSqrtf(float f);
float JCDeg2Rad(float degrees);
float JCRad2Deg(float radians);
bool JCEqualsfe(float a, float b, float e);
bool JCEqualsf(float a, float b);
float JCLerpf(float a, float b, float t);
float JCBoundf(float x, float min, float max);

float JCFloorf(float value);
float JCModf(float x, float y);

// 数字循环平铺，手尾相连，区间为[min,max)
int JCLoopi(int x, int min, int max);
float JCWrapf(float f, float min, float max);

unsigned char JCCompressWrapfb(float f, float min, float max);
unsigned short JCCompressWrapfus(float f, float min, float max);

bool JCIsPowerOf2(unsigned long x);
unsigned long JCNextPowerOf2(unsigned long x);
float JCNextPowerOf2f(float x);
unsigned long JC2N(unsigned long n);
unsigned long JCLog2(unsigned long x);
// 公比为2的等比数列从第m项到第n项的和，即2^m+2^(m+1)+...+2^n
unsigned long JC2NSum(unsigned long m, unsigned long n);

float JCManhattanDistance(float x0, float y0, float x1, float y1);

/**
 * f(x) = kx + b
 */
typedef struct {
    
    float k;
    float b;
    
}JCLinearFunction;

JCLinearFunction JCLinearFunctionMake(float k, float b);
float JCLinearFunctionFx(JCLinearFunction* func, float x);

void JCSetRandomGenerator(unsigned int seed);
float JCRandomf(float min, float max);

JC_END

#endif /* defined(__jw__JCMath__) */
