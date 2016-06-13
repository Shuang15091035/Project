//
//  JCInertialNavigationSystem.h
//  June Winter
//
//  Created by GavinLo on 15/3/26.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCInertialNavigationSystem__
#define __jw__JCInertialNavigationSystem__

#include <jw/JCBase.h>
#include <jw/JCVector3.h>
#include <jw/JCMatrix3.h>
#include <jw/JCQuaternion.h>

JC_BEGIN

typedef enum {
    
    JCInertialNavigationSystemStateInit = 0, // 初始状态
    JCInertialNavigationSystemStateCalibrating, // 校对状态
    JCInertialNavigationSystemStateStartTracking, // 开始跟踪状态
    JCInertialNavigationSystemStateTracking, // 跟踪状态
    
}JCInertialNavigationSystemState;

typedef struct {
    
    JCInertialNavigationSystemState state;
    JCFloat time;
    JCVector3 acceleration;
    JCVector3 velocity;
    JCVector3 position;
    JCQuaternion orientation;
    
}JCInertialNavigationSystemResult;

JCInertialNavigationSystemResult JCInertialNavigationSystemResultMake();
void JCInertialNavigationSystemResultReset(JCInertialNavigationSystemResult* insr);

typedef struct {
    
    JCFloat calibrateTime; // 设定的校对时间（单位：秒）
    JCVector3 accelerationEpsilon; // 加速度感应器常量漂移（单位：m/s^2）
    JCFloat trackingStartTime; // 跟踪开始的时间（单位：秒）
    JCInertialNavigationSystemResult result;
    
// private
    JCFloat _calibrateStartTime; // 开始校对的时间戳（单位：秒）
    unsigned long _calibrateSamples; // 校对的总样本数
    JCFloat _lastTime; // 上一次更新的时间（单位：秒）
    JCVector3 _lastAcceleration; // 上一次更新时候的加速度（单位：m/s^2）
    JCVector3 _lastVelocity; //
    JCMatrix3 _lastC;
    JCVector3 _trackingPosition; // 跟踪位移（单位：m）
    
}JCInertialNavigationSystem;

typedef JCInertialNavigationSystem* JCInertialNavigationSystemRef;
typedef const JCInertialNavigationSystem* JCInertialNavigationSystemRefC;

JCInertialNavigationSystem JCInertialNavigationSystemMake();
void JCInertialNavigationSystemStartCalibrating(JCInertialNavigationSystemRef ins, JCFloat calibrateTime);
void JCInertialNavigationSystemStartTracking(JCInertialNavigationSystemRef ins, JCFloat startTime);
//void JCInertialNavigationSystemUpdate(JCInertialNavigationSystemRef ins, JCFloat time, JCVector3 acceleration, JCQuaternion orientation);
void JCInertialNavigationSystemUpdate(JCInertialNavigationSystemRef ins, JCFloat time, JCVector3 linearAcceleration, JCVector3 rotationRate);
JCInertialNavigationSystemResult JCInertialNavigationSystemGetResult(JCInertialNavigationSystemRefC ins);

JC_END

#endif /* defined(__jw__JCInertialNavigationSystem__) */
