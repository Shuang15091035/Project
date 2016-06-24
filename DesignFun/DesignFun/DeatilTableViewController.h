//
//  TestTableViewController.h
//  DesignFun
//
//  Created by qianfeng on 15/10/7.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeatilTableViewController : UITableViewController

@property (nonatomic) NSInteger page;
@property (nonatomic,copy) NSString *testList;
@property (nonatomic,strong) UIViewController *viewController;

@property (nonatomic, strong) NSMutableArray *dataSource;

- (void)fetchAppData;

@end
