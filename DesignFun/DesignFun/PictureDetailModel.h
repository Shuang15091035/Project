//
//  PictureDetailModel.h
//  DesignFun
//
//  Created by qianfeng on 15/10/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"

@interface PictureDetailModel : JSONModel

@property (nonatomic, strong) NSMutableArray *imgurls;
@property (nonatomic, strong) NSMutableArray *desc;
@property (nonatomic, copy) NSString *shareUrl;

@end
