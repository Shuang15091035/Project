//
//  DIYPlanAdapter.h
//  project_mesher
//
//  Created by mac zdszkj on 15/12/11.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

@protocol DIYDelegate <NSObject>

- (void)changePlanName:(Plan*)plan;
- (void)copyPlan:(Plan*)plan;
- (void)destoryPlan:(Plan*)plan;
- (void)uploadPlan:(Plan*)plan;

@end

@interface DIYPlanAdapter : CCVListAdapter

@property (nonatomic, readwrite) id<DIYDelegate> delegate;

@end
