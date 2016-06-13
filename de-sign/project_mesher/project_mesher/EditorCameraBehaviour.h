//
//  EditorCameraBehaviour.h
//  project_mesher
//
//  Created by mac zdszkj on 16/3/21.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

@interface EditorCameraBehaviour : JWCameraPrefabDefaultBehaviour

@property (nonatomic, readwrite) id<IMesherModel> model;

- (id)initWithContext:(id<JIGameContext>)context cameraPrefab:(id<JICameraPrefab>)cameraPrefab model:(id<IMesherModel>)model;

@end
