//
//  Plan.m
//  project_mesher
//
//  Created by MacMini on 15/10/18.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Plan.h"
#import "Data.h"
#import "Item.h"
#import "PlanItem.h"
#import "MesherModel.h"
#import <ctrlcv/CCVVector3.h>

@interface Plan () <ICVOnResourceLoadingListener> {
    id<IMesherModel> mModel;
    id<ICVGameObject> mRoot;
    id<ICVGameObject> mArchitectureObject;
    NSMutableArray* mObjects;
    PlanOrder* mOrder;
    
    NSInteger mId;
    NSString* mName;
    id<ICVFile> mPreview;
    id<ICVFile> mScene;
    
    id<ICVGameObject> mTempParentForSetNewPosition;
    BOOL mFileDirty;
    BOOL mSceneDirty;
    
    PlanItem *mSerializedArchitectureItem;
    NSMutableArray* mSerializedItems;
    NSMutableArray* mSerializedArchitectureItems;
    
    NSInteger mRooms;
    BOOL mIsSuit;
    BOOL mIsCreate;
    
    NSMutableArray *overlapObject; // 用于存放有相交的物件的数组
    id<ICVTexture> texture;
    id<ICVMaterial> material;
    id<ICVGameObject> archItem;
    id<ICVFile> decalsFile;
    NSMutableArray *decalsArray;
    
    NSString* tempExtension;
}

@property (nonatomic, readonly) id<ICVGameObject> root;

@end

@implementation Plan

- (id)initWithModel:(id<IMesherModel>)model {
    self = [super init];
    if (self != nil) {
        mModel = model;
    }
    return self;
}


- (void)onDestroy {
    [self destroyAllObjects];
    [CCVCoreUtils destroyObject:mRoot];
    mRoot = nil;
    [mPreview deleteFile];
    // 将图片从缓存中删除
    [[CCVCorePluginSystem instance].imageCache removeBy:mPreview];
    mPreview = nil;
    [mScene deleteFile];
    mScene = nil;
    [super onDestroy];
}

@synthesize model = mModel;

- (id<ICVGameObject>)root {
    if (mRoot == nil) {
        id<ICVGameContext> context = mModel.currentContext;
        mRoot = [context createObject];
        mRoot.Id = [NSString stringWithFormat:@"plan_%@", @(self.hash)];
        mRoot.name = mRoot.Id;
        id<ICVGameScene> scene = mModel.currentScene;
        mRoot.parent = scene.root;
        mRoot.queryMask = [MesherModel CanNotSelectMask];
    }
    return mRoot;
}

@synthesize architectureObject = mArchitectureObject;

- (void)addObject:(id<ICVGameObject>)object {
    if (object == nil) {
        return;
    }
    Item* item = [Data getItemFromInstance:object];
    if (item == nil) {
        return;
    }
    Product* product = item.product;
    if (product == nil) {
        return;
    }
    if (product.area == AreaArchitecture) {
        if (mArchitectureObject != nil) {
            return;
        }
        mArchitectureObject = object;
        mArchitectureObject.parent = mRoot;
        return;
    }
    if (mObjects == nil) {
        mObjects = [NSMutableArray array];
    }
    if([mObjects addObject:object likeASet:YES willIngoreNil:NO]) {
        object.parent = mRoot;
        [self.order addItem:item];
        mSceneDirty = YES;
    }
}

- (void)removeObject:(id<ICVGameObject>)object {
    if (object == nil || mObjects == nil) {
        return;
    }
    Item* item = [Data getItemFromInstance:object];
    if (item == nil) {
        return;
    }
    if ([mObjects remove:object]) {
        object.parent = nil;
        [self.order removeItem:item];
        mSceneDirty = YES;
    }
}

- (void)destroyObject:(id<ICVGameObject>)object {
    if (object == nil || mObjects == nil) {
        return;
    }
    Item* item = [Data getItemFromInstance:object];
    if (item == nil) {
        return;
    }
    if ([mObjects remove:object]) {
        object.parent = nil;
        [self.order removeItem:item];
        [CCVCoreUtils destroyObject:object];
        mSceneDirty = YES;
    }
}

