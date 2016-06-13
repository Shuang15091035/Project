//
//  Scale.h
//  project_mesher
//
//  Created by mac zdszkj on 16/6/3.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

@interface Scale : JWSerializeObject

@property (nonatomic, readwrite) NSNumber* sx;
@property (nonatomic, readwrite) NSNumber* sy;
@property (nonatomic, readwrite) NSNumber* sz;

@end
