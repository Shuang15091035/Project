//
//  InspiratedPlanAdapter.h
//  project_mesher
//
//  Created by mac zdszkj on 16/4/11.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

@protocol InspiratedPlanDelegate <NSObject>

- (void)destoryInspiratedBackground:(JWFile*)inspiratedBackground;

@end

@interface InspiratedPlanAdapter : JWListAdapter

@property (nonatomic, readwrite) id<InspiratedPlanDelegate> delegate;

@end
