//
//  ItemDeleteCommand.h
//  project_mesher
//
//  Created by mac zdszkj on 15/11/6.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"
#import "Plan.h"

@interface ItemDeleteCommand : JWCommand

@property (nonatomic, readwrite) id<JIGameObject> object;
@property (nonatomic, readwrite) Plan *plan;

@end
