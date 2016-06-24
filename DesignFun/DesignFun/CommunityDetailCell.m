//
//  CommunityDetailCell.m
//  DesignFun
//
//  Created by qianfeng on 15/10/24.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CommunityDetailCell.h"
#import "CommunityDetailModel.h"
#import "CommunityAllCommentModel.h"

@interface CommunityDetailCell()
@property (strong, nonatomic) UIImageView *picture;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *address;
@property (strong, nonatomic) UILabel *content;

@property (strong, nonatomic) UILabel *time;
@property (strong, nonatomic) UILabel *comment;

@end
@implementation CommunityDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self customView];
    }
    return self;
}
- (void)customView{

    self.picture = [UIImageView new];
    [self.contentView addSubview:self.picture];
    
    self.title = [UILabel new];
    self.title.textColor = [UIColor blueColor];
    self.title.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.title];
    
    self.address = [UILabel new];
    self.address.textAlignment = NSTextAlignmentCenter;
    self.address.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview: self.address];
    
    self.content = [UILabel new];
    self.content.numberOfLines = 0;
    self.content.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.content];
    
    self.time = [UILabel new];
    self.time.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.time];
    
    self.comment = [UILabel new];
    self.comment.textAlignment = NSTextAlignmentCenter;
    self.comment.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview: self.comment];
}
- (void)setDetailModel:(DetailHotComment *)detailModel{

    [self.picture sd_setImageWithURL:[NSURL URLWithString:detailModel.userImg] placeholderImage:nil];
    self.title.text = detailModel.userName;
    self.address.text = [NSString stringWithFormat:@"%@楼",detailModel.loushu];
    self.content.text = detailModel.content;
    self.time.text = detailModel.publishTime;
    self.comment.text = [NSString stringWithFormat:@"%@赞",detailModel.laud];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat margin = 10;
    
    self.picture.frame = CGRectMake(margin, margin, 40, 40);
    
    CGFloat titleW = [self.title.text sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, 20)].width;
    
    self.title.frame = CGRectMake(margin +maxX(self.picture), minY(self.picture)+10, titleW, 20);
    
    self.address.frame = CGRectMake(screentWidth() - 40, minY(self.title), 40, 20);
    
    CGFloat contentH = [self.content.text sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(screentWidth()-2*margin,MAXFLOAT)].height;
    self.content.frame = CGRectMake(margin, maxY(self.picture)+margin, screentWidth()-2*margin, contentH);
    
    self.time.frame = CGRectMake(margin, maxY(self.content)+margin, 100,20);
    
    
    self.comment.frame = CGRectMake(screentWidth() - 40, minY(self.time), 40, 20);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
