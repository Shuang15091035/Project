//
//  militaryModel.h
//  DesignFun
//
//  Created by qianfeng on 15/9/30.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"


@protocol PicsList
@end
@interface  PicsList : JSONModel
@property (nonatomic, copy) NSString <Optional>*picsId;
@property (nonatomic, copy) NSString <Optional>*title;
@property (nonatomic, copy) NSString <Optional>*img;
@property (nonatomic, copy) NSString <Optional>*publishTime;
@property (nonatomic, copy) NSString <Optional>*commentNum;
@end


@protocol NewsList
@end
@interface NewsList : JSONModel
@property (nonatomic, copy) NSString <Optional> *newsId;
@property (nonatomic, copy) NSString <Optional> *picTwo;
@property (nonatomic, copy) NSString <Optional> *timeAgo;
@property (nonatomic, copy) NSString <Optional> *base;
@property (nonatomic, copy) NSString <Optional>*commentNum;
@property (nonatomic, copy) NSString <Optional> *first;
@property (nonatomic, copy) NSString <Optional>*newsCategoryId;
@property (nonatomic, copy) NSString <Optional>*comment;
@property (nonatomic, copy) NSString <Optional>*title;
@property (nonatomic, copy) NSString <Optional> *summary;
@property (nonatomic, copy) NSString <Optional>*local;
@property (nonatomic, copy) NSString <Optional>*publishTime;
@property (nonatomic, copy) NSString <Optional>*isLarge;
@property (nonatomic, copy) NSString <Optional>*mark;
@property (nonatomic, copy) NSString <Optional>*picOne;
@property (nonatomic, copy) NSString <Optional>*picThr;
@end
@interface MilitaryModel : JSONModel

@property (nonatomic, strong) NSMutableArray <PicsList,Optional>*picsList;
@property (nonatomic, strong) NSMutableArray <NewsList>*newsList;

@end
