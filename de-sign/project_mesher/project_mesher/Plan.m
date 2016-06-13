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
#import <jw/JWVector3.h>
#import "GamePhotographer.h"

@interface Plan () <JIOnResourceLoadingListener> {
    id<IMesherModel> mModel;
    id<JIGameObject> mRoot;
    id<JIGameObject> mArchitectureObject;
    NSMutableArray* mObjects;
    PlanOrder* mOrder;
    
    NSInteger mId;
    NSString* mName;
    PlanCamera *mCamera;
    id<JIFile> mPreview;
    id<JIFile> mScene;
    PlanType mType;
    
    id<JIGameObject> mTempParentForSetNewPosition;
    BOOL mFileDirty;
    BOOL mSceneDirty;
    BOOL mFromAR;
    
    PlanItem *mSerializedArchitectureItem;
    NSMutableArray* mSerializedItems;
    NSMutableArray* mSerializedArchitectureItems;
    
    NSInteger mRooms;
    BOOL mIsSuit;
    BOOL mIsCreate;
    
    
    NSMutableArray *overlapObject; // 用于存放有相交的物件的数组
    id<JITexture> texture;
    id<JIMaterial> material;
    id<JIGameObject> archItem;
    id<JIFile> decalsFile;
    NSMutableArray *decalsArray;
    
    NSString* tempExtension;
    CGFloat mArchitureHeight;
    BOOL mIsCreatedPlan;
    //    BOOL mFromExchange;
    //    BOOL mInspiratedCreate;
    
    PlanCamera *mSerializedPlanCamera;
}

@property (nonatomic, readonly) id<JIGameObject> root;

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
    [JWCoreUtils destroyObject:mRoot];
    mRoot = nil;
    [mPreview deleteFile];
    // 将图片从缓存中删除
    [[JWCorePluginSystem instance].imageCache removeBy:mPreview];
    mPreview = nil;
    [mScene deleteFile];
    mScene = nil;
    [super onDestroy];
}

@synthesize model = mModel;
@synthesize architureHeight = mArchitureHeight;
@synthesize isCreatedPlan = mIsCreatedPlan;

- (id<JIGameObject>)root {
    if (mRoot == nil) {
        id<JIGameContext> context = mModel.currentContext;
        mRoot = [context createObject];
        mRoot.Id = [NSString stringWithFormat:@"plan_%@", @(self.hash)];
        mRoot.name = mRoot.Id;
        id<JIGameScene> scene = mModel.world.currentScene;
        mRoot.parent = scene.root;
        mRoot.queryMask = SelectedMaskCannotSelect;
    }
    return mRoot;
}

@synthesize architectureObject = mArchitectureObject;

