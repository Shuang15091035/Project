//
//  InspiratedBehaviour.m
//  project_mesher
//
//  Created by mac zdszkj on 16/4/8.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "InspiratedBehaviour.h"
#import "MesherModel.h"
#import "ItemMoveCommand.h"

@interface InspiratedBehaviour () {
    id<IMesherModel> mModel;
    NSUInteger mSelectedMask;
    InspiratedBehaviourOnSelectBlock mOnSelect;
    BOOL mCanMove;
    ItemMoveCommand* mItemMoveCommand;
    id<JIGameObject> mCanTouchMoveObject;
    
    CGPoint oldPoint;
    CGPoint newPoint;
}

@end

@implementation InspiratedBehaviour

@synthesize model = mModel;
@synthesize selectedMask = mSelectedMask;

- (void)onSingleTap:(UITapGestureRecognizer *)singleTap {
    switch (singleTap.state) {
        case UIGestureRecognizerStateEnded: {
            // 判断是否点击到物件
            CGPoint positionInPixels = singleTap.positionInPixels; // 点击的点
            oldPoint = positionInPixels;
            id<JIGameScene> scene = self.host.scene; // 获取场景
            scene.rayQuery.willSortByDistance = YES; // 射线查询 按照距离排序 为了找到射线的第一个目标对象
            scene.rayQuery.mask = mSelectedMask;
            id<JIRayQueryResult> result = [scene getCameraRayQueryResultFromScreenX:positionInPixels.x screenY:positionInPixels.y]; // 通过点 来获取射线
            if (result.numEntries > 0) { // result 是个列表(包含了距离 和 物件) 是射线穿过的物件
                JWRayQueryResultEntry* e = [result entryAt:0]; // 取到最近的对象
                id<JIGameObject> object = e.object;
                NSLog(@"选中:%@", object.Id);
                JCBounds3 bounds = object.transformBounds;
                JCVector3 size = JCBounds3GetSize(&bounds);
                NSLog(@"模型大小：(%.2f, %.2f, %.2f)", size.x, size.y, size.z);
                
                mModel.selectedObject = object;
                if (mOnSelect != nil) {
                    mOnSelect(object);
                }
            } else {
                mModel.selectedObject = nil;
                if (mOnSelect != nil) {
                    mOnSelect(nil);
                }
            }
            break;
        }
        default:
            break;
    }
}

- (BOOL)onScreenTouchDown:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint positionInPixels = touch.positionInPixels; // 点击的点
    oldPoint = positionInPixels;
    id<JIGameScene> scene = self.host.scene; // 获取场景
    scene.rayQuery.willSortByDistance = YES; // 射线查询 按照距离排序 为了找到射线的第一个目标对象
    scene.rayQuery.mask = mSelectedMask;
    id<JIRayQueryResult> result = [scene getCameraRayQueryResultFromScreenX:positionInPixels.x screenY:positionInPixels.y]; // 通过点 来获取射线
    if (result.numEntries > 0) { // result 是个列表(包含了距离 和 物件) 是射线穿过的物件
        JWRayQueryResultEntry* e = [result entryAt:0]; // 取到最近的对象
        id<JIGameObject> object = e.object;
        NSLog(@"选中:%@", object.Id);
        JCBounds3 bounds = object.transformBounds;
        JCVector3 size = JCBounds3GetSize(&bounds);
        NSLog(@"模型大小：(%.2f, %.2f, %.2f)", size.x, size.y, size.z);
        if (object == mModel.selectedObject) { // 如果选中的物件是已经点中的  无需长按 直接进入touch循环
            mCanTouchMoveObject = object;
        } else {
            mCanTouchMoveObject = nil;
        }
    } else {
        mCanTouchMoveObject = nil;
    }
    return YES;
}

- (BOOL)onScreenTouchMove:(NSSet *)touches withEvent:(UIEvent *)event {
//    if (mCanTouchMoveObject == nil) {
//        return YES;
//    }
//    if (!mCanMove) {
//        return YES;
//    }
//    // 创建移动命令
//    if (mItemMoveCommand == nil) {
//        mItemMoveCommand = [[ItemMoveCommand alloc] init];
//        mItemMoveCommand.plan = mModel.currentPlan;
//        mItemMoveCommand.object = mCanTouchMoveObject;
//        mItemMoveCommand.originPosition = [mCanTouchMoveObject.transform positionInSpace:JWTransformSpaceWorld];
//    }
//    UITouch* touch = [touches anyObject];
//    newPoint = touch.positionInPixels;
//    JCVector3 oldPosition = [mCanTouchMoveObject.transform positionInSpace:JWTransformSpaceWorld];
//    CGFloat insertX = newPoint.x - oldPoint.x;
//    CGFloat insertY = newPoint.y - oldPoint.y;
//    
//    JCVector3 newPosition = JCVector3Make(oldPosition.x + insertX, oldPosition.y, oldPosition.z + insertY);
//    [mCanTouchMoveObject.transform setPositionV:newPosition inSpace:JWTransformSpaceWorld];
    return YES;
}

- (BOOL)onScreenTouchUp:(NSSet *)touches withEvent:(UIEvent *)event {
//    if (!mCanMove) {
//        return YES;
//    }
//    if (mItemMoveCommand != nil) {
//        //取到移动到的目标点
//        mItemMoveCommand.plan = mModel.currentPlan;
//        mItemMoveCommand.destPosition = [mItemMoveCommand.object.transform positionInSpace:JWTransformSpaceWorld];
//        //用command记录并操作目标点的位置
//        [mModel.commandMachine doneCommand:mItemMoveCommand];
//        mItemMoveCommand = nil;
//    }
    return YES;
}

- (BOOL)onScreenTouchCancel:(NSSet *)touches withEvent:(UIEvent *)event {
    return [self onScreenTouchUp:touches withEvent:event];
    return YES;
}

- (void)onPinch:(UIPinchGestureRecognizer *)pinch {
    
}

- (InspiratedBehaviourOnSelectBlock)onSelect {
    return mOnSelect;
}

- (void)setOnSelect:(InspiratedBehaviourOnSelectBlock)onSelect {
    mOnSelect = onSelect;
}

@synthesize canMove = mCanMove;
@end
