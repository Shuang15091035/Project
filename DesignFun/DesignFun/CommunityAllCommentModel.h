//
//  CommunityAllCommentModel.h
//  DesignFun
//
//  Created by qianfeng on 15/10/24.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"

@protocol CommunityAllCommentList
@end
@interface CommunityAllCommentList : JSONModel
@property (nonatomic, copy) NSString <Optional>*commentId;
@property (nonatomic, copy) NSString <Optional>*userId;
@property (nonatomic, copy) NSString <Optional>*newsId;
@property (nonatomic, copy) NSString <Optional>*userImg;
@property (nonatomic, copy) NSString <Optional>*userName;
@property (nonatomic, copy) NSString <Optional>*publishTime;
@property (nonatomic, copy) NSString <Optional>*laud;
@property (nonatomic, copy) NSString <Optional>*content;
@property (nonatomic, copy) NSString <Optional>*loushu;
@property (nonatomic, copy) NSString <Optional>*level;
@property (nonatomic, copy) NSString <Optional>*tipoff;
@property (nonatomic, copy) NSString <Optional>*militaryRandk;
@end

@interface CommunityAllCommentModel : JSONModel
@property (nonatomic, strong) NSMutableArray <Optional,CommunityAllCommentList>*commentList;
@end
