
//
//  CircleCell.m
//  DesignFun
//
//  Created by qianfeng on 15/10/23.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CircleCell.h"
#import "CircleModel.h"

@interface CircleCell()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *abstract;
@property (weak, nonatomic) IBOutlet UILabel *comment;

@end

@implementation CircleCell

- (void)setCircleList:(CircleList *)circleList{
    _circleList = circleList;
    [self.image sd_setImageWithURL:[NSURL URLWithString:circleList.img] placeholderImage:nil];
    
    self.titleLabel.text = circleList.name;
    
    self.abstract.text = circleList.desc;
    
    self.comment.text = circleList.cardSum;
    
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    self.comment.layer.cornerRadius = 10;
    self.comment.clipsToBounds = YES;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
