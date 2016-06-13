//
//  JWARSystem.h
//  June Winter_game
//
//  Created by GavinLo on 15/3/5.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <jw/JWGamePredef.h>
#import <jw/JWObject.h>

typedef NS_ENUM(NSUInteger, JWARErrorCode) {
    JWARErrorCodeOk = 0,
    
    /**
     * 用户拒绝访问摄像头
     */
    JWARErrorCodeCameraAccessDenied,
    
    JWARErrorCodeInitCamera,
    JWARErrorCodeDeinitCamera,
    JWARErrorCodeStartCamera,
    JWARErrorCodeStopCamera,
    
    JWARErrorCodeCustom,
};

@protocol JIARConfig <NSObject>

@property (nonatomic, readwrite) UIInterfaceOrientation cameraOrientation;

@end

@protocol JIOnARSystemListener <NSObject>

- (void) onARInitDone;
- (void) onARCameraActive;
- (void) onARCameraDeactive;
- (void) onARResume;
- (void) onARPaused;
- (void) onARError:(NSError*)error;

@end

@protocol JIARSystem <JIObject>

@property (nonatomic, readwrite) id<JIGameEngine> engine;

/**
 * AR配置，可用于初始化和动态改变AR中的某些设置
 */
@property (nonatomic, readonly) id<JIARConfig> config;

/**
 * AR初始化，会使用到config当中的某些参数
 */
- (void) initAR;

/**
 * AR准备，一般在初始化后直接进入准备状态，不建议手动调用
 */
- (void) prepareAR;

/**
 * AR启动，启动AR功能，如摄像头和目标识别等等。在AR准备完毕后会调用一次，可手动调用
 */
- (void) startAR;

/**
 * AR恢复，用于app从后台切换回来时恢复AR功能
 */
- (void) resumeAR;

/**
 * AR暂停，用于app切换到后台时停止AR功能
 */
- (void) pauseAR;

/**
 * AR停止，完全停止AR所有功能，一般在app退出时调用已释放资源
 */
- (void) stopAR;

@property (nonatomic, readonly) id<JIARImageTracker> imageTracker;
@property (nonatomic, readwrite) id<JIOnARSystemListener> listener;

+ (NSString*) errorDomain;

@end

@interface JWARSystem : JWObject <JIARSystem> {
    id<JIARConfig> mConfig;
    id<JIGameEngine> mEngine;
    id<JIARImageTracker> mImageTracker;
    id<JIOnARSystemListener> mListener;
}

- (id) initWithEngine:(id<JIGameEngine>)engine;

@end
