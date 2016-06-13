//
//  PlanCamera.h
//  project_mesher
//
//  Created by mac zdszkj on 16/5/19.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

@interface PlanCamera : JWSerializeObject

@property (nonatomic, readwrite) float px;
@property (nonatomic, readwrite) float py;
@property (nonatomic, readwrite) float pz;

@property (nonatomic, readwrite) float rx;
@property (nonatomic, readwrite) float ry;
@property (nonatomic, readwrite) float rz;
@property (nonatomic, readwrite) float rw;

@end
