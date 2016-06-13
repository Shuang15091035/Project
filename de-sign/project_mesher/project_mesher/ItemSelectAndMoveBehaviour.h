//
//  ItemSelectAndMoveBehaviour.h
//  project_mesher
//
//  Created by ddeyes on 15/10/27.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

typedef void (^ItemSelectAndMoveBehaviourOnSelectBlock)(id<JIGameObject> object);
typedef BOOL (^ItemSelectAndMoveBehaviourCanMoveBlock)(id<JIGameObject> object);
typedef void (^ItemSelectAndMoveBehaviourOnItemEndMove)(CGPoint positionInView);

@interface ItemSelectAndMoveBehaviour : JWBehaviour

@property (nonatomic, readwrite) id<IMesherModel> model;
@property (nonatomic, readwrite) NSUInteger selectedMask;
@property (nonatomic, readwrite) ItemSelectAndMoveBehaviourOnSelectBlock onSelect;
@property (nonatomic, readwrite) BOOL canMove;
@property (nonatomic, readwrite) ItemSelectAndMoveBehaviourOnItemEndMove onItemEndMove;

@end