- (void)destroyAllObjects {
    [CCVCoreUtils destroyObject:mArchitectureObject];
    mArchitectureObject = nil;
    [CCVCoreUtils destroyArray:mObjects];
    mObjects = nil;
    [CCVCoreUtils destroyObject:mOrder];
    mOrder = nil;
    mSceneDirty = YES;
}

- (PlanOrder *)order {
    if (mOrder == nil) {
        mOrder = [[PlanOrder alloc] init];
    }
    return mOrder;
}

- (id<ICVGameObject>)loadSceneFile:(id<ICVFile>)file parent:(id<ICVGameObject>)parent params:(CCVSceneLoadParams *)params handler:(CCVSceneLoaderEventHandler *)handler cancellable:(id<ICVCancellable>)cancellable {
    NSError* error;
    NSString* json = mScene.stringData;
    [CCVJson fromJson:self serializeMethod:0 withString:json encoding:CCVEncodingUTF8 error:&error];
    if (error != nil) {
        return nil;
    }
    id<ICVGameObject> root = self.root;
    if (mSerializedArchitectureItem != nil) {
        [self loadPlanItem:mSerializedArchitectureItem];
    }
    if (mSerializedItems != nil) {
        for (PlanItem* planItem in mSerializedItems) {
            CCVAsyncResult* result = [self loadPlanItem:planItem];
            if (result != nil) {
                ItemInfo* itemInfo = [[ItemInfo alloc] init]; // 创建info对象
                itemInfo.type = ItemTypeItem; // 默认设置为物件
                id<ICVGameObject> gameObject = result.syncResult;
                [Data bindInstance:gameObject toItemInfo:itemInfo]; // 绑定对应物件
            }
        }
    }
    if (mSerializedArchitectureItems != nil) {
        for (PlanItem* planItem in mSerializedArchitectureItems) {
            archItem = [root objectForId:planItem.nodeId recursive:YES]; // 遍历数组中每一项的子节点
            if (archItem != nil) {
                ItemInfo* itemInfo = [[ItemInfo alloc] init];
                itemInfo.type = planItem.type;
                itemInfo.nodeId = planItem.nodeId;
                itemInfo.item = planItem.item;
                itemInfo.path = planItem.path;
                itemInfo.dx = planItem.dx;
                itemInfo.dy = planItem.dy;
                itemInfo.dz = planItem.dz;
                [Data bindInstance:archItem toItemInfo:itemInfo];// 绑定ItemInfo
                Item *it = [mModel.project getItemById:itemInfo.item.Id];
                if (it.source != nil) {
                    Source *s = it.source;
                    if (s != nil) {
                        tempExtension = s.file.extension;
                        s.file.extension = @"pvr";
                        if(!s.file.exists) {
                            s.file.extension = tempExtension;
                        }
                        [self loadTextureByFile:s.file];
                    }
                }
                archItem.queryMask = [MesherModel CanSelectMask]; // 设置对象可点击
            }
        }
    }
    mSceneDirty = NO;
    mFileDirty = NO;
    [mSerializedItems removeAllObjects]; // 使用完清空数组以便下次使用
    [mSerializedArchitectureItems removeAllObjects]; // 使用完清空数组以便下次使用
    return root;
}

- (void)loadTextureByFile:(id<ICVFile>)file {
    if (file != nil) {
        texture = (id<ICVTexture>)[mModel.currentContext.textureManager createFromFile:file];
        if (texture.isValid) {
            NSString *name = [NSString stringWithFormat:@"mat%@",@(texture.hash)];
            id<ICVFile> file = [CCVFile fileWithType:CCVFileTypeMemory path:name];
            material = (id<ICVMaterial>)[mModel.currentContext.materialManager createFromFile:file];
            material.diffuseTexture = texture;
            [material load]; // 重载material 刷新材质
            archItem.renderable.material = material;
        }else {
            texture.onLoad = self; // 设置代理
            [texture loadAsync:YES];
        }
        mModel.currentPlan.sceneDirty = YES;
    }
}

// 异步载入成功调用
- (void) onLoadResource:(id<ICVResource>)resource {
    texture = (id<ICVTexture>)resource;
    NSString *name = [NSString stringWithFormat:@"mat%@",@(texture.hash)];
    id<ICVFile> file = [CCVFile fileWithType:CCVFileTypeMemory path:name];
    material = (id<ICVMaterial>)[mModel.currentContext.materialManager createFromFile:file];
    material.diffuseTexture = texture;
    [material load]; // 重载material 刷新材质
    archItem.renderable.material = material;
    NSLog(@"载入成功");
}

