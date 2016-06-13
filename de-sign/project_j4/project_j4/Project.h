//
//  Project.h
//  project_mesher
//
//  Created by ddeyes on 15/10/23.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Data.h"

@interface Project : CCVObject

@property (nonatomic, readwrite) id<IMesherModel> model;

- (BOOL) loadProducts;
- (Source*) getSourceById:(NSInteger)sourceId;
- (Item*) getItemById:(NSInteger)itemId;
- (Item*) getItemBySourceId:(NSInteger)sourceId;
- (Product*) getProductById:(NSInteger)productId;
- (NSArray*) getProductsByArea:(Area)area;
@property (nonatomic, readonly) NSArray* products;

- (BOOL) loadPlans;
- (BOOL) savePlans;
- (Plan*) createPlan;
- (void) destoryPlan:(Plan*)plan;
- (Plan*) copyPlan:(Plan*)plan;
- (Plan*) planAtIndex:(NSInteger)index;
@property (nonatomic, readonly) NSInteger numPlans;
@property (nonatomic, readwrite) NSMutableArray* plans; // 本地保存的所有方案
@property (nonatomic, readonly) NSInteger maxPlanId;

@property (nonatomic, readwrite) NSMutableArray *sourceTextures;
@property (nonatomic, readwrite) NSMutableArray *sourceModels;

@property (nonatomic, readwrite) NSMutableArray *wallTextures;
@property (nonatomic, readwrite) NSMutableArray *floorTextures;
@property (nonatomic, readwrite) NSMutableArray *ceilTextures;

#pragma mark Suit界面的属性&方法
- (BOOL) loadSuitPlans;
- (Plan*) suitPlanAtIndex:(NSInteger)index;
- (Plan*) copySuitPlan:(Plan*)suitPlan;
- (Plan*) addSuitPlanToLocal:(Plan*)suitPlan;
@property (nonatomic, readonly) NSArray<NSArray*>* suitRooms;

#pragma mark RoomShape界面的属性&方法
@property (nonatomic, readonly) NSArray<NSArray*>* shapeRooms;
@property (nonatomic, readonly) NSArray *allShapes;
- (Item*) getItemAtIndex:(NSInteger)index;
@end
