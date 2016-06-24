//
//  HotController.h
//  DesignFun
//
//  Created by qianfeng on 15/10/23.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "SquareController.h"

@interface HotController : UIViewController
@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, strong)NSMutableArray *dataSource;
- (void)fetchAppData;
- (NSString *)composeRequestUrl ;
- (CGRect)tableViewRect;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end
