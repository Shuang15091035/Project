//
//  CommentModel.h
//  DesignFun
//
//  Created by qianfeng on 15/10/5.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"

@protocol Replys
@end
@interface Replys : JSONModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *content;
@end

@protocol HotcommentList
@end
@interface HotcommentList : JSONModel
@property (nonatomic, copy) NSString <Optional>*commentId;
@property (nonatomic, copy) NSString <Optional>*newsId;
@property (nonatomic, copy) NSString <Optional>*userName;
@property (nonatomic, copy) NSString <Optional>*userId;
@property (nonatomic, copy) NSString <Optional>*userImg;
@property (nonatomic, copy) NSString <Optional>*publishTime;
@property (nonatomic, copy) NSString <Optional>*laud;
@property (nonatomic, copy) NSString <Optional>*content;
@property (nonatomic, copy) NSString <Optional>*loushu;
@property (nonatomic, strong) NSMutableArray <Optional,Replys>*replys;
@property (nonatomic, copy) NSString <Optional>*level;
@property (nonatomic, copy) NSString <Optional>*militaryRank;
@end

@protocol CommentList
@end
@interface CommentList : JSONModel
@property (nonatomic, copy) NSString <Optional>*commentId;
@property (nonatomic, copy) NSString <Optional>*newsId;
@property (nonatomic, copy) NSString <Optional>*userName;
@property (nonatomic, copy) NSString <Optional>*userId;
@property (nonatomic, copy) NSString <Optional>*userImg;
@property (nonatomic, copy) NSString <Optional>*publishTime;
@property (nonatomic, copy) NSString <Optional>*laud;
@property (nonatomic, copy) NSString <Optional>*content;
@property (nonatomic, copy) NSString <Optional>*loushu;
@property (nonatomic, copy) NSString <Optional>*level;
@property (nonatomic, copy) NSString <Optional>*militaryRank;
@property (nonatomic, strong) NSMutableArray <Optional,Replys>*replys;
@end

@interface CommentModel : JSONModel
@property (nonatomic, strong) NSMutableArray <HotcommentList,Optional> *hotCommentList;
@property (nonatomic, strong) NSMutableArray <CommentList,Optional> *commentList;
@end