// 异步载入失败调用
- (void) onFailedToLoadResource:(id<ICVResource>)resource {
    NSLog(@"加载失败");
}

- (CCVAsyncResult*)loadPlanItem:(PlanItem*)planItem {
    Item* item = planItem.item;
    if (item == nil) {
        //continue;
        NSLog(@"item is nil");
    }
    item = [mModel.project getItemById:item.Id];
    if (item.Id == 0) {
        // 第一个参数 异常的名称
        // 第二个参数 异常的原因
        // 第三个参数 nil 暂时
        @throw [NSException exceptionWithName:@"item id invalid" reason:@"item id is 0 or not found" userInfo:nil];
    }
    
    CCCVector3 position = CCCVector3Make(planItem.px.floatValue, planItem.py.floatValue, planItem.pz.floatValue);
    CCCQuaternion orientation = CCCQuaternionMake(planItem.rw.floatValue, planItem.rx.floatValue, planItem.ry.floatValue, planItem.rz.floatValue);
    return [self loadItem:item position:position orientation:orientation async:NO listener:nil];
}

- (void)saveScene {
    NSError* error;
    NSString* json = [CCVJson toJson:self serializeMethod:0 encoding:CCVEncodingUTF8 error:&error];
    mScene.stringData = json;
    mFileDirty = YES;
}

- (CCVAsyncResult*)loadItem:(Item *)item position:(CCCVector3)position orientation:(CCCQuaternion)orientation async:(BOOL)async listener:(id<ICVSceneLoaderOnLoadingListener>)listener {
    id<ICVGameObject> root = self.root;//获取场景根结点
    if (item == nil) {
        if (listener != nil) {
            [listener onSceneFailLoadFile:nil parent:root error:nil];
        }
        return nil;
    }
    Source* source = item.source;
    if (source == nil || source.file == nil) {
        if (listener != nil) {
            [listener onSceneFailLoadFile:source.file parent:root error:nil];
        }
        return nil;
    }
    id<ICVFile> file = source.file;
    //提取model里的对象
    id<ICVGameContext> context = mModel.currentContext;//获取context对象
    id<ICVSceneLoader> loader = [context.sceneLoaderManager getLoaderForFile:file];//获取一个加载器
    
    // 让物件离地1cm
    if (position.y <= 0.0f && item.product.area != AreaArchitecture) {
        position.y = 0.01f;
    }
    
    if (mTempParentForSetNewPosition == nil) {
        mTempParentForSetNewPosition = [context createObject];
        mTempParentForSetNewPosition.parent = root;
        mTempParentForSetNewPosition.queryMask = [MesherModel CanNotSelectMask];
    }
    [mTempParentForSetNewPosition.transform setPositionV:position];
    
    //异步加载 创建监听
    CCVSceneLoaderOnLoadingListener* onLoadingListener = [[CCVSceneLoaderOnLoadingListener alloc] init];
//    onLoadingListener.onResourceLoaded = (^(id<ICVResource> resource) {
//        if (![resource conformsToProtocol:@protocol(ICVMesh)]) {
//            return;
//        }
//        
//        id<ICVMesh> mesh = (id<ICVMesh>)resource;
//        CCCVertexData vd = [mesh vertexData];
//        CCCVertexDeclaration vde = vd.declaration;
//        CCCVertexElement ve;
//        for (int i = 0; i < vde.numElements; i++) {
//            CCCVertexElement e = vde.elements[i];
//            if (e.semantic == CCCVertexSemanticPosition) {
//                ve = e;
//                break;
//            }
//        }
//        CCCUInt vs = CCCVertexDeclarationGetVertexSize(&vde);
//        NSMutableArray* positions = [NSMutableArray array];
//        for (int s = 0; s < vd.buffer.size; s += vs) {
//            float x = 0.0f;
//            CCCBufferGetFloatAt(&vd.buffer, s + ve.offset, &x);
//            float y = 0.0f;
//            CCCBufferGetFloatAt(&vd.buffer, s + ve.offset + sizeof(float), &y);
//            float z = 0.0f;
//            CCCBufferGetFloatAt(&vd.buffer, s + ve.offset + sizeof(float) * 2, &z);
//            CCVVector3* position = [CCVVector3 vectorWithX:x Y:y Z:z];
//            [positions add:position];
//        }
//        
//    });
    onLoadingListener.onObjectLoaded = (^(id<ICVGameObject> object) {
        if ([object.name startsWith:@"sd_"]) { // 如果是影子
            [object setBoundsEnabled:NO]; // 无视影子的bounds
        }
    });
    onLoadingListener.onFinish = (^(id<ICVFile> file, id<ICVGameObject> parent, id<ICVGameObject> object){
        object.parent = root; // 将节点接到原先的节点上
        [object.transform setPositionV:position];
        [object.transform setOrientationQ:orientation inSpace:CCVTransformSpaceLocal];
        [Data bindInstance:object toItem:item];
        if (item.product.area == AreaArchitecture) { // NOTE 户型不能点击或编辑
            [object setQueryMask:[MesherModel CanNotSelectMask] recursive:YES];
            mModel.gridsObject.visible = NO; // 户型加载后，默认把网格隐藏
        } else {
            [object setQueryMask:[MesherModel CanNotSelectMask] recursive:YES];
            object.queryMask = [MesherModel CanSelectMask];
        }
        [self addObject:object];
        mSceneDirty = YES;
        [listener onSceneFinishLoadFile:file parent:parent object:object];
    });
    onLoadingListener.onFailed = (^(id<ICVFile> file, id<ICVGameObject> parent, NSError* error){
        [listener onSceneFailLoadFile:file parent:parent error:error];
    });
    
    //加载器                     所要展示的对象
    return [loader loadFile:file parent:mTempParentForSetNewPosition params:nil async:async listener:onLoadingListener];
}

