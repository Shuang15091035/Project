//
//  SquareCell.m
//  DesignFun
//
//  Created by qianfeng on 15/10/23.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "SquareCell.h"
#import "SquareModle.h"

@interface SquareCell()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *circleLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UILabel *content;
@end

@implementation SquareCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self customView];
    }
    return self;
}
- (void)customView{

    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor blueColor];
    [self.contentView addSubview:self.titleLabel];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.timeLabel];
    
    self.circleLabel = [UILabel new];
    self.circleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.circleLabel];
    
    self.contentLabel = [UILabel new];
    self.contentLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:self.contentLabel];
    
    self.content = [UILabel new];
    self.content.numberOfLines = 0;
    self.content.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.content];
}
- (void)updateDataSquareCell:(SquareNews *)squareNew{
    
    self.titleLabel.text = squareNew.author;
    self.timeLabel.text = squareNew.timeAgo;
    self.circleLabel.text = squareNew.circleName;
    self.contentLabel.text = squareNew.title;
    self.content.text = squareNew.newsAbstract;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat margin = 10;
    CGFloat padding = 5;
    CGFloat titleLabellW = [self.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, 20)].width;
    self.titleLabel.frame = CGRectMake(margin, margin, titleLabellW, 20);
    
    CGFloat timeLabelW = [self.timeLabel.text sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT,20)].width;
    self.timeLabel.frame = CGRectMake(padding + maxX(self.titleLabel), margin, timeLabelW+10, 20);
    
    CGFloat circleLabellW = [self.timeLabel.text sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT,20)].width;
    self.circleLabel.frame = CGRectMake(padding + maxX(self.timeLabel), margin, circleLabellW+10, 20);
    
    CGFloat contentLabelH = [self.contentLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:15] maxSize:CGSizeMake(screentWidth()-2*margin, MAXFLOAT)].height;
    self.contentLabel.frame = CGRectMake(margin, padding + maxY(self.titleLabel), screentWidth()-2*margin,contentLabelH);
    
    CGFloat contentH = [self.content.text sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(screentWidth()-2*margin, MAXFLOAT)].height;
    self.content.frame = CGRectMake(margin, padding + maxY(self.contentLabel), screentWidth()-2*margin, contentH);
}

- (void)awakeFromNib{

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
