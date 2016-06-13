//
//  UISlider+JWUiCategory.h
//  jw_app
//
//  Created by mac zdszkj on 16/6/1.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWUiCommon.h>

@interface UISlider (JWUiCategory)

- (CGSize) contentSizeWithOptions:(JWUiFitOptions)options;
- (void) fitContentWithOptions:(JWUiFitOptions)options;

@end
