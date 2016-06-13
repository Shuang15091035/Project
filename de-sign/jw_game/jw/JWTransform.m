//
//  JWTransform.m
//  June Winter
//
//  Created by GavinLo on 14-4-12.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWTransform.h"
#import "JWGameObject.h"
#import "JCMath.h"
#import "JWList.h"
#import <jw/JWNode.h>

@interface JWTransformNode : JWNode {
    JWTransform* mTransform;
}

+ (id) nodeWithTransform:(JWTransform*)transform;
- (id) initWithTransform:(JWTransform*)transform;
@property (nonatomic, readonly) JWTransform* transform;

@end

@implementation JWTransformNode

+ (id)nodeWithTransform:(JWTransform *)transform {
    return [[self alloc] initWithTransform:transform];
}

- (id)initWithTransform:(JWTransform *)transform {
    self = [super init];
    if (self != nil) {
        mTransform = transform;
    }
    return self;
}

@synthesize transform = mTransform;

@end

@interface JWTransform () {
//    id<JITransform> mParent;
//    id<JIUList> mChildren;
    id<JINode> mTransformNode;
    JCTransform _transform;
    JCVector3 mUpAxis;
    JCTransform mSaveTransform;
}

//@property (nonatomic, readonly) id<JIUList> childrenList;
@property (nonatomic, readonly) JWTransformNode* transformNode;
@property (nonatomic, readwrite, getter=isDirty) BOOL dirty;

@end

@implementation JWTransform

- (void)onCreate {
    [super onCreate];
    mTransformNode = [JWTransformNode nodeWithTransform:self];
    _transform = JCTransformMake();
    mUpAxis = JCVector3UnitY();
    mSaveTransform = JCTransformMake();
}

- (void)onDestroy {
    self.parent = nil;
    
    // 不调用是因为transform是个特殊的组件,不在host的组件列表中
    //[super onDestroy];
}

- (JWTransformNode *)transformNode {
    return mTransformNode;
}

#pragma mark 位移相关
- (JCVector3)position {
    return [self positionInSpace:JWTransformSpaceParent];
}

- (void)setPosition:(JCVector3)position {
    [self setPosition:position inSpace:JWTransformSpaceParent];
}

- (JCVector3)positionInSpace:(JWTransformSpace)space {
    switch (space) {
        case JWTransformSpaceWorld: {
            JCTransformUpdate(&_transform);
            return _transform.derivedPosition;
        }
        case JWTransformSpaceParent: {
            return _transform.position;
        }
        case JWTransformSpaceLocal: {
            return JCVector3Zero();
        }
    }
    return JCVector3Zero();
}

- (void)setPosition:(JCVector3)position inSpace:(JWTransformSpace)space {
    JCTransformUpdateParent(&_transform);
    switch(space) {
        case JWTransformSpaceWorld: {
            JCTransformSetPositionRelativeToParent(&_transform, JCTransformConvertPositionWorldToParent(&_transform, position));
            break;
        }
        case JWTransformSpaceParent: {
            JCTransformSetPositionRelativeToParent(&_transform, position);
            break;
        }
        case JWTransformSpaceLocal: {
            // TODO
            break;
        }
    }
    self.dirty = YES;
}

- (void)translate:(JCVector3)dv inSpace:(JWTransformSpace)space {
    JCTransformUpdateParent(&_transform);
    switch(space) {
        case JWTransformSpaceWorld: {
            JCTransformTranslateRelativeToParent(&_transform, JCTransformConvertTranslationWorldToParent(&_transform, dv));
            break;
        }
        case JWTransformSpaceParent: {
            JCTransformTranslateRelativeToParent(&_transform, dv);
            break;
        }
        case JWTransformSpaceLocal: {
            JCTransformTranslateRelativeToParent(&_transform, JCTransformConvertTranslationLocalToParent(&_transform, dv));
            break;
        }
    }
    self.dirty = YES;
}

- (void)translate:(JCVector3)dv {
    [self translate:dv inSpace:JWTransformSpaceParent];
}

