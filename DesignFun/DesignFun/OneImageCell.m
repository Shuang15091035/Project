//
//  OneImageCell.m
//  DesignFun
//
//  Created by qianfeng on 15/10/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "OneImageCell.h"
#import "DFPictureModel.h"
#import <UIImageView+WebCache.h>

@interface OneImageCell()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *comment;

@end

@implementation OneImageCell

- (void)updateOneCellData:(DFImage *)image{
    
    [self.image sd_setImageWithURL:[image.imgurls firstObject] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    self.title.text = image.title;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
