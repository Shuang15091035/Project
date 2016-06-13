//
//  ItemSelectAndMoveBehaviour.h
//  project_mesher
//
//  Created by ddeyes on 15/10/27.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

typedef void (^ItemSelectAndMoveBehaviourOnSelectBlock)(id<ICVGameObject> object);
typedef BOOL (^ItemSelectAndMoveBehaviourCanMoveBlock)(id<ICVGameObject> object);

@interface ItemSelectAndMoveBehaviour : CCVBehaviour

@property (nonatomic, readwrite) id<IMesherModel> model;
@property (nonatomic, readwrite) ItemSelectAndMoveBehaviourOnSelectBlock onSelect;
@property (nonatomic, readwrite) BOOL canMove;

@end