#pragma mark 旋转相关
- (JCQuaternion)orientation {
    return [self orientationInSpace:JWTransformSpaceLocal];
}

- (void)setOrientation:(JCQuaternion)orientation {
    [self setOrientation:orientation inSpace:JWTransformSpaceLocal];
}

- (JCQuaternion)orientationInSpace:(JWTransformSpace)space {
    switch (space) {
        case JWTransformSpaceWorld:
        case JWTransformSpaceParent: {
            JCTransformUpdate(&_transform);
            return _transform.derivedOrientation;
        }
        case JWTransformSpaceLocal: {
            return _transform.orientation;
        }
    }
}

- (void)setOrientation:(JCQuaternion)orientation inSpace:(JWTransformSpace)space {
//    JCQuaternion qnorm;
//    JCQuaternionSetq(&qnorm, &q);
//    qnorm = JCQuaternionNormalize(&qnorm);
    
    switch(space) {
        case JWTransformSpaceWorld:
        case JWTransformSpaceParent: {
            JCTransformSetOrientationRelativeToLocal(&_transform, JCTransformConvertOrientationWorldToLocal(&_transform, orientation));
            break;
        }
        case JWTransformSpaceLocal: {
            JCTransformSetOrientationRelativeToLocal(&_transform, orientation);
            break;
        }
    }
    self.dirty = YES;
}

- (void)rotate:(JCQuaternion)dq inSpace:(JWTransformSpace)space {
//    JCQuaternion qnorm;
//    JCQuaternionSetq(&qnorm, &dq);
//    qnorm = JCQuaternionNormalize(&qnorm);
    switch(space) {
        case JWTransformSpaceWorld:
        case JWTransformSpaceParent: {
            JCTransformRotateRelativeToLocal(&_transform, JCTransformConvertOrientationWorldToLocal(&_transform, dq));
            break;
        }
        case JWTransformSpaceLocal: {
            JCTransformRotateRelativeToLocal(&_transform, dq);
            break;
        }
    }
    self.dirty = YES;
}

- (void)rotate:(JCQuaternion)dq {
    [self rotate:dq inSpace:JWTransformSpaceLocal];
}

- (void)rotateDegrees:(float)degrees byAxis:(JCVector3)axis inSpace:(JWTransformSpace)space {
    const float radians = JCDeg2Rad(degrees);
    JCQuaternion dq = JCQuaternionFromAngleAxis(radians, axis);
    [self rotate:dq inSpace:space];
}

- (void)rotateDegrees:(float)degrees byAxis:(JCVector3)axis {
    return [self rotateDegrees:degrees byAxis:axis inSpace:JWTransformSpaceLocal];
}

- (void)setOrientationDegrees:(float)degrees byAxis:(JCVector3)axis inSpace:(JWTransformSpace)space {
    const float radians = JCDeg2Rad(degrees);
    JCQuaternion q = JCQuaternionFromAngleAxis(radians, axis);
    [self setOrientation:q inSpace:space];
}

- (void)setOrientationDegrees:(float)degrees byAxis:(JCVector3)axis {
    [self setOrientationDegrees:degrees byAxis:axis inSpace:JWTransformSpaceLocal];
}

#pragma mark 欧拉角相关
- (JCVector3)eulerAngles {
    return [self eulerAnglesInSpace:JWTransformSpaceLocal];
}

- (void)setEulerAngles:(JCVector3)eulerAngles {
    [self setEulerAngles:eulerAngles inSpace:JWTransformSpaceLocal];
}

- (JCVector3)eulerAnglesInSpace:(JWTransformSpace)space {
    switch (space) {
        case JWTransformSpaceWorld:
        case JWTransformSpaceParent: {
            JCTransformUpdate(&_transform);
            return JCQuaternionToEulerAngles(&_transform.derivedOrientation, true);
        }
        case JWTransformSpaceLocal: {
            return JCQuaternionToEulerAngles(&_transform.orientation, true);
        }
    }
}

- (void)setEulerAngles:(JCVector3)eulerAngles inSpace:(JWTransformSpace)space {
    JCQuaternion nq = JCQuaternionFromEulerAngles(eulerAngles);
    [self setOrientation:nq inSpace:space];
}

