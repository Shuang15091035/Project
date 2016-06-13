//
//  InspiratedImagePickerController.h
//  project_mesher
//
//  Created by mac zdszkj on 16/4/8.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "MesherModel.h"

@protocol InspiratedImagePickerDelegate <NSObject>

- (void)getImage:(UIImage*)image AndQuaternion:(JCQuaternion)quater;

@end

@interface InspiratedImagePickerController : UIImagePickerController

- (instancetype)initWithModel:(id<IMesherModel>)model;
@property (nonatomic,readwrite) id<InspiratedImagePickerDelegate> pickerDelegate;

@end
