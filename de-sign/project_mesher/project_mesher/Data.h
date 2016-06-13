//
//  Data.h
//  project_mesher
//
//  Created by ddeyes on 15/10/23.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"
#import "Source.h"
#import "Item.h"
#import "ItemInfo.h"
#import "Product.h"
#import "Plan.h"
#import "PlanOrder.h"
#import "ObjectExtra.h"

#import "InspiratedPlan.h"

@interface Data : JWObject

+ (Area) parseArea:(NSString*)str;
+ (NSString*) areaToString:(Area)area;
+ (SourceType) parseSourceType:(NSString*)str;
+ (Position) parsePosition:(NSString*)str;
+ (PlanType) parsePlanType:(NSString*)str;
+ (NSString*) planTypeToString:(PlanType)type;
+ (NSString*)positionToString:(Position)position;

// GameObject其实就是Item在场景中的一个实例，他们是N对1的关系
+ (Item*) getItemFromInstance:(id<JIGameObject>)instance;
+ (BOOL) bindInstance:(id<JIGameObject>)instance toItem:(Item*)item;
+ (ItemInfo*) getItemInfoFromInstance:(id<JIGameObject>)instance;
+ (BOOL) bindInstance:(id<JIGameObject>)instance toItemInfo:(ItemInfo*)itemInfo;

@end
