//  Project.m
//  project_mesher
//
//  Created by ddeyes on 15/10/23.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Project.h"
#import "LocalSourceTable.h"
#import "LocalItemTable.h"
#import "LocalProductTable.h"
#import "LocalPlanTable.h"

@interface Project () {
    id<IMesherModel> mModel;
    NSBundle* mBundle;
    NSArray* mSources;
    NSArray* mItems;
    NSArray* mProducts;
    NSMutableArray* mPlans;
    NSInteger mMaxPlanId;
    
    NSMutableArray *mSourceTextures;
    NSMutableArray *mSourceModels;
    
    NSMutableArray *mWallTextures;
    NSMutableArray *mFloorTextures;
    NSMutableArray *mCeilTextures;

    NSMutableArray<NSMutableArray*>* mSuitRooms;
    
    NSMutableArray<NSMutableArray*>* mShapeRooms;
    NSMutableArray *mAllShapes;
}

@end

@implementation Project

#pragma mark products

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        NSDictionary* bundleDic = [[NSBundle mainBundle] infoDictionary];
        NSString* bundleName = [bundleDic objectForKey:@"Project name"];
        NSString* bundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
        mBundle = [NSBundle bundleWithPath:bundlePath];
        if (mBundle == nil) {
            @throw [NSException exceptionWithName:@"Project Bundle not found." reason:@"project name incorrect." userInfo:nil];
        }
    }
    return self;
}

@synthesize model = mModel;

- (BOOL)loadProducts {
    if (mSourceTextures == nil) {
        mSourceTextures = [NSMutableArray array];
    }
    if (mSourceModels == nil) {
        mSourceModels = [NSMutableArray array];
    }
    
    id<ICVFile> file = [CCVFile fileWithBundle:mBundle path:[CCVAssetsBundle nameForPath:@"project/sources.fit"]];
    LocalSourceTable* st = [[LocalSourceTable alloc] initWithBundle:mBundle];
    NSArray* rt = [st loadFile:file];
    if (rt == nil) {
        return NO;
    }
    mSources = rt;
    
    file = [CCVFile fileWithBundle:mBundle path:[CCVAssetsBundle nameForPath:@"project/items.fit"]];
    LocalItemTable* it = [[LocalItemTable alloc] initWithBundle:mBundle];
    rt = [it loadFile:file];
    if (rt == nil) {
        return NO;
    }
    mItems = rt;
    
    file = [CCVFile fileWithBundle:mBundle path:[CCVAssetsBundle nameForPath:@"project/products.fit"]];
    LocalProductTable* pt = [[LocalProductTable alloc] initWithBundle:mBundle];
    rt = [pt loadFile:file];
    if (rt == nil) {
        return NO;
    }
    mProducts = rt;
    
    // 绑定items当中item的source和product，并且绑定product中的item列表
    if (mItems != nil) {
        for (Item* item in mItems) {
            Product* product = [self getProductById:item.productId];
            if (product != nil) {
                item.product = product;
                [product addItem:item];
            }
            Source* source = [self getSourceById:item.sourceId];
            item.source = source;
        }
    }

    if (mSources != nil) {
        for (Source *source in mSources) {
            if (source.type == SourceTypeTexture) {
                [mSourceTextures add:source];
                Item *it = [self getItemBySourceId:source.Id];
                if ([it.product.category isEqualToString:@"墙体"]) {
                    if (mWallTextures == nil) {
                        mWallTextures = [NSMutableArray array];
                    }
                    [mWallTextures add:source];
                }else if ([it.product.category isEqualToString:@"地板"]) {
                    if (mFloorTextures == nil) {
                        mFloorTextures = [NSMutableArray array];
                    }
                    [mFloorTextures add:source];
                }else if ([it.product.category isEqualToString:@"天花"]) {
                    if (mCeilTextures == nil) {
                        mCeilTextures = [NSMutableArray array];
                    }
                    [mCeilTextures add:source];
                }
            }else if (source.type == SourceTypeModel) {
                [mSourceModels add:source];
            }
        }
    }

    
#pragma mark RoomShape相关
    if (mAllShapes == nil) {
        mAllShapes = [NSMutableArray array];
    }
    
    mShapeRooms = [NSMutableArray array];
    for (NSUInteger i = 0; i < RoomsMaxNum; i++) {
        [mShapeRooms add:[NSMutableArray array]];
    }
    for (int i = 0; i < mItems.count; i++) {
        Item *item = mItems[i];
        if (item.rooms != 0) {
            [mAllShapes add:item];
        }
        if (item.rooms < 0) {
            [mShapeRooms[0] add:item];
            continue;
        }
        if (item.rooms == 0) {
            continue;
        }
        if (item.rooms >= RoomsOther) {
            [mShapeRooms[RoomsOther] add:item];
        } else {
            [mShapeRooms[item.rooms] add:item];
        }
    }
    return YES;
}

