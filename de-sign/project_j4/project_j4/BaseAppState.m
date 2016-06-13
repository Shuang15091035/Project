//
//  BaseAppState.m
//  project_mesher
//
//  Created by MacMini on 15/10/12.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "BaseAppState.h"
#import "MesherModel.h"

@implementation BaseAppState

- (id)initWithModel:(id<IMesherModel>)model{
    self = [super init];
    if(self != nil){
        mModel = model;
    }
    return self;
}

//进入状态
- (void)onStateEnter:(NSDictionary *)data{
    [super onStateEnter:data];
    self.view.visible = YES;
}

//离开状态
- (void)onStateLeave{
    self.view.visible = NO;
    [super onStateLeave];
}

- (CGFloat)uiWidthBy:(CGFloat)width {
    return [MesherModel uiWidthBy:width];
}

- (CGFloat)uiHeightBy:(CGFloat)height {
    return [MesherModel uiHeightBy:height];
}

@end
