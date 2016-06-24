//
//  SquareModle.h
//  DesignFun
//
//  Created by qianfeng on 15/10/23.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"

@protocol SquareNews
@end
@interface SquareNews : JSONModel
@property (nonatomic, copy) NSString <Optional>*tid;
@property (nonatomic, copy) NSString <Optional>*fid;
@property (nonatomic, copy) NSString <Optional>*title;
@property (nonatomic, copy) NSString <Optional>*publishTime;
@property (nonatomic, copy) NSString <Optional>*timeAgo;
@property (nonatomic, copy) NSString <Optional>*replies;
@property (nonatomic, copy) NSString <Optional>*authorId;
@property (nonatomic, copy) NSString <Optional>*authorHead;
@property (nonatomic, copy) NSString <Optional>*author;
@property (nonatomic, copy) NSString <Optional>*level;
@property (nonatomic, copy) NSString <Optional>*newsAbstract;
@property (nonatomic, copy) NSMutableArray <Optional>*picList;
@property (nonatomic, copy) NSString <Optional>*circleName;
@end

@interface SquareModle : JSONModel
@property (nonatomic, strong) NSMutableArray <Optional,SquareNews>*newsList;
@end
