//
//  LocalSourceTable.m
//  project_mesher
//
//  Created by ddeyes on 15/10/23.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "LocalSourceTable.h"
#import <jw/NSString+JWCoreCategory.h>

typedef NS_ENUM(int, LocalSourceTableColumnIds) {
    LocalSourceTableColumnId_Id,
    LocalSourceTableColumnId_Name,
    LocalSourceTableColumnId_Type,
    LocalSourceTableColumnId_File,
    LocalSourceTableColumnId_Preview,
};

@interface LocalSourceTable () {
    NSBundle* mBundle;
}

@end

@implementation LocalSourceTable

- (id)initWithBundle:(NSBundle *)bundle {
    self = [super initWithRecordType:[Source class]];
    if (self != nil) {
        mBundle = bundle;
    }
    return self;
}

- (void)setRecord:(id)record word:(NSString *)word columnIndex:(int)columnIndex {
    Source* r = record;
    if (columnIndex == [self getColumnIndexById:LocalSourceTableColumnId_Id]) {
        r.Id = [word integerValue];
    } else if(columnIndex == [self getColumnIndexById:LocalSourceTableColumnId_Name]) {
        r.name = word;
    } else if(columnIndex == [self getColumnIndexById:LocalSourceTableColumnId_Type]) {
        r.type = [Data parseSourceType:word];
    } else if(columnIndex == [self getColumnIndexById:LocalSourceTableColumnId_File]) {
        r.file = [JWFile fileWithBundle:mBundle path:[JWAssetsBundle nameForPath:word]];
    } else if(columnIndex == [self getColumnIndexById:LocalSourceTableColumnId_Preview]) {
        r.preview = [JWFile fileWithBundle:mBundle path:[JWAssetsBundle nameForPath:word]];
    }
}

- (int)getColumnIdByName:(NSString *)columnName {
    if ([NSString is:columnName equalsTo:@"id"]) {
        return LocalSourceTableColumnId_Id;
    }
    if ([NSString is:columnName equalsTo:@"名字"]) {
        return LocalSourceTableColumnId_Name;
    }
    if ([NSString is:columnName equalsTo:@"类型"]) {
        return LocalSourceTableColumnId_Type;
    }
    if ([NSString is:columnName equalsTo:@"文件"]) {
        return LocalSourceTableColumnId_File;
    }
    if ([NSString is:columnName equalsTo:@"缩略图"]) {
        return LocalSourceTableColumnId_Preview;
    }
    return -1;
}

- (int)getNumColumns {
    // 表格列数
    return 5;
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
