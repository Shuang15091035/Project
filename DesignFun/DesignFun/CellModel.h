//
//  CellModel.h
//  DesignFun
//
//  Created by qianfeng on 15/10/4.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"

@protocol AboutNews
@end

@interface AboutNews : JSONModel
@property (nonatomic, copy) NSString <Optional>*aboutId;
@property (nonatomic, copy) NSString <Optional>*title;
@property (nonatomic, copy) NSString <Optional>*picOne;
@property (nonatomic, copy) NSString <Optional>*timestamp;
@property (nonatomic, copy) NSString <Optional>*commentNum;
@end


@interface CellModel : JSONModel
@property (nonatomic, copy) NSString <Optional>*cellId;
@property (nonatomic, copy) NSString <Optional>*authorUserId;
@property (nonatomic, copy) NSString <Optional>*authorNickName;
@property (nonatomic, copy) NSString <Optional>*authorIconUrl;
@property (nonatomic, copy) NSString <Optional>*authorJunxianLevel;
@property (nonatomic, copy) NSString <Optional>*title;
@property (nonatomic, copy) NSString <Optional>*publishTime;
@property (nonatomic, copy) NSString <Optional>*laud;
@property (nonatomic, copy) NSString <Optional>*stamp;
@property (nonatomic, copy) NSString <Optional>*commentSum;
@property (nonatomic, copy) NSString <Optional>*shareUrl;
@property (nonatomic, copy) NSString <Optional>*shareUrl_share;
@property (nonatomic, copy) NSString <Optional>*shareUrl_wx;
@property (nonatomic, copy) NSString <Optional>*shareImg;
@property (nonatomic, copy) NSString <Optional>*shareAbstract;
@property (nonatomic, copy) NSString <Optional>*webContent;
@property (nonatomic, strong) NSMutableArray <AboutNews>*aboutNews;
@end
