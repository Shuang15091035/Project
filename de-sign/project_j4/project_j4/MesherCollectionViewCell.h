//
//  MesherCollectionViewCell.h
//  project_mesher
//
//  Created by mac zdszkj on 15/11/11.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"

@interface MesherCollectionViewCell : UICollectionViewCell

@property (nonatomic, readwrite)UIImageView *imageView;
@property (nonatomic, readwrite)UILabel *title;
@property (nonatomic, readwrite)CCVRelativeLayout *lo_cell;

@end