- (void)showOverlap {
    for (id<ICVGameObject> obj in mModel.currentPlan.objects) {
        [mModel.currentPlan itemOverlap:obj];
    }
}

- (void)itemOverlap:(id<ICVGameObject>)selectedObject {
    if (overlapObject == nil) {
        overlapObject = [NSMutableArray array];
    }
    Item *item = [Data getItemFromInstance:selectedObject];
    if (item.product.position == PositionOnItem) { // 判断item是否是在物件上的
        mModel.currentScene.boundsQuery.mask = [MesherModel CanSelectMask]; // 用于判断物件重叠 mask 设置判定的对象是可选中的对象
        id<ICVBoundsQueryResult> result = [mModel.currentScene.boundsQuery getResultByBounds:selectedObject.transformBounds object:mModel.currentScene.root]; // 把有重叠的对象放在一个result中
        CCCFloat height = 0.01f;
        CCCVector3 position = [selectedObject.transform positionInSpace:CCVTransformSpaceWorld]; // 取出选中对象的位置信息
        if (result.numEntries > 0) { // 如果result中有值 说明有物件重叠
            for (CCVBoundsQueryResultEntry* boundsQ in result.entries) {
                id<ICVGameObject> overlapObj = boundsQ.object;
                CCCFloat overlapObjHeight = overlapObj.transformBounds.max.y - overlapObj.transformBounds.min.y; // 获取重叠对象的高度
                if (overlapObjHeight > height) { // 取出最高的高度
                    height = overlapObjHeight;
                    position.y = height + 0.01f; // 将物件的高度抬到重叠物件上 额外添加一点高度放置重叠
                }
            }
            [selectedObject.transform setPositionV:position inSpace:CCVTransformSpaceWorld]; // 重新定位物件的位置
        } else {
            [mModel.selectedObject.transform setPositionX:selectedObject.transformBounds.min.x Y:0.01 Z:selectedObject.transformBounds.min.z inSpace:CCVTransformSpaceWorld]; // 如果result中没有对象 说明物件没有重叠 将物件调到地面
        }
    }else if (item.product.position == PositionGround) { // 判断item是否是在地面上的
        for (id<ICVGameObject> obj in mModel.currentPlan.objects) { // 遍历所有物件
            Item *it = [Data getItemFromInstance:obj];
            if (obj == selectedObject) { // 排除自己
                continue;
            }
            if (it.product.position == PositionOnItem || it.product.position == PositionGround) { // 将标识有 在物件上 和 在地面的 物件取出
                if ([selectedObject queryByObject:obj]) { // 进行叠加判定
                    [overlapObject add:obj]; // 有叠加的存入数组
                }
            }
        }
        CCCFloat selectedHeight = selectedObject.transformBounds.max.y - selectedObject.transformBounds.min.y;
        if (overlapObject.count > 0) { // 有叠加
            for (id<ICVGameObject> overlapObj in overlapObject) {
                Item *it = [Data getItemFromInstance:overlapObj]; // 将叠加的对象转换成item
                if (it.product.position == PositionOnItem) { // 如果叠加的物件是 在物件上 的
                    CCCVector3 position = [overlapObj.transform positionInSpace:CCVTransformSpaceWorld]; // 取出原先的位置信息
                    position.y = selectedHeight; // 将高度抬高到选中物件的高度
                    [overlapObj.transform setPositionV:position inSpace:CCVTransformSpaceWorld]; // 重新赋值改变高度
                }else if (it.product.position == PositionGround) { // 如果叠加的物件是 在地面 的
                    ItemInfo *overlapObjInfo = [Data getItemInfoFromInstance:overlapObj]; // 将叠加的对象转换成相应的itemInfo
                    if (!overlapObjInfo.isOverlap) { // 叠加物件默认是没有标识的 防止重复赋值覆盖了原始信息
                        //[self enumChildrenUsing:overlapObj]; // 取出原始的material信息
                        [self addDecalsToObject:overlapObj];
                    }
                    overlapObjInfo.isOverlap = YES; // 给予叠加标识
                    
                    ItemInfo *selectedObjectInfo = [Data getItemInfoFromInstance:selectedObject]; //将选中的对象转换成itemInfo
                    if (!selectedObjectInfo.isOverlap) { // 选中默认是没有标识的 防止重复赋值覆盖了原始信息
                        //[self enumChildrenUsing:selectedObject]; // 取出原始的material信息
                        [self addDecalsToObject:selectedObject];

                    }
                    selectedObjectInfo.isOverlap = YES; // 给予叠加标识
                }
            }
        }else { // 无叠加
            NSMutableArray *objOnItem = [NSMutableArray array]; // 存放之前叠加的 在物件上 的数组
            NSMutableArray *objOnGround = [NSMutableArray array]; // 存放之前叠加的 在地面 的数组
            mModel.currentScene.objectQuery.mask = [MesherModel CanSelectMask]; // objectQuery用于判断物件重叠 mask 设置判定的对象是可选中的对象
            for (id<ICVGameObject> obj in mModel.currentPlan.objects) {
                Item *it = [Data getItemFromInstance:obj];
                if (it.product.position == PositionOnItem && obj != selectedObject && obj.transformBounds.min.y > 0.02f) { // 判断 在物件上 对象的逻辑
                    id<ICVObjectQueryResult> result = [mModel.currentScene.objectQuery getResultByObject:obj inObject:mModel.currentScene.root]; // 把有重叠的对象放在一个result中
                    if (result.numEntries == 0) {
                        [objOnItem add:obj];
                    }
                } else if (it.product.position == PositionGround && obj != selectedObject) {
                    ItemInfo *info = [Data getItemInfoFromInstance:obj];
                    if (info.isOverlap) {
                        // 先找到场景中所有有叠加的对象
                        id<ICVObjectQueryResult> result = [mModel.currentScene.objectQuery getResultByObject:obj inObject:mModel.currentScene.root]; // 把有重叠的对象放在一个result中
                        if (result.numEntries == 0) {
                            [objOnGround add:obj]; // 将没有叠加的对象放入数组
                        }
                        // 同时需要对自己本身判断
                        id<ICVObjectQueryResult> selectResult = [mModel.currentScene.objectQuery getResultByObject:selectedObject inObject:mModel.currentScene.root];
                        if (selectResult.numEntries == 0) {
                            [objOnGround add:selectedObject]; // 如果没有重叠也要放入数组
                        }
                    }
                }
            }
            if (objOnItem.count > 0) { // 对于 在物件上 无重叠对象的处理
                for (id<ICVGameObject> obj in objOnItem) {
                    // 放置到地上
                    CCCVector3 position = [obj.transform positionInSpace:CCVTransformSpaceWorld];
                    position.y = 0.01f;
                    [obj.transform setPositionV:position inSpace:CCVTransformSpaceWorld];
                }
            }
            if (objOnGround.count > 0) { // 对于 在地面 无重叠对象的处理
                for (id<ICVGameObject> obj in objOnGround) {
                    // 颜色还原 标识设置为NO
                    ItemInfo *info = [Data getItemInfoFromInstance:obj];
                    if (info.isOverlap) { // 之前有标记的 说明需要还原材质
                        //[self resetMaterial:obj]; // 还原材质
                        [self hidedDecals:obj];
                        info.isOverlap = NO;
                    }
                }
            }
        }
        [overlapObject removeAllObjects];
    }
}

