//
//  UIButton+GlassButton.h
//  project_mesher
//
//  Created by mac zdszkj on 16/3/23.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (GlassButton)

+ (UIButton *)createGlassButtonWithTitle:(NSString*)title
                          highlightColor:(UIColor*)highlightColor
                          highlightImage:(UIImage*)highlightImage
                                     tag:(NSInteger)tag;

@end
