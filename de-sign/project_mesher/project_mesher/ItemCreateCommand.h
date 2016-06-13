//
//  ItemCreateCommand.h
//  project_mesher
//
//  Created by MacMini on 15/11/4.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"
#import "Plan.h"

@interface ItemCreateCommand : JWCommand

@property (nonatomic, readwrite) id<JIGameObject> object;
@property (nonatomic, readwrite) Plan *plan;
@property (nonatomic, readwrite) id<JIGameObject> gridsObject;

@end
