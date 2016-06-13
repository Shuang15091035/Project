//
//  ItemDeleteCommand.h
//  project_mesher
//
//  Created by mac zdszkj on 15/11/6.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"
#import "Plan.h"

@interface ItemDeleteCommand : CCVCommand

@property (nonatomic, readwrite) id<ICVGameObject> object;
@property (nonatomic, readwrite) Plan *plan;

@end