- (Source *)getSourceById:(NSInteger)sourceId {
    if (mSources == nil) {
        return nil;
    }
    for (Source* source in mSources) {
        if (source.Id == sourceId) {
            return source;
        }
    }
    return nil;
}

- (Item *)getItemById:(NSInteger)itemId {
    if (mItems == nil) {
        return nil;
    }
    for (Item* item in mItems) {
        if (item.Id == itemId) {
            return item;
        }
    }
    return nil;
}

- (Item *)getItemBySourceId:(NSInteger)sourceId {
    if (mSources == nil) {
        return nil;
    }
    for (Item *item in mItems) {
        if (item.sourceId == sourceId) {
            return item;
        }
    }
    return nil;
}

- (Product *)getProductById:(NSInteger)productId {
    if (mProducts == nil) {
        return nil;
    }
    for (Product* product in mProducts) {
        if (product.Id == productId) {
            return product;
        }
    }
    return nil;
}

- (NSArray *)getProductsByArea:(Area)area {
    if (area == AreaUnknown) {
        return nil;
    }
    NSMutableArray* products = [NSMutableArray array];
    for (Product* product in mProducts) {
        if (product.area == area) {
            [products add:product];
        }
    }
    return products;
}

- (NSArray *)products {
    return mProducts;
}

#pragma mark plans

- (BOOL)loadPlans {
    if (mPlans != nil) {
        return YES;
    }
    id<ICVFile> file = [CCVFile fileWithType:CCVFileTypeDocument path:@"plans.fit"];
    LocalPlanTable* pt = [[LocalPlanTable alloc] initWithFileType:LocalPlanTableFileTypeDocument model:mModel bundle:nil];
    NSArray* rt = [pt loadFile:file];
    if (rt == nil) {
        return NO;
    }
    if (mPlans == nil) {
        mPlans = [NSMutableArray array];
    }
    [mPlans clear];
    [mPlans addAll:rt];
    
    // 寻找最大id
    mMaxPlanId = 0;
    for (Plan* plan in mPlans) {
        plan.isSuit = NO;
        if (plan.Id > mMaxPlanId) {
            mMaxPlanId = plan.Id;
        }
    }
    return YES;
}

- (BOOL)savePlans {
    id<ICVFile> file = [CCVFile fileWithType:CCVFileTypeDocument path:@"plans.fit"];
    LocalPlanTable* pt = [[LocalPlanTable alloc] initWithFileType:LocalPlanTableFileTypeDocument model:mModel bundle:nil]; // 保存的路径在沙盒中
    return [pt saveFile:file records:mPlans] != nil;
}

- (Plan *)createPlan {
    Plan* plan = [[Plan alloc] initWithModel:mModel];
    plan.isSuit = NO;
    mMaxPlanId++;
    plan.Id = mMaxPlanId;
    plan.name = [NSString stringWithFormat:@"plan_%@", @(plan.Id)];
    plan.preview = [CCVFile fileWithType:CCVFileTypeDocument path:[NSString stringWithFormat:@"preview_%@.png", @(plan.Id)]];
    plan.scene = [CCVFile fileWithType:CCVFileTypeDocument path:[NSString stringWithFormat:@"scene_%@.pla", @(plan.Id)]];
    NSLog(@"-------------%@", plan.scene.realPath);
    if (mPlans == nil) {
        mPlans = [NSMutableArray array];
    }
    [mPlans add:plan];
    return plan;
}

