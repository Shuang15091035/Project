//
//  LocalPlanTable.m
//  project_mesher
//
//  Created by mac zdszkj on 15/11/12.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "LocalPlanTable.h"
#import <ctrlcv/NSString+CCVCoreCategory.h>

typedef NS_ENUM(int, LocalPlanTableColumnId) {
    LocalPlanTableColumnId_Id,
    LocalPlanTableColumnId_Name,
    LocalPlanTableColumnId_Preview,
    LocalPlanTableColumnId_Scene,
    LocalPlanTableColumnId_Rooms,
};

@interface LocalPlanTable () {
    LocalPlanTableFileType mFileType;
    id<IMesherModel> mModel;
    NSBundle *mBundle;
}

@end

@implementation LocalPlanTable

- (id)initWithFileType:(LocalPlanTableFileType)fileType model:(id<IMesherModel>)model bundle:(NSBundle *)bundle{
    self = [super initWithRecordType:[Plan class]];
    if (self != nil) {
        mFileType = fileType;
        mModel = model;
        mBundle = bundle;
    }
    return self;
}

- (id)newRecord {
    return [[Plan alloc] initWithModel:mModel];
}

- (void)setRecord:(id)record word:(NSString *)word columnIndex:(int)columnIndex {
    Plan *r = record;
    if (columnIndex == [self getColumnIndexById:LocalPlanTableColumnId_Id]) {
        r.Id = [word integerValue];
    } else if (columnIndex == [self getColumnIndexById:LocalPlanTableColumnId_Name]) {
        r.name = word;
    } else if (columnIndex == [self getColumnIndexById:LocalPlanTableColumnId_Preview]) {
        switch (mFileType) {
            case LocalPlanTableFileTypeDocument: {
                r.preview = [CCVFile fileWithType:CCVFileTypeDocument path:word];
                break;
            }
            case LocalPlanTableFileTypeAsset: {
                r.preview = [CCVFile fileWithBundle:mBundle path:[CCVAssetsBundle nameForPath:word]];
                break;
            }
        }
        
    } else if (columnIndex == [self getColumnIndexById:LocalPlanTableColumnId_Scene]) {
        switch (mFileType) {
            case LocalPlanTableFileTypeDocument: {
                r.scene = [CCVFile fileWithType:CCVFileTypeDocument path:word];
                break;
            }
            case LocalPlanTableFileTypeAsset: {
                r.scene = [CCVFile fileWithBundle:mBundle path:[CCVAssetsBundle nameForPath:word]];
                break;
            }
        }
    } else if (columnIndex == [self getColumnIndexById:LocalPlanTableColumnId_Rooms]) {
        switch (mFileType) {
            case LocalPlanTableFileTypeDocument: {
                break;
            }
            case LocalPlanTableFileTypeAsset: {
                r.rooms = [word integerValue];
                break;
            }
        }
    }
}

- (int)getColumnIdByName:(NSString *)columnName {
    if ([NSString is:columnName equalsTo:@"id"]) {
        return LocalPlanTableColumnId_Id;
    }
    if ([NSString is:columnName equalsTo:@"名字"]) {
        return LocalPlanTableColumnId_Name;
    }
    if ([NSString is:columnName equalsTo:@"缩略图"]) {
        return LocalPlanTableColumnId_Preview;
    }
    if ([NSString is:columnName equalsTo:@"场景"]) {
        return LocalPlanTableColumnId_Scene;
    }
    if ([NSString is:columnName equalsTo:@"户型"]) {
        return LocalPlanTableColumnId_Rooms;
    }
    return -1;
}


- (int)getNumColumns {
    // 表格列数
    switch (mFileType) {
        case LocalPlanTableFileTypeDocument: {
            return 4;
            break;
        }
        case LocalPlanTableFileTypeAsset: {
            return 5;
            break;
        }
    }
}

- (NSString *)getRecord:(id)record columnIndex:(int)columnIndex {
    switch (mFileType) {
        case LocalPlanTableFileTypeDocument: {
            Plan *r = record;
            if (columnIndex == LocalPlanTableColumnId_Id) {
                return [@(r.Id) stringValue];
            } else if (columnIndex == LocalPlanTableColumnId_Name) {
                return r.name;
            } else if (columnIndex == LocalPlanTableColumnId_Preview) {
                return r.preview == nil ? @"" : r.preview.path;
            } else if (columnIndex == LocalPlanTableColumnId_Scene) {
                return r.scene == nil ? @"" : r.scene.path;
            }else if (columnIndex == LocalPlanTableColumnId_Rooms){
                return [@(r.rooms) stringValue];
            }
            break;
        }
        case LocalPlanTableFileTypeAsset: {
            // 暂时没有操作
            break;
        }
        default:
            break;
    }
    return nil;
}

- (NSString *)getColumnNameByIndex:(int)columnIndex {
    if (columnIndex == LocalPlanTableColumnId_Id) {
        return @"id";
    } else if (columnIndex == LocalPlanTableColumnId_Name) {
        return @"名字";
    } else if (columnIndex == LocalPlanTableColumnId_Preview) {
        return @"缩略图";
    } else if (columnIndex == LocalPlanTableColumnId_Scene) {
        return @"场景";
    } else if (columnIndex == LocalPlanTableColumnId_Scene) {
        return @"户型";
    }
    return nil;
}

@end
