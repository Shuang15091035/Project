//
//  LBDBManager.h
//  LBBSmileCheerful
//
//  Created by qianfeng007 on 15/10/6.
//  Copyright (c) 2015年 刘备备. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DFImage;
@interface DBManager : NSObject

+ (instancetype)shareInstance;;

- (BOOL)insertDataWithModel:(DFImage *)model;

- (BOOL)deleteDataWithModel:(DFImage *)model;

- (BOOL)isExistModel:(DFImage *)model;

- (NSMutableArray *)quaryAllData;

@end
