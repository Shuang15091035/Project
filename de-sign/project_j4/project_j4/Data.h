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

@interface Data : CCVObject

+ (Area) parseArea:(NSString*)str;
+ (NSString*) areaToString:(Area)area;
+ (SourceType) parseSourceType:(NSString*)str;
+ (Position) parsePosition:(NSString*)str;
+ (NSString*)positionToString:(Position)position;

// GameObject其实就是Item在场景中的一个实例，他们是N对1的关系
+ (Item*) getItemFromInstance:(id<ICVGameObject>)instance;
+ (BOOL) bindInstance:(id<ICVGameObject>)instance toItem:(Item*)item;
+ (ItemInfo*) getItemInfoFromInstance:(id<ICVGameObject>)instance;
+ (BOOL) bindInstance:(id<ICVGameObject>)instance toItemInfo:(ItemInfo*)itemInfo;

@end
