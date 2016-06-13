//
//  Item.h
//  project_mesher
//
//  Created by MacMini on 15/10/14.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

// 物件
@interface Item : CCVSerializeObject

@property (nonatomic, readwrite) NSInteger Id;
@property (nonatomic, readwrite) NSInteger productId;
@property (nonatomic, readwrite) Product* product; // 物件所在的产品
@property (nonatomic, readwrite) NSString* name; // 名字
@property (nonatomic, readwrite) float price; // 价格
@property (nonatomic, readwrite) id<ICVFile> preview; // 缩略图
@property (nonatomic, readwrite) id<ICVFile> previewSmall; // 缩略图小，用于产品列表
@property (nonatomic, readwrite) id<ICVFile> previewBig; // 缩略图大，用于物件详情
@property (nonatomic, readwrite) NSInteger sourceId;
@property (nonatomic, readwrite) Source* source; // 绑定的素材
@property (nonatomic, readwrite) NSInteger rooms; // 户型


@end
