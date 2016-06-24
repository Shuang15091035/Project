
//
//  ImageTableViewCell.m
//  PhenixNews
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ImageTableViewCell.h"
#import "UIView+Common.h"
#import <UIImageView+WebCache.h>
@interface ImageTableViewCell(){

    UILabel *_titleLabel1;
    UIImageView *_imageView1;
    UIImageView *_imageView2;
    UIImageView *_imageView3;
    UILabel *_timeLabel;
    UIButton *_commentButton1;
}

@end

@implementation ImageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self customView];
    }
    return self;
}
- (void)customView{

    _titleLabel1 = [UILabel new];
    _titleLabel1.numberOfLines = 0;
    _titleLabel1.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_titleLabel1];
    
    _imageView1 = [[UIImageView alloc]init];
    [self.contentView addSubview:_imageView1];
    
    _imageView2 = [[UIImageView alloc]init];
    [self.contentView addSubview:_imageView2];
    
    _imageView3 = [[UIImageView alloc]init];
    [self.contentView addSubview:_imageView3];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_timeLabel];
    
    _commentButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentButton1.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_commentButton1];
    
}
- (void)setNewsListModel:(NewsList *)newsListModel{

    _newsListModel = newsListModel;
    
    _titleLabel1.text = newsListModel.title;
    
    [_imageView1 sd_setImageWithURL:[NSURL URLWithString:newsListModel.picOne] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    [_imageView2 sd_setImageWithURL:[NSURL URLWithString:newsListModel.picTwo] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    [_imageView3 sd_setImageWithURL:[NSURL URLWithString:newsListModel.picThr] placeholderImage:[UIImage imageNamed:@"loading"]];
    _timeLabel.text = newsListModel.timeAgo;
    
    [_commentButton1 setTitle:[NSString stringWithFormat:@"%@评论",newsListModel.commentNum] forState:UIControlStateNormal];
    [_commentButton1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat margin = 5;
    CGFloat leftMargin = 15;
    
    CGFloat titleLableH = [self sizeWithText:_titleLabel1.text font:[UIFont fontWithName:@"Arial" size:15] maxSize:CGSizeMake(width(self.contentView.frame), 60)].height;
    _titleLabel1.frame = CGRectMake(leftMargin, margin, width(self.contentView.frame), titleLableH);
    CGFloat _imageViewW = (width(self.contentView.frame)-4*leftMargin)/3;
    _imageView1.frame = CGRectMake(leftMargin, maxY(_titleLabel1)+margin, _imageViewW, 60);
    
    _imageView2.frame = CGRectMake(maxX(_imageView1)+leftMargin, maxY(_titleLabel1)+margin, _imageViewW, 60);
    
    _imageView3.frame = CGRectMake(maxX(_imageView2)+leftMargin, maxY(_titleLabel1)+margin, _imageViewW, 60);
    
    _timeLabel.frame = CGRectMake(leftMargin, maxY(_imageView1)+margin, 200, 20);
    _commentButton1.frame = CGRectMake(width(self.contentView.frame)- 80, minY(_timeLabel), 80, 20);

}
#pragma mark - 计算文字的尺寸
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
+ (ImageTableViewCell *)cellWithTableviewCell:(UITableView *)tableview{

    static NSString *ident = @"imageCell";
    ImageTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        cell = [[ImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    return cell;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
