//
//  CircleModel.h
//  DesignFun
//
//  Created by qianfeng on 15/10/23.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"

@protocol CircleList
@end

@interface CircleList : JSONModel
@property (nonatomic, copy) NSString <Optional>*id;
@property (nonatomic, copy) NSString <Optional>*name;
@property (nonatomic, copy) NSString <Optional>*attention;
@property (nonatomic, copy) NSString <Optional>*cardSum;
@property (nonatomic, copy) NSString <Optional>*img;
@property (nonatomic, copy) NSString <Optional>*headimg;
@property (nonatomic, copy) NSString <Optional>*desc;
@property (nonatomic, copy) NSString <Optional>*groupid;
@property (nonatomic, copy) NSString <Optional>*groupname;
@end

@interface CircleModel : JSONModel
@property (nonatomic, strong) NSMutableArray <Optional,CircleList>*list;
@end
