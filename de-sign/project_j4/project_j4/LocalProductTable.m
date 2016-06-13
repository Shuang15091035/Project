//
//  LocalProductTable.m
//  project_mesher
//
//  Created by ddeyes on 15/10/23.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "LocalProductTable.h"
#import <ctrlcv/NSString+CCVCoreCategory.h>

typedef NS_ENUM(int, LocalProductTableColumnIds) {
    LocalProductTableColumnId_Id,
    LocalProductTableColumnId_Name,
    LocalProductTableColumnId_Area,
    LocalProductTableColumnId_Category,
    LocalProductTableColumnId_Position,
    LocalProductTableColumnId_Preview,
    LocalProductTableColumnId_Link,
    LocalProductTableColumnId_Description,
};

@interface LocalProductTable () {
    NSBundle *mBundle;
}

@end

@implementation LocalProductTable

- (instancetype)initWithBundle:(NSBundle *)bundle {
    self = [super initWithRecordType:[Product class]];
    if (self != nil) {
        mBundle = bundle;
    }
    return self;
}

- (void)setRecord:(id)record word:(NSString *)word columnIndex:(int)columnIndex {
    Product* r = record;
    if (columnIndex == [self getColumnIndexById:LocalProductTableColumnId_Id]) {
        r.Id = [word integerValue];
    } else if(columnIndex == [self getColumnIndexById:LocalProductTableColumnId_Name]) {
        r.name = word;
    } else if(columnIndex == [self getColumnIndexById:LocalProductTableColumnId_Area]) {
        r.area = [Data parseArea:word];
    } else if (columnIndex == [self getColumnIndexById:LocalProductTableColumnId_Category]) {
        r.category = word;
    } else if (columnIndex == [self getColumnIndexById:LocalProductTableColumnId_Position]) {
        r.position = [Data parsePosition:word];
    } else if(columnIndex == [self getColumnIndexById:LocalProductTableColumnId_Preview]) {
        r.preview = [CCVFile fileWithBundle:mBundle path:[CCVAssetsBundle nameForPath:word]];
    } else if(columnIndex == [self getColumnIndexById:LocalProductTableColumnId_Link]) {
        r.link = word;
    } else if(columnIndex == [self getColumnIndexById:LocalProductTableColumnId_Description]) {
        r.description = word;
    }
}

- (int)getColumnIdByName:(NSString *)columnName {
    if ([NSString is:columnName equalsTo:@"id"]) {
        return LocalProductTableColumnId_Id;
    }
    if ([NSString is:columnName equalsTo:@"名字"]) {
        return LocalProductTableColumnId_Name;
    }
    if ([NSString is:columnName equalsTo:@"区域"]) {
        return LocalProductTableColumnId_Area;
    }
    if ([NSString is:columnName equalsTo:@"分类"]) {
        return LocalProductTableColumnId_Category;
    }
    if ([NSString is:columnName equalsTo:@"方位"]) {
        return LocalProductTableColumnId_Position;
    }
    if ([NSString is:columnName equalsTo:@"缩略图"]) {
        return LocalProductTableColumnId_Preview;
    }
    if ([NSString is:columnName equalsTo:@"链接"]) {
        return LocalProductTableColumnId_Link;
    }
    if ([NSString is:columnName equalsTo:@"描述"]) {
        return LocalProductTableColumnId_Description;
    }
    return -1;
}

- (int)getNumColumns {
    // 表格列数
    return 8;
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