- (void)rollDegrees:(float)degrees inSpace:(JWTransformSpace)space {
    [self rotateDegrees:degrees byAxis:JCVector3UnitZ() inSpace:space];
}

- (void)rollDegrees:(float)degrees {
    [self rollDegrees:degrees inSpace:JWTransformSpaceLocal];
}

- (void)yawDegrees:(float)degrees inSpace:(JWTransformSpace)space {
    [self rotateDegrees:degrees byAxis:JCVector3UnitY() inSpace:space];
}

- (void)yawDegrees:(float)degrees {
    [self yawDegrees:degrees inSpace:JWTransformSpaceLocal];
}

- (void)picthDegrees:(float)degrees inSpace:(JWTransformSpace)space {
    [self rotateDegrees:degrees byAxis:JCVector3UnitX() inSpace:space];
}

- (void)picthDegrees:(float)degrees {
    [self picthDegrees:degrees inSpace:JWTransformSpaceLocal];
}

- (float)rolling {
    return [self rollingInSpace:JWTransformSpaceLocal];
}

- (void)setRolling:(float)rolling {
    [self setRolling:rolling inSpace:JWTransformSpaceLocal];
}

- (float)rollingInSpace:(JWTransformSpace)space {
    switch(space) {
        case JWTransformSpaceWorld:
        case JWTransformSpaceParent: {
            JCTransformUpdate(&_transform);
            return JCRad2Deg(JCQuaternionGetRoll(&_transform.derivedOrientation, true));
        }
        case JWTransformSpaceLocal: {
            return JCRad2Deg(JCQuaternionGetRoll(&_transform.orientation, true));
        }
    }
    return 0.0f;
}

- (void)setRolling:(float)rolling inSpace:(JWTransformSpace)space {
    // TODO 先这样实现
    float yaw = self.yawing;
    float pitch = self.pitching;
    [self resetOrientation:NO];
    [self rollDegrees:rolling inSpace:space];
    [self yawDegrees:yaw];
    [self picthDegrees:pitch];
}

- (float)yawing {
    return [self yawingInSpace:JWTransformSpaceLocal];
}

- (void)setYawing:(float)yawing {
    [self setYawing:yawing inSpace:JWTransformSpaceLocal];
}

- (float)yawingInSpace:(JWTransformSpace)space {
    switch(space) {
        case JWTransformSpaceWorld:
        case JWTransformSpaceParent: {
            JCTransformUpdate(&_transform);
            return JCRad2Deg(JCQuaternionGetYaw(&_transform.derivedOrientation, true));
        }
        case JWTransformSpaceLocal: {
            return JCRad2Deg(JCQuaternionGetYaw(&_transform.orientation, true));
        }
    }
    return 0.0f;
}

- (void)setYawing:(float)yawing inSpace:(JWTransformSpace)space {
    // TODO 先这样实现
    float roll = self.rolling;
    float pitch = self.pitching;
    [self resetOrientation:NO];
    [self rollDegrees:roll];
    [self yawDegrees:yawing inSpace:space];
    [self picthDegrees:pitch];
}

- (float)pitching {
    return [self pitchingInSpace:JWTransformSpaceLocal];
}

- (void)setPitching:(float)pitching {
    [self setPitching:pitching inSpace:JWTransformSpaceLocal];
}

- (float)pitchingInSpace:(JWTransformSpace)space {
    switch(space) {
        case JWTransformSpaceWorld:
        case JWTransformSpaceParent: {
            JCTransformUpdate(&_transform);
            return JCRad2Deg(JCQuaternionGetPitch(&_transform.derivedOrientation, true));
        }
        case JWTransformSpaceLocal: {
            return JCRad2Deg(JCQuaternionGetPitch(&_transform.orientation, true));
        }
    }
    return 0.0f;
}

- (void)setPitching:(float)pitching inSpace:(JWTransformSpace)space {
    // TODO 先这样实现
    float roll = self.rolling;
    float yaw = self.yawing;
    [self resetOrientation:NO];
    [self rollDegrees:roll];
    [self yawDegrees:yaw];
    [self picthDegrees:pitching inSpace:space];
}

