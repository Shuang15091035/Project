//
//  DFPictureModel.h
//  DesignFun
//
//  Created by qianfeng on 15/10/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"


@protocol DFImage <NSObject>
@end

@interface DFImage : JSONModel
@property (nonatomic, copy) NSString <Optional>*title;
@property (nonatomic, copy) NSString <Optional>*id;
@property (nonatomic, copy) NSMutableArray <Optional>*imgurls;
@property (nonatomic, copy) NSString <Optional>*imgSum;
@property (nonatomic, copy) NSString <Optional>*commentNum;
@property (nonatomic, copy) NSString <Optional>*imageType;
@end

@interface DFPictureModel : JSONModel
@property (nonatomic, strong) NSMutableArray <DFImage,Optional>*imglist;
@end
