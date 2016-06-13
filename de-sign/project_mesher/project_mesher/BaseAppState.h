//
//  BaseAppState.h
//  project_mesher
//
//  Created by MacMini on 15/10/12.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

@interface BaseAppState : JWAppState{
    id<IMesherModel> mModel;
}

- (id) initWithModel:(id<IMesherModel>)model;

- (CGFloat) uiWidthBy:(CGFloat)width;
- (CGFloat) uiHeightBy:(CGFloat)height;

@end
