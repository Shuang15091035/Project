//
//  UpdateTextureCommand.h
//  project_mesher
//
//  Created by mac zdszkj on 16/1/13.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

@interface UpdateTextureCommand : JWCommand

@property (nonatomic, readwrite) id<JIGameObject> archtureObject;
@property (nonatomic, readwrite) id<JIMaterial> originMaterial; // 原始的素材贴图
@property (nonatomic, readwrite) id<JIMaterial> destMaterial; // 要更新的素材贴图

@end
