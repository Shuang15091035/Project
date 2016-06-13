//
//  Product.h
//  project_mesher
//
//  Created by ddeyes on 15/10/23.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"
#import "Item.h"

typedef NS_ENUM(NSInteger, Area) {
    AreaUnknown = 0,
    AreaArchitecture = 1,
    AreaLivingRoom = 2,
    AreaBedroom = 3,
    AreaKitchen = 4,
    AreaToilet = 5,
};

typedef NS_ENUM(NSInteger, Position) {
    PositionUnknown = 0,
    PositionGround,
    PositionTop,
    PositionOnItem,
    PositionInWall,
    PositionOnWall,
    PositionLast = PositionOnWall,
};

// 产品
@interface Product : JWObject

@property (nonatomic, readwrite) NSInteger Id;
@property (nonatomic, readwrite) NSString* name; // 名字
@property (nonatomic, readwrite) Area area; // 区域
@property (nonatomic, readwrite) NSString *category; // 分类
@property (nonatomic, readwrite) Position position; // 方位
@property (nonatomic, readwrite) id<JIFile> preview;
@property (nonatomic, readwrite) NSString* link; // 链接
@property (nonatomic, readwrite) NSString* description; // 描述

// 物件列表相关
- (void) addItem:(Item*)item;
- (void) removeItem:(Item*)item;
@property (nonatomic, readonly) NSArray* items;

@end