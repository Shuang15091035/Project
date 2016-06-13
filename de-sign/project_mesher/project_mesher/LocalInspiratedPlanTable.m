//
//  LocalInspiratedPlanTable.m
//  project_mesher
//
//  Created by mac zdszkj on 16/4/11.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "LocalInspiratedPlanTable.h"
#import <jw/NSString+JWCoreCategory.h>

typedef NS_ENUM(int, LocalInspiratedPlanTableColumnId) {
    LocalInspiratedPlanTableColumnId_Id,
    LocalInspiratedPlanTableColumnId_Name,
    LocalInspiratedPlanTableColumnId_Preview,
    LocalInspiratedPlanTableColumnId_Scene,
    LocalInspiratedPlanTableColumnId_InspirateBackground,
    LocalInspiratedPlanTableColumnId_QuaterW,
    LocalInspiratedPlanTableColumnId_QuaterX,
    LocalInspiratedPlanTableColumnId_QuaterY,
    LocalInspiratedPlanTableColumnId_QuaterZ,
};

@interface LocalInspiratedPlanTable () {
    LocalInspiratedPlanTableFileType mFileType;
    id<IMesherModel> mModel;
    NSBundle *mBundle;
}

@end

@implementation LocalInspiratedPlanTable

- (id)initWithFileType:(LocalInspiratedPlanTableFileType)fileType model:(id<IMesherModel>)model bundle:(NSBundle *)bundle{
    self = [super initWithRecordType:[Plan class]];
    if (self != nil) {
        mFileType = fileType;
        mModel = model;
        mBundle = bundle;
    }
    return self;
}

- (id)newRecord {
    return [[InspiratedPlan alloc] initWithModel:mModel];
}

- (void)setRecord:(id)record word:(NSString *)word columnIndex:(int)columnIndex {
    InspiratedPlan *r = record;
    if (columnIndex == [self getColumnIndexById:LocalInspiratedPlanTableColumnId_Id]) {
        r.Id = [word integerValue];
    } else if (columnIndex == [self getColumnIndexById:LocalInspiratedPlanTableColumnId_Name]) {
        r.name = word;
    } else if (columnIndex == [self getColumnIndexById:LocalInspiratedPlanTableColumnId_Preview]) {
        switch (mFileType) {
            case LocalInspiratedPlanTableFileTypeDocument: {
                r.preview = [JWFile fileWithType:JWFileTypeDocument path:word];
                break;
            }
            case LocalInspiratedPlanTableFileTypeAsset: {
                r.preview = [JWFile fileWithBundle:mBundle path:[JWAssetsBundle nameForPath:word]];
                break;
            }
        }
        
    } else if (columnIndex == [self getColumnIndexById:LocalInspiratedPlanTableColumnId_Scene]) {
        switch (mFileType) {
            case LocalInspiratedPlanTableFileTypeDocument: {
                r.scene = [JWFile fileWithType:JWFileTypeDocument path:word];
                break;
            }
            case LocalInspiratedPlanTableFileTypeAsset: {
                r.scene = [JWFile fileWithBundle:mBundle path:[JWAssetsBundle nameForPath:word]];
                break;
            }
        }
    } else if (columnIndex == [self getColumnIndexById:LocalInspiratedPlanTableColumnId_InspirateBackground]) {
        switch (mFileType) {
            case LocalInspiratedPlanTableFileTypeDocument: {
                r.inspirateBackground = [JWFile fileWithType:JWFileTypeDocument path:word];
                break;
            }
            case LocalInspiratedPlanTableFileTypeAsset: {
                r.inspirateBackground = [JWFile fileWithBundle:mBundle path:[JWAssetsBundle nameForPath:word]];
                break;
            }
        }
    }
//    } else if (columnIndex == [self getColumnIndexById:LocalInspiratedPlanTableColumnId_QuaterW]) {
//        r.qw = [word floatValue];
//    }
//    else if (columnIndex == [self getColumnIndexById:LocalInspiratedPlanTableColumnId_QuaterX]) {
//        r.qx = [word floatValue];
//    }
//    else if (columnIndex == [self getColumnIndexById:LocalInspiratedPlanTableColumnId_QuaterY]) {
//        r.qy = [word floatValue];
//    }
//    else if (columnIndex == [self getColumnIndexById:LocalInspiratedPlanTableColumnId_QuaterZ]) {
//        r.qz = [word floatValue];
//    }
}