- (void)addObject:(id<JIGameObject>)object {
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

- (void)removeObject:(id<JIGameObject>)object {
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

- (void)destroyObject:(id<JIGameObject>)object {
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
        [JWCoreUtils destroyObject:object];
        mSceneDirty = YES;
    }
}

- (void)destroyAllObjects {
    [JWCoreUtils destroyObject:mArchitectureObject];
    mArchitectureObject = nil;
    [JWCoreUtils destroyArray:mObjects];
    mObjects = nil;
    [JWCoreUtils destroyObject:mOrder];
    mOrder = nil;
    mSceneDirty = YES;
}

- (PlanOrder *)order {
    if (mOrder == nil) {
        mOrder = [[PlanOrder alloc] init];
    }
    return mOrder;
}

- (id<JIGameObject>)loadSceneFile:(id<JIFile>)file parent:(id<JIGameObject>)parent params:(JWSceneLoadParams *)params handler:(JWSceneLoaderEventHandler *)handler cancellable:(id<JICancellable>)cancellable {
    NSError* error;
    NSString* json = mScene.stringData;
    [JWJson fromJson:self serializeMethod:0 withString:json encoding:JWEncodingUTF8 error:&error];
    if (error != nil) {
        return nil;
    }
    id<JIGameObject> root = self.root;
    if (mSerializedArchitectureItem != nil) {
        [self loadPlanItem:mSerializedArchitectureItem];
    }
    if (mSerializedItems != nil) {
        for (PlanItem* planItem in mSerializedItems) {
            JWAsyncResult* result = [self loadPlanItem:planItem];
            if (result != nil) {
                ItemInfo* itemInfo = [[ItemInfo alloc] init]; // 创建info对象
                itemInfo.type = ItemTypeItem; // 默认设置为物件
                itemInfo.st = planItem.st;
                itemInfo.ts = planItem.ts;
                itemInfo.sc = planItem.sc;
                id<JIGameObject> gameObject = result.syncResult;
//                JCVector3 scale = gameObject.transform.scale;
                itemInfo.originScale = gameObject.transform.scale;
                [Data bindInstance:gameObject toItemInfo:itemInfo]; // 绑定对应物件
                if (itemInfo.st != nil) {
                    JCVector3 stretchPivot = JCVector3Make([itemInfo.st.px floatValue], [itemInfo.st.py floatValue], [itemInfo.st.pz floatValue]);
                    JCVector3 stretch = JCVector3Make([itemInfo.st.ox floatValue], [itemInfo.st.oy floatValue], [itemInfo.st.oz floatValue]);
                    gameObject.stretch = JCStretchMake(stretchPivot, stretch);
                }
                if (itemInfo.ts != nil) {
                    NSMutableDictionary *materialsDictionary = [NSMutableDictionary dictionary];
                    [gameObject enumRenderableUsing:^(id<JIRenderable> renderable, NSUInteger idx, BOOL *stop) {
                        if ([renderable.host.name startsWith:@"sd_"]) {
                            return;
                        }
                        if (renderable.host == mModel.itemRectFrameDecals.decalsObject) {
                            return;
                        }
                        if (renderable.host == mModel.itemOverlapDecals.decalsObject) {
                            return;
                        }
                        id<JIMaterial> mat = [renderable.material copyInstanceWithName:[NSString stringWithFormat:@"%@%@",@(gameObject.hash),renderable.host.name]];
                        id<JITexture> dif = [mat.diffuseTexture copyInstance];
                        mat.diffuseTexture = dif;
                        [materialsDictionary setObject:mat forKey:[NSString stringWithFormat:@"%@",@(renderable.hash)]];
                    }];
                    [gameObject enumRenderableUsing:^(id<JIRenderable> renderable, NSUInteger idx, BOOL *stop) {
                        if ([renderable.host.name startsWith:@"sd_"]) {
                            return;
                        }
                        if (renderable.host == mModel.itemRectFrameDecals.decalsObject) {
                            return;
                        }
                        if (renderable.host == mModel.itemOverlapDecals.decalsObject) {
                            return;
                        }
                        id<JIMaterial> mat = [materialsDictionary valueForKey:[NSString stringWithFormat:@"%@",@(renderable.hash)]];
                        if (mat == nil) {
                            return;
                        }
                        id<JITexture> diffuse = mat.diffuseTexture;
                        diffuse.tilingOffset = JCTilingOffsetMake([itemInfo.ts.tx floatValue], [itemInfo.ts.ty floatValue], 0.0f, 0.0f);
                        renderable.material = mat;
                    }];
                }
                if (itemInfo.sc != nil) {
                    JCVector3 scale = JCVector3Make([itemInfo.sc.sx floatValue], [itemInfo.sc.sx floatValue], [itemInfo.sc.sx floatValue]);
                    JCVector3 originScale = itemInfo.originScale;
                    JCVector3 newScale = JCVector3Mulv(&originScale, &scale);
                    gameObject.transform.scale = newScale;
                }
            }
        }
    }
    if (mSerializedArchitectureItems != nil) {
        CGFloat ceilHeight = 0.0f;
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
                archItem.queryMask = 0x1 << itemInfo.type;
                [Data bindInstance:archItem toItemInfo:itemInfo];// 绑定ItemInfo
                if (itemInfo.type == ItemTypeCeil) {
                    CGFloat ceilY = archItem.transformBoundsByStretch.max.y;
                    if (ceilY > ceilHeight) {
                        ceilHeight = ceilY;
                    }
                }
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
                //archItem.queryMask = SelectedMaskArch; // 设置对象可点击
            }
        }
        mArchitureHeight = ceilHeight;
    }
    mSceneDirty = NO;
    mFileDirty = NO;
    [mSerializedItems removeAllObjects]; // 使用完清空数组以便下次使用
    [mSerializedArchitectureItems removeAllObjects]; // 使用完清空数组以便下次使用
    return root;
}