#pragma mark 旋转轴相关
- (JCVector3)axisAt:(int)index inSpace:(JWTransformSpace)space {
    JCQuaternion q = [self orientationInSpace:space];
    JCVector3 xAxis;
    JCVector3 yAxis;
    JCVector3 zAxis;
    JCQuaternionToAxes(&q, &xAxis, &yAxis, &zAxis);
    switch(index)
    {
        case 0:
            return xAxis;
        case 1:
            return yAxis;
        case 2:
            return zAxis;
    }
    return JCVector3Zero();
}

- (JCAxes)axes {
    return [self axesInSpace:JWTransformSpaceLocal];
}

- (JCAxes)axesInSpace:(JWTransformSpace)space {
    JCQuaternion q = [self orientationInSpace:space];
    return JCQuaternionGetAxes(&q);
}

- (JCVector3)xAxis {
    return [self axisAt:0 inSpace:JWTransformSpaceLocal];
}

- (JCVector3)xAxisInSpace:(JWTransformSpace)space {
    return [self axisAt:0 inSpace:space];
}

- (JCVector3)yAxis {
    return [self axisAt:1 inSpace:JWTransformSpaceLocal];
}

- (JCVector3)yAxisInSpace:(JWTransformSpace)space {
    return [self axisAt:1 inSpace:space];
}

- (JCVector3)zAxis {
    return [self axisAt:2 inSpace:JWTransformSpaceLocal];
}

- (JCVector3)zAxisInSpace:(JWTransformSpace)space {
    return [self axisAt:2 inSpace:space];
}

#pragma mark 自定义轴旋转
@synthesize upAxis = mUpAxis;

- (void)rotateUpDegrees:(float)degrees inSpace:(JWTransformSpace)space {
    [self rotateDegrees:degrees byAxis:mUpAxis inSpace:space];
}

- (void)rotateUpDegrees:(float)degrees {
    [self rotateUpDegrees:degrees inSpace:JWTransformSpaceLocal];
}

- (JCVector3)scale {
    return _transform.scale;
}

- (void)setScale:(JCVector3)scale {
    JCTransformSetScale(&_transform, scale);
    self.dirty = YES;
}

- (void)scaleBy:(JCVector3)ds {
    JCVector3 s = JCVector3Mulv(&_transform.scale, &ds);
    JCTransformSetScale(&_transform, s);
    self.dirty = YES;
}

#pragma mark 矩阵相关
- (JCMatrix4)matrix {
    JCTransformUpdate(&_transform);
    return _transform.matrix;
}

- (void)setMatrix:(JCMatrix4)matrix {
    JCMatrix4ToTransform(&matrix, &_transform.position, &_transform.orientation, &_transform.scale);
    self.dirty = YES;
}

//- (id<JITransform>)parent
//{
//    return mParent;
//}
//
//- (void)setParent:(id<JITransform>)parent
//{
//    if(mParent == self || parent == mParent)
//        return;
//    
//    JWTransform* par = self.parent;
//    if(par != nil)
//        [par.childrenList removeObject:self];
//    
//    mParent = parent;
//    par = mParent;
//    JCTransformSetParent(&_transform, par != nil ? par._transform : NULL);
//    
//    if(par != nil)
//        [par.childrenList addObject:self];
//}
//
//- (id<JIUList>)children {
//    return self.childrenList;
//}
//
//- (id<JIUList>)childrenList {
//    if (mChildren == nil) {
//        mChildren = [JWSafeUList list];
//    }
//    return mChildren;
//}

#pragma mark 父子关系相关
- (id<JITransform>)parent {
    JWTransformNode* parent = (JWTransformNode*)mTransformNode.parent;
    if (parent == nil) {
        return nil;
    }
    return parent.transform;
}

- (void)setParent:(id<JITransform>)parent {
    JWTransform* par = (JWTransform*)parent;
    mTransformNode.parent = par.transformNode;
    JCTransformSetParent(&_transform, par != nil ? par._transform : NULL);
}

