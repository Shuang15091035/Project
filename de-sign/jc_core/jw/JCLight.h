//
//  JCLight.h
//  June Winter
//
//  Created by GavinLo on 15/1/10.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCLight__
#define __jw__JCLight__

#include <jw/JCBase.h>
#include <jw/JCColor.h>
#include <jw/JCVector3.h>

JC_BEGIN

typedef struct
{
    JCVector3 position;
    JCVector3 direction;
    JCColor diffuse;
    
}JCLight;

JCLight JCLightDefault();

typedef struct
{
    JCLight light;
    float cutoff;
    float exponent;
    
}JCSpotLight;

JCSpotLight JCSpotLightDefault();

typedef struct
{
    unsigned int spotLightCount;
    
}JCLightsFeatures;

JCLightsFeatures JCLightsFeaturesMake();

JC_END

#endif /* defined(__jw__JCLight__) */
