//
//  JCAnimation.h
//  June Winter
//
//  Created by GavinLo on 14/12/17.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCAnimation__
#define __jw__JCAnimation__

#include <jw/JCBase.h>
#include <jw/JCArray.h>
#include <jw/JCTransform.h>

JC_BEGIN

typedef enum {
    
    JCAnimationFrameInvalidTimePosition = JCULongMax,
    
}JCAnimationFrameConstants;

typedef enum {
    
    JCAnimationTrackMaxFrames = 128,
    
}JCAnimationTrackConstants;

typedef enum {
    
    JCAnimationTypeUnknown = 0,
    JCAnimationTypeTranslate = 0x1 << 0,
    JCAnimationTypeRotate = 0x1 << 1,
    JCAnimationTypeScale = 0x1 << 2,
    JCAnimationTypeTransform = 0x1 << 3, //JCAnimationTypeTranslate | JCAnimationTypeRotate | JCAnimationTypeScale,
    JCAnimationTypeEulerAngles = 0x1 << 4,
    
}JCAnimationType;

typedef enum {
    
    JCAnimationInterpolationFuncLinear = 0,
    
}JCAnimationInterpolationFunc;

typedef struct {
    
    JCULong timePosition;
    JCTransform transform;
    JCVector3 eulerAngles;
    
}JCAnimationFrame;

typedef JCAnimationFrame* JCAnimationFrameRef;
typedef const JCAnimationFrame* JCAnimationFrameRefC;

JCAnimationFrame JCAnimationFrameNull();
JCAnimationFrame JCAnimationFrameMake(JCULong timePosition);
bool JCAnimationFrameIsInvalid(JCAnimationFrameRefC frame);

typedef struct {
    
    JCAnimationType type;
    JCULong duration;
    bool isLoop;
    JCAnimationInterpolationFunc interpolationFunc;
    JCULong numFrames;
    JCAnimationFrame frames[JCAnimationTrackMaxFrames];
    
}JCAnimationTrack;

typedef JCAnimationTrack* JCAnimationTrackRef;
typedef const JCAnimationTrack* JCAnimationTrackRefC;

JCAnimationTrack JCAnimationTrackMake(JCAnimationType type, JCULong duration, bool isLoop);
JCAnimationFrameRef JCAnimationTrackAddKeyFrame(JCAnimationTrackRef track, JCAnimationFrame frame);
JCULong JCAnimationTrackGetNumKeyFrames(JCAnimationTrackRefC track);
JCAnimationFrameRef JCAnimationTrackKeyFrameAtIndexRef(JCAnimationTrackRef track, JCULong index);
JCAnimationFrame JCAnimationTrackKeyFrameAtIndex(JCAnimationTrackRefC track, JCULong index);
JCAnimationFrame JCAnimationTrackGetInterpolationFrame(JCAnimationTrackRefC track, JCLong timePosition);

void JCAnimationTrackDeepCopy(JCAnimationTrackRef dst, JCAnimationTrackRefC src);
void JCAnimationTrackUpdate(JCAnimationTrackRef track);

JC_END

#endif /* defined(__jw__JCAnimation__) */
