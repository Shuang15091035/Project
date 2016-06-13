//
//  Stretch.h
//  project_mesher
//
//  Created by mac zdszkj on 16/5/30.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

@interface Stretch : JWSerializeObject

@property (nonatomic, readwrite) NSNumber* px;
@property (nonatomic, readwrite) NSNumber* py;
@property (nonatomic, readwrite) NSNumber* pz;

@property (nonatomic, readwrite) NSNumber* ox;
@property (nonatomic, readwrite) NSNumber* oy;
@property (nonatomic, readwrite) NSNumber* oz;

@end
