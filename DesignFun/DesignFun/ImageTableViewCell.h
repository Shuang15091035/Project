//
//  ImageTableViewCell.h
//  PhenixNews
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MilitaryModel.h"
@interface ImageTableViewCell : UITableViewCell
@property (nonatomic, strong) NewsList *newsListModel;
+ (ImageTableViewCell *)cellWithTableviewCell:(UITableView *)tableview;
@end