- (int)getColumnIdByName:(NSString *)columnName {
    if ([NSString is:columnName equalsTo:@"id"]) {
        return LocalInspiratedPlanTableColumnId_Id;
    }
    if ([NSString is:columnName equalsTo:@"名字"]) {
        return LocalInspiratedPlanTableColumnId_Name;
    }
    if ([NSString is:columnName equalsTo:@"缩略图"]) {
        return LocalInspiratedPlanTableColumnId_Preview;
    }
    if ([NSString is:columnName equalsTo:@"场景"]) {
        return LocalInspiratedPlanTableColumnId_Scene;
    }
    if ([NSString is:columnName equalsTo:@"背景"]) {
        return LocalInspiratedPlanTableColumnId_InspirateBackground;
    }
//    if ([NSString is:columnName equalsTo:@"qw"]) {
//        return LocalInspiratedPlanTableColumnId_QuaterW;
//    }
//    if ([NSString is:columnName equalsTo:@"qx"]) {
//        return LocalInspiratedPlanTableColumnId_QuaterX;
//    }
//    if ([NSString is:columnName equalsTo:@"qy"]) {
//        return LocalInspiratedPlanTableColumnId_QuaterY;
//    }
//    if ([NSString is:columnName equalsTo:@"qz"]) {
//        return LocalInspiratedPlanTableColumnId_QuaterZ;
//    }
    return -1;
}

- (int)getNumColumns {
    // 表格列数
    return 5;
}

- (NSString *)getRecord:(id)record columnIndex:(int)columnIndex {
    switch (mFileType) {
        case LocalInspiratedPlanTableFileTypeDocument: {
            InspiratedPlan *r = record;
            if (columnIndex == LocalInspiratedPlanTableColumnId_Id) {
                return [@(r.Id) stringValue];
            } else if (columnIndex == LocalInspiratedPlanTableColumnId_Name) {
                return r.name;
            } else if (columnIndex == LocalInspiratedPlanTableColumnId_Preview) {
                return r.preview == nil ? @"" : r.preview.path;
            } else if (columnIndex == LocalInspiratedPlanTableColumnId_Scene) {
                return r.scene == nil ? @"" : r.scene.path;
            }else if (columnIndex == LocalInspiratedPlanTableColumnId_InspirateBackground){
                return r.inspirateBackground == nil ? @"" : r.inspirateBackground.path;
            }
//            else if (columnIndex == LocalInspiratedPlanTableColumnId_QuaterW){
//                return [@(r.qw) stringValue];
//            }
//            else if (columnIndex == LocalInspiratedPlanTableColumnId_QuaterX){
//                return [@(r.qx) stringValue];
//            }
//            else if (columnIndex == LocalInspiratedPlanTableColumnId_QuaterY){
//                return [@(r.qy) stringValue];
//            }
//            else if (columnIndex == LocalInspiratedPlanTableColumnId_QuaterZ){
//                return [@(r.qz) stringValue];
//            }
            break;
        }
        case LocalInspiratedPlanTableFileTypeAsset: {
            // 暂时没有操作
            break;
        }
        default:
            break;
    }
    return nil;
}

- (NSString *)getColumnNameByIndex:(int)columnIndex {
    if (columnIndex == LocalInspiratedPlanTableColumnId_Id) {
        return @"id";
    } else if (columnIndex == LocalInspiratedPlanTableColumnId_Name) {
        return @"名字";
    } else if (columnIndex == LocalInspiratedPlanTableColumnId_Preview) {
        return @"缩略图";
    } else if (columnIndex == LocalInspiratedPlanTableColumnId_Scene) {
        return @"场景";
    } else if (columnIndex == LocalInspiratedPlanTableColumnId_InspirateBackground) {
        return @"背景";
    }
//    } else if (columnIndex == LocalInspiratedPlanTableColumnId_QuaterW) {
//        return @"qw";
//    } else if (columnIndex == LocalInspiratedPlanTableColumnId_QuaterX) {
//        return @"qx";
//    } else if (columnIndex == LocalInspiratedPlanTableColumnId_QuaterY) {
//        return @"qy";
//    } else if (columnIndex == LocalInspiratedPlanTableColumnId_QuaterZ) {
//        return @"qz";
//    }
    return nil;
}

@end
