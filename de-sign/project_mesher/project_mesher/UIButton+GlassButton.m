//
//  UIButton+GlassButton.m
//  project_mesher
//
//  Created by mac zdszkj on 16/3/23.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "UIButton+GlassButton.h"

@implementation UIButton (GlassButton)

+(UIButton *)createGlassButtonWithTitle:(NSString *)title highlightColor:(UIColor *)highlightColor highlightImage:(UIImage *)highlightImage tag:(NSInteger)tag {
    
    UIButton *btn = [UIButton new];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:highlightColor forState:UIControlStateHighlighted];
    [btn setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    btn.tag = tag;
    
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    
    return btn;
}

@end