- (void) addDecalsToObject:(id<ICVGameObject>)obj {
    if (decalsFile == nil) {
        decalsFile = [CCVFile fileWithBundle:[NSBundle mainBundle] path:[CCVResourceBundle nameForDrawable:@"overlap_rect_frame.png"]];
    }
    if (decalsArray == nil) {
        decalsArray = [NSMutableArray array];
    }
    BOOL isFind = false;
    for (CCVRect4CornersDecals *decals in decalsArray) {
        if (decals.decalsObject.visible == NO) {
            CCCBounds3 objectBounds = obj.scaleBounds;
            CCCVector3 objectSize = CCCBounds3GetSize(&objectBounds);
            [decals updateInnerWidth:objectSize.x innerHeight:objectSize.z];
            [decals.decalsObject.transform reset:NO];
            decals.decalsObject.parent = obj;
            [decals.decalsObject.transform translateX:0.0f Y:0.01f Z:0.0f]; // 防止z-fighting
            decals.decalsObject.visible = YES;
            isFind = YES;
            break;
        }
    }
    if (isFind == NO) {
        CCVRect4CornersDecals *decals = [[CCVRect4CornersDecals alloc] initWithContext:mModel.currentContext parent:mModel.currentScene.root innerWidth:1.0f innerHeight:1.0f cornerOffsetX:0.5f cornerOffsetY:0.5f thickness:0.05f cornerOffsetU:0.0f cornerOffsetV:0.0f uvThickness:0.346f decalsFile:decalsFile];
        decals.decalsObject.queryMask = [MesherModel CanNotSelectMask];
        [decals.decalsObject.transform setInheritScale:NO];
        CCCBounds3 objectBounds = obj.scaleBounds;
        CCCVector3 objectSize = CCCBounds3GetSize(&objectBounds);
        [decals updateInnerWidth:objectSize.x innerHeight:objectSize.z];
        [decals.decalsObject.transform reset:NO];
        decals.decalsObject.parent = obj;
        [decals.decalsObject.transform translateX:0.0f Y:0.02f Z:0.0f]; // 防止z-fighting
        decals.decalsObject.visible = YES;
        [decalsArray add:decals];
    }
}

