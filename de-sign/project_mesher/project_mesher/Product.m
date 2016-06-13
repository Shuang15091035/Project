//
//  Product.m
//  project_mesher
//
//  Created by ddeyes on 15/10/23.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Product.h"

@interface Product () {
    NSInteger mId;
    NSString* mName;
    Area mArea;
    NSString *mCategory;
    Position mPosition;
    id<JIFile> mPreview;
    NSString* mLink;
    NSString* mDescription;
    NSMutableArray* mItems;
}

@end

@implementation Product

@synthesize Id = mId;
@synthesize name = mName;
@synthesize area = mArea;
@synthesize category = mCategory;
@synthesize position = mPosition;
@synthesize preview = mPreview;
@synthesize link = mLink;
@synthesize description = mDescription;

- (void)addItem:(Item *)item {
    if (mItems == nil) {
        mItems = [NSMutableArray array];
    }
    [mItems addObject:item likeASet:YES willIngoreNil:YES];
}

- (void)removeItem:(Item *)item {
    if (mItems == nil) {
        return;
    }
    [mItems remove:item];
}

- (NSArray *)items {
    return mItems;
}

@end
