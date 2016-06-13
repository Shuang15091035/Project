//
//  ObjectExtra.m
//  project_j4
//
//  Created by mac zdszkj on 16/3/16.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "ObjectExtra.h"

@interface ObjectExtra () {
    Item *mItem;
    ItemInfo *mItemInfo;
//    id<ICVGameObject> mBorderObject;
    ItemAnimation *mItemAnimation;
    id<ICVMaterial> mArchMaterial;
}

@end

@implementation ObjectExtra

@synthesize item = mItem;
@synthesize itemInfo = mItemInfo;
//@synthesize borderObject = mBorderObject;
@synthesize itemAnimation = mItemAnimation;
@synthesize archMaterial = mArchMaterial;

@end
