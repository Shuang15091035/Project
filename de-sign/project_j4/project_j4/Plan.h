//
//  Plan.h
//  project_mesher
//
//  Created by MacMini on 15/10/18.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"
#import "PlanItem.h"

// 方案
@interface Plan : CCVSerializeObject

- (id)initWithModel:(id<IMesherModel>)model;

@property (nonatomic, readonly) id<ICVGameObject> architectureObject;
- (void) addObject:(id<ICVGameObject>)object; // 添加物件
- (void) removeObject:(id<ICVGameObject>)object; // 删除列表中的物件信息
- (void) destroyObject:(id<ICVGameObject>)object; // 删除物件
- (void) destroyAllObjects;
- (id<ICVGameObject>) loadSceneFile:(id<ICVFile>)file parent:(id<ICVGameObject>)parent params:(CCVSceneLoadParams *)params handler:(CCVSceneLoaderEventHandler *)handler cancellable:(id<ICVCancellable>)cancellable;
- (void) saveScene;
- (CCVAsyncResult*) loadItem:(Item*)item position:(CCCVector3)position orientation:(CCCQuaternion)orientation async:(BOOL)async listener:(id<ICVSceneLoaderOnLoadingListener>)listener;

- (void)showOverlap;

#pragma mark 物件重叠逻辑
- (void)itemOverlap:(id<ICVGameObject>)selectedObject;
- (void) addDecalsToObject:(id<ICVGameObject>)obj;
- (void) hidedDecals:(id<ICVGameObject>)obj;

@property (nonatomic, readwrite) id<IMesherModel> model;
@property (nonatomic, readwrite) NSMutableArray *objects;
@property (nonatomic, readwrite) NSInteger Id;
@property (nonatomic, readwrite) NSString* name;
@property (nonatomic, readwrite) id<ICVFile> preview; // 缩略图
@property (nonatomic, readwrite) id<ICVFile> scene; // 场景文件
@property (nonatomic, readwrite) NSInteger rooms;
@property (nonatomic, readwrite) BOOL isSuit; // 用于判断是否来自suit界面
@property (nonatomic, readwrite) BOOL isCreate; // 用于判断是否是新建的Plan

@property (nonatomic, readwrite) BOOL fileDirty; // 物件有改动
@property (nonatomic, readwrite) BOOL sceneDirty; // 场景有改动

@property (nonatomic, readonly) PlanOrder* order; // 报价单

@property (nonatomic, readwrite) PlanItem *serializedArchitectureItem;
@property (nonatomic, readwrite) NSMutableArray *serializedItems;
@property (nonatomic, readwrite) NSMutableArray *serializedArchitectureItems; // 保存户型节点下可用的子节点的数组

@end
