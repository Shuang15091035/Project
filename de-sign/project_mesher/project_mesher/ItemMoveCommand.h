//
//  ItemMoveCommand.h
//  project_mesher
//
//  Created by MacMini on 15/10/18.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"
#import "Plan.h"

@interface ItemMoveCommand : JWCommand

@property (nonatomic, readwrite) Plan *plan;
@property (nonatomic, readwrite) id<JIGameObject> object;
@property (nonatomic, readwrite) JCVector3 originPosition;
@property (nonatomic, readwrite) JCVector3 destPosition;
@property (nonatomic, readwrite) id<JITransform> originTransform;
@property (nonatomic, readwrite) id<JITransform> destTransform;

@end
