//
//  ItemSelectAndMoveBehaviour.m
//  project_mesher
//
//  Created by ddeyes on 15/10/27.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "ItemSelectAndMoveBehaviour.h"
#import "MesherModel.h"
#import "ItemMoveCommand.h"

@interface ItemSelectAndMoveBehaviour () {
    id<IMesherModel> mModel;
    ItemSelectAndMoveBehaviourOnSelectBlock mOnSelect;
    BOOL mCanMove;
    ItemMoveCommand* mItemMoveCommand;
    id<ICVGameObject> mCanTouchMoveObject;
    
    NSMutableArray *overlapObject; // 用于存放有相交的物件的数组
}

@property (nonatomic, readwrite) UITouch *mt;

@end

@implementation ItemSelectAndMoveBehaviour

@synthesize model = mModel;

- (void)onLongPress:(UILongPressGestureRecognizer *)longPress {
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:{
            // 判断是否点击到物件
            CGPoint positionInPixels = longPress.positionInPixels; // 点击的点
            id<ICVGameScene> scene = self.host.scene; // 获取场景
            scene.rayQuery.willSortByDistance = YES; // 射线查询 按照距离排序 为了找到射线的第一个目标对象
            scene.rayQuery.mask = [MesherModel CanSelectMask];
            id<ICVRayQueryResult> result = [scene getCameraRayQueryResultFromScreenX:positionInPixels.x screenY:positionInPixels.y]; // 通过点 来获取射线
            if (result.numEntries > 0) { // result 是个列表(包含了距离 和 物件) 是射线穿过的物件
                CCVRayQueryResultEntry* e = [result entryAt:0]; // 取到最近的对象
                id<ICVGameObject> object = e.object;
                NSLog(@"选中:%@", object.Id);
                CCCBounds3 bounds = object.transformBounds;
                CCCVector3 size = CCCBounds3GetSize(&bounds);
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
        case UIGestureRecognizerStateChanged: {
            if (mModel.selectedObject == nil) {
                break;
            }
            if (!mCanMove) {
                break;
            }
            // 创建移动命令
            if (mItemMoveCommand == nil) {
                mItemMoveCommand = [[ItemMoveCommand alloc] init];
                mItemMoveCommand.plan = mModel.currentPlan;
                mItemMoveCommand.object = mModel.selectedObject;
                mItemMoveCommand.originPosition = [mModel.selectedObject.transform positionInSpace:CCVTransformSpaceWorld];
            }
            // 移动物件
            CGPoint p = longPress.positionInPixels;
            id<ICVGameScene> scene = self.host.scene;
            CCCRayPlaneIntersectResult result = [scene getCameraRayToUnitYZeroPlaneResultFromScreenX:p.x screenY:p.y];//和地面求交
            //result是点中地面的点
            
            [mModel.currentPlan itemOverlap:mModel.selectedObject];
            
            if (result.hit) {//点中
                CCCVector3 objectPosition = [mModel.selectedObject.transform positionInSpace:CCVTransformSpaceWorld];//物件在本身坐标系的位置
                CCCVector3 newPosition = result.point;//点击的点的位置
                newPosition.y = objectPosition.y;//避免抖动 在同平面移动
                [mModel.selectedObject.transform setPositionV:newPosition inSpace:CCVTransformSpaceWorld];
                mModel.currentPlan.sceneDirty = YES;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (!mCanMove) {
                break;
            }
            if (mItemMoveCommand != nil) {
                //取到移动到的目标点
                mItemMoveCommand.plan = mModel.currentPlan;
                mItemMoveCommand.destPosition = [mItemMoveCommand.object.transform positionInSpace:CCVTransformSpaceWorld];
                //用command记录并操作目标点的位置
                [mModel.commandMachine doneCommand:mItemMoveCommand];
                mItemMoveCommand = nil;
            }
            [mModel.currentPlan showOverlap];
            break;
        }
        default:
            break;
    }
}

- (void)onSingleTap:(UITapGestureRecognizer *)singleTap{
    switch (singleTap.state) {
        case UIGestureRecognizerStateEnded: {
            // 判断是否点击到物件
            CGPoint positionInPixels = singleTap.positionInPixels; // 点击的点
            id<ICVGameScene> scene = self.host.scene; // 获取场景
            scene.rayQuery.willSortByDistance = YES; // 射线查询 按照距离排序 为了找到射线的第一个目标对象
            scene.rayQuery.mask = [MesherModel CanSelectMask];
            id<ICVRayQueryResult> result = [scene getCameraRayQueryResultFromScreenX:positionInPixels.x screenY:positionInPixels.y]; // 通过点 来获取射线
            if (result.numEntries > 0) { // result 是个列表(包含了距离 和 物件) 是射线穿过的物件
                CCVRayQueryResultEntry* e = [result entryAt:0]; // 取到最近的对象
                id<ICVGameObject> object = e.object;
                NSLog(@"选中:%@", object.Id);
                CCCBounds3 bounds = object.transformBounds;
                CCCVector3 size = CCCBounds3GetSize(&bounds);
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
    // 判断是否点击到物件
    UITouch* touch = [touches anyObject];
    CGPoint positionInPixels = touch.positionInPixels; // 点击的点
    id<ICVGameScene> scene = self.host.scene; // 获取场景
    scene.rayQuery.willSortByDistance = YES; // 射线查询 按照距离排序 为了找到射线的第一个目标对象
    scene.rayQuery.mask = [MesherModel CanSelectMask];
    id<ICVRayQueryResult> result = [scene getCameraRayQueryResultFromScreenX:positionInPixels.x screenY:positionInPixels.y]; // 通过点 来获取射线
    if (result.numEntries > 0) { // result 是个列表(包含了距离 和 物件) 是射线穿过的物件
        CCVRayQueryResultEntry* e = [result entryAt:0]; // 取到最近的对象
        id<ICVGameObject> object = e.object;
        NSLog(@"选中:%@", object.Id);
        CCCBounds3 bounds = object.transformBounds;
        CCCVector3 size = CCCBounds3GetSize(&bounds);
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
    if (mCanTouchMoveObject == nil) {
        return YES;
    }
    if (!mCanMove) {
        return YES;
    }
    // 创建移动命令
    if (mItemMoveCommand == nil) {
        mItemMoveCommand = [[ItemMoveCommand alloc] init];
        mItemMoveCommand.plan = mModel.currentPlan;
        mItemMoveCommand.object = mCanTouchMoveObject;
        mItemMoveCommand.originPosition = [mCanTouchMoveObject.transform positionInSpace:CCVTransformSpaceWorld];
    }
    // 移动物件
    UITouch* touch = [touches anyObject];
    CGPoint p = touch.positionInPixels;
    id<ICVGameScene> scene = self.host.scene;
    CCCRayPlaneIntersectResult result = [scene getCameraRayToUnitYZeroPlaneResultFromScreenX:p.x screenY:p.y];//和地面求交
    //result是点中地面的点
    
    [mModel.currentPlan itemOverlap:mModel.selectedObject];
    
    if (result.hit) {//点中
        CCCVector3 objectPosition = [mCanTouchMoveObject.transform positionInSpace:CCVTransformSpaceWorld];//物件在本身坐标系的位置
        CCCVector3 newPosition = result.point;//点击的点的位置
        newPosition.y = objectPosition.y;//避免抖动 在同平面移动
        [mCanTouchMoveObject.transform setPositionV:newPosition inSpace:CCVTransformSpaceWorld];
        mModel.currentPlan.sceneDirty = YES;
    }
    return YES;
}

- (BOOL)onScreenTouchUp:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!mCanMove) {
        return YES;
    }
    if (mItemMoveCommand != nil) {
        //取到移动到的目标点
        mItemMoveCommand.plan = mModel.currentPlan;
        mItemMoveCommand.destPosition = [mItemMoveCommand.object.transform positionInSpace:CCVTransformSpaceWorld];
        //用command记录并操作目标点的位置
        [mModel.commandMachine doneCommand:mItemMoveCommand];
        mItemMoveCommand = nil;
    }
    [mModel.currentPlan showOverlap];
    return YES;
}

- (BOOL)onScreenTouchCancel:(NSSet *)touches withEvent:(UIEvent *)event {
    return [self onScreenTouchUp:touches withEvent:event];
}

- (ItemSelectAndMoveBehaviourOnSelectBlock)onSelect {
    return mOnSelect;
}

- (void)setOnSelect:(ItemSelectAndMoveBehaviourOnSelectBlock)onSelect {
    mOnSelect = onSelect;
}

@synthesize canMove = mCanMove;

@end
