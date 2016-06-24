//
//  CommentCell.m
//  DesignFun
//
//  Created by qianfeng on 15/10/5.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CommentCell.h"
#import "UIView+Common.h"
#import <UIImageView+WebCache.h>

@interface CommentCell(){

    UIImageView *_iconImageView;
    UILabel *_nameLabel;
    UILabel *_contentLabel;
    UILabel *_timeLabel;
    UILabel *_commentLabel;
    UILabel *_respondLabel;
}
@end

@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self customCell];
    }
    return self;
}
- (void)customCell{
    _iconImageView = [UIImageView new];
    _iconImageView.clipsToBounds = YES;
    _iconImageView.layer.cornerRadius = 10;
    [self.contentView addSubview:_iconImageView];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.textColor = [UIColor blueColor];
    [self.contentView addSubview:_nameLabel];
    
    _contentLabel = [UILabel new];
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [UIFont fontWithName:@"Arial" size:15];
    [self.contentView addSubview:_contentLabel];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_timeLabel];
    
    _commentLabel = [UILabel new];
    _commentLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_commentLabel];
    
    _respondLabel = [UILabel new];
    _respondLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_respondLabel];

}
- (void)setSharModel:(ShareHotcommentList *)sharModel{

    _sharModel = sharModel;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:sharModel.userImg] placeholderImage:nil];
    
    _nameLabel.text = sharModel.userName;
    
    _contentLabel.text = sharModel.content;

    _timeLabel.text = sharModel.publishTime;
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat margin = 10;
    _iconImageView.frame = CGRectMake(margin, margin, 30, 30);
    
    _nameLabel.frame = CGRectMake(maxX(_iconImageView)+margin, minY(_iconImageView), width(self.contentView.frame)- width(_iconImageView.frame) - 100, height(_iconImageView.frame));
    
    CGFloat titleLableH = [self sizeWithText:_contentLabel.text font:[UIFont fontWithName:@"Arial" size:15] maxSize:CGSizeMake(width(self.contentView.frame)-20, MAXFLOAT)].height;
    _contentLabel.frame = CGRectMake(margin, maxY(_iconImageView)+margin, width(self.contentView.frame)-2*margin, titleLableH);
    
    _timeLabel.frame = CGRectMake(screentWidth() - 70, maxY(_contentLabel)+margin, 120, 20);
    
    _commentLabel.frame = CGRectMake(width(self.contentView.frame)/2+20, maxY(_contentLabel)+margin, 60, 20);
    
    _respondLabel.frame = CGRectMake(maxX(_commentLabel), maxY(_contentLabel)+margin, 60, 20);
}
#pragma mark - 计算文字的尺寸
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
+ (CommentCell *)cellWithTableviewCell:(UITableView *)tableview{
    
    static NSString *ident = @"commentCell";
    CommentCell *cell = [tableview dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        cell = [[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    return cell;
}
@end
