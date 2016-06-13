//
//  ItemMoveCommand.h
//  project_mesher
//
//  Created by MacMini on 15/10/18.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"
#import "Plan.h"

@interface ItemMoveCommand : CCVCommand

@property (nonatomic, readwrite) Plan *plan;
@property (nonatomic, readwrite) id<ICVGameObject> object;
@property (nonatomic, readwrite) CCCVector3 originPosition;
@property (nonatomic, readwrite) CCCVector3 destPosition;
@property (nonatomic, readwrite) id<ICVTransform> originTransform;
@property (nonatomic, readwrite) id<ICVTransform> destTransform;

@end
