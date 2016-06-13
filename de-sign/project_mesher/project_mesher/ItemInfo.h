//
//  ItemInfo.h
//  project_mesher
//
//  Created by mac zdszkj on 16/1/7.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"
#import "Stretch.h"
#import "TilingOffset.h"
#import "Scale.h"

@interface ItemInfo : JWObject

@property (nonatomic, readwrite) ItemType type;
@property (nonatomic, readwrite) NSString* nodeId;
@property (nonatomic, readwrite) Item* item;
@property (nonatomic, readwrite) BOOL isOverlap; // 判断是否有重叠
@property (nonatomic, readwrite) JCColor diffuseColor;
@property (nonatomic, readwrite) NSMutableArray *path;

@property (nonatomic, readwrite) NSNumber* dx; // 法线
@property (nonatomic, readwrite) NSNumber* dy;
@property (nonatomic, readwrite) NSNumber* dz;

@property (nonatomic, readwrite) Stretch *st;
@property (nonatomic, readwrite) TilingOffset *ts;
@property (nonatomic, readwrite) Scale *sc;
@property (nonatomic, readwrite) JCVector3 originScale;

@property (nonatomic, readwrite) id<JIMaterial> material;
@property (nonatomic, readwrite) NSMutableArray *materials;
@property (nonatomic, readwrite) NSMutableDictionary *materialsDictionary;

@end
