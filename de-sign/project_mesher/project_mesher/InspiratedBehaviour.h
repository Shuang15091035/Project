//
//  InspiratedBehaviour.h
//  project_mesher
//
//  Created by mac zdszkj on 16/4/8.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

typedef void (^InspiratedBehaviourOnSelectBlock)(id<JIGameObject> object);
typedef BOOL (^InspiratedBehaviourCanMoveBlock)(id<JIGameObject> object);

@interface InspiratedBehaviour : JWBehaviour

@property (nonatomic, readwrite) id<IMesherModel> model;
@property (nonatomic, readwrite) NSUInteger selectedMask;
@property (nonatomic, readwrite) InspiratedBehaviourOnSelectBlock onSelect;
@property (nonatomic, readwrite) BOOL canMove;

@end