- (void) hidedDecals:(id<ICVGameObject>)obj {
    for (CCVRect4CornersDecals *decals in decalsArray) {
        if (decals.decalsObject.parent == obj) {
            decals.decalsObject.parent = nil;
            decals.decalsObject.visible = NO;
        }
    }
}

- (void)enumChildrenUsing:(id<ICVGameObject>)obj {
    [obj.transform enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<ICVTransform> transform = obj;
        id<ICVGameObject> child = transform.host; //host表示transform的属于者
        NSString *name = [NSString stringWithFormat:@"material_%@",@(child.hash)];
        id<ICVMaterial> mater = [child.renderable.material copyInstanceWithName:name];
        ObjectExtra *extra = child.extra;
        if (extra == nil) {
            extra = [ObjectExtra new];
        }
        extra.archMaterial = mater;
        child.extra = extra;
        [self enumChildrenUsing:child];
    }];
}

- (void)changeChildColor:(id<ICVGameObject>)obj And:(CCCColor)color {
    [obj.transform enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<ICVTransform> transform = obj;
        id<ICVGameObject> child = transform.host; //host表示transform的属于者
        NSString *name = [NSString stringWithFormat:@"material__%@",@(child.renderable.material.hash)];
        id<ICVMaterial> mater = [child.renderable.material copyInstanceWithName:name];
        mater.diffuseColor = color;
        child.renderable.material = mater;
        [self changeChildColor:child And:color];
    }];
}

