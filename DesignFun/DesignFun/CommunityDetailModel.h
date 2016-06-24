//
//  CommunityDetailModel.h
//  DesignFun
//
//  Created by qianfeng on 15/10/24.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"
@protocol DetailHotComment
@end

@interface DetailHotComment : JSONModel
@property (nonatomic, copy) NSString <Optional>*commentId;
@property (nonatomic, copy) NSString <Optional>*userId;
@property (nonatomic, copy) NSString <Optional>*newsId;
@property (nonatomic, copy) NSString <Optional>*userName;
@property (nonatomic, copy) NSString <Optional>*userImg;
@property (nonatomic, copy) NSString <Optional>*publishTime;
@property (nonatomic, copy) NSString <Optional>*laud;
@property (nonatomic, copy) NSString <Optional>*content;
@property (nonatomic, copy) NSString <Optional>*loushu;
@property (nonatomic, copy) NSString <Optional>*level;
@property (nonatomic, copy) NSString <Optional>*militaryRank;

@end

@interface CommunityDetailModel : JSONModel
@property (nonatomic, copy) NSString <Optional>*id;
@property (nonatomic, copy) NSString <Optional>*fid;
@property (nonatomic, copy) NSString <Optional>*title;
@property (nonatomic, copy) NSString <Optional>*userId;
@property (nonatomic, copy) NSString <Optional>*author;
@property (nonatomic, copy) NSString <Optional>*publishTime;
@property (nonatomic, copy) NSString <Optional>*url;
@property (nonatomic, copy) NSString <Optional>*userImg;
@property (nonatomic, copy) NSString <Optional>*laud;
@property (nonatomic, copy) NSString <Optional>*laudList;
@property (nonatomic, copy) NSString <Optional>*stamp;
@property (nonatomic, copy) NSString <Optional>*commentSum;
@property (nonatomic, copy) NSMutableArray <Optional,DetailHotComment>*hotCommentList;
@property (nonatomic, strong) NSMutableArray <Optional>*allCommentList;
@property (nonatomic, copy) NSString <Optional>*shareImg;
@property (nonatomic, copy) NSString <Optional>*shareUrl;
@property (nonatomic, copy) NSString <Optional>*shareUrl_wx;
@property (nonatomic, copy) NSString <Optional>*webContent;
//@property (nonatomic, strong) NSMutableArray <Optional>*imgArr;
@end
