//
//  CommunityDetailController.h
//  DesignFun
//
//  Created by qianfeng on 15/10/23.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunityDetailController : UIViewController
@property (nonatomic, copy) NSString *detailId;
@property (nonatomic, copy) NSString *detailFid;
@property (nonatomic, strong) UIViewController *viewController;
@end
