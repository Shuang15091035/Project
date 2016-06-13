//
//  Architecture.h
//  project_mesher
//
//  Created by mac zdszkj on 15/11/25.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"
#import "Floor.h"
#import "Ceil.h"
#import "Walls.h"

@interface Architecture : JWObject

@property (nonatomic, readwrite) Floor *floor;
@property (nonatomic, readwrite) Ceil *ceil;
@property (nonatomic, readwrite) Walls *walls;

@end
