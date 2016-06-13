//
//  inspiratedPlan.h
//  project_mesher
//
//  Created by mac zdszkj on 16/4/6.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"
#import "PlanItem.h"
#import "Plan.h"

@interface InspiratedPlan : Plan

@property (nonatomic, readwrite) id<IMesherModel> model;
//@property (nonatomic, readwrite) NSMutableArray *objects;
//@property (nonatomic, readwrite) NSInteger Id;
//@property (nonatomic, readwrite) NSString* name;
//@property (nonatomic, readwrite) id<JIFile> preview; // 缩略图
//@property (nonatomic, readwrite) id<JIFile> scene; // 场景文件
//@property (nonatomic, readwrite) id<JIFile> inspirateBackground; // 设计场景的底照
//@property (nonatomic, readwrite) float qw;
//@property (nonatomic, readwrite) float qx;
//@property (nonatomic, readwrite) float qy;
//@property (nonatomic, readwrite) float qz;

//@property (nonatomic, readonly) PlanOrder* order; // 报价单

//@property (nonatomic, readwrite) NSMutableArray *serializedItems;

- (id)initWithModel:(id<IMesherModel>)model;

- (void) addObject:(id<JIGameObject>)object; // 添加物件
- (void) removeObject:(id<JIGameObject>)object; // 删除列表中的物件信息
- (void) destroyObject:(id<JIGameObject>)object; // 删除物件
- (void) destroyAllObjects;

- (id<JIGameObject>) loadSceneFile:(id<JIFile>)file parent:(id<JIGameObject>)parent params:(JWSceneLoadParams *)params handler:(JWSceneLoaderEventHandler *)handler cancellable:(id<JICancellable>)cancellable;
- (void) saveScene;
- (JWAsyncResult*) loadItem:(Item*)item position:(JCVector3)position orientation:(JCQuaternion)orientation async:(BOOL)async listener:(id<JISceneLoaderOnLoadingListener>)listener;

@end
