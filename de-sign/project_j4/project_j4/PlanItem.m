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

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.type = ItemTypeItem;
    }
    return self;
}

- (id<ICVGameObject>)object {
    return nil;
}

- (void)setObject:(id<ICVGameObject>)object {
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
             @"t":[CCVSerializeInfo objectWithName:@"serializedType" objClass:[NSNumber class]],
             @"i":[CCVSerializeInfo objectWithName:@"item" objClass:[Item class]],
             @"ni":[CCVSerializeInfo objectWithName:@"nodeId" objClass:[NSString class]],
             @"dx": [CCVSerializeInfo objectWithClass:[NSNumber class]],
             @"dy": [CCVSerializeInfo objectWithClass:[NSNumber class]],
             @"dz": [CCVSerializeInfo objectWithClass:[NSNumber class]],
             //@"io":[CCVSerializeInfo objectWithName:@"isOverlap" objClass:[NSNumber class]],
//             @"ti":[CCVSerializeInfo objectWithName:@"textureId" objClass:[NSNumber class]],
             @"px": [CCVSerializeInfo objectWithClass:[NSNumber class]],
             @"py": [CCVSerializeInfo objectWithClass:[NSNumber class]],
             @"pz": [CCVSerializeInfo objectWithClass:[NSNumber class]],
             @"rw": [CCVSerializeInfo objectWithClass:[NSNumber class]],
             @"rx": [CCVSerializeInfo objectWithClass:[NSNumber class]],
             @"ry": [CCVSerializeInfo objectWithClass:[NSNumber class]],
             @"rz": [CCVSerializeInfo objectWithClass:[NSNumber class]],
//             @"sx": [CCVSerializeInfo objectWithClass:[NSNumber class]],
//             @"sy": [CCVSerializeInfo objectWithClass:[NSNumber class]],
//             @"sz": [CCVSerializeInfo objectWithClass:[NSNumber class]],
             @"p":[CCVSerializeInfo objectWithName:@"path" objClass:[NSMutableArray class]],
             };
}

@end