- (void)destoryPlan:(Plan *)plan {
    if (plan == nil || mPlans == nil) {
        return;
    }
    if ([mPlans remove:plan]) {
        [CCVCoreUtils destroyObject:plan];
    }
}

- (Plan *)copyPlan:(Plan *)plan {
    Plan* newPlan = [self createPlan];
    newPlan.name = [NSString stringWithFormat:@"%@ 副本", plan.name];
    newPlan.preview.data = plan.preview.data;
    newPlan.scene.data = plan.scene.data;
    return newPlan;
}

- (Plan *)planAtIndex:(NSInteger)index {
    if (mPlans == nil) {
        return nil;
    }
    return [mPlans at:index];
}

- (NSInteger)numPlans {
    if (mPlans == nil) {
        return 0;
    }
    return mPlans.count;
}

- (NSMutableArray *)plans {
    return mPlans;
}

- (NSInteger)maxPlanId {
    return mMaxPlanId;
}

- (BOOL)loadSuitPlans {
    if (mSuitRooms != nil) {
        return YES;
    }
    id<ICVFile> file = [CCVFile fileWithBundle:mBundle path:[CCVAssetsBundle nameForPath:@"project/plans.fit"]];
    LocalPlanTable *pt = [[LocalPlanTable alloc] initWithFileType:LocalPlanTableFileTypeAsset model:mModel bundle:mBundle];
    NSArray* rt = [pt loadFile:file];
    if (rt == nil) {
        return NO;
    }
    mSuitRooms = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < RoomsMaxNum; i++) {
        [mSuitRooms add:[NSMutableArray array]];
    }
    
    for (Plan *suitPlan in rt) {
        [mSuitRooms[0] add:suitPlan];
        if (suitPlan.rooms == 0) {
            continue;
        }
        if (suitPlan.rooms >= RoomsOther) {
            [mSuitRooms[RoomsOther] add:suitPlan];
        } else {
            [mSuitRooms[suitPlan.rooms] add:suitPlan];
        }
        suitPlan.isSuit = YES;
    }
    return YES;
}

@synthesize suitRooms = mSuitRooms;

- (Plan*) suitPlanAtIndex:(NSInteger)index {
    if (mSuitRooms[0] == nil) {
        return nil;
    }
    return [mSuitRooms[0] at:index];
}

- (Plan *)copySuitPlan:(Plan *)suitPlan {
    Plan *plan = [[Plan alloc] initWithModel:mModel];
    plan.Id = mMaxPlanId + 1;
    plan.name = suitPlan.name;
    plan.rooms = suitPlan.rooms;
    plan.preview = suitPlan.preview;
    plan.scene = suitPlan.scene;
    plan.isSuit = suitPlan.isSuit;
    return plan;
}

- (Plan *)addSuitPlanToLocal:(Plan *)suitPlan {
    mMaxPlanId++;
    Plan* plan = suitPlan;
    plan.preview = [CCVFile fileWithType:CCVFileTypeDocument path:[NSString stringWithFormat:@"suit_preview_%@.png", @(plan.Id)]];
    plan.scene = [CCVFile fileWithType:CCVFileTypeDocument path:[NSString stringWithFormat:@"suit_scene_%@.pla", @(plan.Id)]];
    if (mPlans == nil) {
        mPlans = [NSMutableArray array];
    }
    [mPlans add:plan];
    return plan;
}

@synthesize shapeRooms = mShapeRooms;
@synthesize allShapes = mAllShapes;

@synthesize sourceTextures = mSourceTextures;
@synthesize sourceModels = mSourceModels;

@synthesize wallTextures = mWallTextures;
@synthesize floorTextures = mFloorTextures;
@synthesize ceilTextures = mCeilTextures;

- (Item *)getItemAtIndex:(NSInteger)index {
    if (mAllShapes == nil) {
        return nil;
    }
    return [mAllShapes at:index];
}

@end
