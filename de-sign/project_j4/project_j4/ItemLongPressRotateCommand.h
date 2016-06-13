//
//  ItemLongPressRotateCommand.h
//  project_mesher
//
//  Created by mac zdszkj on 15/12/17.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

@interface ItemLongPressRotateCommand : CCVCommand

@property (nonatomic, readwrite) id<ICVGameObject> object;
@property (nonatomic, readwrite) float angle;

@end
