//
//  CellModel.m
//  DesignFun
//
//  Created by qianfeng on 15/10/4.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CellModel.h"

@implementation AboutNews
+(JSONKeyMapper *)keyMapper{
    
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"aboutId"}];
}
@end

@implementation CellModel
+(JSONKeyMapper *)keyMapper{

    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"cellId"}];
}
@end
