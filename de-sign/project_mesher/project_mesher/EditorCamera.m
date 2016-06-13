//
//  EditorCamera.m
//  project_mesher
//
//  Created by mac zdszkj on 16/3/21.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "EditorCamera.h"
#import "EditorCameraBehaviour.h"

@implementation EditorCamera

- (id<JIBehaviour>)onCreateCameraBehaviourWithContext:(id<JIGameContext>)context {
    EditorCameraBehaviour *behaviour = [[EditorCameraBehaviour alloc] initWithContext:context cameraPrefab:self];
    return behaviour;
}

@end
