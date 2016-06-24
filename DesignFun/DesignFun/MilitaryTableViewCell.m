//
//  MilitaryTableViewCell.m
//  DesignFun
//
//  Created by qianfeng on 15/9/30.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "MilitaryTableViewCell.h"
#import "UIView+Common.h"
#import <UIImageView+WebCache.h>

@interface MilitaryTableViewCell(){

    UIImageView *_imageView;
    UILabel *_titleLableLabel;
    UILabel *_topicLabel;
    UIButton *_commentButton;
}
@end
@implementation MilitaryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self customView];
    }
    return self;
}
- (void)customView{
    
    _imageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_imageView];
    
    _titleLableLabel = [UILabel new];
    _titleLableLabel.numberOfLines = 0;
    
    _titleLableLabel.font = [UIFont fontWithName:@"Arial" size:15];
    _titleLableLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLableLabel];
    
    _topicLabel = [UILabel new];
    _topicLabel.font = [UIFont fontWithName:@"Arial" size:12];
    [self.contentView addSubview:_topicLabel];
    
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _commentButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [self.contentView addSubview:_commentButton];
    
}
- (void)setNewsListModel:(NewsList *)newsListModel{

    [_imageView sd_setImageWithURL:[NSURL URLWithString:newsListModel.picOne] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    _titleLableLabel.text = newsListModel.title;
   
    _topicLabel.text = newsListModel.timeAgo;
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat margin = 10;
    
    CGFloat _imageViewH = height(self.contentView.frame)-2*margin;
    _imageView.frame = CGRectMake(margin, minY(self.contentView)+margin, _imageViewH, _imageViewH);
    CGFloat titleLableH = [self sizeWithText:_titleLableLabel.text font:[UIFont fontWithName:@"Arial" size:15] maxSize:CGSizeMake(width(self.contentView.frame)-3*margin-width(_imageView.frame), 60)].height;
    _titleLableLabel.frame = CGRectMake(maxX(_imageView)+margin, minY(_imageView), width(self.contentView.frame)-3*margin-width(_imageView.frame), titleLableH);
    
    _topicLabel.frame = CGRectMake(maxX(_imageView)+margin, maxY(_imageView)-20, 120, 20);
    
    _commentButton.frame = CGRectMake(width(self.contentView.frame)-100, height(self.contentView.frame)-margin - 40, 80, 60);
    
}
#pragma mark - 计算文字的尺寸
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
+ (MilitaryTableViewCell *)cellWithTableviewCell:(UITableView *)tableview{
    
    static NSString *identifier = @"militaryCell";
    MilitaryTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MilitaryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
