//
//  DIYPlanAdapter.m
//  project_mesher
//
//  Created by mac zdszkj on 15/12/11.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "DIYPlanAdapter.h"
#import "DIY.h"
#import "MesherModel.h"

@interface DIYViewHolder : JWViewHolder {
    UIImageView *img_image;
    JWImageOptions *opt_img_image;
    JWRelativeLayout *lo_black;
    JWRelativeLayout *lo_selected;
    UILabel *nameLabel;
    JWLinearLayout *lo_menu_tap;
    Plan *mPlan;
    id<DIYDelegate> mDelegate;
}

@property (nonatomic, readwrite) id<DIYDelegate> delegate;

@end

@implementation DIYViewHolder

@synthesize delegate = mDelegate;

- (UIView *)onCreateView:(NSBundle *)bundle viewType:(NSUInteger)viewType parent:(UIView *)parent {
    UIImage *btn_named_n = [UIImage imageByResourceDrawable:@"btn_named_n"];
    UIImage *btn_copy_n = [UIImage imageByResourceDrawable:@"btn_copy_n"];
    UIImage *btn_delete_enter_n = [UIImage imageByResourceDrawable:@"btn_delete_enter_n"];
    UIImage *btn_upload_n = [UIImage imageByResourceDrawable:@"btn_upload_n"];
    
    JWRelativeLayout *lo_view = [JWRelativeLayout layout];
    lo_view.layoutParams.width = [MesherModel uiWidthBy:1260.0f];
    lo_view.layoutParams.height = [MesherModel uiHeightBy:1000.0f];
    [parent addSubview:lo_view];
    
    img_image = [[UIImageView alloc] init];
    img_image.layoutParams.width = JWLayoutMatchParent;
    img_image.layoutParams.height = JWLayoutMatchParent;
    [lo_view addSubview:img_image];
    
    // 黑色遮罩层
    lo_black = [JWRelativeLayout layout];
    lo_black.layoutParams.width = JWLayoutMatchParent;
    lo_black.layoutParams.height = JWLayoutMatchParent;
    lo_black.backgroundColor = [UIColor blackColor];
    lo_black.alpha = 0.1f;
    [lo_view addSubview:lo_black];
    
    lo_selected = [JWRelativeLayout layout];
    lo_selected.layoutParams.width = JWLayoutMatchParent;
    lo_selected.layoutParams.height = JWLayoutMatchParent;
    lo_selected.backgroundColor = [UIColor clearColor];
    lo_selected.layoutParams.alignment = JWLayoutAlignCenterInParent;
    [lo_view addSubview:lo_selected];
    
    JWRelativeLayout *lo_top = [JWRelativeLayout layout];
    lo_top.layoutParams.width = JWLayoutMatchParent;
    lo_top.layoutParams.height = 4;
    lo_top.layoutParams.alignment = JWLayoutAlignParentTop;
    lo_top.backgroundColor = [UIColor whiteColor];
    [lo_selected addSubview:lo_top];
    
    JWRelativeLayout *lo_left = [JWRelativeLayout layout];
    lo_left.layoutParams.width = 4;
    lo_left.layoutParams.height = JWLayoutMatchParent;
    lo_left.layoutParams.alignment = JWLayoutAlignParentLeft;
    lo_left.backgroundColor = [UIColor whiteColor];
    [lo_selected addSubview:lo_left];
    
    JWRelativeLayout *lo_bottom = [JWRelativeLayout layout];
    lo_bottom.layoutParams.width = JWLayoutMatchParent;
    lo_bottom.layoutParams.height = 4;
    lo_bottom.layoutParams.alignment = JWLayoutAlignParentBottom;
    lo_bottom.backgroundColor = [UIColor whiteColor];
    [lo_selected addSubview:lo_bottom];
    
    JWRelativeLayout *lo_right = [JWRelativeLayout layout];
    lo_right.layoutParams.width = 4;
    lo_right.layoutParams.height = JWLayoutMatchParent;
    lo_right.layoutParams.alignment = JWLayoutAlignParentRight;
    lo_right.backgroundColor = [UIColor whiteColor];
    [lo_selected addSubview:lo_right];
    
    nameLabel = [[UILabel alloc] init];
    nameLabel.layoutParams.width = 0.4;
    nameLabel.layoutParams.height = [MesherModel uiHeightBy:180.0f];
    nameLabel.layoutParams.alignment = JWLayoutAlignCenterHorizontal | JWLayoutAlignParentTop;
    nameLabel.layoutParams.marginTop = [MesherModel uiHeightBy:180.0f];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        nameLabel.labelTextSize = 40;
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        nameLabel.labelTextSize = 20;
    }
    nameLabel.labelTextStyle = JWTextStyleBold;
    nameLabel.textColor = [UIColor whiteColor];
    [lo_view addSubview:nameLabel];

    lo_menu_tap = [JWLinearLayout layout];
    lo_menu_tap.layoutParams.height = JWLayoutWrapContent;
    lo_menu_tap.layoutParams.width = JWLayoutWrapContent;
    lo_menu_tap.layoutParams.alignment = JWLayoutAlignCenterHorizontal | JWLayoutAlignParentBottom;
    lo_menu_tap.orientation = JWLayoutOrientationHorizontal;
    lo_menu_tap.layoutParams.marginBottom = [MesherModel uiHeightBy:180.0f];
    [lo_view addSubview:lo_menu_tap];
    
    UIButton *btn_named = [[UIButton alloc] init];
    [btn_named setBackgroundImage:btn_named_n forState:UIControlStateNormal];
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        btn_named.layoutParams.width = [MesherModel uiWidthBy:80.0f];
        btn_named.layoutParams.height = [MesherModel uiHeightBy:80.0f];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        btn_named.layoutParams.width = [MesherModel uiWidthBy:80.0f];
        btn_named.layoutParams.height = [MesherModel uiHeightBy:100.0f];
    }
    [btn_named addTarget:self action:@selector(changePlanName:) forControlEvents:UIControlEventTouchUpInside];
    [lo_menu_tap addSubview:btn_named];
    
    UIButton *btn_copy = [[UIButton alloc] init];
    [btn_copy setBackgroundImage:btn_copy_n forState:UIControlStateNormal];
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        btn_copy.layoutParams.width = [MesherModel uiWidthBy:80.0f];
        btn_copy.layoutParams.height = [MesherModel uiHeightBy:80.0f];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        btn_copy.layoutParams.width = [MesherModel uiWidthBy:80.0f];
        btn_copy.layoutParams.height = [MesherModel uiHeightBy:100.0f];
    }
    btn_copy.layoutParams.marginLeft = 3;
    [btn_copy addTarget:self action:@selector(copyPlan:) forControlEvents:UIControlEventTouchUpInside];
    [lo_menu_tap addSubview:btn_copy];
    
    UIButton *btn_delete = [[UIButton alloc] init];
    [btn_delete setBackgroundImage:btn_delete_enter_n forState:UIControlStateNormal];
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        btn_delete.layoutParams.width = [MesherModel uiWidthBy:80.0f];
        btn_delete.layoutParams.height = [MesherModel uiHeightBy:80.0f];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        btn_delete.layoutParams.width = [MesherModel uiWidthBy:80.0f];
        btn_delete.layoutParams.height = [MesherModel uiHeightBy:100.0f];
    }
    btn_delete.layoutParams.marginLeft = 3;
    [btn_delete addTarget:self action:@selector(destoryPlan:) forControlEvents:UIControlEventTouchUpInside];
    [lo_menu_tap addSubview:btn_delete];
    
    UIButton *btn_upload = [[UIButton alloc] init];
    [btn_upload setBackgroundImage:btn_upload_n forState:UIControlStateNormal];
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        btn_upload.layoutParams.width = [MesherModel uiWidthBy:80.0f];
        btn_upload.layoutParams.height = [MesherModel uiHeightBy:80.0f];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        btn_upload.layoutParams.width = [MesherModel uiWidthBy:80.0f];
        btn_upload.layoutParams.height = [MesherModel uiHeightBy:100.0f];
    }
    btn_upload.layoutParams.marginLeft = 3;
    [btn_upload addTarget:self action:@selector(uploadPlan:) forControlEvents:UIControlEventTouchUpInside];
    [lo_menu_tap addSubview:btn_upload];
    
    return lo_view;
}

