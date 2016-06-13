//
//  inspiratedPlan.m
//  project_mesher
//
//  Created by mac zdszkj on 16/4/6.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "InspiratedPlan.h"
#import "Data.h"
#import "Item.h"
#import "PlanItem.h"
#import "MesherModel.h"
#import <jw/JWVector3.h>

@interface InspiratedPlan() {
    id<IMesherModel> mModel;
    id<JIGameObject> mRoot;
    NSMutableArray* mObjects;
    PlanOrder* mOrder;
    
    NSInteger mId;
    NSString* mName;
    id<JIFile> mPreview;
    id<JIFile> mScene;
    id<JIFile> mInspirateBackground;
//    JCQuaternion mQuater;
    float mQw;
    float mQx;
    float mQy;
    float mQz;
    float mCameraX;
    float mCameraY;
    float mCameraZ;
    
    
    id<JIGameObject> mTempParentForSetNewPosition;
    
    NSMutableArray* mSerializedItems;
}

//@property (nonatomic, readwrite) NSString* serializedBackgroundPath;

@end

@implementation InspiratedPlan

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
    [mInspirateBackground deleteFile];
    [[JWCorePluginSystem instance].imageCache removeBy:mInspirateBackground];
    mInspirateBackground = nil;
    [mScene deleteFile];
    mScene = nil;
    [super onDestroy];
}

@synthesize model = mModel;

- (id<JIGameObject>)root {
    if (mRoot == nil) {
        id<JIGameContext> context = mModel.currentContext;
        mRoot = [context createObject];
        mRoot.Id = [NSString stringWithFormat:@"inspiratePlan_%@", @(self.hash)];
        mRoot.name = mRoot.Id;
        id<JIGameScene> scene = mModel.world.currentScene;
        mRoot.parent = scene.root;
        mRoot.queryMask = SelectedMaskCannotSelect;
    }
    return mRoot;
}

- (void)addObject:(id<JIGameObject>)object {
    if (object == nil) {
        return;
    }
    Item *item = [Data getItemFromInstance:object];
    if (item == nil) {
        return;
    }
    Product *product = item.product;
    if (product == nil) {
        return;
    }
    if (mObjects == nil) {
        mObjects = [NSMutableArray array];
    }
    if([mObjects addObject:object likeASet:YES willIngoreNil:NO]) {
        object.parent = mRoot;
        [self.order addItem:item];
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
    }
}

- (void)destroyAllObjects {
    [JWCoreUtils destroyArray:mObjects];
    mObjects = nil;
    [JWCoreUtils destroyObject:mOrder];
    mOrder = nil;
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
    if (mSerializedItems != nil) {
        for (PlanItem* planItem in mSerializedItems) {
            JWAsyncResult* result = [self loadPlanItem:planItem];
            if (result != nil) {
                ItemInfo* itemInfo = [[ItemInfo alloc] init]; // 创建info对象
                itemInfo.type = ItemTypeItem; // 默认设置为物件
                id<JIGameObject> gameObject = result.syncResult;
                [Data bindInstance:gameObject toItemInfo:itemInfo]; // 绑定对应物件
            }
        }
    }
    [mSerializedItems removeAllObjects]; // 使用完清空数组以便下次使用
    if (mModel.currentPlan.inspirateBackground == nil) {
        mModel.currentPlan.inspirateBackground = mInspirateBackground;
    }
    mModel.currentPlan.qw = mQw;
    mModel.currentPlan.qx = mQx;
    mModel.currentPlan.qy = mQy;
    mModel.currentPlan.qz = mQz;
    mModel.currentPlan.cameraX = mCameraX;
    mModel.currentPlan.cameraY = mCameraY;
    mModel.currentPlan.cameraZ = mCameraZ;
    
    return root;
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

    
    if (mTempParentForSetNewPosition == nil) {
        mTempParentForSetNewPosition = [context createObject];
        mTempParentForSetNewPosition.parent = root;
        mTempParentForSetNewPosition.queryMask = SelectedMaskCannotSelect;
    }
    [mTempParentForSetNewPosition.transform setPosition:position];
    
    //异步加载 创建监听
    JWSceneLoaderOnLoadingListener* onLoadingListener = [[JWSceneLoaderOnLoadingListener alloc] init];
        onLoadingListener.onObjectLoaded = (^(id<JIGameObject> object) {
        if ([object.name startsWith:@"sd_"]) { // 如果是影子
            [object setBoundsEnabled:NO]; // 无视影子的bounds
        }
    });
    onLoadingListener.onObjectLoaded = (^(id<JIGameObject> object){
        //把沙发隐藏
    });
    onLoadingListener.onFinish = (^(id<JIFile> file, id<JIGameObject> parent, id<JIGameObject> object){
        object.parent = root; // 将节点接到原先的节点上
        [object.transform setPosition:position];
        [object.transform setOrientation:orientation inSpace:JWTransformSpaceLocal];
        [Data bindInstance:object toItem:item];
        [object setQueryMask:SelectedMaskCannotSelect recursive:YES];
        object.queryMask = 0x1 << (ItemTypeLast + item.product.position);
        [self addObject:object];
        [listener onSceneFinishLoadFile:file parent:parent object:object];
    });
    onLoadingListener.onFailed = (^(id<JIFile> file, id<JIGameObject> parent, NSError* error){
        [listener onSceneFailLoadFile:file parent:parent error:error];
    });
    
    //加载器                     所要展示的对象
    return [loader loadFile:file parent:mTempParentForSetNewPosition params:nil async:async listener:onLoadingListener];
}

@synthesize objects = mObjects;

@synthesize Id = mId;
@synthesize name = mName;
@synthesize preview = mPreview;
@synthesize scene = mScene;
@synthesize inspirateBackground = mInspirateBackground;
//@synthesize quater = mQuater;
@synthesize qw = mQw;
@synthesize qx = mQx;
@synthesize qy = mQy;
@synthesize qz = mQz;
@synthesize cameraX = mCameraX;
@synthesize cameraY = mCameraY;
@synthesize cameraZ = mCameraZ;

//- (NSString *)serializedBackgroundPath {
//    return mInspirateBackground.path;
//}
//
//- (void)setSerializedBackgroundPath:(NSString *)serializedBackgroundPath {
//    mInspirateBackground = [JWFile fileWithType:JWFileTypeDocument path:serializedBackgroundPath];
//}

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

- (NSDictionary *)serializeMembers {
    return @{
             @"qw": [JWSerializeInfo objectWithClass:[NSNumber class]],
             @"qx": [JWSerializeInfo objectWithClass:[NSNumber class]],
             @"qy": [JWSerializeInfo objectWithClass:[NSNumber class]],
             @"qz": [JWSerializeInfo objectWithClass:[NSNumber class]],
             //@"height": [JWSerializeInfo objectWithClass:[NSNumber class]],
             @"cameraX": [JWSerializeInfo objectWithClass:[NSNumber class]],
             @"cameraY": [JWSerializeInfo objectWithClass:[NSNumber class]],
             @"cameraZ": [JWSerializeInfo objectWithClass:[NSNumber class]],
             @"its": [JWSerializeInfo arrayWithName:@"serializedItems" arrayClass:[NSMutableArray class] itemClass:[PlanItem class]],
             };
}

@end
