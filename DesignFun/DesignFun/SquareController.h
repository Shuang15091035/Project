//
//  SquareController.h
//  DesignFun
//
//  Created by qianfeng on 15/10/23.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SquareController : UIViewController
@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, strong)NSMutableArray *dataSource;
- (void)fetchAppData;
@end
