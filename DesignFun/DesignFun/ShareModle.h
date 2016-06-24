//
//  ShareModle.h
//  DesignFun
//
//  Created by qianfeng on 15/10/5.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"

@protocol ShareReplys
@end
@interface ShareReplys : JSONModel
@property (nonatomic, copy) NSString <Optional>*shareId;
@property (nonatomic, copy) NSString <Optional>*userName;
@property (nonatomic, copy) NSString <Optional>*content;
@end

@protocol ShareHotcommentList
@end
@interface ShareHotcommentList : JSONModel
@property (nonatomic, copy) NSString <Optional>*commentId;
@property (nonatomic, copy) NSString <Optional>*newsId;
@property (nonatomic, copy) NSString <Optional>*userName;
@property (nonatomic, copy) NSString <Optional>*userId;
@property (nonatomic, copy) NSString <Optional>*userImg;
@property (nonatomic, copy) NSString <Optional>*publishTime;
@property (nonatomic, copy) NSString <Optional>*laud;
@property (nonatomic, copy) NSString <Optional>*content;
@property (nonatomic, copy) NSString <Optional>*loushu;
@property (nonatomic, strong) NSMutableArray <Optional,ShareReplys>*replys;
@property (nonatomic, copy) NSString <Optional>*level;
@property (nonatomic, copy) NSString <Optional>*militaryRank;
@end

@protocol Share_list
@end
@interface Share_list : JSONModel
@property (nonatomic, copy) NSString <Optional>*uid;
@property (nonatomic, copy) NSString <Optional>*img;
@property (nonatomic, copy) NSString <Optional>*nickName;
@end


@protocol List
@end
@interface List : JSONModel
@property (nonatomic, copy) NSString <Optional>*uid;
@property (nonatomic, copy) NSString <Optional>*nickName;
@property (nonatomic, copy) NSString <Optional>*img;
@end

@protocol RewardList
@end
@interface RewardList : JSONModel
@property (nonatomic, copy) NSString <Optional>*reward_num;
@property (nonatomic, strong) NSMutableArray <List,Optional>*list;
@property (nonatomic, strong) NSMutableArray <Optional>*reward_msg;
@end

@interface ShareModle : JSONModel

@property (nonatomic, copy) NSString <Optional>*error;
@property (nonatomic, copy) NSString <Optional>*aid;
@property (nonatomic, copy) NSString <Optional>*share_num;
@property (nonatomic, strong) NSMutableArray <Share_list,Optional>*share_list;
@property (nonatomic, strong) NSMutableArray <ShareHotcommentList,Optional>*hotcommentList;
@property (nonatomic, strong) RewardList <Optional>*rewardList;
@property (nonatomic, copy) NSString <Optional>*comment_type;
@end
