//
//  CommentCell.h
//  DesignFun
//
//  Created by qianfeng on 15/10/5.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareModle.h"
@interface CommentCell : UITableViewCell
@property (nonatomic, strong) ShareHotcommentList *sharModel;
+ (CommentCell *)cellWithTableviewCell:(UITableView *)tableview;
@end
