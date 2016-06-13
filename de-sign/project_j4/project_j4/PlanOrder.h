//
//  PlanOrder.h
//  project_mesher
//
//  Created by ddeyes on 15/10/22.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Data.h"

@interface OrderItem : CCVObject

- (id) initWithItem:(Item*)item;
- (void) addItem;
- (void) removeItem;
@property (nonatomic, readonly) Item* item;
@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) float totalPrice;

@end

@interface OrderArea : CCVObject

- (id) initWithArea:(Area)area;
- (void) addItem:(Item*)item;
- (void) removeItem:(Item*)item;
@property (nonatomic, readonly) Area area;
@property (nonatomic, readonly) NSArray* orderItems;
@property (nonatomic, readonly) float totalPrice;

@end

@interface PlanOrder : CCVObject

- (void) addItem:(Item*)item;
- (void) removeItem:(Item*)item;

@property (nonatomic, readonly) NSArray* areaAndItems;
@property (nonatomic, readonly) float totalPrice;

@end