- (NSUInteger)numChildren {
    return mTransformNode.numChildren;
}

- (void)enumChildrenUsing:(void (^)(id<JITransform>, NSUInteger, BOOL *))block {
    [mTransformNode enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        JWTransformNode* childNode = obj;
        id<JITransform> child = childNode.transform;
        block(child, idx, stop);
    }];
}

#pragma mark 变换继承相关
- (BOOL)isInheritOrientation {
    return _transform.inheritOrientation ? YES : NO;
}

- (void)setInheritOrientation:(BOOL)inheritOrientation {
    _transform.inheritOrientation = inheritOrientation ? true : false;
}

- (BOOL)isInheritScale {
    return _transform.inheritScale ? YES : NO;
}

- (void)setInheritScale:(BOOL)inheritScale {
    _transform.inheritScale = inheritScale ? true : false;
}

#pragma mark 实用方法
- (void)update {
    JCTransformUpdate(&_transform);
}

- (void)copyTransform:(id<JITransform>)transform inWorld:(BOOL)inWorld {
    if (transform == nil) {
        return;
    }
    JWTransform* t = transform;
    [self _setTransform:t._transform inWorld:inWorld];
    //self.parent = t.parent; // NOTE 不复制parent
    self.dirty = YES;
}

//- (void)save:(BOOL)willAlsoSaveChildren {
//    JCTransformSetTransform(&mSaveTransform, &_transform, false);
//    if (!willAlsoSaveChildren) {
//        return;
//    }
//    if (mChildren != nil) {
//        [mChildren enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
//            JWTransform* child = obj;
//            [child save:willAlsoSaveChildren];
//        }];
//    }
//}
//
//- (void)restore:(BOOL)willAlsoRestoreChildren {
//    JCTransformSetTransform(&_transform, &mSaveTransform, false);
//    if (!willAlsoRestoreChildren) {
//        self.dirty = YES;
//        return;
//    }
//    if (mChildren != nil) {
//        [mChildren enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
//            JWTransform* child = obj;
//            [child restore:willAlsoRestoreChildren];
//        }];
//    }
//    self.dirty = YES;
//}
//
//- (void)reset:(BOOL)willAlsoResetChildren {
//    JCTransformResetTransform(&_transform);
//    if (!willAlsoResetChildren) {
//        self.dirty = YES;
//        return;
//    }
//    if (mChildren != nil) {
//        [mChildren enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
//            JWTransform* child = obj;
//            [child reset:willAlsoResetChildren];
//        }];
//    }
//    self.dirty = YES;
//}
//
//- (void)resetOrientation:(BOOL)willAlsoResetChildren {
//    JCTransformResetOrientation(&_transform);
//    if (!willAlsoResetChildren) {
//        self.dirty = YES;
//        return;
//    }
//    if (mChildren != nil) {
//        [mChildren enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
//            JWTransform* child = obj;
//            [child resetOrientation:willAlsoResetChildren];
//        }];
//    }
//    self.dirty = YES;
//}

- (void)save:(BOOL)willAlsoSaveChildren {
    JCTransformSetTransform(&mSaveTransform, &_transform, false);
    if (!willAlsoSaveChildren) {
        return;
    }
    if (mTransformNode.firstChild != nil) {
        [mTransformNode enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
            JWTransformNode* childNode = obj;
            id<JITransform> child = childNode.transform;
            [child save:willAlsoSaveChildren];
        }];
    }
}

- (void)restore:(BOOL)willAlsoRestoreChildren {
    JCTransformSetTransform(&_transform, &mSaveTransform, false);
    if (!willAlsoRestoreChildren) {
        self.dirty = YES;
        return;
    }
    if (mTransformNode.firstChild != nil) {
        [mTransformNode enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
            JWTransformNode* childNode = obj;
            id<JITransform> child = childNode.transform;
            [child restore:willAlsoRestoreChildren];
        }];
    }
    self.dirty = YES;
}

