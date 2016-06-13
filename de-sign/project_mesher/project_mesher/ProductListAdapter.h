//
//  ProductListAdapter.h
//  project_mesher
//
//  Created by MacMini on 15/10/13.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

@protocol ProductListAdapterDelegate <NSObject>

- (void)onFirstCellCenter:(CGPoint)center;

@end

@interface ProductListAdapter : JWListAdapter

@property (nonatomic, readwrite) id<ProductListAdapterDelegate> delegate;

@end