//- (CGSize)getViewSize:(NSUInteger)viewType {
//    CGSize size = CGSizeMake([MesherModel uiWidthBy:1260.0f], [MesherModel uiHeightBy:1000.0f]);
//    return size;
//}

- (void)setRecord:(id)record {
    Plan *plan = record;
    img_image.image = nil;
    [[JWCorePluginSystem instance].imageCache getBy:plan.preview options:nil async:YES onGet:^(UIImage *image) {
        img_image.image = image;
    }];
    nameLabel.text = plan.name;
    mPlan = plan;
    if (plan.Id == 0 || plan.Id == -1 || plan.Id == -2) {
        nameLabel.hidden = YES;
        lo_black.hidden = YES;
        lo_menu_tap.hidden = YES;
    } else {
        nameLabel.hidden = NO;
        lo_black.hidden = NO;
        lo_menu_tap.hidden = NO;
    }
}

- (void)changePlanName:(Plan*)plan {
    if (mDelegate != nil) {
        [mDelegate changePlanName:mPlan];
    }
}

- (void)copyPlan:(Plan*)plan {
    if (mDelegate != nil) {
        [mDelegate copyPlan:mPlan];
    }
}

- (void)destoryPlan:(Plan*)plan {
    if (mDelegate != nil) {
        [mDelegate destoryPlan:mPlan];
    }
}

- (void)uploadPlan:(Plan*)plan {
    if (mDelegate != nil) {
        [mDelegate uploadPlan:mPlan];
    }
}

@end

@interface DIYPlanAdapter () {
    id<DIYDelegate> mDelegate;
}

@end

@implementation DIYPlanAdapter

- (id<JIViewHolder>)onCreateViewHolder {
    DIYViewHolder *DIY_vh = [[DIYViewHolder alloc] init];
    DIY_vh.delegate = mDelegate;
    return DIY_vh;
}

- (CGSize)getViewSizeAt:(NSUInteger)position {
    CGSize size = CGSizeMake([MesherModel uiWidthBy:1260.0f], [MesherModel uiHeightBy:1000.0f]);
    return size;
}

@synthesize delegate = mDelegate;

@end
