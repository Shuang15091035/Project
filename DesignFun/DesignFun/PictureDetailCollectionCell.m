//
//  PictureDetailCollectionCell.m
//  DesignFun
//
//  Created by qianfeng on 15/10/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "PictureDetailCollectionCell.h"
@interface PictureDetailCollectionCell()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,assign) BOOL isClick;
@end

@implementation PictureDetailCollectionCell
- (void)updataPictureDetailCollecionCell:(NSString *)imgUrl content:(NSString *)content{
    
    self.pictureView.userInteractionEnabled = YES;
    [self.pictureView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"loading"]];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapGesture:)];
    
     [self.pictureView addGestureRecognizer:tapGesture];
}
//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
//    return self.pictureView;
//}
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
//    
//    self.pictureView.center = self.scrollView.center;
//}

- (void)imageTapGesture:(UITapGestureRecognizer *)gesture{

    self.isClick = !self.isClick;
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"Click" object:nil userInfo:@{@"bool" : [NSNumber numberWithBool:self.isClick]}];
    self.block(self.isClick,_pictureView);
}

- (void)awakeFromNib {

}

@end
