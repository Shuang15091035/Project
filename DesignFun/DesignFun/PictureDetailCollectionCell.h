//
//  PictureDetailCollectionCell.h
//  DesignFun
//
//  Created by qianfeng on 15/10/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureDetailModel.h"

typedef void (^ClickBlock)(BOOL isClick,UIImageView *imageView);
@interface PictureDetailCollectionCell : UICollectionViewCell
- (void)updataPictureDetailCollecionCell:(NSString *)imgUrl content:(NSString *)content;

@property (nonatomic, copy) ClickBlock block;
@end
