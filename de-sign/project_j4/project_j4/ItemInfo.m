//
//  ItemInfo.m
//  project_mesher
//
//  Created by mac zdszkj on 16/1/7.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "ItemInfo.h"

@interface ItemInfo () {
    ItemType mType;
    NSString* mNodeId;
    Item* mItem;
    BOOL mIsOvetlap;
    CCCColor mDiffuseColor;
    NSMutableArray *mPath;
    
    NSNumber* mDx; // 法线
    NSNumber* mDy;
    NSNumber* mDz;
}

@end

@implementation ItemInfo

@synthesize type = mType;
@synthesize nodeId = mNodeId;
@synthesize item = mItem;
@synthesize isOverlap = mIsOvetlap;
@synthesize diffuseColor = mDiffuseColor;
@synthesize path = mPath;

@synthesize dx = mDx;
@synthesize dy = mDy;
@synthesize dz = mDz;

@end
