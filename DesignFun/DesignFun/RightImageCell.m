//
//  RightImageCell.m
//  DesignFun
//
//  Created by qianfeng on 15/10/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "RightImageCell.h"
#import "DFPictureModel.h"

@interface RightImageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@end

@implementation RightImageCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)updateOneCellData:(DFImage *)image{

    [self.imageView1 sd_setImageWithURL:image.imgurls[0] placeholderImage:[UIImage imageNamed:@"loading"]];
    [self.imageView2 sd_setImageWithURL:image.imgurls[1] placeholderImage:[UIImage imageNamed:@"loading"]];
    [self.imageView3 sd_setImageWithURL:image.imgurls[2] placeholderImage:[UIImage imageNamed:@"loading"]];
    self.titleLabel.text = image.title;
    [self.commentBtn setTitle:image.commentNum forState:UIControlStateNormal];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
