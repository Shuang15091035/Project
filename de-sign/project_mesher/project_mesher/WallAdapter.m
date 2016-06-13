//
//  WallAdapter.m
//  project_mesher
//
//  Created by mac zdszkj on 16/1/6.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//
#import "WallAdapter.h"
#import "Common.h"
#import "MesherModel.h"

@interface WallViewHolder : JWViewHolder {
    id<IMesherModel> mModel;
    JWRelativeLayout* view;
    UIImageView* img_image;
    JWImageOptions* opt_img_image;
    
    CGFloat viewSize;
}

- (id) initWithModel:(id<IMesherModel>)model;

@end

@implementation WallViewHolder

- (id)initWithModel:(id<IMesherModel>)model {
    self = [super init];
    if (self != nil) {
        mModel = model;
    }
    return self;
}

- (UIView *)onCreateView:(NSBundle *)bundle viewType:(NSUInteger)viewType parent:(UIView *)parent {
    view = [JWRelativeLayout layout];
    viewSize = [MesherModel uiWidthBy:100.0f] > [MesherModel uiHeightBy:100.0f] ? [MesherModel uiWidthBy:100.0f] : [MesherModel uiHeightBy:100.0f];
    view.layoutParams.width = viewSize;
    view.layoutParams.height = viewSize;
    view.backgroundColor = [UIColor whiteColor];
    
    img_image = [[UIImageView alloc] init];
    CGFloat imageSize = [MesherModel uiWidthBy:90.0f] > [MesherModel uiHeightBy:90.0f] ? [MesherModel uiWidthBy:90.0f] : [MesherModel uiHeightBy:90.0f];
    img_image.layoutParams.width = imageSize;//[MesherModel uiWidthBy:90.0f];
    img_image.layoutParams.height = imageSize;//[MesherModel uiHeightBy:90.0f];
    img_image.layoutParams.alignment = JWLayoutAlignCenterInParent;
    [view addSubview:img_image];
    opt_img_image = nil;
    
    return view;
}

//传值
- (void)setRecord:(id)record {
    Source *source = record;
    img_image.image = nil;
    if(!source.preview.exists) {
        source.preview.extension = @"pvr";
    }
    [[JWCorePluginSystem instance].imageCache getBy:source.preview options:nil async:YES onGet:^(UIImage *image) {
        img_image.image = image;
    }];
}

@end

@implementation WallAdapter

- (id<JIViewHolder>)onCreateViewHolder {
    return [[WallViewHolder alloc] init];
}

- (CGSize)getViewSizeAt:(NSUInteger)position {
    CGFloat viewSize = [MesherModel uiWidthBy:100.0f] > [MesherModel uiHeightBy:100.0f] ? [MesherModel uiWidthBy:100.0f] : [MesherModel uiHeightBy:100.0f];
    CGSize size = CGSizeMake(viewSize, viewSize);
    return size;
}

@end