- (void)loadTextureByFile:(id<JIFile>)file {
    if (file != nil) {
        texture = (id<JITexture>)[mModel.currentContext.textureManager createFromFile:file];
        if (texture.isValid) {
            NSString *name = [NSString stringWithFormat:@"mat%@",@(texture.hash)];
            id<JIFile> file = [JWFile fileWithType:JWFileTypeMemory path:name];
            material = (id<JIMaterial>)[mModel.currentContext.materialManager createFromFile:file];
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
- (void) onLoadResource:(id<JIResource>)resource {
    texture = (id<JITexture>)resource;
    NSString *name = [NSString stringWithFormat:@"mat%@",@(texture.hash)];
    id<JIFile> file = [JWFile fileWithType:JWFileTypeMemory path:name];
    material = (id<JIMaterial>)[mModel.currentContext.materialManager createFromFile:file];
    material.diffuseTexture = texture;
    [material load]; // 重载material 刷新材质
    archItem.renderable.material = material;
    NSLog(@"载入成功");
}

// 异步载入失败调用
- (void) onFailedToLoadResource:(id<JIResource>)resource {
    NSLog(@"加载失败");
}

- (JWAsyncResult*)loadPlanItem:(PlanItem*)planItem {
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
    
    JCVector3 position = JCVector3Make(planItem.px.floatValue, planItem.py.floatValue, planItem.pz.floatValue);
    JCQuaternion orientation = JCQuaternionMake(planItem.rw.floatValue, planItem.rx.floatValue, planItem.ry.floatValue, planItem.rz.floatValue);
    return [self loadItem:item position:position orientation:orientation async:NO listener:nil];
}

- (void)saveScene {
    NSError* error;
    NSString* json = [JWJson toJson:self serializeMethod:0 encoding:JWEncodingUTF8 error:&error];
    mScene.stringData = json;
    mFileDirty = YES;
}

- (JWAsyncResult*)loadItem:(Item *)item position:(JCVector3)position orientation:(JCQuaternion)orientation async:(BOOL)async listener:(id<JISceneLoaderOnLoadingListener>)listener {
    id<JIGameObject> root = self.root;//获取场景根结点
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
    id<JIFile> file = source.file;
    //提取model里的对象
    id<JIGameContext> context = mModel.currentContext;//获取context对象
    id<JISceneLoader> loader = [context.sceneLoaderManager getLoaderForFile:file];//获取一个加载器
    
    // 让物件离地1cm
    if (position.y <= 0.0f && item.product.area != AreaArchitecture) {
        position.y = 0.01f;
    }
    
    if (mTempParentForSetNewPosition == nil) {
        mTempParentForSetNewPosition = [context createObject];
        mTempParentForSetNewPosition.parent = root;
        mTempParentForSetNewPosition.queryMask = SelectedMaskCannotSelect;
    }
    [mTempParentForSetNewPosition.transform setPosition:position];
    
    //异步加载 创建监听
    JWSceneLoaderOnLoadingListener* onLoadingListener = [[JWSceneLoaderOnLoadingListener alloc] init];
    //    onLoadingListener.onResourceLoaded = (^(id<JIResource> resource) {
    //        if (![resource conformsToProtocol:@protocol(JIMesh)]) {
    //            return;
    //        }
    //
    //        id<JIMesh> mesh = (id<JIMesh>)resource;
    //        CJWertexData vd = [mesh vertexData];
    //        CJWertexDeclaration vde = vd.declaration;
    //        CJWertexElement ve;
    //        for (int i = 0; i < vde.numElements; i++) {
    //            CJWertexElement e = vde.elements[i];
    //            if (e.semantic == CJWertexSemanticPosition) {
    //                ve = e;
    //                break;
    //            }
    //        }
    //        JCUInt vs = CJWertexDeclarationGetVertexSize(&vde);
    //        NSMutableArray* positions = [NSMutableArray array];
    //        for (int s = 0; s < vd.buffer.size; s += vs) {
    //            float x = 0.0f;
    //            JCBufferGetFloatAt(&vd.buffer, s + ve.offset, &x);
    //            float y = 0.0f;
    //            JCBufferGetFloatAt(&vd.buffer, s + ve.offset + sizeof(float), &y);
    //            float z = 0.0f;
    //            JCBufferGetFloatAt(&vd.buffer, s + ve.offset + sizeof(float) * 2, &z);
    //            JWVector3* position = [JWVector3 vectorWithX:x Y:y Z:z];
    //            [positions add:position];
    //        }
    //
    //    });
    
    if (!mModel.isTeachMove) {
        if (mModel.loadScene) {
            JWEditorCameraPrefab *camera = [mModel.photographer changeToEditorCamera:1000];
            PlanCamera *planCamera = mModel.currentPlan.camera;
            if (planCamera != nil) {
                JWTransform* transform = [[JWTransform alloc] initWithContext:mModel.currentContext];
                [transform setPosition:JCVector3Make(planCamera.px, planCamera.py, planCamera.pz)];
                [transform setOrientation:JCQuaternionMake(planCamera.rw, planCamera.rx, planCamera.ry, planCamera.rz) inSpace:JWTransformSpaceLocal];
                [camera adjustCameraTransform:transform];
            }else {
                [camera setYaw:160.0f];
                [camera setPicth:-60.0f];
                [camera setZoom:10.0f];
            }
        }
    }
    onLoadingListener.onObjectLoaded = (^(id<JIGameObject> object) {
        if ([object.name startsWith:@"sd_"]) { // 如果是影子
            [object setBoundsEnabled:NO]; // 无视影子的bounds
        }
    });
    onLoadingListener.onFinish = (^(id<JIFile> file, id<JIGameObject> parent, id<JIGameObject> object){
        object.parent = root; // 将节点接到原先的节点上
        [object.transform setPosition:position];
        [object.transform setOrientation:orientation inSpace:JWTransformSpaceLocal];
        [Data bindInstance:object toItem:item];
        if (item.product.area == AreaArchitecture) { // NOTE 户型不能点击或编辑
            [object setQueryMask:SelectedMaskCannotSelect recursive:YES];
            mModel.gridsObject.visible = NO; // 户型加载后，默认把网格隐藏
            //            JCVector3 a = [object.transform positionInSpace:JWTransformSpaceWorld];
            //            NSLog(@"%f,%f,%f",a.x,a.y,a.z);
        } else {
            [object setQueryMask:SelectedMaskCannotSelect recursive:YES];
            object.queryMask = 0x1 << (ItemTypeLast + item.product.position);
        }
        if (mModel.isTeach && source.Id == 21) {
            JCVector3 position = [object.transform positionInSpace:JWTransformSpaceWorld];
            //            position.y = 0.01f;
            JCBounds3 bounds = object.scaleBounds;
            JCVector3 size = JCBounds3GetSize(&bounds);
            CGFloat n = size.x/size.z * 0.05;
            bounds.min.x -= n;
            bounds.min.z -= n;
            bounds.max.x += n;
            bounds.max.z += n;
            [object setVisible:NO recursive:YES];
            
            id<JIGameObject> tempObject = [mModel.currentContext createObject];
            tempObject.parent = mModel.currentScene.root;
            [tempObject setQueryMask:SelectedMaskCannotSelect recursive:YES];
            [tempObject setBounds:bounds];
            [tempObject.transform rotateUpDegrees:90.0f];
            [tempObject.transform setPosition:position inSpace:JWTransformSpaceWorld];
            mModel.teachObject = tempObject;
            
            id<JIFile> file = [JWFile fileWithBundle:[NSBundle mainBundle] path:[JWResourceBundle nameForDrawable:@"teach_rect_frame.png"]];
            JWRect4CornersDecals *mItemRectFrameDecals = [[JWRect4CornersDecals alloc] initWithContext:mModel.currentContext parent:mModel.currentScene.root innerWidth:1.0f innerHeight:1.0f cornerOffsetX:0.15f cornerOffsetY:0.15f thickness:0.06f cornerOffsetU:0.0f cornerOffsetV:0.0f uvThickness:0.346f decalsFile:file];
            mItemRectFrameDecals.decalsObject.visible = NO;
            mItemRectFrameDecals.decalsObject.queryMask = SelectedMaskCannotSelect;
            [mItemRectFrameDecals.decalsObject.transform setInheritScale:NO];
            JCBounds3 objectBounds = tempObject.bounds;
            JCVector3 objectSize = JCBounds3GetSize(&objectBounds);
            [mItemRectFrameDecals updateInnerWidth:objectSize.x innerHeight:objectSize.z];
            [mItemRectFrameDecals.decalsObject.transform reset:NO];
            mItemRectFrameDecals.decalsObject.parent = tempObject;
            [mItemRectFrameDecals.decalsObject.transform translate:JCVector3Make(0.0f, 0.025f, 0.0f)];
            mModel.teachDeacls = mItemRectFrameDecals.decalsObject;
            [JWCoreUtils destroyObject:object];
        }else {
            [self addObject:object];
        }
        mSceneDirty = YES;
        [listener onSceneFinishLoadFile:file parent:parent object:object];
    });
    onLoadingListener.onFailed = (^(id<JIFile> file, id<JIGameObject> parent, NSError* error){
        [listener onSceneFailLoadFile:file parent:parent error:error];
    });
    
    //加载器                     所要展示的对象
    return [loader loadFile:file parent:mTempParentForSetNewPosition params:nil async:async listener:onLoadingListener];
}

- (void)showOverlap {
    for (id<JIGameObject> obj in mModel.currentPlan.objects) {
        [mModel.currentPlan itemOverlap:obj];
    }
}

- (void)itemOverlap:(id<JIGameObject>)selectedObject {
    if (overlapObject == nil) {
        overlapObject = [NSMutableArray array];
    }
    Item *item = [Data getItemFromInstance:selectedObject];
    if (item.product.position == PositionOnItem) { // 判断item是否是在物件上的
        mModel.currentScene.boundsQuery.mask = SelectedMaskAllItemsExceptTop; // 用于判断物件重叠 mask 设置判定的对象是可选中的对象
        id<JIBoundsQueryResult> result = [mModel.currentScene.boundsQuery getResultByBounds:selectedObject.transformBoundsByStretch object:mModel.currentScene.root]; // 把有重叠的对象放在一个result中
        JCFloat height = 0.01f;
        JCVector3 position = [selectedObject.transform positionInSpace:JWTransformSpaceWorld]; // 取出选中对象的位置信息
        if (result.numEntries > 0) { // 如果result中有值 说明有物件重叠
            for (JWBoundsQueryResultEntry* boundsQ in result.entries) {
                id<JIGameObject> overlapObj = boundsQ.object;
                if (![overlapObj isEqual:selectedObject]) {
                    JCFloat overlapObjHeight = overlapObj.transformBoundsByStretch.max.y - overlapObj.transformBoundsByStretch.min.y; // 获取重叠对象的高度
                    if (overlapObjHeight > height) { // 取出最高的高度
                        height = overlapObjHeight;
                        position.y = height + 0.01f; // 将物件的高度抬到重叠物件上 额外添加一点高度放置重叠
                    }
                }
            }
            [selectedObject.transform setPosition:position inSpace:JWTransformSpaceWorld]; // 重新定位物件的位置
        } else {
            [mModel.selectedObject.transform setPosition:JCVector3Make(selectedObject.transformBoundsByStretch.min.x, 0.01, selectedObject.transformBoundsByStretch.min.z) inSpace:JWTransformSpaceWorld]; // 如果result中没有对象 说明物件没有重叠 将物件调到地面
        }
    }else if (item.product.position == PositionGround) { // 判断item是否是在地面上的
        for (id<JIGameObject> obj in mModel.currentPlan.objects) { // 遍历所有物件
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
        JCFloat selectedHeight = selectedObject.transformBoundsByStretch.max.y - selectedObject.transformBoundsByStretch.min.y;
        if (overlapObject.count > 0) { // 有叠加
            for (id<JIGameObject> overlapObj in overlapObject) {
                Item *it = [Data getItemFromInstance:overlapObj]; // 将叠加的对象转换成item
                if (it.product.position == PositionOnItem) { // 如果叠加的物件是 在物件上 的
                    JCVector3 position = [overlapObj.transform positionInSpace:JWTransformSpaceWorld]; // 取出原先的位置信息
                    position.y = selectedHeight; // 将高度抬高到选中物件的高度
                    [overlapObj.transform setPosition:position inSpace:JWTransformSpaceWorld]; // 重新赋值改变高度
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
            mModel.currentScene.objectQuery.mask = SelectedMaskAllItems; // objectQuery用于判断物件重叠 mask 设置判定的对象是可选中的对象
            for (id<JIGameObject> obj in mModel.currentPlan.objects) {
                Item *it = [Data getItemFromInstance:obj];
                if (it.product.position == PositionOnItem && obj != selectedObject && obj.transformBoundsByStretch.min.y > 0.02f) { // 判断 在物件上 对象的逻辑
                    id<JIObjectQueryResult> result = [mModel.currentScene.objectQuery getResultByObject:obj inObject:mModel.currentScene.root]; // 把有重叠的对象放在一个result中
                    if (result.numEntries == 0) {
                        [objOnItem add:obj];
                    }
                } else if (it.product.position == PositionGround && obj != selectedObject) {
                    ItemInfo *info = [Data getItemInfoFromInstance:obj];
                    if (info.isOverlap) {
                        // 先找到场景中所有有叠加的对象
                        id<JIObjectQueryResult> result = [mModel.currentScene.objectQuery getResultByObject:obj inObject:mModel.currentScene.root]; // 把有重叠的对象放在一个result中
                        if (result.numEntries == 0) {
                            [objOnGround add:obj]; // 将没有叠加的对象放入数组
                        }
                        // 同时需要对自己本身判断
                        id<JIObjectQueryResult> selectResult = [mModel.currentScene.objectQuery getResultByObject:selectedObject inObject:mModel.currentScene.root];
                        if (selectResult.numEntries == 0) {
                            [objOnGround add:selectedObject]; // 如果没有重叠也要放入数组
                        }
                    }
                }
            }
            if (objOnItem.count > 0) { // 对于 在物件上 无重叠对象的处理
                for (id<JIGameObject> obj in objOnItem) {
                    // 放置到地上
                    JCVector3 position = [obj.transform positionInSpace:JWTransformSpaceWorld];
                    position.y = 0.01f;
                    [obj.transform setPosition:position inSpace:JWTransformSpaceWorld];
                }
            }
            if (objOnGround.count > 0) { // 对于 在地面 无重叠对象的处理
                for (id<JIGameObject> obj in objOnGround) {
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

- (void) addDecalsToObject:(id<JIGameObject>)obj {
    if (decalsFile == nil) {
        decalsFile = [JWFile fileWithBundle:[NSBundle mainBundle] path:[JWResourceBundle nameForDrawable:@"overlap_rect_frame.png"]];
    }
    if (decalsArray == nil) {
        decalsArray = [NSMutableArray array];
    }
    BOOL isFind = false;
    for (JWRect4CornersDecals *decals in decalsArray) {
        if (decals.decalsObject.visible == NO) {
            JCBounds3 objectBounds = obj.scaleBoundsByStretch;
            JCVector3 objectSize = JCBounds3GetSize(&objectBounds);
            [decals updateInnerWidth:objectSize.x innerHeight:objectSize.z];
            [decals.decalsObject.transform reset:NO];
            decals.decalsObject.parent = obj;
            [decals.decalsObject.transform translate:JCVector3Make(0.0f, 0.02f, 0.0f)]; // 防止z-fighting
            decals.decalsObject.visible = YES;
            isFind = YES;
            break;
        }
    }
    if (isFind == NO) {
        JWRect4CornersDecals *decals = [[JWRect4CornersDecals alloc] initWithContext:mModel.currentContext parent:mModel.currentScene.root innerWidth:1.0f innerHeight:1.0f cornerOffsetX:0.15f cornerOffsetY:0.15f thickness:0.05f cornerOffsetU:0.0f cornerOffsetV:0.0f uvThickness:0.346f decalsFile:decalsFile];
        mModel.itemOverlapDecals = decals;
        decals.decalsObject.queryMask = SelectedMaskAllItems;
        [decals.decalsObject.transform setInheritScale:NO];
        decals.decalsObject.inheritStretch = NO;
        JCBounds3 objectBounds = obj.scaleBoundsByStretch;
        JCVector3 objectSize = JCBounds3GetSize(&objectBounds);
        [decals updateInnerWidth:objectSize.x innerHeight:objectSize.z];
        [decals.decalsObject.transform reset:NO];
        decals.decalsObject.parent = obj;
        [decals.decalsObject.transform translate:JCVector3Make(0.0f, 0.02f, 0.0f)]; // 防止z-fighting
        decals.decalsObject.visible = YES;
        [decalsArray add:decals];
    }
}

- (void) hidedDecals:(id<JIGameObject>)obj {
    for (JWRect4CornersDecals *decals in decalsArray) {
        if (decals.decalsObject.parent == obj) {
            decals.decalsObject.parent = nil;
            decals.decalsObject.visible = NO;
        }
    }
}

- (void)enumChildrenUsing:(id<JIGameObject>)obj {
    [obj.transform enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JITransform> transform = obj;
        id<JIGameObject> child = transform.host; //host表示transform的属于者
        NSString *name = [NSString stringWithFormat:@"material_%@",@(child.hash)];
        id<JIMaterial> mater = [child.renderable.material copyInstanceWithName:name];
        ObjectExtra *extra = child.extra;
        if (extra == nil) {
            extra = [ObjectExtra new];
        }
        extra.archMaterial = mater;
        child.extra = extra;
        [self enumChildrenUsing:child];
    }];
}

- (void)changeChildColor:(id<JIGameObject>)obj And:(JCColor)color {
    [obj.transform enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JITransform> transform = obj;
        id<JIGameObject> child = transform.host; //host表示transform的属于者
        NSString *name = [NSString stringWithFormat:@"material__%@",@(child.renderable.material.hash)];
        id<JIMaterial> mater = [child.renderable.material copyInstanceWithName:name];
        mater.diffuseColor = color;
        child.renderable.material = mater;
        [self changeChildColor:child And:color];
    }];
}

- (void)resetMaterial:(id<JIGameObject>)obj {
    [obj.transform enumChildrenUsing:^(id obj, NSUInteger idx, BOOL *stop) {
        id<JITransform> transform = obj;
        id<JIGameObject> child = transform.host; //host表示transform的属于者
        ObjectExtra *extra = child.extra;
        id<JIMaterial> mater = extra.archMaterial;
        child.renderable.material = mater;
        [self resetMaterial:child];
    }];
}

#pragma mark 对象重叠算法逻辑 可能暂时不用
- (BOOL)findOverlapObject:(id<JIGameObject>)objectA AndB:(id<JIGameObject>)objectB {
    /*
     dobj  b2d  bobj
     
     d2a   cen  c2b
     
     aobj  a2c  cobj
     */
    JCVector3 aobj = objectA.transformBoundsByStretch.min;
    JCVector3 bobj = objectA.transformBoundsByStretch.max;
    JCVector3 cobj = JCVector3Make(aobj.x, aobj.y, bobj.z);
    JCVector3 dobj = JCVector3Make(bobj.x, aobj.y, aobj.z);
    JCVector3 cenA = JCVector3Make((bobj.x - aobj.x)/2 , aobj.y, (bobj.z - aobj.z)/2);
    
    JCVector3 a_over = objectB.transformBoundsByStretch.min;
    JCVector3 b_over = objectB.transformBoundsByStretch.max;
    JCVector3 c_over = JCVector3Make(a_over.x, a_over.y, b_over.z);
    JCVector3 d_over = JCVector3Make(b_over.x, a_over.y, a_over.z);
    JCVector3 cenB = JCVector3Make((b_over.x - a_over.x)/2, a_over.y, (b_over.z - a_over.z)/2);
    
    BOOL overlapA = aobj.x > objectB.transformBoundsByStretch.min.x && aobj.x < objectB.transformBoundsByStretch.max.x && aobj.z > objectB.transformBoundsByStretch.min.z && aobj.z < objectB.transformBoundsByStretch.max.z;
    BOOL overlapB = bobj.x > objectB.transformBoundsByStretch.min.x && bobj.x < objectB.transformBoundsByStretch.max.x && bobj.z > objectB.transformBoundsByStretch.min.z && bobj.z < objectB.transformBoundsByStretch.max.z;
    BOOL overlapC = cobj.x > objectB.transformBoundsByStretch.min.x && cobj.x < objectB.transformBoundsByStretch.max.x && cobj.z > objectB.transformBoundsByStretch.min.z && cobj.z < objectB.transformBoundsByStretch.max.z;
    BOOL overlapD = dobj.x > objectB.transformBoundsByStretch.min.x && dobj.x < objectB.transformBoundsByStretch.max.x && dobj.z > objectB.transformBoundsByStretch.min.z && dobj.z < objectB.transformBoundsByStretch.max.z;
    BOOL overlapCen = cenA.x > objectB.transformBoundsByStretch.min.x && cenA.x < objectB.transformBoundsByStretch.max.x && cenA.z > objectB.transformBoundsByStretch.min.z && cenA.z < objectB.transformBoundsByStretch.max.z;
    
    BOOL overlapA_over = a_over.x > objectA.transformBoundsByStretch.min.x && a_over.x < objectA.transformBoundsByStretch.max.x && a_over.z > objectA.transformBoundsByStretch.min.z && a_over.z < objectA.transformBoundsByStretch.max.z;
    BOOL overlapB_over = b_over.x > objectA.transformBoundsByStretch.min.x && b_over.x < objectA.transformBoundsByStretch.max.x && b_over.z > objectA.transformBoundsByStretch.min.z && b_over.z < objectA.transformBoundsByStretch.max.z;
    BOOL overlapC_over = c_over.x > objectA.transformBoundsByStretch.min.x && c_over.x < objectA.transformBoundsByStretch.max.x && c_over.z > objectA.transformBoundsByStretch.min.z && c_over.z < objectA.transformBoundsByStretch.max.z;
    BOOL overlapD_over = d_over.x > objectA.transformBoundsByStretch.min.x && d_over.x < objectA.transformBoundsByStretch.max.x && d_over.z > objectA.transformBoundsByStretch.min.z && d_over.z < objectA.transformBoundsByStretch.max.z;
    BOOL overlapCen_over = cenB.x > objectA.transformBoundsByStretch.min.x && cenB.x < objectA.transformBoundsByStretch.max.x && cenB.z > objectA.transformBoundsByStretch.min.z && cenB.z < objectA.transformBoundsByStretch.max.z;
    
    if (overlapA || overlapB || overlapC || overlapD || overlapA_over || overlapB_over || overlapC_over || overlapD_over || overlapCen || overlapCen_over) {
        return YES;
    } else {
        return NO;
    }
}

@synthesize objects = mObjects;

@synthesize Id = mId;
@synthesize name = mName;
@synthesize camera = mCamera;
@synthesize preview = mPreview;
@synthesize scene = mScene;
@synthesize type = mType;

@synthesize fromAR = mFromAR;

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
    for (id<JIGameObject> object in mObjects) {
        Item *it = [Data getItemFromInstance:object];
        ItemInfo *info = [Data getItemInfoFromInstance:object];
        PlanItem *pit = [[PlanItem alloc] init];
        pit.item = it;
        pit.object = object;
        pit.st = info.st;
        pit.ts = info.ts;
        pit.sc = info.sc;
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

- (void) addSerializedArchitectureItems:(id<JIGameObject>)gameObject {
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
        id<JITransform> transform = obj;
        id<JIGameObject> child = transform.host; //host表示transform的属于者
        [self addSerializedArchitectureItems:child]; // 递归调用自己
    }];
}

- (void)setSerializedArchitectureItems:(NSMutableArray *)serializedArchitectureItems {
    mSerializedArchitectureItems = serializedArchitectureItems;
}

@synthesize rooms = mRooms;
@synthesize isSuit = mIsSuit;
@synthesize isCreate = mIsCreate;

//@synthesize fromExchange = mFromExchange;
//@synthesize inspiratedCreate = mInspiratedCreate;

- (NSDictionary *)serializeMembers {
    return @{
             @"cam":[JWSerializeInfo objectWithName:@"camera" objClass:[PlanCamera class]],
             @"arc": [JWSerializeInfo objectWithName:@"serializedArchitectureItem" objClass:[PlanItem class]],
             @"its": [JWSerializeInfo arrayWithName:@"serializedItems" arrayClass:[NSMutableArray class] itemClass:[PlanItem class]],
             @"ars": [JWSerializeInfo arrayWithName:@"serializedArchitectureItems" arrayClass:[NSMutableArray class] itemClass:[PlanItem class]],
             };
}

@end
