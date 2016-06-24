//
//  ArmyHead.h
//  DesignFun
//
//  Created by qianfeng on 15/9/29.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#ifndef DesignFun_HeadDefine_h
#define DesignFun_HeadDefine_h

/*
 界面类型
 */
//#define kCommentType    @"comment"
//#define kHostpotType   @"Hostpot"
//#define kMilitaryAffairsType  @"MilitaryAffairs"
//#define kHistoryType      @"history"
//#define kRoundWorldtType  @"RoundWorld"

//推荐的接口的URL
#define COMMENT_DESIGNFUN_URL @"http://api.wap.miercn.com/api/2.0.3/newlist.php?list=%@&page=%ld&plat=android&proct=mierapp&versioncode=20150807&apiCode=4"
  
//cell的数据信息
#define cellUrl @"http://api.wap.miercn.com/api/2.0.3/article_json.php?id=%ld&plat=android&proct=mierapp&versioncode=20150807&apiCode=4"

//精彩评论的URL
#define CommentURL @"http://api.wap.miercn.com/api/2.0.3/feedback.php?act=get_list&aid=1977736&page=%ld&plat=android&proct=mierapp&versioncode=20150807&apiCode=4"

//精彩评论和分享的接口

#define ShareURL @"http://api.wap.miercn.com/api/2.0.3/article_share.php?plat=android&proct=mierapp&versioncode=20150807&apiCode=4&aid=%@&web=1"

//图库界面的接口

#define DFPictureURl @"http://api.wap.miercn.com/api/2.0.3/pic_list.php?plat=android&proct=mierapp&versioncode=20150807&apiCode=4&page=%ld"

//社区广场接口
#define DFSquareURL @"http://bbs.mier123.com/api/quanzi/hot_thread.php?page=%ld&type=square&plat=android&proct=mierapp&versioncode=20150807&apiCode=4"

//社区最热接口
#define DFHotURl @"http://bbs.mier123.com/api/quanzi/hot_thread.php?page=%ld&type=hot&plat=android&proct=mierapp&versioncode=20150807&apiCode=4"

//社区圈子接口
#define DFCircleURL @"http://bbs.mier123.com/api/quanzi/boardCount.php?plat=android&proct=mierapp&versioncode=20150807&apiCode=4"

//社区详情接口

#define CommentDetailUrl @"http://bbs.mier123.com/api/quanzi/viewthread_json.php?tid=%@&fid=%@&page=%ld&plat=android&proct=mierapp&versioncode=20150807&apiCode=4"
#define CommunityAllCommentUrl @"http://bbs.mier123.com/api/quanzi/feedback.php?tid=%@&fid=%@&page=%ld&plat=android&proct=mierapp&versioncode=20150807&apiCode=4"

//圈子详情接口

#define CircleDetailURl @"http://bbs.mier123.com/api/quanzi/thread_json.php?fid=%@&page=%ld&order=%@&plat=android&proct=mierapp&versioncode=20150807&apiCode=4"

#endif




