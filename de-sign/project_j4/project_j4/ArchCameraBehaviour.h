//
//  ArchCameraBehaviour.h
//  project_mesher
//
//  Created by mac zdszkj on 16/1/28.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"
#import <ctrlcv/CCVCameraPrefabDefaultBehaviour.h>

@interface ArchCameraBehaviour : CCVCameraPrefabDefaultBehaviour

@property (nonatomic, readwrite) id<ICVStateMachine> machine;

@end
