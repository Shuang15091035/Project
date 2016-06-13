//
//  Item.m
//  project_mesher
//
//  Created by MacMini on 15/10/14.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Item.h"

@interface Item () {
    NSInteger mId;
    NSInteger mProductId;
    Product* mProduct;
    NSString* mName;
    float mPrice;
    id<JIFile> mPreview;
    id<JIFile> mPreviewSmall;
    id<JIFile> mPreviewBig;
    NSInteger mSourceId;
    Source* mSource;
    NSInteger mRooms;
    
}

@end

@implementation Item

@synthesize Id = mId;
@synthesize productId = mProductId;
@synthesize product = mProduct;
@synthesize name = mName;
@synthesize price = mPrice;
@synthesize preview = mPreview;
@synthesize previewSmall = mPreviewSmall;
@synthesize previewBig = mPreviewBig;
@synthesize sourceId = mSourceId;
@synthesize source = mSource;
@synthesize rooms = mRooms;


- (NSDictionary *)serializeMembers {
    return @{
             // Item类里接受的是“Id”(大写),JSON里数据是"id"(小写)   需要转换
             @"id":[JWSerializeInfo objectWithName:@"Id" objClass:[NSNumber class]],
            };
}


@end