- (void)reset:(BOOL)willAlsoResetChildren {
    JCTransformResetTransform(&_transform);
    if (!willAlsoResetChildren) {
        self.dirty = YES;
        return;
    }
    if (mTransformNode.firstChild != nil) {
        [mTransformNode enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
            JWTransformNode* childNode = obj;
            id<JITransform> child = childNode.transform;
            [child reset:willAlsoResetChildren];
        }];
    }
    self.dirty = YES;
}

- (void)resetOrientation:(BOOL)willAlsoResetChildren {
    JCTransformResetOrientation(&_transform);
    if (!willAlsoResetChildren) {
        self.dirty = YES;
        return;
    }
    if (mTransformNode.firstChild != nil) {
        [mTransformNode enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
            JWTransformNode* childNode = obj;
            id<JITransform> child = childNode.transform;
            [child resetOrientation:willAlsoResetChildren];
        }];
    }
    self.dirty = YES;
}

- (BOOL)isDirty
{
    return _transform.isDirty ? YES : NO;
}

- (void)setDirty:(BOOL)dirty {
    JCTransformSetDirty(&_transform, dirty ? true : false);
    if (mHost != nil) {
        // transform会影响transformBounds
        [mHost updateBounds:NO];
        if (dirty) {
            JWGameObject* host = mHost;
            [host onTransformChanged:self];
        }
    }
    [self setChildrenDirty:dirty];
}

//- (void) setChildrenDirty:(BOOL)dirty {
//    if (mChildren == nil) {
//        return;
//    }
//    [mChildren enumUsing:^(id obj, NSUInteger idx, BOOL *stop) {
//        JWTransform* child = obj;
//        child.dirty = dirty;
//    }];
//}

- (void) setChildrenDirty:(BOOL)dirty {
    if (mTransformNode.firstChild != nil) {
        [mTransformNode enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
            JWTransformNode* childNode = obj;
            JWTransform* child = childNode.transform;
            child.dirty = dirty;
        }];
    }
}

- (id<JIComponent>)copyInstance {
    JWTransform* transform = [[JWTransform alloc] initWithContext:mContext];
    [self copyTransform:transform inWorld:YES];
    return transform;
}

- (JCTransformRef)_transform
{
    return &_transform;
}

- (void)_setTransform:(JCTransform *)transform inWorld:(BOOL)inWorld
{
    JCTransformSetTransform(&_transform, transform, inWorld ? true : false);
    self.dirty = YES;
}

- (NSString *)description {
    [self update];
    NSString* format = @"p(%.3f,%.3f,%.3f)\no(%.3f,%.3f,%.3f,%.3f)\nax(%.3f,%.3f,%.3f)\nay(%.3f,%.3f,%.3f)\naz(%.3f,%.3f,%.3f)\ns(%.3f,%.3f,%.3f)";
    JCVector3 xAxis;
    JCVector3 yAxis;
    JCVector3 zAxis;
    JCQuaternionToAxes(&_transform.orientation, &xAxis, &yAxis, &zAxis);
    NSString* local = [NSString stringWithFormat:format, _transform.position.x, _transform.position.y, _transform.position.z,
                       _transform.orientation.w, _transform.orientation.x, _transform.orientation.y, _transform.orientation.z,
                       xAxis.x, xAxis.y, xAxis.z, yAxis.x, yAxis.y, yAxis.z, zAxis.x, zAxis.y, zAxis.z,
                       _transform.scale.x, _transform.scale.y, _transform.scale.z];
    JCQuaternionToAxes(&_transform.derivedOrientation, &xAxis, &yAxis, &zAxis);
    NSString* world = [NSString stringWithFormat:format, _transform.derivedPosition.x, _transform.derivedPosition.y, _transform.derivedPosition.z,
                       _transform.derivedOrientation.w, _transform.derivedOrientation.x, _transform.derivedOrientation.y, _transform.derivedOrientation.z,
                       xAxis.x, xAxis.y, xAxis.z, yAxis.x, yAxis.y, yAxis.z, zAxis.x, zAxis.y, zAxis.z,
                       _transform.derivedScale.x, _transform.derivedScale.y, _transform.derivedScale.z];
    return [NSString stringWithFormat:@"-- local --\n%@\n -- world --\n%@", local, world];
}

@end
