//
//  SmallEnterMenuCollectionViewCell.m
//  project_mesher
//
//  Created by mac zdszkj on 15/11/19.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "SmallEnterMenuCollectionViewCell.h"
#import "Data.h"
#import "MesherModel.h"

@implementation SmallEnterMenuCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.lo_cell = [JWRelativeLayout layout];
        self.lo_cell.layoutParams.width = JWLayoutMatchParent;
        self.lo_cell.layoutParams.height = JWLayoutMatchParent;
        self.lo_cell.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.lo_cell];
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.layoutParams.width = JWLayoutMatchParent;
        self.imageView.layoutParams.height = JWLayoutMatchParent;
        [self.lo_cell addSubview:self.imageView];
        
        self.contentView.layer.borderWidth = 5.0f;
        self.contentView.layer.borderColor = [[UIColor whiteColor] CGColor];
    }
    return self;
}


@end
