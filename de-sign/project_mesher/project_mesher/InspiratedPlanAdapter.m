//
//  InspiratedPlanAdapter.m
//  project_mesher
//
//  Created by mac zdszkj on 16/4/11.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "InspiratedPlanAdapter.h"
#import "MesherModel.h"

@interface InspiratedPlanViewHolder : JWViewHolder {
    
    JWRelativeLayout *lo_view;
    UIImageView *img_image;
    JWImageOptions *opt_img_image;
//    UILabel *name;
    id<InspiratedPlanDelegate> mDelegate;
}

@property (nonatomic, readwrite) id<InspiratedPlanDelegate> delegate;

@end

@implementation InspiratedPlanViewHolder

@synthesize delegate = mDelegate;

- (UIView *)onCreateView:(NSBundle *)bundle viewType:(NSUInteger)viewType parent:(UIView *)parent {
    lo_view = [JWRelativeLayout layout];
    lo_view.layoutParams.width = [MesherModel uiWidthBy:580.0f];
    lo_view.layoutParams.height = [MesherModel uiHeightBy:560.0f];
    lo_view.backgroundColor = [UIColor clearColor];
    
//    UIImage *bg_adapter = [UIImage imageByResourceDrawable:@"bg_suit_adapter"];
//    UIImageView *bg_plan = [[UIImageView alloc] initWithImage:bg_adapter];
//    bg_plan.layoutParams.width = [MesherModel uiWidthBy:520.0f];
//    bg_plan.layoutParams.height = [MesherModel uiHeightBy:380.0f];
//    bg_plan.layoutParams.alignment = JWLayoutAlignParentTopLeft;
//    bg_plan.layoutParams.marginLeft = [MesherModel uiWidthBy:30.0f];
//    bg_plan.layoutParams.marginTop = [MesherModel uiHeightBy:60.0f];
//    [lo_view addSubview:bg_plan];
    
    JWRelativeLayout *lo_image = [JWRelativeLayout layout];
    lo_image.layoutParams.width = [MesherModel uiWidthBy:500.0f];
    lo_image.layoutParams.height = [MesherModel uiHeightBy:380.0f];
    lo_image.layoutParams.alignment = JWLayoutAlignParentTopLeft;
    lo_image.backgroundColor = [UIColor whiteColor];
    lo_image.layoutParams.marginLeft = [MesherModel uiWidthBy:30.0f];
    lo_image.layoutParams.marginTop = [MesherModel uiHeightBy:60.0f];
    [lo_view addSubview:lo_image];
    
    img_image = [[UIImageView alloc] init];
    float size = [MesherModel uiWidthBy:520.0f] < [MesherModel uiHeightBy:380.0f] ? [MesherModel uiWidthBy:520.0f] : [MesherModel uiHeightBy:380.0f];
    img_image.layoutParams.width = size;
    img_image.layoutParams.height = size;
    img_image.backgroundColor = [UIColor whiteColor];
    img_image.contentMode = UIViewContentModeScaleAspectFill;
    img_image.layoutParams.alignment = JWLayoutAlignCenterInParent;
    img_image.layoutParams.marginTop = 6;
    img_image.layoutParams.marginLeft = 6;
    img_image.layoutParams.marginBottom = 6;
    img_image.layoutParams.marginRight = 6;
    [lo_image addSubview:img_image];
    opt_img_image = nil;
    
    return lo_view;
}

- (void)setRecord:(id)record {
    InspiratedPlan *plan = record;
    img_image.image = nil;
    if (plan.inspirateBackground != nil) {
        [[JWCorePluginSystem instance].imageCache getBy:plan.inspirateBackground options:opt_img_image async:YES onGet:^(UIImage *image) {
            img_image.image = image;
        }];
    };
}

- (void)destoryInspiratedBackground:(JWFile*)inspiratedBackground {
    if (mDelegate != nil) {
        [mDelegate destoryInspiratedBackground:inspiratedBackground];
    }
}

@end

@interface InspiratedPlanAdapter () {
    id<InspiratedPlanDelegate> mDelegate;
}

@end

@implementation InspiratedPlanAdapter

- (id<JIViewHolder>)onCreateViewHolder {
    return [[InspiratedPlanViewHolder alloc] init];
}

- (CGSize)getViewSizeAt:(NSUInteger)position {
    CGSize size = CGSizeMake([MesherModel uiWidthBy:580.0f], [MesherModel uiHeightBy:560.0f]);
    return size;
}

@synthesize delegate = mDelegate;

@end
