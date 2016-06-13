//
//  PlanItem.h
//  project_mesher
//
//  Created by mac zdszkj on 15/11/17.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

@interface PlanItem : CCVSerializeObject

@property (nonatomic, readwrite) ItemType type;
@property (nonatomic, readwrite) Item *item;
@property (nonatomic, readwrite) NSString* nodeId; // 户型节点下的子节点(墙,地板,天花...)的名字
@property (nonatomic, readwrite) NSNumber* dx; // 法线
@property (nonatomic, readwrite) NSNumber* dy;
@property (nonatomic, readwrite) NSNumber* dz;

//@property (nonatomic, readwrite) NSNumber* textureId; // 更改后的贴图素材id
@property (nonatomic, readwrite) id<ICVGameObject> object;

@property (nonatomic, readwrite) NSNumber* px;
@property (nonatomic, readwrite) NSNumber* py;
@property (nonatomic, readwrite) NSNumber* pz;

@property (nonatomic, readwrite) NSNumber* rw;
@property (nonatomic, readwrite) NSNumber* rx;
@property (nonatomic, readwrite) NSNumber* ry;
@property (nonatomic, readwrite) NSNumber* rz;

@property (nonatomic, readwrite) NSNumber* serializedType;

@property (nonatomic, readwrite) NSNumber* isOverlap;

@property (nonatomic,readwrite) NSMutableArray *path;

// NOTE 不导入缩放信息
//@property (nonatomic, readwrite) NSNumber* sx;
//@property (nonatomic, readwrite) NSNumber* sy;
//@property (nonatomic, readwrite) NSNumber* sz;

@end
