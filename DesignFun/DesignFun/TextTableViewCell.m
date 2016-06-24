//
//  TextTableViewCell.m
//  DesignFun
//
//  Created by qianfeng on 15/10/6.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "TextTableViewCell.h"
#import "UIView+Common.h"
@interface TextTableViewCell(){

    UILabel *_titleLabel;
    UILabel *_timeLable;
    UILabel *_commentLabel;
    
}
@end
@implementation TextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLabel];
        
        _timeLable = [UILabel new];
        _timeLable.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeLable];
        
        _commentLabel = [UILabel new];
        _commentLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_commentLabel];
        
    }
    return self;
}
- (void)setNewsListModel:(NewsList *)newsListModel{
    _newsListModel = newsListModel;
    
    _titleLabel.text = newsListModel.title;
    
    _timeLable.text = newsListModel.timeAgo;
    
    _commentLabel.text = [NSString stringWithFormat:@"%@评论",newsListModel.commentNum];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat margin = 10;
    CGFloat titleLableH = [self sizeWithText:_titleLabel.text font:[UIFont fontWithName:@"Arial" size:15] maxSize:CGSizeMake(width(self.contentView.frame)-2*margin, MAXFLOAT)].height;
    _titleLabel.frame = CGRectMake(margin, margin, width(self.contentView.frame)-2*margin, titleLableH);
    _timeLable.frame = CGRectMake(margin, maxY(_titleLabel)+2*margin, 100, 20);
    _commentLabel.frame = CGRectMake(width(self.contentView.frame)-60, minY(_timeLable), 60, 20);
}
#pragma mark - 计算文字的尺寸
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
+ (TextTableViewCell *)cellWithTableviewCell:(UITableView *)tableview{
    
    static NSString *ident = @"textCell";
    TextTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        cell = [[TextTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
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