- (void)resetMaterial:(id<ICVGameObject>)obj {
    [obj.transform enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<ICVTransform> transform = obj;
        id<ICVGameObject> child = transform.host; //host表示transform的属于者
        ObjectExtra *extra = child.extra;
        id<ICVMaterial> mater = extra.archMaterial;
        child.renderable.material = mater;
        [self resetMaterial:child];
    }];
}

#pragma mark 对象重叠算法逻辑 可能暂时不用
- (BOOL)findOverlapObject:(id<ICVGameObject>)objectA AndB:(id<ICVGameObject>)objectB {
    /*
     dobj  b2d  bobj
     
     d2a   cen  c2b
     
     aobj  a2c  cobj
     */
    CCCVector3 aobj = objectA.transformBounds.min;
    CCCVector3 bobj = objectA.transformBounds.max;
    CCCVector3 cobj = CCCVector3Make(aobj.x, aobj.y, bobj.z);
    CCCVector3 dobj = CCCVector3Make(bobj.x, aobj.y, aobj.z);
    CCCVector3 cenA = CCCVector3Make((bobj.x - aobj.x)/2 , aobj.y, (bobj.z - aobj.z)/2);
    
    CCCVector3 a_over = objectB.transformBounds.min;
    CCCVector3 b_over = objectB.transformBounds.max;
    CCCVector3 c_over = CCCVector3Make(a_over.x, a_over.y, b_over.z);
    CCCVector3 d_over = CCCVector3Make(b_over.x, a_over.y, a_over.z);
    CCCVector3 cenB = CCCVector3Make((b_over.x - a_over.x)/2, a_over.y, (b_over.z - a_over.z)/2);
    
    BOOL overlapA = aobj.x > objectB.transformBounds.min.x && aobj.x < objectB.transformBounds.max.x && aobj.z > objectB.transformBounds.min.z && aobj.z < objectB.transformBounds.max.z;
    BOOL overlapB = bobj.x > objectB.transformBounds.min.x && bobj.x < objectB.transformBounds.max.x && bobj.z > objectB.transformBounds.min.z && bobj.z < objectB.transformBounds.max.z;
    BOOL overlapC = cobj.x > objectB.transformBounds.min.x && cobj.x < objectB.transformBounds.max.x && cobj.z > objectB.transformBounds.min.z && cobj.z < objectB.transformBounds.max.z;
    BOOL overlapD = dobj.x > objectB.transformBounds.min.x && dobj.x < objectB.transformBounds.max.x && dobj.z > objectB.transformBounds.min.z && dobj.z < objectB.transformBounds.max.z;
    BOOL overlapCen = cenA.x > objectB.transformBounds.min.x && cenA.x < objectB.transformBounds.max.x && cenA.z > objectB.transformBounds.min.z && cenA.z < objectB.transformBounds.max.z;
    
    BOOL overlapA_over = a_over.x > objectA.transformBounds.min.x && a_over.x < objectA.transformBounds.max.x && a_over.z > objectA.transformBounds.min.z && a_over.z < objectA.transformBounds.max.z;
    BOOL overlapB_over = b_over.x > objectA.transformBounds.min.x && b_over.x < objectA.transformBounds.max.x && b_over.z > objectA.transformBounds.min.z && b_over.z < objectA.transformBounds.max.z;
    BOOL overlapC_over = c_over.x > objectA.transformBounds.min.x && c_over.x < objectA.transformBounds.max.x && c_over.z > objectA.transformBounds.min.z && c_over.z < objectA.transformBounds.max.z;
    BOOL overlapD_over = d_over.x > objectA.transformBounds.min.x && d_over.x < objectA.transformBounds.max.x && d_over.z > objectA.transformBounds.min.z && d_over.z < objectA.transformBounds.max.z;
    BOOL overlapCen_over = cenB.x > objectA.transformBounds.min.x && cenB.x < objectA.transformBounds.max.x && cenB.z > objectA.transformBounds.min.z && cenB.z < objectA.transformBounds.max.z;
    
    if (overlapA || overlapB || overlapC || overlapD || overlapA_over || overlapB_over || overlapC_over || overlapD_over || overlapCen || overlapCen_over) {
        return YES;
    } else {
        return NO;
    }
}

