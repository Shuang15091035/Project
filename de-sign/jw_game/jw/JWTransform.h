//
//  JWTransform.h
//  June Winter
//
//  Created by GavinLo on 14-4-12.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGamePredef.h>
#import <jw/JWComponent.h>
#import <jw/JCTransform.h>
#import <jw/NSMutableArray+JWArrayList.h>

typedef NS_ENUM(NSInteger, JWTransformSpace) {
    
    JWTransformSpaceWorld,
    JWTransformSpaceParent,
    JWTransformSpaceLocal,
    
};

@protocol JITransform <JIComponent>

#pragma mark 位移相关
@property (nonatomic, readwrite) JCVector3 position;
- (JCVector3) positionInSpace:(JWTransformSpace)space;
- (void) setPosition:(JCVector3)position inSpace:(JWTransformSpace)space;
- (void) translate:(JCVector3)dv inSpace:(JWTransformSpace)space;
- (void) translate:(JCVector3)dv;

#pragma mark 旋转相关
@property (nonatomic, readwrite) JCQuaternion orientation;
- (JCQuaternion) orientationInSpace:(JWTransformSpace)space;
- (void) setOrientation:(JCQuaternion)orientation inSpace:(JWTransformSpace)space;
- (void) setOrientationDegrees:(float)degrees byAxis:(JCVector3)axis inSpace:(JWTransformSpace)space;
- (void) setOrientationDegrees:(float)degrees byAxis:(JCVector3)axis;
- (void) rotate:(JCQuaternion)dq inSpace:(JWTransformSpace)space;
- (void) rotate:(JCQuaternion)dq;
- (void) rotateDegrees:(float)degrees byAxis:(JCVector3)axis inSpace:(JWTransformSpace)space;
- (void) rotateDegrees:(float)degrees byAxis:(JCVector3)axis;
#pragma mark 欧拉角相关
@property (nonatomic, readwrite) JCVector3 eulerAngles;
- (JCVector3) eulerAnglesInSpace:(JWTransformSpace)space;
- (void) setEulerAngles:(JCVector3)eulerAngles inSpace:(JWTransformSpace)space;
- (void) rollDegrees:(float)degrees inSpace:(JWTransformSpace)space;
- (void) rollDegrees:(float)degrees;
- (void) yawDegrees:(float)degrees inSpace:(JWTransformSpace)space;
- (void) yawDegrees:(float)degrees;
- (void) picthDegrees:(float)degrees inSpace:(JWTransformSpace)space;
- (void) picthDegrees:(float)degrees;
@property (nonatomic, readwrite) float rolling;
- (float) rollingInSpace:(JWTransformSpace)space;
- (void) setRolling:(float)rolling inSpace:(JWTransformSpace)space;
@property (nonatomic, readwrite) float yawing;
- (float) yawingInSpace:(JWTransformSpace)space;
- (void) setYawing:(float)yawing inSpace:(JWTransformSpace)space;
@property (nonatomic, readwrite) float pitching;
- (float) pitchingInSpace:(JWTransformSpace)space;
- (void) setPitching:(float)pitching inSpace:(JWTransformSpace)space;
#pragma mark 旋转轴相关
@property (nonatomic, readonly) JCAxes axes;
- (JCAxes) axesInSpace:(JWTransformSpace)space;
@property (nonatomic, readonly) JCVector3 xAxis;
- (JCVector3) xAxisInSpace:(JWTransformSpace)space;
@property (nonatomic, readonly) JCVector3 yAxis;
- (JCVector3) yAxisInSpace:(JWTransformSpace)space;
@property (nonatomic, readonly) JCVector3 zAxis;
- (JCVector3) zAxisInSpace:(JWTransformSpace)space;
#pragma mark 自定义轴旋转
@property (nonatomic, readwrite) JCVector3 upAxis;
- (void) rotateUpDegrees:(float)degrees inSpace:(JWTransformSpace)space;
- (void) rotateUpDegrees:(float)degrees;

#pragma mark 缩放相关
@property (nonatomic, readwrite) JCVector3 scale;
- (void) scaleBy:(JCVector3)ds;

#pragma mark 矩阵相关
@property (nonatomic, readwrite) JCMatrix4 matrix;

#pragma mark 父子关系相关
@property (nonatomic, readwrite) id<JITransform> parent;
@property (nonatomic, readonly) NSUInteger numChildren;
- (void) enumChildrenUsing:(void (^)(id<JITransform> child, NSUInteger idx, BOOL* stop))block;
#pragma mark 变换继承相关
@property (nonatomic, readwrite, getter=isInheritOrientation) BOOL inheritOrientation;
@property (nonatomic, readwrite, getter=isInheritScale) BOOL inheritScale;

#pragma mark 实用方法
- (void) update;
- (void) copyTransform:(id<JITransform>)transform inWorld:(BOOL)inWorld;
- (void) save:(BOOL)willAlsoSaveChildren;
- (void) restore:(BOOL)willAlsoRestoreChildren;
- (void) reset:(BOOL)willAlsoResetChildren;
- (void) resetOrientation:(BOOL)willAlsoResetChildren;

@end

@interface JWTransform : JWComponent <JITransform>

@property (nonatomic, readonly) JCTransformRef _transform;
- (void) _setTransform:(JCTransformRef)transform inWorld:(BOOL)inWorld;

@end
