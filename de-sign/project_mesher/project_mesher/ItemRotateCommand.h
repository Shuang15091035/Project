//
//  ItemRotateCommand.h
//  project_mesher
//
//  Created by MacMini on 15/10/22.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

@interface ItemRotateCommand : JWCommand

@property (nonatomic, readwrite) id<JIGameObject> object;
@property (nonatomic, readwrite) float angle;

@end
