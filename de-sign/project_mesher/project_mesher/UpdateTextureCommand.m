//
//  UpdateTextureCommand.m
//  project_mesher
//
//  Created by mac zdszkj on 16/1/13.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "UpdateTextureCommand.h"

@interface UpdateTextureCommand() {
    id<JIGameObject> mArchtureObject;
    id<JIMaterial> mOriginMaterial;
    id<JIMaterial> mDestMaterial;
}

@end

@implementation UpdateTextureCommand

@synthesize archtureObject = mArchtureObject;
@synthesize originMaterial = mOriginMaterial;
@synthesize destMaterial = mDestMaterial;

- (void)todo {
    [mDestMaterial load];
    mArchtureObject.renderable.material = mDestMaterial;
}

- (void)undo {
    [mOriginMaterial load];
    mArchtureObject.renderable.material = mOriginMaterial;
}

@end
