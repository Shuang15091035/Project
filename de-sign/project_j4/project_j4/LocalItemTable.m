//
//  LocalItemTable.m
//  project_mesher
//
//  Created by ddeyes on 15/10/23.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "LocalItemTable.h"
#import <ctrlcv/NSString+CCVCoreCategory.h>

typedef NS_ENUM(int, LocalItemTableColumnIds) {
    LocalItemTableColumnId_Id,
    LocalItemTableColumnId_ProductId,
    LocalItemTableColumnId_Name,
    LocalItemTableColumnId_Price,
    LocalItemTableColumnId_Preview,
    LocalItemTableColumnId_SourceId,
    LocalItemTableColumnId_Rooms,
};

@interface LocalItemTable () {
    NSBundle *mBundle;
}

@end

@implementation LocalItemTable

- (instancetype)initWithBundle:(NSBundle *)bundle {
    self = [super initWithRecordType:[Item class]];
    if (self != nil) {
        mBundle = bundle;
    }
    return self;
}

- (void)setRecord:(id)record word:(NSString *)word columnIndex:(int)columnIndex {
    Item* r = record;
    if (columnIndex == [self getColumnIndexById:LocalItemTableColumnId_Id]) {
        r.Id = [word integerValue];
    } else if(columnIndex == [self getColumnIndexById:LocalItemTableColumnId_ProductId]) {
        r.productId = [word integerValue];
    } else if(columnIndex == [self getColumnIndexById:LocalItemTableColumnId_Name]) {
        r.name = word;
    } else if(columnIndex == [self getColumnIndexById:LocalItemTableColumnId_Price]) {
        r.price = [word floatValue];
    } else if(columnIndex == [self getColumnIndexById:LocalItemTableColumnId_Preview]) {
        r.preview = [CCVFile fileWithBundle:mBundle path:[CCVAssetsBundle nameForPath:word]];
        r.previewSmall = [CCVFile fileWithBundle:mBundle path:[CCVAssetsBundle nameForPath:word]];
        r.previewSmall.extra = @(1);
        r.previewBig = [CCVFile fileWithBundle:mBundle path:[CCVAssetsBundle nameForPath:word]];
        r.previewBig.extra = @(2);
    } else if(columnIndex == [self getColumnIndexById:LocalItemTableColumnId_SourceId]) {
        r.sourceId = [word integerValue];
    } else if(columnIndex == [self getColumnIndexById:LocalItemTableColumnId_Rooms]) {
        r.rooms = [word integerValue];
    }
}

- (int)getColumnIdByName:(NSString *)columnName {
    if ([NSString is:columnName equalsTo:@"id"]) {
        return LocalItemTableColumnId_Id;
    }
    if ([NSString is:columnName equalsTo:@"产品id"]) {
        return LocalItemTableColumnId_ProductId;
    }
    if ([NSString is:columnName equalsTo:@"名字"]) {
        return LocalItemTableColumnId_Name;
    }
    if ([NSString is:columnName equalsTo:@"价格"]) {
        return LocalItemTableColumnId_Price;
    }
    if ([NSString is:columnName equalsTo:@"缩略图"]) {
        return LocalItemTableColumnId_Preview;
    }
    if ([NSString is:columnName equalsTo:@"素材id"]) {
        return LocalItemTableColumnId_SourceId;
    }
    if ([NSString is:columnName equalsTo:@"户型"]) {
        return LocalItemTableColumnId_Rooms;
    }
    return -1;
}

- (int)getNumColumns {
    // 表格列数
    return 7;
}

- (NSString *)getRecord:(id)record columnIndex:(int)columnIndex {
    // TODO
    return nil;
}

- (NSString *)getColumnNameByIndex:(int)columnIndex {
    // TODO
    return nil;
}

@end
