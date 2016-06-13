//
//  Plan.h
//  project_mesher
//
//  Created by MacMini on 15/10/18.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"
#import "PlanItem.h"
#import "PlanCamera.h"

typedef NS_ENUM(int, PlanType) {
    PlanType_UnKnown,
    PlanType_Suit,
    PlanType_Basic,
};

// 方案
@interface Plan : JWSerializeObject

- (id)initWithModel:(id<IMesherModel>)model;

@property (nonatomic, readonly) id<JIGameObject> architectureObject;
- (void) addObject:(id<JIGameObject>)object; // 添加物件
- (void) removeObject:(id<JIGameObject>)object; // 删除列表中的物件信息
- (void) destroyObject:(id<JIGameObject>)object; // 删除物件
- (void) destroyAllObjects;
- (id<JIGameObject>) loadSceneFile:(id<JIFile>)file parent:(id<JIGameObject>)parent params:(JWSceneLoadParams *)params handler:(JWSceneLoaderEventHandler *)handler cancellable:(id<JICancellable>)cancellable;
- (void) saveScene;
- (JWAsyncResult*) loadItem:(Item*)item position:(JCVector3)position orientation:(JCQuaternion)orientation async:(BOOL)async listener:(id<JISceneLoaderOnLoadingListener>)listener;

- (void)showOverlap;

#pragma mark 物件重叠逻辑
- (void)itemOverlap:(id<JIGameObject>)selectedObject;
- (void) addDecalsToObject:(id<JIGameObject>)obj;
- (void) hidedDecals:(id<JIGameObject>)obj;

@property (nonatomic, readwrite) id<IMesherModel> model;
@property (nonatomic, readwrite) NSMutableArray *objects;
@property (nonatomic, readwrite) NSInteger Id;
@property (nonatomic, readwrite) NSString* name;
@property (nonatomic, readwrite) PlanCamera *camera;
@property (nonatomic, readwrite) id<JIFile> preview; // 缩略图
@property (nonatomic, readwrite) id<JIFile> scene; // 场景文件
@property (nonatomic, readwrite) PlanType type;

@property (nonatomic, readwrite) NSInteger rooms;
@property (nonatomic, readwrite) BOOL isSuit; // 用于判断是否来自suit界面
@property (nonatomic, readwrite) BOOL isCreate; // 用于判断是否是新建的Plan

@property (nonatomic, readwrite) BOOL fileDirty; // 物件有改动
@property (nonatomic, readwrite) BOOL sceneDirty; // 场景有改动
@property (nonatomic, readwrite) BOOL fromAR; // 从AR状态回来

@property (nonatomic, readwrite) CGFloat architureHeight;//房型的高度

@property (nonatomic, readonly) PlanOrder* order; // 报价单
@property (nonatomic, readwrite) BOOL isCreatedPlan;

@property (nonatomic, readwrite) PlanItem *serializedArchitectureItem;
@property (nonatomic, readwrite) NSMutableArray *serializedItems;
@property (nonatomic, readwrite) NSMutableArray *serializedArchitectureItems; // 保存户型节点下可用的子节点的数组

#pragma mark inspiration相关
@property (nonatomic, readwrite) id<JIFile> inspirateBackground; // 设计场景的底照
@property (nonatomic, readwrite) float qw;
@property (nonatomic, readwrite) float qx;
@property (nonatomic, readwrite) float qy;
@property (nonatomic, readwrite) float qz;
//@property (nonatomic, readwrite) float height;
@property (nonatomic, readwrite) float cameraX;
@property (nonatomic, readwrite) float cameraY;
@property (nonatomic, readwrite) float cameraZ;

#pragma mark PlanCamera
@property (nonatomic, readwrite) PlanCamera *serializedPlanCamera;

//@property (nonatomic, readwrite) BOOL fromExchange;
//@property (nonatomic, readwrite) BOOL inspiratedCreate;

@end
