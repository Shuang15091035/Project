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
    JCColor mDiffuseColor;
    NSMutableArray *mPath;
    
    NSNumber* mDx; // 法线
    NSNumber* mDy;
    NSNumber* mDz;
    
    Stretch *mSt;
    TilingOffset *mTs;
    Scale *mSc;
    JCVector3 mOriginScale;
    
    id<JIMaterial> mMaterial;
    NSMutableArray *mMaterials;
    NSMutableDictionary *mMaterialsDictionary;
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

@synthesize st = mSt;
@synthesize ts = mTs;
@synthesize sc = mSc;
@synthesize originScale = mOriginScale;

@synthesize material = mMaterial;
@synthesize materials = mMaterials;

@synthesize materialsDictionary = mMaterialsDictionary;

//- (NSDictionary *)serializeMembers {
//    return @{
//             @"st":[JWSerializeInfo objectWithClass:[Stretch class]],
//             @"ts":[JWSerializeInfo objectWithClass:[TilingOffset class]],
//             };
//}

@end
