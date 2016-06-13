//
//  ObjectExtra.m
//  project_mesher
//
//  Created by mac zdszkj on 16/3/16.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "ObjectExtra.h"

@interface ObjectExtra () {
    Item *mItem;
    ItemInfo *mItemInfo;
    id<JIGameObject> mArchBorder;
    ItemAnimation *mItemAnimation;
    id<JIMaterial> mArchMaterial;
    NSUInteger mIndexPathRow;
}

@end

@implementation ObjectExtra

@synthesize item = mItem;
@synthesize itemInfo = mItemInfo;
@synthesize archBorder = mArchBorder;
@synthesize itemAnimation = mItemAnimation;
@synthesize archMaterial = mArchMaterial;
@synthesize indexPathRow = mIndexPathRow;

@end
