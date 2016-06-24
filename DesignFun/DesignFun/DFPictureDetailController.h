//
//  DFPictureDetailController.h
//  DesignFun
//
//  Created by qianfeng on 15/10/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DFImage;
@interface DFPictureDetailController : UIViewController
@property (nonatomic,copy) NSString *pageId;
@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, strong) DFImage *dfImage;
@end
