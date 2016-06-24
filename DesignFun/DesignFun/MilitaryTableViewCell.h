//
//  MilitaryTableViewCell.h
//  DesignFun
//
//  Created by qianfeng on 15/9/30.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MilitaryModel.h"

@interface MilitaryTableViewCell : UITableViewCell
@property (nonatomic, strong) NewsList *newsListModel;
+ (MilitaryTableViewCell *)cellWithTableviewCell:(UITableView *)tableview;
@end
