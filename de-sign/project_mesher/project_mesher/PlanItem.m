//
//  PlanItem.m
//  project_mesher
//
//  Created by mac zdszkj on 15/11/17.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "PlanItem.h"
#import "Item.h"
#import "ItemInfo.h"
#import "Data.h"

@interface PlanItem () {
    ItemType mType;
    Item *mItem;
    NSString* mNodeId;
    
    NSNumber* mDx; // 法线
    NSNumber* mDy;
    NSNumber* mDz;
    
//    NSNumber* mTextureId;
    NSNumber* mPx;
    NSNumber* mPy;
    NSNumber* mPz;
    NSNumber* mRw;
    NSNumber* mRx;
    NSNumber* mRy;
    NSNumber* mRz;
//    NSNumber* mSx;
//    NSNumber* mSy;
//    NSNumber* mSz;
    
    NSNumber* mIsOverlap;
    NSMutableArray *mPath;
    
    NSNumber* mQw;
    NSNumber* mQx;
    NSNumber* mQy;
    NSNumber* mQz;
    
    Stretch *mSt;
    TilingOffset *mTs;
    Scale *mSc;
}

@end

@implementation PlanItem

@synthesize type = mType;
@synthesize item = mItem;
@synthesize nodeId = mNodeId;
//@synthesize textureId = mTextureId;
@synthesize dx = mDx;
@synthesize dy = mDy;
@synthesize dz = mDz;

@synthesize px = mPx;
@synthesize py = mPy;
@synthesize pz = mPz;
@synthesize rw = mRw;
@synthesize rx = mRx;
@synthesize ry = mRy;
@synthesize rz = mRz;
//@synthesize sx = mSx;
//@synthesize sy = mSy;
//@synthesize sz = mSz;

@synthesize isOverlap = mIsOverlap;
@synthesize path = mPath;

@synthesize qw = mQw;
@synthesize qx = mQx;
@synthesize qy = mQy;
@synthesize qz = mQz;

@synthesize st = mSt;
@synthesize ts = mTs;
@synthesize sc = mSc;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.type = ItemTypeItem;
    }
    return self;
}

- (id<JIGameObject>)object {
    return nil;
}

- (void)setObject:(id<JIGameObject>)object {
    mPx = @(object.transform.position.x);
    mPy = @(object.transform.position.y);
    mPz = @(object.transform.position.z);
    mRw = @(object.transform.orientation.w);
    mRx = @(object.transform.orientation.x);
    mRy = @(object.transform.orientation.y);
    mRz = @(object.transform.orientation.z);
    ItemInfo* itemInfo = [Data getItemInfoFromInstance:object];
    if (itemInfo != nil) {
        mType = itemInfo.type;
        mNodeId = itemInfo.nodeId;
        if (itemInfo.item != nil) {
           mItem = itemInfo.item;
        }
        if (itemInfo.isOverlap == true) {
            mIsOverlap = [NSNumber numberWithBool:itemInfo.isOverlap];
        }
        if (itemInfo.type != ItemTypeItem && itemInfo.type != ItemTypeUnknown) {
            mPath = itemInfo.path;
            mDx = itemInfo.dx;
            mDy = itemInfo.dy;
            mDz = itemInfo.dz;
        }else {
            mSt = itemInfo.st;
            mTs = itemInfo.ts;
            mSc = itemInfo.sc;
        }
    }
//    mSx = @(object.transform.scale.x);
//    mSy = @(object.transform.scale.y);
//    mSz = @(object.transform.scale.z);
}

- (NSNumber *)serializedType {
    if (mType == ItemTypeItem) {
        return nil;
    } else {
        return @(mType);
    }
}

- (void)setSerializedType:(NSNumber *)serializedType {
    mType = (ItemType)[serializedType intValue];
}

- (NSNumber *)isOverlap {
    if (mIsOverlap == nil) {
        return nil;
    } else {
        return mIsOverlap;
    }
}

- (void)setIsOverlap:(NSNumber *)isOverlap {
    mIsOverlap = isOverlap;
}

- (NSDictionary *)serializeMembers {
    return @{
             @"t":[JWSerializeInfo objectWithName:@"serializedType" objClass:[NSNumber class]],
             @"i":[JWSerializeInfo objectWithName:@"item" objClass:[Item class]],
             @"ni":[JWSerializeInfo objectWithName:@"nodeId" objClass:[NSString class]],
             @"dx":[JWSerializeInfo objectWithClass:[NSNumber class]],
             @"dy":[JWSerializeInfo objectWithClass:[NSNumber class]],
             @"dz":[JWSerializeInfo objectWithClass:[NSNumber class]],
             //@"io":[JWSerializeInfo objectWithName:@"isOverlap" objClass:[NSNumber class]],
//             @"ti":[JWSerializeInfo objectWithName:@"textureId" objClass:[NSNumber class]],
             @"px":[JWSerializeInfo objectWithClass:[NSNumber class]],
             @"py":[JWSerializeInfo objectWithClass:[NSNumber class]],
             @"pz":[JWSerializeInfo objectWithClass:[NSNumber class]],
             @"rw":[JWSerializeInfo objectWithClass:[NSNumber class]],
             @"rx":[JWSerializeInfo objectWithClass:[NSNumber class]],
             @"ry":[JWSerializeInfo objectWithClass:[NSNumber class]],
             @"rz":[JWSerializeInfo objectWithClass:[NSNumber class]],
//             @"sx": [JWSerializeInfo objectWithClass:[NSNumber class]],
//             @"sy": [JWSerializeInfo objectWithClass:[NSNumber class]],
//             @"sz": [JWSerializeInfo objectWithClass:[NSNumber class]],
             @"p":[JWSerializeInfo objectWithName:@"path" objClass:[NSMutableArray class]],
             @"qw":[JWSerializeInfo objectWithClass:[NSNumber class]],
             @"qx":[JWSerializeInfo objectWithClass:[NSNumber class]],
             @"qy":[JWSerializeInfo objectWithClass:[NSNumber class]],
             @"qz":[JWSerializeInfo objectWithClass:[NSNumber class]],
             @"st":[JWSerializeInfo objectWithName:@"st" objClass:[Stretch class]],
             @"ts":[JWSerializeInfo objectWithName:@"ts" objClass:[TilingOffset class]],
             @"sc":[JWSerializeInfo objectWithName:@"sc" objClass:[Scale class]],
             };
}

@end
