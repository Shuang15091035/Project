//
//  ItemInfo.h
//  project_mesher
//
//  Created by mac zdszkj on 16/1/7.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

@interface ItemInfo : CCVObject

@property (nonatomic, readwrite) ItemType type;
@property (nonatomic, readwrite) NSString* nodeId;
@property (nonatomic, readwrite) Item* item;
@property (nonatomic, readwrite) BOOL isOverlap; // 判断是否有重叠
@property (nonatomic, readwrite) CCCColor diffuseColor;
@property (nonatomic, readwrite) NSMutableArray *path;

@property (nonatomic, readwrite) NSNumber* dx; // 法线
@property (nonatomic, readwrite) NSNumber* dy;
@property (nonatomic, readwrite) NSNumber* dz;

@end