@synthesize objects = mObjects;

@synthesize Id = mId;
@synthesize name = mName;
@synthesize preview = mPreview;
@synthesize scene = mScene;

- (BOOL)sceneDirty {
    return mSceneDirty;
}

- (void)setSceneDirty:(BOOL)sceneDirty {
    mSceneDirty = sceneDirty;
}

- (BOOL)fileDirty {
    return mFileDirty;
}

- (void)setFileDirty:(BOOL)fileDirty {
    mFileDirty = fileDirty;
}

- (PlanItem *)serializedArchitectureItem {
    if (mArchitectureObject == nil) {
        return nil;
    }
    if (mSerializedArchitectureItem == nil) {
        mSerializedArchitectureItem = [[PlanItem alloc] init];
    }
    mSerializedArchitectureItem.item = [Data getItemFromInstance:mArchitectureObject];
    mSerializedArchitectureItem.object = mArchitectureObject;
    return mSerializedArchitectureItem;
}

- (void)setSerializedArchitectureItem:(PlanItem *)serializedArchitectureItem {
    mSerializedArchitectureItem = serializedArchitectureItem;
}

- (NSMutableArray *)serializedItems {
    if (mObjects == nil) {
        return nil;
    }
    if (mSerializedItems == nil) {
        mSerializedItems = [NSMutableArray array];
    }
    [mSerializedItems clear];
    for (id<ICVGameObject> object in mObjects) {
        Item *it = [Data getItemFromInstance:object];
        PlanItem *pit = [[PlanItem alloc] init];
        pit.item = it;
        pit.object = object;
        [mSerializedItems add:pit];
    }
    return mSerializedItems;
}

- (void)setSerializedItems:(NSMutableArray *)serializedItems {
    mSerializedItems = serializedItems;
}

- (NSMutableArray *)serializedArchitectureItems {
    if (mArchitectureObject == nil) {
        return nil;
    }
    if (mSerializedArchitectureItems == nil) {
        mSerializedArchitectureItems = [NSMutableArray array];
    }
    [mSerializedArchitectureItems clear];
    [self addSerializedArchitectureItems:mArchitectureObject]; // 从户型的object中查找子的object
    return mSerializedArchitectureItems;
}

- (void) addSerializedArchitectureItems:(id<ICVGameObject>)gameObject {
    // 递归查找子类的object
    ItemInfo* itemInfo = [Data getItemInfoFromInstance:gameObject];
    if (itemInfo != nil) {
        switch (itemInfo.type) {
            case ItemTypeWall:
            case ItemTypeFloor:
            case ItemTypeCeil: {
                PlanItem *pit = [[PlanItem alloc] init];
                pit.type = itemInfo.type;
                pit.nodeId = itemInfo.nodeId;
                pit.item = itemInfo.item;
                pit.path = itemInfo.path;
                pit.dx = itemInfo.dx;
                pit.dy = itemInfo.dy;
                pit.dz = itemInfo.dz;
                [mSerializedArchitectureItems add:pit];
                break;
            }
            default:
                break;
        }
    }
    [gameObject.transform enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        // 内置了结束条件
        id<ICVTransform> transform = obj;
        id<ICVGameObject> child = transform.host; //host表示transform的属于者
        [self addSerializedArchitectureItems:child]; // 递归调用自己
    }];
}

- (void)setSerializedArchitectureItems:(NSMutableArray *)serializedArchitectureItems {
    mSerializedArchitectureItems = serializedArchitectureItems;
}

@synthesize rooms = mRooms;
@synthesize isSuit = mIsSuit;
@synthesize isCreate = mIsCreate;

- (NSDictionary *)serializeMembers {
    return @{
             @"arc": [CCVSerializeInfo objectWithName:@"serializedArchitectureItem" objClass:[PlanItem class]],
             @"its": [CCVSerializeInfo arrayWithName:@"serializedItems" arrayClass:[NSMutableArray class] itemClass:[PlanItem class]],
             @"ars": [CCVSerializeInfo arrayWithName:@"serializedArchitectureItems" arrayClass:[NSMutableArray class] itemClass:[PlanItem class]],
             };
}

@end
