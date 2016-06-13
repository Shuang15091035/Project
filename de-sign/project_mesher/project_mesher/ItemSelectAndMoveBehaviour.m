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
    NSUInteger mSelectedMask;
    ItemSelectAndMoveBehaviourOnSelectBlock mOnSelect;
    BOOL mCanMove;
    ItemSelectAndMoveBehaviourOnItemEndMove mOnItemEndMove;
    ItemMoveCommand* mItemMoveCommand;
    id<JIGameObject> mCanTouchMoveObject;
    
    NSMutableArray *overlapObject; // 用于存放有相交的物件的数组
    
    id<JIGameObject> tempWall;
}

@property (nonatomic, readwrite) UITouch *mt;

@end

@implementation ItemSelectAndMoveBehaviour

@synthesize model = mModel;
@synthesize selectedMask = mSelectedMask;

- (void)onLongPress:(UILongPressGestureRecognizer *)longPress {
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:{
            // 判断是否点击到物件
            CGPoint positionInPixels = longPress.positionInPixels; // 点击的点
            id<JIGameScene> scene = self.host.scene; // 获取场景
            scene.rayQuery.willSortByDistance = YES; // 射线查询 按照距离排序 为了找到射线的第一个目标对象
            //scene.rayQuery.mask = [MesherModel CanSelectMask];
            scene.rayQuery.mask = mSelectedMask;
            if (!mModel.isFPS) {
                scene.rayQuery.mask = SelectedMaskAllArchsExceptCeil | SelectedMaskAllItemsExceptTop;
            }
            id<JIRayQueryResult> result = [scene getCameraRayQueryResultFromScreenX:positionInPixels.x screenY:positionInPixels.y]; // 通过点 来获取射线
            if (result.numEntries > 0) { // result 是个列表(包含了距离 和 物件) 是射线穿过的物件
                JWRayQueryResultEntry* e = [result entryAt:0]; // 取到最近的对象
                ItemInfo *info = [Data getItemInfoFromInstance:e.object];
                Item *it = [Data getItemFromInstance:e.object];
                if (mModel.isTeachMove) {
                    if (it.Id != 21) {
                        break;
                    }
                }
                if (info.type == ItemTypeWall) {
                    JCVector3 wallNormal = JCVector3Make([info.dx floatValue], [info.dy floatValue], [info.dz floatValue]);
                    JCRay3 ray = [mModel.currentCamera.camera getRayFromX:positionInPixels.x screenY:positionInPixels.y];
                    JCVector3 rayDirection = ray.direction;
                    JCFloat a = JCVector3DotProductv(&wallNormal, &rayDirection);
                    if (a >= 0.0f) {
                        if (result.numEntries > 2) {
                            e = [result entryAt:1];
                        }
                    }
                }
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
                mItemMoveCommand.originPosition = [mModel.selectedObject.transform positionInSpace:JWTransformSpaceWorld];
            }
            // 移动物件
            CGPoint p = longPress.positionInPixels;
            id<JIGameScene> scene = self.host.scene;
            
            Item *item = [Data getItemFromInstance:mModel.selectedObject];
            if (item.product.position == PositionOnItem) {
                JCRayPlaneIntersectResult result = [scene getCameraRayToUnitYZeroPlaneResultFromScreenX:p.x screenY:p.y];//和地面求交
                //result是点中地面的点
                
                [mModel.currentPlan itemOverlap:mModel.selectedObject];
                [mModel.currentPlan showOverlap];
                if (result.hit) {//点中
                    JCVector3 objectPosition = [mModel.selectedObject.transform positionInSpace:JWTransformSpaceWorld];//物件在本身坐标系的位置
                    JCVector3 newPosition = result.point;//点击的点的位置
                    newPosition.y = objectPosition.y;//避免抖动 在同平面移动
                    [mModel.selectedObject.transform setPosition:newPosition inSpace:JWTransformSpaceWorld];
                    mModel.currentPlan.sceneDirty = YES;
                }
            }else if (item.product.position == PositionOnWall) {
                id<JIGameScene> scene = mModel.currentScene; // 获取场景
                scene.rayQuery.willSortByDistance = YES; // 射线查询 按照距离排序 为了找到射线的第一个目标对象
                //scene.rayQuery.mask = [MesherModel CanSelectMask];// 可以优化
                scene.rayQuery.mask = mSelectedMask;
                id<JIRayQueryResult> result = [scene getCameraRayQueryResultFromScreenX:p.x screenY:p.y];
                if (result.numEntries > 0) { // result 是个列表(包含了距离 和 物件) 是射线穿过的物件
                    id<JIGameObject> wall;
                    for (int i = 0; i < result.numEntries; i++) {
                        JWRayQueryResultEntry* e = [result entryAt:i];
                        ItemInfo *itemInfo = [Data getItemInfoFromInstance:e.object];
                        if (itemInfo.type == ItemTypeWall) {
                            wall = e.object;
                            break;
                        }
                    }
                    if (wall != nil) {
                        ItemInfo *itemInfo = [Data getItemInfoFromInstance:wall];
                        JCVector2 cameraXY = [mModel.currentCamera.camera getCoordinatesFromScreenX:p.x screenY:p.y];
                        JCRay3 ray = [mModel.currentCamera.camera getRayFromX:cameraXY.x screenY:cameraXY.y];
                        JCVector3 normal = JCVector3Make([itemInfo.dx floatValue], [itemInfo.dy floatValue], [itemInfo.dz floatValue]);
                        
                        JCFloat distance = fabsf([itemInfo.dx floatValue] * wall.transformBounds.min.x + [itemInfo.dy floatValue] * wall.transformBounds.min.y + [itemInfo.dz floatValue] * wall.transformBounds.min.z);//原点到平面的距离
                        JCPlane ground = JCPlaneMake(normal, distance);//平面的位置
                        JCRayPlaneIntersectResult result = JCRayPlaneIntersect(&ray, &ground);
                        result.point = JCRayPlaneIntersectResultGetHitPoint(&result, &ray);
                        if (result.hit) {//点中
                            JCVector3 objectPosition = [mModel.selectedObject.transform positionInSpace:JWTransformSpaceWorld];//物件在本身坐标系的位置
                            JCVector3 newPosition = result.point;//点击的点的位置
                            if([itemInfo.dx intValue] != 0) {
                                newPosition.x = objectPosition.x;//避免抖动 在同平面移动
                            }else if ([itemInfo.dz intValue] != 0){
                                newPosition.z = objectPosition.z;//避免抖动 在同平面移动
                            }
                            [mModel.selectedObject.transform setPosition:newPosition inSpace:JWTransformSpaceWorld];
                            mModel.currentPlan.sceneDirty = YES;
                            if (tempWall != wall) {
                                JCVector3 selectObjZ = [mModel.selectedObject.transform zAxisInSpace:JWTransformSpaceWorld];
                                float d = JCVector3DotProductv(&normal, &selectObjZ);
                                float radians = acosf(d);
                                float degrees = JCRad2Deg(radians); // 旋转的角度
                                ItemInfo *now = [Data getItemInfoFromInstance:wall];
                                JCVector3 nowNormal = JCVector3Make([now.dx floatValue], [now.dy floatValue], [now.dz floatValue]);
                                JCVector3 cn = JCVector3CrossProductv(&selectObjZ, &nowNormal);// 计算出的向量可以判断方向
                                if (cn.y < 0.0f) {
                                    degrees = -degrees;
                                }
                                [mModel.selectedObject.transform rotateUpDegrees:degrees+180 inSpace:JWTransformSpaceWorld];
                                tempWall = wall;
                                // 设置贴墙
                                if([now.dx intValue] != 0) {
                                    if ([now.dx intValue] > 0){
                                        newPosition.x += 0.01f;
                                    }else {
                                        newPosition.x -= 0.01f;
                                    }
                                }else if ([now.dz intValue] != 0){
                                    if ([now.dz intValue] > 0){
                                        newPosition.z += 0.01f;
                                    }else {
                                        newPosition.z -= 0.01f;
                                    }
                                }
                                [mModel.selectedObject.transform setPosition:newPosition inSpace:JWTransformSpaceWorld];
                            }
                        }
                    }
                }
            }else if (item.product.position == PositionInWall || item.product.position == PositionGround){
                if (mModel.isTeachMove) {
                    id<JIGameScene> scene = mModel.currentScene; // 获取场景
                    JCRayPlaneIntersectResult result = [scene getCameraRayToUnitYZeroPlaneResultFromScreenX:p.x screenY:p.y];//和地面求交
                    JCVector3 point = result.point;
                    point.y = 0.01f;
                    [mModel.selectedObject.transform setPosition:point inSpace:JWTransformSpaceWorld];
                }else {
                    id<JIGameScene> scene = mModel.currentScene; // 获取场景
                    scene.rayQuery.willSortByDistance = YES; // 射线查询 按照距离排序 为了找到射线的第一个目标对象
                    //                scene.rayQuery.mask = [MesherModel CanSelectMask];// 可以优化
                    scene.rayQuery.mask = mSelectedMask;
                    id<JIRayQueryResult> result = [scene getCameraRayQueryResultFromScreenX:p.x screenY:p.y];
                    id<JIGameObject> wall;
                    for (int i = 0; i < result.numEntries; i++) {
                        JWRayQueryResultEntry* e = [result entryAt:i];
                        ItemInfo *itemInfo = [Data getItemInfoFromInstance:e.object];
                        if (itemInfo.type == ItemTypeWall) {
                            wall = e.object;
                            break;
                        }
                    }
                    if (wall == nil) {
                        [mModel.currentPlan itemOverlap:mModel.selectedObject];
                        JCRayPlaneIntersectResult result = [scene getCameraRayToUnitYZeroPlaneResultFromScreenX:p.x screenY:p.y];//和地面求交
                        if (result.hit) {//点中
                            JCVector3 objectPosition = [mCanTouchMoveObject.transform positionInSpace:JWTransformSpaceWorld];//物件在本身坐标系的位置
                            JCVector3 newPosition = result.point;//点击的点的位置
                            newPosition.y = objectPosition.y;//避免抖动 在同平面移动
                            [mCanTouchMoveObject.transform setPosition:newPosition inSpace:JWTransformSpaceWorld];
                            mModel.currentPlan.sceneDirty = YES;
                        }
                    }else {
                        ItemInfo *itemInfo = [Data getItemInfoFromInstance:wall];
                        JCVector2 cameraXY = [mModel.currentCamera.camera getCoordinatesFromScreenX:p.x screenY:p.y];
                        JCRay3 ray = [mModel.currentCamera.camera getRayFromX:cameraXY.x screenY:cameraXY.y];
                        JCVector3 normal = JCVector3Make([itemInfo.dx floatValue], [itemInfo.dy floatValue], [itemInfo.dz floatValue]);
                        
                        JCFloat distance = fabsf([itemInfo.dx floatValue] * wall.transformBounds.min.x + [itemInfo.dy floatValue] * wall.transformBounds.min.y + [itemInfo.dz floatValue] * wall.transformBounds.min.z);//原点到平面的距离
                        JCPlane ground = JCPlaneMake(normal, distance);//平面的位置
                        JCRayPlaneIntersectResult result = JCRayPlaneIntersect(&ray, &ground);
                        result.point = JCRayPlaneIntersectResultGetHitPoint(&result, &ray);
                        if (result.hit) {//点中
                            JCVector3 objectPosition = [mModel.selectedObject.transform positionInSpace:JWTransformSpaceWorld];//物件在本身坐标系的位置
                            JCVector3 newPosition = result.point;//点击的点的位置
                            if(item.product.position == PositionGround) {
                                if([itemInfo.dx intValue] != 0) {
                                    if ([itemInfo.dx intValue] > 0){
                                        objectPosition.x = wall.transformBounds.min.x + (mModel.selectedObject.transformBounds.max.x - mModel.selectedObject.transformBounds.min.x)/2;
                                        newPosition.x = objectPosition.x + 0.01f;//避免抖动 在同平面移动
                                    }else {
                                        objectPosition.x = wall.transformBounds.min.x - (mModel.selectedObject.transformBounds.max.x - mModel.selectedObject.transformBounds.min.x)/2;
                                        newPosition.x = objectPosition.x - 0.01f;;//避免抖动 在同平面移动
                                    }
                                }else if ([itemInfo.dz intValue] != 0){
                                    if ([itemInfo.dz intValue] > 0){
                                        objectPosition.z = wall.transformBounds.min.z + (mModel.selectedObject.transformBounds.max.z - mModel.selectedObject.transformBounds.min.z)/2;
                                        newPosition.z = objectPosition.z + 0.01f;//避免抖动 在同平面移动
                                    }else {
                                        objectPosition.z = wall.transformBounds.min.z - (mModel.selectedObject.transformBounds.max.z - mModel.selectedObject.transformBounds.min.z)/2;
                                        newPosition.z = objectPosition.z - 0.01f;//避免抖动 在同平面移动
                                    }
                                }
                            }else if(item.product.position == PositionInWall) {
                                if([itemInfo.dx intValue] != 0) {
                                    newPosition.x = objectPosition.x;//避免抖动 在同平面移动
                                }else if ([itemInfo.dz intValue] != 0){
                                    newPosition.z = objectPosition.z;//避免抖动 在同平面移动
                                }
                            }
                            newPosition.y = 0.01f;
                            [mModel.selectedObject.transform setPosition:newPosition inSpace:JWTransformSpaceWorld];
                            mModel.currentPlan.sceneDirty = YES;
                            if (tempWall != wall) {
                                JCVector3 selectObjZ = [mModel.selectedObject.transform zAxisInSpace:JWTransformSpaceWorld];
                                float d = JCVector3DotProductv(&normal, &selectObjZ);
                                float radians = acosf(d);
                                float degrees = JCRad2Deg(radians); // 旋转的角度
                                
                                ItemInfo *now = [Data getItemInfoFromInstance:wall];
                                JCVector3 nowNormal = JCVector3Make([now.dx floatValue], [now.dy floatValue], [now.dz floatValue]);
                                JCVector3 cn = JCVector3CrossProductv(&selectObjZ, &nowNormal);
                                if (cn.y < 0.0f) {
                                    degrees = -degrees;
                                }
                                [mModel.selectedObject.transform rotateUpDegrees:degrees+180 inSpace:JWTransformSpaceWorld];
                                tempWall = wall;
                                
                                // 设置贴墙
                                if(item.product.position == PositionGround) {
                                    if([now.dx intValue] != 0) {
                                        if ([now.dx intValue] > 0){
                                            newPosition.x += ((mModel.selectedObject.transformBounds.max.x - mModel.selectedObject.transformBounds.min.x)/2 + 0.01f);
                                        }else {
                                            newPosition.x -= ((mModel.selectedObject.transformBounds.max.x - mModel.selectedObject.transformBounds.min.x)/2 + 0.01f);
                                        }
                                    }else if ([now.dz intValue] != 0){
                                        if ([now.dz intValue] > 0){
                                            newPosition.z += ((mModel.selectedObject.transformBounds.max.z - mModel.selectedObject.transformBounds.min.z)/2 + 0.01f);
                                        }else {
                                            newPosition.z -= ((mModel.selectedObject.transformBounds.max.z - mModel.selectedObject.transformBounds.min.z)/2 + 0.01f);
                                        }
                                    }
                                }else if (item.product.position == PositionInWall) {
                                    if([now.dx intValue] != 0) {
                                        if ([now.dx intValue] > 0){
                                            newPosition.x += 0.01f;
                                        }else {
                                            newPosition.x -= 0.01f;
                                        }
                                    }else if ([now.dz intValue] != 0){
                                        if ([now.dz intValue] > 0){
                                            newPosition.z += 0.01f;
                                        }else {
                                            newPosition.z -= 0.01f;
                                        }
                                    }
                                }
                                
                                newPosition.y = 0.01f;
                                [mModel.selectedObject.transform setPosition:newPosition inSpace:JWTransformSpaceWorld];
                            }
                        }
                    }
                    mModel.currentScene.boundsQuery.mask = SelectedMaskAllItems | SelectedMaskAllArchs;
                    id<JIBoundsQueryResult> resultBounds = [mModel.currentScene.boundsQuery getResultByBounds:mModel.selectedObject.transformBounds object:mModel.currentScene.root];
                    JCVector3 selectedPosition = [mModel.selectedObject.transform positionInSpace:JWTransformSpaceWorld];
                    if (result.numEntries > 0) { // 如果result中有值 说明有物件重叠
                        for (JWBoundsQueryResultEntry* boundsQ in resultBounds.entries) {
                            id<JIGameObject> overlapObj = boundsQ.object;
                            ItemInfo *wallInfo = [Data getItemInfoFromInstance:overlapObj];
                            if (wallInfo.type == ItemTypeWall) {
                                if ([wallInfo.dx integerValue] != 0) {
                                    if ([wallInfo.dx integerValue] > 0) {
                                        selectedPosition.x = overlapObj.transformBounds.max.x + (mModel.selectedObject.transformBounds.max.x - mModel.selectedObject.transformBounds.min.x)/2 + 0.02f;
                                    }else {
                                        selectedPosition.x = overlapObj.transformBounds.max.x - (mModel.selectedObject.transformBounds.max.x - mModel.selectedObject.transformBounds.min.x)/2 - 0.02f;
                                    }
                                }else if ([wallInfo.dz integerValue] != 0) {
                                    if ([wallInfo.dz integerValue] > 0) {
                                        selectedPosition.z = overlapObj.transformBounds.max.z + (mModel.selectedObject.transformBounds.max.z - mModel.selectedObject.transformBounds.min.z)/2 + 0.02f;
                                    }else {
                                        selectedPosition.z = overlapObj.transformBounds.max.z - (mModel.selectedObject.transformBounds.max.z - mModel.selectedObject.transformBounds.min.z)/2 - 0.02f;
                                    }
                                }
                            }
                            [mModel.selectedObject.transform setPosition:selectedPosition inSpace:JWTransformSpaceWorld];
                        }
                    }
                }
            } else if (item.product.position == PositionTop) {
                id<JIGameScene> scene = mModel.currentScene; // 获取场景
                scene.rayQuery.willSortByDistance = YES;
                scene.rayQuery.mask = SelectedMaskAllItems | SelectedMaskAllArchs;//mSelectedMask;
                id<JIRayQueryResult> result = [scene getCameraRayQueryResultFromScreenX:p.x screenY:p.y];
                id<JIGameObject> ceil = nil;
                for (int i = 0; i < result.numEntries; i++) {
                    JWRayQueryResultEntry* e = [result entryAt:i];
                    ItemInfo *itemInfo = [Data getItemInfoFromInstance:e.object];
                    if (itemInfo.type == ItemTypeCeil) {
                        ceil = e.object;
                        break;
                    }
                }
                if (ceil != nil) {
                    ItemInfo *itemInfo = [Data getItemInfoFromInstance:ceil];
                    JCVector2 cameraXY = [mModel.currentCamera.camera getCoordinatesFromScreenX:p.x screenY:p.y];
                    JCRay3 ray = [mModel.currentCamera.camera getRayFromX:cameraXY.x screenY:cameraXY.y];
                    JCVector3 normal = JCVector3Make([itemInfo.dx floatValue], [itemInfo.dy floatValue], [itemInfo.dz floatValue]);
                    JCFloat distance = fabsf([itemInfo.dx floatValue] * ceil.transformBounds.min.x + [itemInfo.dy floatValue] * ceil.transformBounds.min.y + [itemInfo.dz floatValue] * ceil.transformBounds.min.z);//原点到平面的距离
                    JCPlane ground = JCPlaneMake(normal, distance);//平面的位置
                    JCRayPlaneIntersectResult result = JCRayPlaneIntersect(&ray, &ground);
                    result.point = JCRayPlaneIntersectResultGetHitPoint(&result, &ray);
                    if (result.hit) {
                        JCVector3 objectPosition = [mModel.selectedObject.transform positionInSpace:JWTransformSpaceWorld];//物件在本身坐标系的位置
                        JCVector3 newPosition = result.point;//点击的点的位置
                        newPosition.y = objectPosition.y;
                        [mModel.selectedObject.transform setPosition:newPosition inSpace:JWTransformSpaceWorld];
                        mModel.currentPlan.sceneDirty = YES;
                    }
                }
                
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
                mItemMoveCommand.destPosition = [mItemMoveCommand.object.transform positionInSpace:JWTransformSpaceWorld];
                //用command记录并操作目标点的位置
                [mModel.commandMachine doneCommand:mItemMoveCommand];
                mItemMoveCommand = nil;
            }
            if (mOnItemEndMove != nil) {
                mOnItemEndMove(longPress.position);
            }
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
            id<JIGameScene> scene = self.host.scene; // 获取场景
            scene.rayQuery.willSortByDistance = YES; // 射线查询 按照距离排序 为了找到射线的第一个目标对象
            //            scene.rayQuery.mask = [MesherModel CanSelectMask];
            scene.rayQuery.mask = mSelectedMask;
            if (!mModel.isFPS) {
                scene.rayQuery.mask = SelectedMaskAllArchsExceptCeil | SelectedMaskAllItemsExceptTop;
            }
            id<JIRayQueryResult> result = [scene getCameraRayQueryResultFromScreenX:positionInPixels.x screenY:positionInPixels.y]; // 通过点 来获取射线
            if (result.numEntries > 0) { // result 是个列表(包含了距离 和 物件) 是射线穿过的物件
                JWRayQueryResultEntry* e = [result entryAt:0]; // 取到最近的对象
                ItemInfo *info = [Data getItemInfoFromInstance:e.object];
                Item *it = [Data getItemFromInstance:e.object];
                if (mModel.isTeachMove) {
                    if (it.Id != 21) {
                        break;
                    }
                }
                if (info.type == ItemTypeWall) {
                    JCVector3 wallNormal = JCVector3Make([info.dx floatValue], [info.dy floatValue], [info.dz floatValue]);
                    JCRay3 ray = [mModel.currentCamera.camera getRayFromX:positionInPixels.x screenY:positionInPixels.y];
                    JCVector3 rayDirection = ray.direction;
                    JCFloat a = JCVector3DotProductv(&wallNormal, &rayDirection);
                    if (a >= 0.0f) {
                        if (result.numEntries > 2) {
                            e = [result entryAt:1];
                        }
                    }
                }
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
    // 判断是否点击到物件
    UITouch* touch = [touches anyObject];
    CGPoint positionInPixels = touch.positionInPixels; // 点击的点
    id<JIGameScene> scene = self.host.scene; // 获取场景
    scene.rayQuery.willSortByDistance = YES; // 射线查询 按照距离排序 为了找到射线的第一个目标对象
    //    scene.rayQuery.mask = [MesherModel CanSelectMask];
    scene.rayQuery.mask = mSelectedMask;
    if (!mModel.isFPS) {
        scene.rayQuery.mask = SelectedMaskAllArchsExceptCeil | SelectedMaskAllItemsExceptTop;
    }
    id<JIRayQueryResult> result = [scene getCameraRayQueryResultFromScreenX:positionInPixels.x screenY:positionInPixels.y]; // 通过点 来获取射线
    if (result.numEntries > 0) { // result 是个列表(包含了距离 和 物件) 是射线穿过的物件
        JWRayQueryResultEntry* e = [result entryAt:0]; // 取到最近的对象
        ItemInfo *info = [Data getItemInfoFromInstance:e.object];
        Item *it = [Data getItemFromInstance:e.object];
        if (mModel.isTeachMove) {
            if (it.Id != 21) {
                return YES;
            }
        }
        if (info.type == ItemTypeWall) {
            JCVector3 wallNormal = JCVector3Make([info.dx floatValue], [info.dy floatValue], [info.dz floatValue]);
            JCRay3 ray = [mModel.currentCamera.camera getRayFromX:positionInPixels.x screenY:positionInPixels.y];
            JCVector3 rayDirection = ray.direction;
            JCFloat a = JCVector3DotProductv(&wallNormal, &rayDirection);
            if (a >= 0.0f) {
                if (result.numEntries > 2) {
                    e = [result entryAt:1];
                }
            }
        }
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
        mItemMoveCommand.originPosition = [mCanTouchMoveObject.transform positionInSpace:JWTransformSpaceWorld];
    }
    // 移动物件
    UITouch* touch = [touches anyObject];
    CGPoint p = touch.positionInPixels;
    id<JIGameScene> scene = self.host.scene;
    
    Item *item = [Data getItemFromInstance:mModel.selectedObject];
    if (item.product.position == PositionOnItem) {
        JCRayPlaneIntersectResult result = [scene getCameraRayToUnitYZeroPlaneResultFromScreenX:p.x screenY:p.y];//和地面求交
        //result是点中地面的点
        
        [mModel.currentPlan itemOverlap:mModel.selectedObject];
        [mModel.currentPlan showOverlap];
        if (result.hit) {//点中
            JCVector3 objectPosition = [mCanTouchMoveObject.transform positionInSpace:JWTransformSpaceWorld];//物件在本身坐标系的位置
            JCVector3 newPosition = result.point;//点击的点的位置
            newPosition.y = objectPosition.y;//避免抖动 在同平面移动
            [mCanTouchMoveObject.transform setPosition:newPosition inSpace:JWTransformSpaceWorld];
            mModel.currentPlan.sceneDirty = YES;
        }
    }else if (item.product.position == PositionOnWall) {
        id<JIGameScene> scene = mModel.currentScene; // 获取场景
        scene.rayQuery.willSortByDistance = YES; // 射线查询 按照距离排序 为了找到射线的第一个目标对象
        scene.rayQuery.mask = mSelectedMask;
        id<JIRayQueryResult> result = [scene getCameraRayQueryResultFromScreenX:p.x screenY:p.y];
        if (result.numEntries > 0) { // result 是个列表(包含了距离 和 物件) 是射线穿过的物件
            id<JIGameObject> wall = nil;
            for (int i = 0; i < result.numEntries; i++) {
                JWRayQueryResultEntry* e = [result entryAt:i];
                ItemInfo *itemInfo = [Data getItemInfoFromInstance:e.object];
                if (itemInfo.type == ItemTypeWall) {
                    wall = e.object;
                    break;
                }
            }
            if (wall != nil) {
                ItemInfo *itemInfo = [Data getItemInfoFromInstance:wall];
                JCVector2 cameraXY = [mModel.currentCamera.camera getCoordinatesFromScreenX:p.x screenY:p.y];
                JCRay3 ray = [mModel.currentCamera.camera getRayFromX:cameraXY.x screenY:cameraXY.y];
                JCVector3 normal = JCVector3Make([itemInfo.dx floatValue], [itemInfo.dy floatValue], [itemInfo.dz floatValue]);
                
                JCFloat distance = fabsf([itemInfo.dx floatValue] * wall.transformBounds.min.x + [itemInfo.dy floatValue] * wall.transformBounds.min.y + [itemInfo.dz floatValue] * wall.transformBounds.min.z);//原点到平面的距离
                JCPlane ground = JCPlaneMake(normal, distance);//平面的位置
                JCRayPlaneIntersectResult result = JCRayPlaneIntersect(&ray, &ground);
                result.point = JCRayPlaneIntersectResultGetHitPoint(&result, &ray);
                if (result.hit) {//点中
                    JCVector3 objectPosition = [mModel.selectedObject.transform positionInSpace:JWTransformSpaceWorld];//物件在本身坐标系的位置
                    JCVector3 newPosition = result.point;//点击的点的位置
                    if([itemInfo.dx intValue] != 0) {
                        newPosition.x = objectPosition.x;//避免抖动 在同平面移动
                    }else if ([itemInfo.dz intValue] != 0){
                        newPosition.z = objectPosition.z;//避免抖动 在同平面移动
                    }
                    [mModel.selectedObject.transform setPosition:newPosition inSpace:JWTransformSpaceWorld];
                    mModel.currentPlan.sceneDirty = YES;
                    if (tempWall != wall) {
                        JCVector3 selectObjZ = [mModel.selectedObject.transform zAxisInSpace:JWTransformSpaceWorld];
                        float d = JCVector3DotProductv(&normal, &selectObjZ);
                        if (d > 1.0f) {
                            d = 1.0f;
                        }else if (d < -1.0f) {
                            d = -1.0f;
                        }
                        float radians = acosf(d);
                        float degrees = JCRad2Deg(radians); // 旋转的角度
                        
                        ItemInfo *now = [Data getItemInfoFromInstance:wall];
                        JCVector3 nowNormal = JCVector3Make([now.dx floatValue], [now.dy floatValue], [now.dz floatValue]);
                        JCVector3 cn = JCVector3CrossProductv(&selectObjZ, &nowNormal);
                        if (cn.y < 0.0f) {
                            degrees = -degrees;
                        }
                        [mModel.selectedObject.transform rotateUpDegrees:degrees+180 inSpace:JWTransformSpaceWorld];
                        tempWall = wall;
                        
                        // 设置贴墙
                        if([now.dx intValue] != 0) {
                            if ([now.dx intValue] > 0){
                                newPosition.x += 0.01f;
                            }else {
                                newPosition.x -= 0.01f;
                            }
                        }else if ([now.dz intValue] != 0){
                            if ([now.dz intValue] > 0){
                                newPosition.z += 0.01f;
                            }else {
                                newPosition.z -= 0.01f;
                            }
                        }
                        [mModel.selectedObject.transform setPosition:newPosition inSpace:JWTransformSpaceWorld];
                    }
                }
            }
        }
      }else if (item.product.position == PositionInWall || item.product.position == PositionGround) {
          if (mModel.isTeachMove) {
              id<JIGameScene> scene = mModel.currentScene; // 获取场景
              JCRayPlaneIntersectResult result = [scene getCameraRayToUnitYZeroPlaneResultFromScreenX:p.x screenY:p.y];//和地面求交
              JCVector3 point = result.point;
              point.y = 0.01f;
              [mModel.selectedObject.transform setPosition:point inSpace:JWTransformSpaceWorld];
          }else {
              id<JIGameScene> scene = mModel.currentScene; // 获取场景
              scene.rayQuery.willSortByDistance = YES; // 射线查询 按照距离排序 为了找到射线的第一个目标对象
              //        scene.rayQuery.mask = [MesherModel CanSelectMask];// 可以优化
              scene.rayQuery.mask = mSelectedMask;
              id<JIRayQueryResult> result = [scene getCameraRayQueryResultFromScreenX:p.x screenY:p.y];
              id<JIGameObject> wall = nil;
              if (result.numEntries > 0) {
                  for (int i = 0; i < result.numEntries; i++) {
                      JWRayQueryResultEntry* e = [result entryAt:i];
                      ItemInfo *itemInfo = [Data getItemInfoFromInstance:e.object];
                      if (itemInfo.type == ItemTypeWall) {
                          wall = e.object;
                          break;
                      }
                  }
              }
              if (wall == nil) {
                  [mModel.currentPlan itemOverlap:mModel.selectedObject];
                  JCRayPlaneIntersectResult result = [scene getCameraRayToUnitYZeroPlaneResultFromScreenX:p.x screenY:p.y];//和地面求交
                  if (result.hit) {//点中
                      JCVector3 objectPosition = [mCanTouchMoveObject.transform positionInSpace:JWTransformSpaceWorld];//物件在本身坐标系的位置
                      JCVector3 newPosition = result.point;//点击的点的位置
                      newPosition.y = objectPosition.y;//避免抖动 在同平面移动
                      [mCanTouchMoveObject.transform setPosition:newPosition inSpace:JWTransformSpaceWorld];
                      mModel.currentPlan.sceneDirty = YES;
                  }
              }else {
                  ItemInfo *itemInfo = [Data getItemInfoFromInstance:wall];
                  JCVector2 cameraXY = [mModel.currentCamera.camera getCoordinatesFromScreenX:p.x screenY:p.y];
                  JCRay3 ray = [mModel.currentCamera.camera getRayFromX:cameraXY.x screenY:cameraXY.y];
                  JCVector3 normal = JCVector3Make([itemInfo.dx floatValue], [itemInfo.dy floatValue], [itemInfo.dz floatValue]);
                  
                  JCFloat distance = fabsf([itemInfo.dx floatValue] * wall.transformBounds.min.x + [itemInfo.dy floatValue] * wall.transformBounds.min.y + [itemInfo.dz floatValue] * wall.transformBounds.min.z);//原点到平面的距离
                  JCPlane ground = JCPlaneMake(normal, distance);//平面的位置
                  JCRayPlaneIntersectResult result = JCRayPlaneIntersect(&ray, &ground);
                  result.point = JCRayPlaneIntersectResultGetHitPoint(&result, &ray);
                  if (result.hit) {//点中
                      JCVector3 objectPosition = [mModel.selectedObject.transform positionInSpace:JWTransformSpaceWorld];//物件在本身坐标系的位置
                      JCVector3 newPosition = result.point;//点击的点的位置
                      if(item.product.position == PositionTop) {
                          if([itemInfo.dx intValue] != 0) {
                              if ([itemInfo.dx intValue] > 0){
                                  objectPosition.x = wall.transformBounds.min.x + (mModel.selectedObject.transformBounds.max.x - mModel.selectedObject.transformBounds.min.x)/2;
                                  newPosition.x = objectPosition.x + 0.01f;//避免抖动 在同平面移动
                              }else {
                                  objectPosition.x = wall.transformBounds.min.x - (mModel.selectedObject.transformBounds.max.x - mModel.selectedObject.transformBounds.min.x)/2;
                                  newPosition.x = objectPosition.x - 0.01f;//避免抖动 在同平面移动
                              }
                          }else if ([itemInfo.dz intValue] != 0){
                              if ([itemInfo.dz intValue] > 0){
                                  objectPosition.z = wall.transformBounds.min.z + (mModel.selectedObject.transformBounds.max.z - mModel.selectedObject.transformBounds.min.z)/2;
                                  newPosition.z = objectPosition.z + 0.01f;//避免抖动 在同平面移动
                              }else {
                                  objectPosition.z = wall.transformBounds.min.z - (mModel.selectedObject.transformBounds.max.z - mModel.selectedObject.transformBounds.min.z)/2;
                                  newPosition.z = objectPosition.z - 0.01f;//避免抖动 在同平面移动
                              }
                          }
                      }else if(item.product.position == PositionInWall) {
                          if([itemInfo.dx intValue] != 0) {
                              newPosition.x = objectPosition.x;//避免抖动 在同平面移动
                          }else if ([itemInfo.dz intValue] != 0){
                              newPosition.z = objectPosition.z;//避免抖动 在同平面移动
                          }
                      }
                      newPosition.y = 0.01f;
                      [mModel.selectedObject.transform setPosition:newPosition inSpace:JWTransformSpaceWorld];
                      mModel.currentPlan.sceneDirty = YES;
                      if (tempWall != wall) {
                          JCVector3 selectObjZ = [mModel.selectedObject.transform zAxisInSpace:JWTransformSpaceWorld];
                          float d = JCVector3DotProductv(&normal, &selectObjZ);
                          if (d > 1.0f) {
                              d = 1.0f;
                          }else if (d < -1.0f) {
                              d = -1.0f;
                          }
                          float radians = acosf(d);
                          float degrees = JCRad2Deg(radians); // 旋转的角度
                          
                          ItemInfo *now = [Data getItemInfoFromInstance:wall];
                          JCVector3 nowNormal = JCVector3Make([now.dx floatValue], [now.dy floatValue], [now.dz floatValue]);
                          JCVector3 cn = JCVector3CrossProductv(&selectObjZ, &nowNormal);
                          if (cn.y < 0.0f) {
                              degrees = -degrees;
                          }
                          [mModel.selectedObject.transform rotateUpDegrees:degrees+180 inSpace:JWTransformSpaceWorld];
                          tempWall = wall;
                          
                          // 设置贴墙
                          if(item.product.position == PositionGround) {
                              if([now.dx intValue] != 0) {
                                  if ([now.dx intValue] > 0){
                                      newPosition.x += ((mModel.selectedObject.transformBounds.max.x - mModel.selectedObject.transformBounds.min.x)/2 + 0.01f);
                                  }else {
                                      newPosition.x -= ((mModel.selectedObject.transformBounds.max.x - mModel.selectedObject.transformBounds.min.x)/2 + 0.01f);
                                  }
                              }else if ([now.dz intValue] != 0){
                                  if ([now.dz intValue] > 0){
                                      newPosition.z += ((mModel.selectedObject.transformBounds.max.z - mModel.selectedObject.transformBounds.min.z)/2 + 0.01f);
                                  }else {
                                      newPosition.z -= ((mModel.selectedObject.transformBounds.max.z - mModel.selectedObject.transformBounds.min.z)/2 + 0.01f);
                                  }
                              }
                          }else if (item.product.position == PositionInWall) {
                              if([now.dx intValue] != 0) {
                                  if ([now.dx intValue] > 0){
                                      newPosition.x += 0.01f;
                                  }else {
                                      newPosition.x -= 0.01f;
                                  }
                              }else if ([now.dz intValue] != 0){
                                  if ([now.dz intValue] > 0){
                                      newPosition.z += 0.01f;
                                  }else {
                                      newPosition.z -= 0.01f;
                                  }
                              }
                          }
                          newPosition.y = 0.01f;
                          [mModel.selectedObject.transform setPosition:newPosition inSpace:JWTransformSpaceWorld];
                      }
                  }
              }
              mModel.currentScene.boundsQuery.mask = SelectedMaskAllItems | SelectedMaskAllArchs;
              id<JIBoundsQueryResult> resultBounds = [mModel.currentScene.boundsQuery getResultByBounds:mModel.selectedObject.transformBounds object:mModel.currentScene.root];
              JCVector3 selectedPosition = [mModel.selectedObject.transform positionInSpace:JWTransformSpaceWorld];
              if (result.numEntries > 0) { // 如果result中有值 说明有物件重叠
                  for (JWBoundsQueryResultEntry* boundsQ in resultBounds.entries) {
                      id<JIGameObject> overlapObj = boundsQ.object;
                      ItemInfo *wallInfo = [Data getItemInfoFromInstance:overlapObj];
                      if (wallInfo.type == ItemTypeWall) {
                          if ([wallInfo.dx integerValue] != 0) {
                              if ([wallInfo.dx integerValue] > 0) {
                                  selectedPosition.x = overlapObj.transformBounds.max.x + (mModel.selectedObject.transformBounds.max.x - mModel.selectedObject.transformBounds.min.x)/2 + 0.02f;
                              }else {
                                  selectedPosition.x = overlapObj.transformBounds.max.x - (mModel.selectedObject.transformBounds.max.x - mModel.selectedObject.transformBounds.min.x)/2 - 0.02f;
                              }
                          }else if ([wallInfo.dz integerValue] != 0) {
                              if ([wallInfo.dz integerValue] > 0) {
                                  selectedPosition.z = overlapObj.transformBounds.max.z + (mModel.selectedObject.transformBounds.max.z - mModel.selectedObject.transformBounds.min.z)/2 + 0.02f;
                              }else {
                                  selectedPosition.z = overlapObj.transformBounds.max.z - (mModel.selectedObject.transformBounds.max.z - mModel.selectedObject.transformBounds.min.z)/2 - 0.02f;
                              }
                          }
                      }
                      [mModel.selectedObject.transform setPosition:selectedPosition inSpace:JWTransformSpaceWorld];
                  }
              }
          }
    } else if (item.product.position == PositionTop) {
        id<JIGameScene> scene = mModel.currentScene; // 获取场景
        scene.rayQuery.willSortByDistance = YES;
        scene.rayQuery.mask = SelectedMaskAllItems | SelectedMaskAllArchs;
        id<JIRayQueryResult> result = [scene getCameraRayQueryResultFromScreenX:p.x screenY:p.y];
        id<JIGameObject> ceil = nil;
        for (int i = 0; i < result.numEntries; i++) {
            JWRayQueryResultEntry* e = [result entryAt:i];
            ItemInfo *itemInfo = [Data getItemInfoFromInstance:e.object];
            if (itemInfo.type == ItemTypeCeil) {
                ceil = e.object;
                break;
            }
        }
        if (ceil != nil) {
            ItemInfo *itemInfo = [Data getItemInfoFromInstance:ceil];
            JCVector2 cameraXY = [mModel.currentCamera.camera getCoordinatesFromScreenX:p.x screenY:p.y];
            JCRay3 ray = [mModel.currentCamera.camera getRayFromX:cameraXY.x screenY:cameraXY.y];
            JCVector3 normal = JCVector3Make([itemInfo.dx floatValue], [itemInfo.dy floatValue], [itemInfo.dz floatValue]);
            JCFloat distance = fabsf([itemInfo.dx floatValue] * ceil.transformBounds.min.x + [itemInfo.dy floatValue] * ceil.transformBounds.min.y + [itemInfo.dz floatValue] * ceil.transformBounds.min.z);//原点到平面的距离
            JCPlane ground = JCPlaneMake(normal, distance);//平面的位置
            JCRayPlaneIntersectResult result = JCRayPlaneIntersect(&ray, &ground);
            result.point = JCRayPlaneIntersectResultGetHitPoint(&result, &ray);
            if (result.hit) {
                JCVector3 objectPosition = [mModel.selectedObject.transform positionInSpace:JWTransformSpaceWorld];//物件在本身坐标系的位置
                JCVector3 newPosition = result.point;//点击的点的位置
                newPosition.y = objectPosition.y;
                [mModel.selectedObject.transform setPosition:newPosition inSpace:JWTransformSpaceWorld];
                mModel.currentPlan.sceneDirty = YES;
            }
        }
        
    }
    return YES;
}

- (BOOL)onScreenTouchUp:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    if (!mCanMove) {
        return YES;
    }
    if (mItemMoveCommand != nil) {
        //取到移动到的目标点
        mItemMoveCommand.plan = mModel.currentPlan;
        mItemMoveCommand.destPosition = [mItemMoveCommand.object.transform positionInSpace:JWTransformSpaceWorld];
        //用command记录并操作目标点的位置
        [mModel.commandMachine doneCommand:mItemMoveCommand];
        mItemMoveCommand = nil;
    }
    if (mOnItemEndMove != nil) {
        mOnItemEndMove(touch.position);
    }
    
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

- (ItemSelectAndMoveBehaviourOnItemEndMove)onItemEndMove {
    return mOnItemEndMove;
}

- (void)setOnItemEndMove:(ItemSelectAndMoveBehaviourOnItemEndMove)onItemEndMove {
    mOnItemEndMove = onItemEndMove;
}

@end
