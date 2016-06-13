//
//  PlanOrder.m
//  project_mesher
//
//  Created by ddeyes on 15/10/22.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "PlanOrder.h"

@interface OrderItem () {
    Item* mItem;
    NSUInteger mCount;
}

@end

@implementation OrderItem

- (void)onDestroy {
    mItem = nil; // 清除物件
    mCount = 0; // 计数器清零
    [super onDestroy];
}

- (id)initWithItem:(Item *)item {
    self = [super init];
    if (self != nil) {
        mItem = item;
        mCount = 0;
    }
    return self;
}

- (void)addItem {
    mCount++;
}

- (void)removeItem {
    if (mCount == 0) {
        return;
    }
    mCount--;
}

- (Item *)item {
    return mItem;
}

- (NSUInteger)count {
    return mCount;
}

- (float)totalPrice {
    if (mItem == nil) {
        return 0.0f;
    }
    float total = mItem.price * (float)mCount;
    return total;
}

@end

@interface OrderArea () {
    Area mArea;
    NSMutableArray* mOrders;
}

@end

@implementation OrderArea

- (void)onDestroy {
    [CCVCoreUtils destroyArray:mOrders]; //清除物件列表
    mOrders = nil; // 赋空
    [super onDestroy];
}

- (id)initWithArea:(Area)area {
    self = [super init];
    if (self != nil) {
        mArea = area;
    }
    return self;
}

- (void)addItem:(Item *)item {
    if (item == nil) {
        return;
    }
    if (mOrders == nil) {
        mOrders = [NSMutableArray array];
    }
    OrderItem* foundItem = [self getOrderByItem:item];
    if (foundItem == nil) {
        foundItem = [[OrderItem alloc] initWithItem:item];
        [mOrders add:foundItem];
    }
    [foundItem addItem];
}

- (void)removeItem:(Item *)item {
    if (item == nil) {
        return;
    }
    if (mOrders == nil) {
        return;
    }
    OrderItem* foundItem = [self getOrderByItem:item];
    if (foundItem == nil) {
        return;
    }
    [foundItem removeItem];
    if (foundItem.count == 0) {
        [mOrders remove:foundItem];
    }
}

- (OrderItem*) getOrderByItem:(Item*)item {
    OrderItem* foundItem = nil;
    for (OrderItem* orderItem in mOrders) {
        if (orderItem.item == item) {
            foundItem = orderItem;
            break;
        }
    }
    return foundItem;
}

- (Area)area {
    return mArea;
}

- (NSArray *)orderItems {
    return mOrders;
}

- (float)totalPrice {
    if (mOrders == nil) {
        return 0.0f;
    }
    float total = 0.0f;
    for (OrderItem* orderItem in mOrders) {
        total += orderItem.totalPrice;
    }
    return total;
}

@end

@interface PlanOrder () {
    NSMutableArray* mOrderAreas;
    NSMutableArray* mTempAreaAndItems;
}

@end

@implementation PlanOrder

- (void)onDestroy {
    [CCVCoreUtils destroyArray:mOrderAreas]; //清除报价单区域列表
    mOrderAreas = nil;// 赋空为下次使用
    if (mTempAreaAndItems != nil) {
        [mTempAreaAndItems clear]; // 清除缓存
        mTempAreaAndItems = nil; // 赋空
    }
    [super onDestroy];
}

- (void)addItem:(Item *)item {
    if (item == nil || item.product == nil) {
        return;
    }
    if (mOrderAreas == nil) {
        mOrderAreas = [NSMutableArray array];
    }
    OrderArea* foundArea = [self getAreaByItem:item];
    if (foundArea == nil) {
        foundArea = [[OrderArea alloc] initWithArea:item.product.area];
        [mOrderAreas add:foundArea];
    }
    [foundArea addItem:item];
}

- (void)removeItem:(Item *)item {
    if (item == nil) {
        return;
    }
    if (mOrderAreas == nil) {
        return;
    }
    OrderArea* foundArea = [self getAreaByItem:item];
    if (foundArea == nil) {
        return;
    }
    [foundArea removeItem:item];
}

- (OrderArea*) getAreaByItem:(Item*)item {
    OrderArea* foundArea = nil;
    for (OrderArea* orderArea in mOrderAreas) {
        if (item.product.area == orderArea.area) {
            foundArea = orderArea;
            break;
        }
    }
    return foundArea;
}

- (NSArray *)areaAndItems {
    if (mOrderAreas == nil) {
        return nil;
    }
    if (mTempAreaAndItems == nil) {
        mTempAreaAndItems = [NSMutableArray array];
    }
    [mTempAreaAndItems clear];
    for (OrderArea* orderArea in mOrderAreas) {
        NSArray* orders = orderArea.orderItems;
        if (orders == nil || orders.count == 0) {
            continue;
        }
        [mTempAreaAndItems addAll:orders];
        [mTempAreaAndItems add:orderArea];
    }
    return mTempAreaAndItems;
}

- (float)totalPrice {
    if (mOrderAreas == nil) {
        return 0.0f;
    }
    float total = 0.0f;
    for (OrderArea* orderArea in mOrderAreas) {
        total += orderArea.totalPrice;
    }
    return total;
}

@end
