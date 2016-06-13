//
//  LocalInspiratedPlanTable.h
//  project_mesher
//
//  Created by mac zdszkj on 16/4/11.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Data.h"

typedef NS_ENUM(NSInteger, LocalInspiratedPlanTableFileType) {
    LocalInspiratedPlanTableFileTypeDocument,
    LocalInspiratedPlanTableFileTypeAsset,
};

@interface LocalInspiratedPlanTable : JWFileTable

- (id) initWithFileType:(LocalInspiratedPlanTableFileType)fileType model:(id<IMesherModel>)model bundle:(NSBundle*)bundle;

@end
