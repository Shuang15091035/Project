//
//  ObjectExtra.h
//  project_j4
//
//  Created by mac zdszkj on 16/3/16.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"
#import "Item.h"
#import "ItemInfo.h"
#import "ItemAnimation.h"

@interface ObjectExtra : CCVObject

@property (nonatomic, readwrite) Item *item;
@property (nonatomic, readwrite) ItemInfo *itemInfo;
//@property (nonatomic, readwrite) id<ICVGameObject> borderObject;
@property (nonatomic, readwrite) ItemAnimation *itemAnimation;
@property (nonatomic, readwrite) id<ICVMaterial> archMaterial;

@end
