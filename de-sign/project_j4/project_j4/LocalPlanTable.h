//
//  LocalPlanTable.h
//  project_mesher
//
//  Created by mac zdszkj on 15/11/12.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Data.h"

typedef NS_ENUM(NSInteger, LocalPlanTableFileType) {
    LocalPlanTableFileTypeDocument,
    LocalPlanTableFileTypeAsset,
};

@interface LocalPlanTable : CCVFileTable

- (id) initWithFileType:(LocalPlanTableFileType)fileType model:(id<IMesherModel>)model bundle:(NSBundle*)bundle;

@end
