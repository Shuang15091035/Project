//
//  TextTableViewCell.h
//  DesignFun
//
//  Created by qianfeng on 15/10/6.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MilitaryModel.h"
@interface TextTableViewCell : UITableViewCell
@property (nonatomic, strong) NewsList *newsListModel;
+ (TextTableViewCell *)cellWithTableviewCell:(UITableView *)tableview;
@end
