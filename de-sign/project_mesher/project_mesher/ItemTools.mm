//
//  ItemTools.m
//  project_mesher
//
//  Created by mac zdszkj on 16/5/30.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "ItemTools.h"
#import "MesherModel.h"
#import "GamePhotographer.h"
#import "ItemToolsCommand.h"

@interface ItemTools()<UITextFieldDelegate> {
    JWRelativeLayout *lo_itemTools;
    id<JIGameObject> mStretchPivotObject;
    id<JIGameObject> tempObject;
    
    UITextField *tf_px;
    UISlider *sl_px;
    
    UITextField *tf_py;
    UISlider *sl_py;
    
    UITextField *tf_pz;
    UISlider *sl_pz;
    
    UITextField *tf_ox;
    UISlider *sl_ox;
    
    UITextField *tf_oy;
    UISlider *sl_oy;
    
    UITextField *tf_oz;
    UISlider *sl_oz;
    
    UITextField *tf_tilingOffsetX;
    UISlider *sl_tilingOffsetX;
    
    UITextField *tf_tilingOffsetY;
    UISlider *sl_tilingOffsetY;
    
    UITextField *tf_scaleX;
    UISlider *sl_scaleX;
    
    UITextField *tf_scaleY;
    UISlider *sl_scaleY;
    
    UITextField *tf_scaleZ;
    UISlider *sl_scaleZ;
    
//    id<JIMaterial> material;
    NSMutableArray *materials;
    NSMutableDictionary *materialsDictionary;
    
    NSString *tempText;
    
    ItemToolsCommand *command;
    UIButton *doneInKeyboardButton;
    CGSize keyBoardSize;
    
//    UIImage *slider_l;
//    UIImage *slider_r;
}

@end

@implementation ItemTools

- (UIView *)onCreateView:(UIView *)parent {
    lo_itemTools = (JWRelativeLayout*)[parent viewWithTag:R_id_lo_tools];
    
//    btn_back = (UIImageView*)[parent viewWithTag:R_id_btn_back];
//    btn_back.userInteractionEnabled = YES;
//    [self.gestureEventBinder bindEventsWithType:JWGestureTypeSingleTap toView:btn_back willBindSubviews:NO andFilter:nil];

#pragma mark 轴对象
    mStretchPivotObject = [mModel.currentContext createObject];
    mStretchPivotObject.parent = mModel.currentScene.root;
    mStretchPivotObject.transform.inheritScale = NO;
    mStretchPivotObject.axisLength = 1.5f;
    [mStretchPivotObject setAxesVisible:YES recursive:NO];
    
    JWScrollView *sv_tools = [[JWScrollView alloc] init];
    sv_tools.layoutParams.width = JWLayoutMatchParent;
    sv_tools.layoutParams.height = JWLayoutMatchParent;
    sv_tools.backgroundColor = [UIColor clearColor];
    [lo_itemTools addSubview:sv_tools];
    
    JWLinearLayout *lo_tools_lin = [JWLinearLayout layout];
    lo_tools_lin.layoutParams.width = JWLayoutMatchParent;
    lo_tools_lin.layoutParams.height = JWLayoutWrapContent;
    lo_tools_lin.backgroundColor = [UIColor clearColor];
    lo_tools_lin.orientation = JWLayoutOrientationVertical;
    [sv_tools addSubview:lo_tools_lin];
    
    UIImage *ball = [UIImage imageByResourceDrawable:@"sl_ball"];
    UIImage *ball_iphone = [UIImage imageByResourceDrawable:@"sl_ball_iphone"];
//
//    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
//        slider_l = [UIImage imageNamed:@"sl_line_l_pad"];
//        slider_r = [UIImage imageNamed:@"sl_line_r_pad"];
//    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
//        slider_l = [UIImage imageNamed:@"sl_line_l_iphone"];
//        slider_r = [UIImage imageNamed:@"sl_line_r_iphone"];
//    }
    
    CGFloat sliderHeight;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        sliderHeight = ball.size.height;
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        sliderHeight = ball_iphone.size.height;
    }
    
    JWRelativeLayout *lo_title = [JWRelativeLayout layout];
    lo_title.layoutParams.width = JWLayoutMatchParent;
    lo_title.layoutParams.height = JWLayoutWrapContent;
    lo_title.backgroundColor = [UIColor clearColor];
    [lo_tools_lin addSubview:lo_title];

    UIImage *btn_back_n = [UIImage imageByResourceDrawable:@"btn_close_n.png"];
    UIImageView *btn_back = [[UIImageView alloc] initWithImage:btn_back_n];
    btn_back.tag = R_id_btn_back;
    btn_back.layoutParams.width = JWLayoutWrapContent;
    btn_back.layoutParams.height = JWLayoutWrapContent;
    btn_back.layoutParams.alignment = JWLayoutAlignParentLeft;
    btn_back.layoutParams.marginLeft = [MesherModel uiWidthBy:20.0f];
    [lo_title addSubview:btn_back];
    btn_back.userInteractionEnabled = YES;
    [self.gestureEventBinder bindEventsWithType:JWGestureTypeSingleTap toView:btn_back willBindSubviews:NO andFilter:nil];
    
    UILabel *lb_title = [UILabel new];
    lb_title.layoutParams.width = JWLayoutWrapContent;
    lb_title.layoutParams.height = JWLayoutWrapContent;
    lb_title.text = @"工 具";
    lb_title.labelTextSize = 18;
    lb_title.textColor = [UIColor colorWithARGB:R_color_item_tools];
    lb_title.layoutParams.alignment = JWLayoutAlignCenterInParent;
    [lo_title addSubview:lb_title];
    
    UIImage *img_divider_dark_520_img = [UIImage imageByResourceDrawable:@"img_divider_dark_520.png"];
    UIImageView *img_divider_dark_520 = [[UIImageView alloc] initWithImage:img_divider_dark_520_img];
    img_divider_dark_520.layoutParams.width = JWLayoutMatchParent;
    img_divider_dark_520.layoutParams.height = JWLayoutWrapContent;
    img_divider_dark_520.layoutParams.marginLeft = [self uiWidthBy:20.0f];
    img_divider_dark_520.layoutParams.marginRight = [self uiWidthBy:20.0f];
    [lo_tools_lin addSubview:img_divider_dark_520];
    
#pragma mark 支点
    JWLinearLayout *lo_stretch = [JWLinearLayout layout];
    lo_stretch.layoutParams.width = JWLayoutMatchParent;
    lo_stretch.layoutParams.height = JWLayoutWrapContent;
    lo_stretch.backgroundColor = [UIColor clearColor];
    lo_stretch.orientation = JWLayoutOrientationHorizontal;
    [lo_tools_lin addSubview:lo_stretch];
    
    UILabel *lb_stretch = [UILabel new];
    lb_stretch.layoutParams.width = JWLayoutMatchParent;
    lb_stretch.layoutParams.height = JWLayoutWrapContent;
    lb_stretch.text = @"支 点";
    lb_stretch.textAlignment = NSTextAlignmentLeft;
    lb_stretch.textColor = [UIColor colorWithARGB:R_color_item_tools];
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        lb_stretch.labelTextSize = 18.0f;
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        lb_stretch.labelTextSize = 12.0f;
    }
//    lb_stretch.layoutParams.marginLeft = [self uiWidthBy:25.0f];
    lb_stretch.layoutParams.marginTop = [self uiHeightBy:20.0f];
    lb_stretch.layoutParams.marginLeft = [self uiWidthBy:20.0f];
    [lo_stretch addSubview:lb_stretch];
    
//    JWRelativeLayout *lo_st = [JWRelativeLayout layout];
//    lo_st.layoutParams.width = JWLayoutMatchParent;
//    lo_st.layoutParams.height = JWLayoutWrapContent;
//    lo_st.backgroundColor = [UIColor colorWithARGB:0xffb3b3b3];
//    [lo_tools_lin addSubview:lo_st];
    
    JWLinearLayout *lin_st = [JWLinearLayout layout];
    lin_st.layoutParams.width = [self uiWidthBy:500.0f];
    lin_st.layoutParams.height = JWLayoutWrapContent;
    lin_st.layoutParams.alignment = JWLayoutAlignCenterInParent;
    lin_st.backgroundColor = [UIColor whiteColor];
    lin_st.layer.borderWidth = 0.5f;
    lin_st.layer.borderColor = [[UIColor colorWithARGB:0xffb3b3b3] CGColor];
    lin_st.orientation = JWLayoutOrientationVertical;
    lin_st.layoutParams.marginTop = [self uiHeightBy:20.0f];
    [lo_tools_lin addSubview:lin_st];
    
    JWLinearLayout *lo_stretch_lin = [JWLinearLayout layout];
    lo_stretch_lin.layoutParams.width = JWLayoutMatchParent;
    lo_stretch_lin.layoutParams.height = JWLayoutWrapContent;
    lo_stretch_lin.backgroundColor = [UIColor clearColor];
    lo_stretch_lin.orientation = JWLayoutOrientationHorizontal;
    lo_stretch_lin.layoutParams.marginTop = [self uiHeightBy:20.0f];
    [lin_st addSubview:lo_stretch_lin];
    
    tf_px = [UITextField new];
    tf_px.layoutParams.width = JWLayoutMatchParent;
    tf_px.layoutParams.height = JWLayoutWrapContent;
    tf_px.layoutParams.weight = 1;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        tf_px.textFieldTextSize = 18.0f;
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        tf_px.textFieldTextSize = 12.0f;
    }
    tf_px.text = @"-99.999";
    tf_px.layoutParams.alignment = JWLayoutAlignParentLeft | JWLayoutOrientationVertical;
    tf_px.layoutParams.marginLeft = [self uiWidthBy:15.0f];
    [self updataTextField:tf_px];
    [lo_stretch_lin addSubview:tf_px];
    
    tf_py = [UITextField new];
    tf_py.layoutParams.width = JWLayoutMatchParent;//[self uiWidthBy:130.0f];
    tf_py.layoutParams.height = JWLayoutWrapContent;
    tf_py.layoutParams.weight = 1;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        tf_py.textFieldTextSize = 18.0f;
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        tf_py.textFieldTextSize = 12.0f;
    }
    tf_py.text = @"-99.999";
    tf_py.layoutParams.alignment = JWLayoutAlignParentLeft | JWLayoutOrientationVertical;
    tf_py.layoutParams.marginLeft = [self uiWidthBy:5.0f];
    [self updataTextField:tf_py];
    [lo_stretch_lin addSubview:tf_py];
    
    tf_pz = [UITextField new];
    tf_pz.layoutParams.width = JWLayoutMatchParent;//[self uiWidthBy:130.0f];
    tf_pz.layoutParams.height = JWLayoutWrapContent;
    tf_pz.layoutParams.weight = 1;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        tf_pz.textFieldTextSize = 18.0f;
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        tf_pz.textFieldTextSize = 12.0f;
    }
    tf_pz.text = @"-99.999";
    tf_pz.layoutParams.alignment = JWLayoutAlignParentLeft | JWLayoutOrientationVertical;
    tf_pz.layoutParams.marginLeft = [self uiWidthBy:5.0f];
    [self updataTextField:tf_pz];
//    tf_pz.layoutParams.rightOf = lb_py;
    [lo_stretch_lin addSubview:tf_pz];
    
#pragma mark 支点X
//    JWRelativeLayout *lo_px = [JWRelativeLayout layout];
//    lo_px.layoutParams.width = JWLayoutMatchParent;
//    lo_px.layoutParams.height = JWLayoutWrapContent;
//    lo_px.backgroundColor = [UIColor clearColor];
//    lo_px.layoutParams.marginTop = [self uiHeightBy:5.0f];
//    [lo_tools_lin addSubview:lo_px];
    
    sl_px = [[UISlider alloc] init];
    sl_px.layoutParams.width = [self uiWidthBy:460.0f];
    sl_px.layoutParams.height = sliderHeight;
//    sl_px.layoutParams.alignment = JWLayoutAlignParentRight | JWLayoutOrientationVertical;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        [sl_px setThumbImage:ball forState:UIControlStateNormal];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        [sl_px setThumbImage:ball_iphone forState:UIControlStateNormal];
    }
//    sl_px.layoutParams.marginRight = [self uiWidthBy:20.0f];
    sl_px.layoutParams.alignment = JWLayoutAlignCenterInParent;
    sl_px.layoutParams.marginTop = [self uiHeightBy:20.0f];
    sl_px.value = 0.0f;
    [self updateSlider:sl_px];
    [lin_st addSubview:sl_px];
    [sl_px addTarget:self action:@selector(onStretchChanged:) forControlEvents:UIControlEventValueChanged];
    
#pragma mark 支点Y
//    JWRelativeLayout *lo_py = [JWRelativeLayout layout];
//    lo_py.layoutParams.width = JWLayoutMatchParent;
//    lo_py.layoutParams.height = JWLayoutWrapContent;
//    lo_py.backgroundColor = [UIColor clearColor];
//    lo_py.layoutParams.marginTop = [self uiHeightBy:5.0f];
//    [lo_tools_lin addSubview:lo_py];
    
    sl_py = [[UISlider alloc] init];
    sl_py.layoutParams.width = [self uiWidthBy:460.0f];
    sl_py.layoutParams.height = sliderHeight;
//    sl_py.layoutParams.alignment = JWLayoutAlignParentRight | JWLayoutOrientationVertical;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        [sl_py setThumbImage:ball forState:UIControlStateNormal];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        [sl_py setThumbImage:ball_iphone forState:UIControlStateNormal];
    }
//    sl_py.layoutParams.marginRight = [self uiWidthBy:20.0f];
    sl_py.layoutParams.alignment = JWLayoutAlignCenterInParent;
    sl_py.layoutParams.marginTop = [self uiHeightBy:20.0f];
    sl_py.value = 0.0f;
    [self updateSlider:sl_py];
    [lin_st addSubview:sl_py];
    [sl_py addTarget:self action:@selector(onStretchChanged:) forControlEvents:UIControlEventValueChanged];
    
#pragma mark 支点Z
//    JWRelativeLayout *lo_pz = [JWRelativeLayout layout];
//    lo_pz.layoutParams.width = JWLayoutMatchParent;
//    lo_pz.layoutParams.height = JWLayoutWrapContent;
//    lo_pz.backgroundColor = [UIColor clearColor];
//    lo_pz.layoutParams.marginTop = [self uiHeightBy:5.0f];
//    [lo_tools_lin addSubview:lo_pz];
    
    sl_pz = [[UISlider alloc] init];
    sl_pz.layoutParams.width = [self uiWidthBy:460.0f];
    sl_pz.layoutParams.height = sliderHeight;
//    sl_pz.layoutParams.alignment = JWLayoutAlignParentRight | JWLayoutOrientationVertical;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        [sl_pz setThumbImage:ball forState:UIControlStateNormal];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        [sl_pz setThumbImage:ball_iphone forState:UIControlStateNormal];
    }
//    sl_pz.layoutParams.marginRight = [self uiWidthBy:20.0f];
    sl_pz.layoutParams.alignment = JWLayoutAlignCenterInParent;
    sl_pz.layoutParams.marginTop = [self uiHeightBy:20.0f];
    sl_pz.value = 0.0f;
    [self updateSlider:sl_pz];
    [lin_st addSubview:sl_pz];
    [sl_pz addTarget:self action:@selector(onStretchChanged:) forControlEvents:UIControlEventValueChanged];
    
    JWRelativeLayout *lo_st_e = [JWRelativeLayout layout];
    lo_st_e.layoutParams.width = JWLayoutMatchParent;
    lo_st_e.layoutParams.height = sliderHeight;
    [lin_st addSubview:lo_st_e];
    
#pragma mark 大小
    JWLinearLayout *lo_size = [JWLinearLayout layout];
    lo_size.layoutParams.width = JWLayoutMatchParent;
    lo_size.layoutParams.height = JWLayoutWrapContent;
    lo_size.backgroundColor = [UIColor clearColor];
    lo_size.orientation = JWLayoutOrientationHorizontal;
    lo_size.layoutParams.marginTop = [self uiHeightBy:20.0f];
    [lo_tools_lin addSubview:lo_size];
    
    UILabel *lb_size = [UILabel new];
    lb_size.layoutParams.width = JWLayoutMatchParent;
    lb_size.layoutParams.height = JWLayoutWrapContent;
    lb_size.text = @"大 小";
    lb_size.textAlignment = NSTextAlignmentLeft;
    lb_size.textColor = [UIColor colorWithARGB:R_color_item_tools];
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        lb_size.labelTextSize = 18.0f;
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        lb_size.labelTextSize = 12.0f;
    }
    lb_size.layoutParams.marginLeft = [self uiWidthBy:20.0f];
//    lb_size.layoutParams.marginLeft = [self uiWidthBy:25.0f];
    [lo_size addSubview:lb_size];
    
    JWLinearLayout *lin_so = [JWLinearLayout layout];
    lin_so.layoutParams.width = [self uiWidthBy:500.0f];
    lin_so.layoutParams.height = JWLayoutWrapContent;
    lin_so.layoutParams.alignment = JWLayoutAlignCenterInParent;
    lin_so.backgroundColor = [UIColor whiteColor];
    lin_so.layer.borderWidth = 0.5f;
    lin_so.layer.borderColor = [[UIColor colorWithARGB:0xffb3b3b3] CGColor];
    lin_so.orientation = JWLayoutOrientationVertical;
    lin_so.layoutParams.marginTop = [self uiHeightBy:20.0f];
    [lo_tools_lin addSubview:lin_so];
    
    JWLinearLayout *lo_size_lin = [JWLinearLayout layout];
    lo_size_lin.layoutParams.width = JWLayoutMatchParent;
    lo_size_lin.layoutParams.height = JWLayoutWrapContent;
    lo_size_lin.backgroundColor = [UIColor clearColor];
    lo_size_lin.orientation = JWLayoutOrientationHorizontal;
    lo_size_lin.layoutParams.marginTop = [self uiHeightBy:20.0f];
    [lin_so addSubview:lo_size_lin];
    
    tf_ox = [UITextField new];
    tf_ox.layoutParams.width = JWLayoutMatchParent;//[self uiWidthBy:130.0f];
    tf_ox.layoutParams.height = JWLayoutWrapContent;
    tf_ox.layoutParams.weight = 1;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        tf_ox.textFieldTextSize = 18.0f;
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        tf_ox.textFieldTextSize = 12.0f;
    }
    tf_ox.text = @"-99.999";
    tf_ox.layoutParams.alignment = JWLayoutAlignParentLeft | JWLayoutOrientationVertical;
    tf_ox.layoutParams.marginLeft = [self uiWidthBy:15.0f];
    [self updataTextField:tf_ox];
    [lo_size_lin addSubview:tf_ox];
    
    tf_oy = [UITextField new];
    tf_oy.layoutParams.width = JWLayoutMatchParent;//[self uiWidthBy:130.0f];
    tf_oy.layoutParams.height = JWLayoutWrapContent;
    tf_oy.layoutParams.weight = 1;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        tf_oy.textFieldTextSize = 18.0f;
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        tf_oy.textFieldTextSize = 12.0f;
    }
    tf_oy.text = @"-99.999";
    tf_oy.layoutParams.alignment = JWLayoutAlignParentLeft | JWLayoutOrientationVertical;
    tf_oy.layoutParams.marginLeft = [self uiWidthBy:5.0f];
    [self updataTextField:tf_oy];
    [lo_size_lin addSubview:tf_oy];
    
    tf_oz = [UITextField new];
    tf_oz.layoutParams.width = JWLayoutMatchParent;//[self uiWidthBy:130.0f];
    tf_oz.layoutParams.height = JWLayoutWrapContent;
    tf_oz.layoutParams.weight = 1;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        tf_oz.textFieldTextSize = 18.0f;
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        tf_oz.textFieldTextSize = 12.0f;
    }
    tf_oz.text = @"-99.999";
    tf_oz.layoutParams.alignment = JWLayoutAlignParentLeft | JWLayoutOrientationVertical;
    tf_oz.layoutParams.marginLeft = [self uiWidthBy:5.0f];
    [self updataTextField:tf_oz];
    [lo_size_lin addSubview:tf_oz];
    
#pragma mark 大小X
//    JWRelativeLayout *lo_ox = [JWRelativeLayout layout];
//    lo_ox.layoutParams.width = JWLayoutMatchParent;
//    lo_ox.layoutParams.height = JWLayoutWrapContent;
//    lo_ox.backgroundColor = [UIColor clearColor];
//    lo_ox.layoutParams.marginTop = [self uiHeightBy:5.0f];
//    [lo_tools_lin addSubview:lo_ox];
    
    sl_ox = [[UISlider alloc] init];
    sl_ox.layoutParams.width = [self uiWidthBy:460.0f];
    sl_ox.layoutParams.height = sliderHeight;
//    sl_ox.layoutParams.alignment = JWLayoutAlignParentRight | JWLayoutOrientationVertical;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        [sl_ox setThumbImage:ball forState:UIControlStateNormal];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        [sl_ox setThumbImage:ball_iphone forState:UIControlStateNormal];
    }
//    sl_ox.layoutParams.marginRight = [self uiWidthBy:20.0f];
    sl_ox.value = 0.0f;
    [self updateSlider:sl_ox];
    sl_ox.layoutParams.alignment = JWLayoutAlignCenterInParent;
    sl_ox.layoutParams.marginTop = [self uiHeightBy:20.0f];
    [lin_so addSubview:sl_ox];
    [sl_ox addTarget:self action:@selector(onStretchChanged:) forControlEvents:UIControlEventValueChanged];
    
#pragma mark 大小Y
//    JWRelativeLayout *lo_oy = [JWRelativeLayout layout];
//    lo_oy.layoutParams.width = JWLayoutMatchParent;
//    lo_oy.layoutParams.height = JWLayoutWrapContent;
//    lo_oy.backgroundColor = [UIColor clearColor];
//    lo_oy.layoutParams.marginTop = [self uiHeightBy:5.0f];
//    [lo_tools_lin addSubview:lo_oy];
    
    sl_oy = [[UISlider alloc] init];
    sl_oy.layoutParams.width = [self uiWidthBy:460.0f];
    sl_oy.layoutParams.height = sliderHeight;
    sl_oy.layoutParams.alignment = JWLayoutAlignParentRight | JWLayoutOrientationVertical;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        [sl_oy setThumbImage:ball forState:UIControlStateNormal];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        [sl_oy setThumbImage:ball_iphone forState:UIControlStateNormal];
    }
//    sl_oy.layoutParams.marginRight = [self uiWidthBy:20.0f];
    sl_oy.value = 0.0f;
    [self updateSlider:sl_oy];
    sl_oy.layoutParams.alignment = JWLayoutAlignCenterInParent;
    sl_oy.layoutParams.marginTop = [self uiHeightBy:20.0f];
    [lin_so addSubview:sl_oy];
    [sl_oy addTarget:self action:@selector(onStretchChanged:) forControlEvents:UIControlEventValueChanged];
    
#pragma mark 大小Z
//    JWRelativeLayout *lo_oz = [JWRelativeLayout layout];
//    lo_oz.layoutParams.width = JWLayoutMatchParent;
//    lo_oz.layoutParams.height = JWLayoutWrapContent;
//    lo_oz.backgroundColor = [UIColor clearColor];
//    lo_oz.layoutParams.marginTop = [self uiHeightBy:5.0f];
//    [lo_tools_lin addSubview:lo_oz];
    
    sl_oz = [[UISlider alloc] init];
    sl_oz.layoutParams.width = [self uiWidthBy:460.0f];
    sl_oz.layoutParams.height = sliderHeight;
    sl_oz.layoutParams.alignment = JWLayoutAlignParentRight | JWLayoutOrientationVertical;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        [sl_oz setThumbImage:ball forState:UIControlStateNormal];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        [sl_oz setThumbImage:ball_iphone forState:UIControlStateNormal];
    }
//    sl_oz.layoutParams.marginRight = [self uiWidthBy:20.0f];
    sl_oz.value = 0.0f;
    [self updateSlider:sl_oz];
    sl_oz.layoutParams.alignment = JWLayoutAlignCenterInParent;
    sl_oz.layoutParams.marginTop = [self uiHeightBy:20.0f];
    [lin_so addSubview:sl_oz];
    [sl_oz addTarget:self action:@selector(onStretchChanged:) forControlEvents:UIControlEventValueChanged];
    
    JWRelativeLayout *lo_so_e = [JWRelativeLayout layout];
    lo_so_e.layoutParams.width = JWLayoutMatchParent;
    lo_so_e.layoutParams.height = sliderHeight;
    [lin_so addSubview:lo_so_e];
    
#pragma mark 平铺
    JWLinearLayout *lo_tile = [JWLinearLayout layout];
    lo_tile.layoutParams.width = JWLayoutMatchParent;
    lo_tile.layoutParams.height = JWLayoutWrapContent;
    lo_tile.backgroundColor = [UIColor clearColor];
    lo_tile.orientation = JWLayoutOrientationHorizontal;
    lo_tile.layoutParams.marginTop = [self uiHeightBy:20.0f];
    [lo_tools_lin addSubview:lo_tile];
    
    UILabel *lb_tile = [UILabel new];
    lb_tile.layoutParams.width = JWLayoutMatchParent;
    lb_tile.layoutParams.height = JWLayoutWrapContent;
    lb_tile.text = @"平 铺";
    lb_tile.textAlignment = NSTextAlignmentCenter;
    lb_tile.textColor = [UIColor colorWithARGB:R_color_item_tools];
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        lb_tile.labelTextSize = 18.0f;
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        lb_tile.labelTextSize = 12.0f;
    }
//    lb_tile.layoutParams.marginLeft = [self uiWidthBy:25.0f];
    [lo_tile addSubview:lb_tile];
    
    JWLinearLayout *lin_ts = [JWLinearLayout layout];
    lin_ts.layoutParams.width = [self uiWidthBy:500.0f];
    lin_ts.layoutParams.height = JWLayoutWrapContent;
    lin_ts.layoutParams.alignment = JWLayoutAlignCenterInParent;
    lin_ts.backgroundColor = [UIColor whiteColor];
    lin_ts.layer.borderWidth = 0.5f;
    lin_ts.layer.borderColor = [[UIColor colorWithARGB:0xffb3b3b3] CGColor];
    lin_ts.orientation = JWLayoutOrientationVertical;
    lin_ts.layoutParams.marginTop = [self uiHeightBy:20.0f];
    [lo_tools_lin addSubview:lin_ts];
    
    JWLinearLayout *lo_tile_lin = [JWLinearLayout layout];
    lo_tile_lin.layoutParams.width = JWLayoutMatchParent;
    lo_tile_lin.layoutParams.height = JWLayoutWrapContent;
    lo_tile_lin.backgroundColor = [UIColor clearColor];
    lo_tile_lin.orientation = JWLayoutOrientationHorizontal;
    lo_tile_lin.layoutParams.marginTop = [self uiHeightBy:20.0f];
    [lin_ts addSubview:lo_tile_lin];
    
    tf_tilingOffsetX = [UITextField new];
    tf_tilingOffsetX.layoutParams.width = JWLayoutMatchParent;//[self uiWidthBy:180.0f];
    tf_tilingOffsetX.layoutParams.height = JWLayoutWrapContent;
    tf_tilingOffsetX.layoutParams.weight = 1;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        tf_tilingOffsetX.textFieldTextSize = 18.0f;
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        tf_tilingOffsetX.textFieldTextSize = 12.0f;
    }
    tf_tilingOffsetX.text = @"-99.999";
    [self updataTextField:tf_tilingOffsetX];
//    tf_tilingOffsetX.layoutParams.alignment = JWLayoutAlignCenterInParent;
//    tf_tilingOffsetX.layoutParams.marginLeft = [self uiWidthBy:15.0f];
    [lo_tile_lin addSubview:tf_tilingOffsetX];
    
    tf_tilingOffsetY = [UITextField new];
    tf_tilingOffsetY.layoutParams.width = JWLayoutMatchParent;//[self uiWidthBy:180.0f];
    tf_tilingOffsetY.layoutParams.height = JWLayoutWrapContent;
    tf_tilingOffsetY.layoutParams.weight = 1;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        tf_tilingOffsetY.textFieldTextSize = 18.0f;
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        tf_tilingOffsetY.textFieldTextSize = 12.0f;
    }
    tf_tilingOffsetY.text = @"-99.999";
    [self updataTextField:tf_tilingOffsetY];
//    tf_tilingOffsetY.layoutParams.alignment = JWLayoutAlignCenterInParent;
//    tf_tilingOffsetY.layoutParams.marginLeft = [self uiWidthBy:5.0f];
    [lo_tile_lin addSubview:tf_tilingOffsetY];
    
#pragma mark 平铺X
//    JWRelativeLayout *lo_tilingX = [JWRelativeLayout layout];
//    lo_tilingX.layoutParams.width = JWLayoutMatchParent;
//    lo_tilingX.layoutParams.height = JWLayoutWrapContent;
//    lo_tilingX.backgroundColor = [UIColor clearColor];
//    lo_tilingX.layoutParams.marginTop = [self uiHeightBy:5.0f];
//    [lo_tools_lin addSubview:lo_tilingX];
    
    sl_tilingOffsetX = [[UISlider alloc] init];
    sl_tilingOffsetX.layoutParams.width = [self uiWidthBy:460.0f];
    sl_tilingOffsetX.layoutParams.height = sliderHeight;
    sl_tilingOffsetX.layoutParams.alignment = JWLayoutAlignCenterInParent;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        [sl_tilingOffsetX setThumbImage:ball forState:UIControlStateNormal];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        [sl_tilingOffsetX setThumbImage:ball_iphone forState:UIControlStateNormal];
    }
    sl_tilingOffsetX.layoutParams.marginTop = [self uiHeightBy:20.0f];
    sl_tilingOffsetX.value = 1.0f;
    [self updateSlider:sl_tilingOffsetX];
    [lin_ts addSubview:sl_tilingOffsetX];
    [sl_tilingOffsetX addTarget:self action:@selector(onTillingChanged:) forControlEvents:UIControlEventValueChanged];
    
#pragma mark 平铺Y
//    JWRelativeLayout *lo_tilingY = [JWRelativeLayout layout];
//    lo_tilingY.layoutParams.width = JWLayoutMatchParent;
//    lo_tilingY.layoutParams.height = JWLayoutWrapContent;
//    lo_tilingY.backgroundColor = [UIColor clearColor];
//    lo_tilingY.layoutParams.marginTop = [self uiHeightBy:5.0f];
//    [lo_tools_lin addSubview:lo_tilingY];
    
    sl_tilingOffsetY = [[UISlider alloc] init];
    sl_tilingOffsetY.layoutParams.width = [self uiWidthBy:460.0f];
    sl_tilingOffsetY.layoutParams.height = sliderHeight;
    sl_tilingOffsetY.layoutParams.alignment = JWLayoutAlignCenterInParent;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        [sl_tilingOffsetY setThumbImage:ball forState:UIControlStateNormal];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        [sl_tilingOffsetY setThumbImage:ball_iphone forState:UIControlStateNormal];
    }
    sl_tilingOffsetY.layoutParams.marginTop = [self uiHeightBy:20.0f];
    sl_tilingOffsetY.value = 1.0f;
    [self updateSlider:sl_tilingOffsetY];
    [lin_ts addSubview:sl_tilingOffsetY];
    [sl_tilingOffsetY addTarget:self action:@selector(onTillingChanged:) forControlEvents:UIControlEventValueChanged];
    
    JWRelativeLayout *lo_ts_e = [JWRelativeLayout layout];
    lo_ts_e.layoutParams.width = JWLayoutMatchParent;
    lo_ts_e.layoutParams.height = sliderHeight;
    [lin_ts addSubview:lo_ts_e];
    
#pragma mark 缩放
    JWLinearLayout *lo_scale = [JWLinearLayout layout];
    lo_scale.layoutParams.width = JWLayoutMatchParent;
    lo_scale.layoutParams.height = JWLayoutWrapContent;
    lo_scale.backgroundColor = [UIColor clearColor];
    lo_scale.orientation = JWLayoutOrientationHorizontal;
    lo_scale.layoutParams.marginTop = [self uiHeightBy:20.0f];
    [lo_tools_lin addSubview:lo_scale];
    
    UILabel *lb_scale = [UILabel new];
    lb_scale.layoutParams.width = JWLayoutMatchParent;
    lb_scale.layoutParams.height = JWLayoutWrapContent;
    lb_scale.text = @"缩 放";
    lb_scale.textAlignment = NSTextAlignmentCenter;
    lb_scale.textColor = [UIColor colorWithARGB:R_color_item_tools];
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        lb_scale.labelTextSize = 18.0f;
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        lb_scale.labelTextSize = 12.0f;
    }
    [lo_scale addSubview:lb_scale];
    
    JWLinearLayout *lin_sc = [JWLinearLayout layout];
    lin_sc.layoutParams.width = [self uiWidthBy:500.0f];
    lin_sc.layoutParams.height = JWLayoutWrapContent;
    lin_sc.layoutParams.alignment = JWLayoutAlignCenterInParent;
    lin_sc.backgroundColor = [UIColor whiteColor];
    lin_sc.layer.borderWidth = 0.5f;
    lin_sc.layer.borderColor = [[UIColor colorWithARGB:0xffb3b3b3] CGColor];
    lin_sc.orientation = JWLayoutOrientationVertical;
    lin_sc.layoutParams.marginTop = [self uiHeightBy:20.0f];
    [lo_tools_lin addSubview:lin_sc];
    
    JWLinearLayout *lo_scale_lin = [JWLinearLayout layout];
    lo_scale_lin.layoutParams.width = JWLayoutMatchParent;
    lo_scale_lin.layoutParams.height = JWLayoutWrapContent;
    lo_scale_lin.backgroundColor = [UIColor clearColor];
    lo_scale_lin.orientation = JWLayoutOrientationHorizontal;
    lo_scale_lin.layoutParams.marginTop = [self uiHeightBy:20.0f];
    [lin_sc addSubview:lo_scale_lin];
    
    tf_scaleX = [UITextField new];
    tf_scaleX.layoutParams.width = JWLayoutMatchParent;
    tf_scaleX.layoutParams.height = JWLayoutWrapContent;
    tf_scaleX.layoutParams.weight = 1;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        tf_scaleX.textFieldTextSize = 18.0f;
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        tf_scaleX.textFieldTextSize = 12.0f;
    }
    tf_scaleX.text = @"-99.999";
    tf_scaleX.layoutParams.alignment = JWLayoutAlignParentLeft | JWLayoutOrientationVertical;
    tf_scaleX.layoutParams.marginLeft = [self uiWidthBy:15.0f];
    [self updataTextField:tf_scaleX];
    [lo_scale_lin addSubview:tf_scaleX];
    
    tf_scaleY = [UITextField new];
    tf_scaleY.layoutParams.width = JWLayoutMatchParent;
    tf_scaleY.layoutParams.height = JWLayoutWrapContent;
    tf_scaleY.layoutParams.weight = 1;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        tf_scaleY.textFieldTextSize = 18.0f;
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        tf_scaleY.textFieldTextSize = 12.0f;
    }
    tf_scaleY.text = @"-99.999";
    tf_scaleY.layoutParams.alignment = JWLayoutAlignParentLeft | JWLayoutOrientationVertical;
    tf_scaleY.layoutParams.marginLeft = [self uiWidthBy:5.0f];
    [self updataTextField:tf_scaleY];
    [lo_scale_lin addSubview:tf_scaleY];
    
    tf_scaleZ = [UITextField new];
    tf_scaleZ.layoutParams.width = JWLayoutMatchParent;
    tf_scaleZ.layoutParams.height = JWLayoutWrapContent;
    tf_scaleZ.layoutParams.weight = 1;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        tf_scaleZ.textFieldTextSize = 18.0f;
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        tf_scaleZ.textFieldTextSize = 12.0f;
    }
    tf_scaleZ.text = @"-99.999";
    tf_scaleZ.layoutParams.alignment = JWLayoutAlignParentLeft | JWLayoutOrientationVertical;
    tf_scaleZ.layoutParams.marginLeft = [self uiWidthBy:5.0f];
    [self updataTextField:tf_scaleZ];
    [lo_scale_lin addSubview:tf_scaleZ];

#pragma mark 缩放X
    sl_scaleX = [[UISlider alloc] init];
    sl_scaleX.layoutParams.width = [self uiWidthBy:460.0f];
    sl_scaleX.layoutParams.height = sliderHeight;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        [sl_scaleX setThumbImage:ball forState:UIControlStateNormal];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        [sl_scaleX setThumbImage:ball_iphone forState:UIControlStateNormal];
    }
    sl_scaleX.value = 1.0f;
    [self updateSlider:sl_scaleX];
    sl_scaleX.layoutParams.alignment = JWLayoutAlignCenterInParent;
    sl_scaleX.layoutParams.marginTop = [self uiHeightBy:20.0f];
    [lin_sc addSubview:sl_scaleX];
    [sl_scaleX addTarget:self action:@selector(onScaleChange:) forControlEvents:UIControlEventValueChanged];
    
#pragma mark 缩放Y
    sl_scaleY = [[UISlider alloc] init];
    sl_scaleY.layoutParams.width = [self uiWidthBy:460.0f];
    sl_scaleY.layoutParams.height = sliderHeight;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        [sl_scaleY setThumbImage:ball forState:UIControlStateNormal];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        [sl_scaleY setThumbImage:ball_iphone forState:UIControlStateNormal];
    }
    sl_scaleY.value = 1.0f;
    [self updateSlider:sl_scaleY];
    sl_scaleY.layoutParams.alignment = JWLayoutAlignCenterInParent;
    sl_scaleY.layoutParams.marginTop = [self uiHeightBy:20.0f];
    [lin_sc addSubview:sl_scaleY];
    [sl_scaleY addTarget:self action:@selector(onScaleChange:) forControlEvents:UIControlEventValueChanged];
    
#pragma mark 缩放Z
    sl_scaleZ = [[UISlider alloc] init];
    sl_scaleZ.layoutParams.width = [self uiWidthBy:460.0f];
    sl_scaleZ.layoutParams.height = sliderHeight;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        [sl_scaleZ setThumbImage:ball forState:UIControlStateNormal];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        [sl_scaleZ setThumbImage:ball_iphone forState:UIControlStateNormal];
    }
    sl_scaleZ.value = 1.0f;
    [self updateSlider:sl_scaleZ];
    sl_scaleZ.layoutParams.alignment = JWLayoutAlignCenterInParent;
    sl_scaleZ.layoutParams.marginTop = [self uiHeightBy:20.0f];
    [lin_sc addSubview:sl_scaleZ];
    [sl_scaleZ addTarget:self action:@selector(onScaleChange:) forControlEvents:UIControlEventValueChanged];
    
    JWRelativeLayout *lo_sc_e = [JWRelativeLayout layout];
    lo_sc_e.layoutParams.width = JWLayoutMatchParent;
    lo_sc_e.layoutParams.height = sliderHeight;
    [lin_sc addSubview:lo_sc_e];
    
#pragma mark 留白
    JWRelativeLayout *lo_empty = [JWRelativeLayout layout];
    lo_empty.layoutParams.width = JWLayoutMatchParent;
    lo_empty.layoutParams.height = [self uiHeightBy:200.0f];
    lo_empty.backgroundColor = [UIColor clearColor];
    [lo_tools_lin addSubview:lo_empty];

    return lo_itemTools;
}

- (void)onStateEnter:(NSDictionary *)data{
    [super onStateEnter:data];
    
    if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        //注册键盘显示通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
        //注册键盘隐藏通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    lo_itemTools.hidden = NO;
    
    tempObject = mModel.selectedObject;
    
    ItemInfo *info = [Data getItemInfoFromInstance:mModel.selectedObject];
    
    if (info.materialsDictionary != nil) {
        materialsDictionary = info.materialsDictionary;
    } else {
        materialsDictionary = [NSMutableDictionary dictionary];
        [mModel.selectedObject enumRenderableUsing:^(id<JIRenderable> renderable, NSUInteger idx, BOOL *stop) {
            if ([renderable.host.name startsWith:@"sd_"]) {
                return;
            }
            if (renderable.host == mModel.itemRectFrameDecals.decalsObject) {
                return;
            }
            if (renderable.host == mModel.itemOverlapDecals.decalsObject) {
                return;
            }
            id<JIMaterial> material = [renderable.material copyInstanceWithName:[NSString stringWithFormat:@"%@%@",@(mModel.selectedObject.hash),renderable.host.name]];
            id<JITexture> diffuse = [material.diffuseTexture copyInstance];
            material.diffuseTexture = diffuse;
            [materialsDictionary setObject:material forKey:[NSString stringWithFormat:@"%@",@(renderable.hash)]];
        }];
        ItemInfo *info = [Data getItemInfoFromInstance:mModel.selectedObject];
        info.materialsDictionary = materialsDictionary;
    }
    
    JCBounds3 bounds = mModel.selectedObject.scaleBounds;
    JCVector3 size = JCBounds3GetSize(&bounds);
    
    sl_px.maximumValue = (bounds.max.x - bounds.min.x)/2;
    sl_px.minimumValue = -(bounds.max.x - bounds.min.x)/2;
    sl_py.maximumValue = (bounds.max.y - bounds.min.y)/2;
    sl_py.minimumValue = -(bounds.max.y - bounds.min.y)/2;
    sl_pz.maximumValue = (bounds.max.z - bounds.min.z)/2;
    sl_pz.minimumValue = -(bounds.max.z - bounds.min.z)/2;
    
    sl_ox.maximumValue = size.x;
    sl_ox.minimumValue = 0.0f;
    sl_oy.maximumValue = size.y;
    sl_oy.minimumValue = 0.0f;
    sl_oz.maximumValue = size.z;
    sl_oz.minimumValue = 0.0f;
    
    sl_tilingOffsetX.maximumValue = 20.0f;
    sl_tilingOffsetX.minimumValue = 1.0f;
    sl_tilingOffsetY.maximumValue = 20.0f;
    sl_tilingOffsetY.minimumValue = 1.0f;
    
    sl_scaleX.maximumValue = 3.0f;
    sl_scaleX.minimumValue = 1.0f;
    sl_scaleY.maximumValue = 3.0f;
    sl_scaleY.minimumValue = 1.0f;
    sl_scaleZ.maximumValue = 3.0f;
    sl_scaleZ.minimumValue = 1.0f;
    
    mStretchPivotObject.parent = mModel.selectedObject;
    [mStretchPivotObject setAxesVisible:YES recursive:NO];
    mStretchPivotObject.transform.position = JCVector3Make(sl_px.value, sl_py.value, sl_pz.value);
//    tf_px.text = [NSString stringWithFormat:@"%.3f", sl_px.value];
//    tf_py.text = [NSString stringWithFormat:@"%.3f", sl_py.value];
//    tf_pz.text = [NSString stringWithFormat:@"%.3f", sl_pz.value];
    
    if (info.st != nil) {
        tf_px.text = [NSString stringWithFormat:@"%.3f",[info.st.px floatValue]];
        tf_py.text = [NSString stringWithFormat:@"%.3f",[info.st.py floatValue]];
        tf_pz.text = [NSString stringWithFormat:@"%.3f",[info.st.pz floatValue]];
        tf_ox.text = [NSString stringWithFormat:@"%.3f",[info.st.ox floatValue] + size.x];
        tf_oy.text = [NSString stringWithFormat:@"%.3f",[info.st.oy floatValue] + size.y];
        tf_oz.text = [NSString stringWithFormat:@"%.3f",[info.st.oz floatValue] + size.z];
        
        sl_px.value = [info.st.px floatValue];
        sl_py.value = [info.st.py floatValue];
        sl_pz.value = [info.st.pz floatValue];
        sl_ox.value = [info.st.ox floatValue];
        sl_oy.value = [info.st.oy floatValue];
        sl_oz.value = [info.st.oz floatValue];
    } else {
        tf_px.text = @"0.000";
        tf_py.text = @"0.100";
        tf_pz.text = @"0.000";
        tf_ox.text = [NSString stringWithFormat:@"%.3f",size.x];
        tf_oy.text = [NSString stringWithFormat:@"%.3f",size.y];
        tf_oz.text = [NSString stringWithFormat:@"%.3f",size.z];
        
        sl_px.value = 0.0f;
        sl_py.value = 0.1f;
        sl_pz.value = 0.0f;
        sl_ox.value = 0.0f;
        sl_oy.value = 0.0f;
        sl_oz.value = 0.0f;
    }
    
    if (info.ts != nil) {
        tf_tilingOffsetX.text = [NSString stringWithFormat:@"%.3f",[info.ts.tx floatValue]];
        tf_tilingOffsetY.text = [NSString stringWithFormat:@"%.3f",[info.ts.ty floatValue]];
        
        sl_tilingOffsetX.value = [info.ts.tx floatValue];
        sl_tilingOffsetY.value = [info.ts.ty floatValue];
    } else {
        [mModel.selectedObject enumRenderableUsing:^(id<JIRenderable> renderable, NSUInteger idx, BOOL *stop) {
            if ([renderable.host.name startsWith:@"sd_"]) {
                return;
            }
            if (renderable.host == mModel.itemRectFrameDecals.decalsObject) {
                return;
            }
            if (renderable.host == mModel.itemOverlapDecals.decalsObject) {
                return;
            }
            id<JIMaterial> material = renderable.material;
            id<JITexture> diffuse = material.diffuseTexture;
            tf_tilingOffsetX.text = [NSString stringWithFormat:@"%.3f",diffuse.tilingOffset.tiling.x];
            tf_tilingOffsetY.text = [NSString stringWithFormat:@"%.3f",diffuse.tilingOffset.tiling.y];
            sl_tilingOffsetX.value = diffuse.tilingOffset.tiling.x;
            sl_tilingOffsetY.value = diffuse.tilingOffset.tiling.y;
            *stop = YES;
        }];
    }
    
    if (info.sc != nil) {
        tf_scaleX.text = [NSString stringWithFormat:@"%.3f",[info.sc.sx floatValue]];
        tf_scaleY.text = [NSString stringWithFormat:@"%.3f",[info.sc.sy floatValue]];
        tf_scaleZ.text = [NSString stringWithFormat:@"%.3f",[info.sc.sz floatValue]];
        
        sl_scaleX.value = [info.sc.sx floatValue];
        sl_scaleY.value = [info.sc.sy floatValue];
        sl_scaleZ.value = [info.sc.sz floatValue];
    } else {
        tf_scaleX.text = @"1.000";
        tf_scaleY.text = @"1.000";
        tf_scaleZ.text = @"1.000";
        
        sl_scaleX.value = 1.0f;
        sl_scaleY.value = 1.0f;
        sl_scaleZ.value = 1.0f;
    }
    
#pragma mark 设置点击任何物件都返回之前的状态 防止多余的误操作
    ItemTools *weakSelf = self;
    id<IMesherModel> model = mModel;
    mModel.itemSelectAndMoveBehaviour.selectedMask = SelectedMaskAllItems | SelectedMaskAllArchs;
    mModel.itemSelectAndMoveBehaviour.onSelect = (^(id<JIGameObject> object) {
        [weakSelf updateUndoRedoState];
        [weakSelf.parentMachine revertState];
    });
    mModel.itemSelectAndMoveBehaviour.canMove = NO;
    mModel.itemSelectAndMoveBehaviour.onItemEndMove = ^(CGPoint positionInView){
        [model.currentPlan showOverlap];
    };
    
    mModel.photographer.cameraEnabled = YES;
    
    [self updateStretch];
    [self updateScale];
    
#pragma mark Command
    if (command == nil) {
        command = [[ItemToolsCommand alloc] init];
    }
    command.model = mModel;
    command.object = mModel.selectedObject;
    JCVector3 stretchPivot = JCVector3Make(sl_px.value, sl_py.value, sl_pz.value);
    JCVector3 stretch = JCVector3Make(sl_ox.value, sl_oy.value, sl_oz.value);
    JCStretch ost = JCStretchMake(stretchPivot, stretch);
    command.originStretch = ost;
    command.materialsDictionary = materialsDictionary;
    command.originTx = [tf_tilingOffsetX.text floatValue];
    command.originTy = [tf_tilingOffsetY.text floatValue];
    command.originSx = [tf_scaleX.text floatValue];
    command.originSy = [tf_scaleY.text floatValue];
    command.originSz = [tf_scaleZ.text floatValue];
    command.originScale = info.originScale;
}

- (void)onStateLeave{
//    lo_itemTools.hidden = YES;
//    mStretchPivotObject.parent = nil;
    mModel.photographer.cameraEnabled = NO;
    ItemInfo *info = [Data getItemInfoFromInstance:tempObject];
    Stretch *st = [Stretch new];
    st.px = [NSNumber numberWithFloat:sl_px.value];
    st.py = [NSNumber numberWithFloat:sl_py.value];
    st.pz = [NSNumber numberWithFloat:sl_pz.value];
    st.ox = [NSNumber numberWithFloat:sl_ox.value];
    st.oy = [NSNumber numberWithFloat:sl_oy.value];
    st.oz = [NSNumber numberWithFloat:sl_oz.value];
    TilingOffset *ts = [TilingOffset new];
    ts.tx = [NSNumber numberWithFloat:sl_tilingOffsetX.value];
    ts.ty = [NSNumber numberWithFloat:sl_tilingOffsetY.value];
    Scale *sc = [Scale new];
    sc.sx = [NSNumber numberWithFloat:sl_scaleX.value];
    sc.sy = [NSNumber numberWithFloat:sl_scaleY.value];
    sc.sz = [NSNumber numberWithFloat:sl_scaleZ.value];
    info.st = st;
    info.ts = ts;
    info.sc = sc;
    [mStretchPivotObject setAxesVisible:NO recursive:NO];
    
    JCVector3 stretchPivot = JCVector3Make(sl_px.value, sl_py.value, sl_pz.value);
    JCVector3 stretch = JCVector3Make(sl_ox.value, sl_oy.value, sl_oz.value);
    JCStretch dst = JCStretchMake(stretchPivot, stretch);
    command.destStretch = dst;
    command.destTx = [ts.tx floatValue];
    command.destTy = [ts.ty floatValue];
    command.destSx = [sc.sx floatValue];
    command.destSy = [sc.sy floatValue];
    command.destSz = [sc.sz floatValue];
    [mModel.commandMachine doneCommand:command];
    command = nil;
    
    [mModel.currentPlan showOverlap];
    
    //移除监听
    if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        //注销键盘显示通知
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
    
    [self finishAction];
    [super onStateLeave];
}

- (void)onSingleTap:(UITapGestureRecognizer *)singleTap{
    switch (singleTap.view.tag) {
        case R_id_btn_back: {
            [self.parentMachine revertState];
            break;
        }
        default:
            break;
    }
}

- (void) updateStretch {
    JCVector3 stretchPivot = JCVector3Make(sl_px.value, sl_py.value, sl_pz.value);
    JCVector3 stretch = JCVector3Make(sl_ox.value, sl_oy.value, sl_oz.value);
    mModel.selectedObject.stretch = JCStretchMake(stretchPivot, stretch);
    mStretchPivotObject.transform.position = stretchPivot;
    mStretchPivotObject.stretch = JCStretchZero();
    
    [mModel.selectedObject enumRenderableUsing:^(id<JIRenderable> renderable, NSUInteger idx, BOOL *stop) {
        if ([renderable.host.name startsWith:@"sd_"]) {
            return;
        }
        if (renderable.host == mModel.itemRectFrameDecals.decalsObject) {
            return;
        }
        if (renderable.host == mModel.itemOverlapDecals.decalsObject) {
            return;
        }
        id<JIMaterial> mat = [materialsDictionary valueForKey:[NSString stringWithFormat:@"%@",@(renderable.hash)]];
        if (mat == nil) {
            return;
        }
        id<JITexture> diffuse = mat.diffuseTexture;
        diffuse.tilingOffset = JCTilingOffsetMake([tf_tilingOffsetX.text floatValue], [tf_tilingOffsetY.text floatValue], 0.0f, 0.0f);
        renderable.material = mat;
    }];
    mModel.currentPlan.sceneDirty = YES;
    [self updateInfo];
}

- (void) onStretchChanged:(UISlider*)slider {
    [self updateStretch];
    mStretchPivotObject.transform.position = JCVector3Make(sl_px.value, sl_py.value, sl_pz.value);
    JCBounds3 bounds = mModel.selectedObject.scaleBounds;
    JCVector3 size = JCBounds3GetSize(&bounds);
    tf_ox.text = [NSString stringWithFormat:@"%.3f", size.x + sl_ox.value];
    tf_oy.text = [NSString stringWithFormat:@"%.3f", size.y + sl_oy.value];
    tf_oz.text = [NSString stringWithFormat:@"%.3f", size.z + sl_oz.value];
    tf_px.text = [NSString stringWithFormat:@"%.3f", sl_px.value];
    tf_py.text = [NSString stringWithFormat:@"%.3f", sl_py.value];
    tf_pz.text = [NSString stringWithFormat:@"%.3f", sl_pz.value];
}

- (void) onTillingChanged:(UISlider*)slider {
    [mModel.selectedObject enumRenderableUsing:^(id<JIRenderable> renderable, NSUInteger idx, BOOL *stop) {
        if ([renderable.host.name startsWith:@"sd_"]) {
            return;
        }
        if (renderable.host == mModel.itemRectFrameDecals.decalsObject) {
            return;
        }
        if (renderable.host == mModel.itemOverlapDecals.decalsObject) {
            return;
        }
        id<JIMaterial> mat = [materialsDictionary valueForKey:[NSString stringWithFormat:@"%@",@(renderable.hash)]];
        if (mat == nil) {
            return;
        }
        id<JITexture> diffuse = mat.diffuseTexture;
        diffuse.tilingOffset = JCTilingOffsetMake(sl_tilingOffsetX.value, sl_tilingOffsetY.value, 0.0f, 0.0f);
        renderable.material = mat;
    }];
    
    tf_tilingOffsetX.text = [NSString stringWithFormat:@"%.3f", sl_tilingOffsetX.value];
    tf_tilingOffsetY.text = [NSString stringWithFormat:@"%.3f", sl_tilingOffsetY.value];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    tempText = textField.text;
    return YES;
}

- (void) textChange:(UITextField *)textField {
    UILabel *textFieldLabel = (UILabel*)textField.inputAccessoryView;
    NSString *newText = [self isNumberOfInputContent:textField.text];
    textFieldLabel.text = newText;
}

- (void) updataTextField:(UITextField *)textFeild {
    textFeild.textColor = [UIColor colorWithARGB:R_color_item_tools];
    textFeild.textAlignment = NSTextAlignmentCenter;
//    textFeild.keyboardType = UIKeyboardTypeNumberPad;
    textFeild.returnKeyType = UIReturnKeyDone;
    [textFeild addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingDidBegin | UIControlEventEditingChanged];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [self uiHeightBy:100.0f], [self uiWidthBy:100.0f])];
    label.textAlignment = NSTextAlignmentCenter;
    textFeild.inputAccessoryView = label;
    textFeild.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    JCBounds3 bounds = mModel.selectedObject.scaleBounds;
    JCVector3 size = JCBounds3GetSize(&bounds);
    
    if ([textField.text isEqual:@""]) {
        textField.text = tempText;
        [textField resignFirstResponder];
        return NO;
    }
    
    sl_px.value = [tf_px.text floatValue];
    sl_py.value = [tf_py.text floatValue];
    sl_pz.value = [tf_pz.text floatValue];
    sl_ox.value = [tf_ox.text floatValue] - size.x;
    sl_oy.value = [tf_oy.text floatValue] - size.y;
    sl_oz.value = [tf_oz.text floatValue] - size.z;
    sl_tilingOffsetX.value = [tf_tilingOffsetX.text floatValue];
    sl_tilingOffsetY.value = [tf_tilingOffsetY.text floatValue];
    sl_scaleX.value = [tf_scaleX.text floatValue];
    sl_scaleY.value = [tf_scaleY.text floatValue];
    sl_scaleZ.value = [tf_scaleZ.text floatValue];
    
    if ([tf_px.text floatValue] > sl_px.maximumValue) {
        tf_px.text = [NSString stringWithFormat:@"%.3f",sl_px.maximumValue];
    }else if ([tf_px.text floatValue] < sl_px.minimumValue){
        tf_px.text = [NSString stringWithFormat:@"%.3f",sl_px.minimumValue];
    }
    if ([tf_py.text floatValue] > sl_py.maximumValue) {
        tf_py.text = [NSString stringWithFormat:@"%.3f",sl_py.maximumValue];
    }else if ([tf_py.text floatValue] < sl_py.minimumValue){
        tf_py.text = [NSString stringWithFormat:@"%.3f",sl_py.minimumValue];
    }
    
    if ([tf_ox.text floatValue] - size.x > sl_ox.maximumValue) {
        tf_ox.text = [NSString stringWithFormat:@"%.3f",sl_ox.maximumValue + size.x];
    }else if ([tf_ox.text floatValue] - size.x < sl_ox.minimumValue){
        tf_ox.text = [NSString stringWithFormat:@"%.3f",size.x];
    }
    if ([tf_oy.text floatValue] - size.y > sl_oy.maximumValue) {
        tf_oy.text = [NSString stringWithFormat:@"%.3f",sl_oy.maximumValue + size.y];
    }else if ([tf_oy.text floatValue] - size.y < sl_oy.minimumValue){
        tf_oy.text = [NSString stringWithFormat:@"%.3f",size.y];
    }
    if ([tf_oz.text floatValue] - size.z > sl_oz.maximumValue) {
        tf_oz.text = [NSString stringWithFormat:@"%.3f",sl_oz.maximumValue + size.z];
    }else if ([tf_oz.text floatValue] - size.z < sl_oz.minimumValue){
        tf_oz.text = [NSString stringWithFormat:@"%.3f",size.z];
    }
    
    if ([tf_tilingOffsetX.text floatValue] > sl_tilingOffsetX.maximumValue) {
        tf_tilingOffsetX.text = [NSString stringWithFormat:@"%.3f",sl_tilingOffsetX.maximumValue];
    }else if ([tf_tilingOffsetX.text floatValue] < sl_tilingOffsetX.minimumValue){
        tf_tilingOffsetX.text = [NSString stringWithFormat:@"%.3f",sl_tilingOffsetX.minimumValue];
    }
    if ([tf_tilingOffsetY.text floatValue] > sl_tilingOffsetY.maximumValue) {
        tf_tilingOffsetY.text = [NSString stringWithFormat:@"%.3f",sl_tilingOffsetY.maximumValue];
    }else if ([tf_tilingOffsetY.text floatValue] < sl_tilingOffsetY.minimumValue){
        tf_tilingOffsetY.text = [NSString stringWithFormat:@"%.3f",sl_tilingOffsetY.minimumValue];
    }
    
    if ([tf_scaleX.text floatValue] > sl_scaleX.maximumValue) {
        tf_scaleX.text = [NSString stringWithFormat:@"%.3f",sl_scaleX.maximumValue];
    }else if ([tf_scaleX.text floatValue] < sl_scaleX.minimumValue){
        tf_scaleX.text = [NSString stringWithFormat:@"%.3f",sl_scaleX.minimumValue];
    }
    if ([tf_scaleY.text floatValue] > sl_scaleY.maximumValue) {
        tf_scaleY.text = [NSString stringWithFormat:@"%.3f",sl_scaleY.maximumValue];
    }else if ([tf_scaleY.text floatValue] < sl_scaleY.minimumValue){
        tf_scaleY.text = [NSString stringWithFormat:@"%.3f",sl_scaleY.minimumValue];
    }
    if ([tf_scaleZ.text floatValue] > sl_scaleZ.maximumValue) {
        tf_scaleZ.text = [NSString stringWithFormat:@"%.3f",sl_scaleZ.maximumValue];
    }else if ([tf_scaleZ.text floatValue] < sl_scaleZ.minimumValue){
        tf_scaleZ.text = [NSString stringWithFormat:@"%.3f",sl_scaleZ.minimumValue];
    }
    
    [self updateStretch];
    [self updateScale];
    [textField resignFirstResponder];
    
    return YES;
}

- (void) onScaleChange:(UISlider*)slider {
    [self updateScale];
    tf_scaleX.text = [NSString stringWithFormat:@"%.3f",sl_scaleX.value];
    tf_scaleY.text = [NSString stringWithFormat:@"%.3f",sl_scaleY.value];
    tf_scaleZ.text = [NSString stringWithFormat:@"%.3f",sl_scaleZ.value];
}

- (void) updateScale {
    ItemInfo *info = [Data getItemInfoFromInstance:mModel.selectedObject];
    JCVector3 orginScale = info.originScale;
    JCVector3 scale = JCVector3Make(sl_scaleX.value, sl_scaleY.value, sl_scaleZ.value);
    JCVector3 newScale = JCVector3Mulv(&orginScale, &scale);
    mModel.selectedObject.transform.scale = newScale;
    mModel.currentPlan.sceneDirty = YES;
    [self updateInfo];
}

#pragma mark 判断输入的内容为数字内容
- (NSString *)isNumberOfInputContent:(NSString *)inputContent{
    NSString *nubmerStr = @"0123456789.";
    NSMutableString *avaliableContent = [NSMutableString string];
    for (int i = 0; i < inputContent.length; i++) {
        NSString *str = [NSString stringWithFormat:@"%c",[inputContent characterAtIndex:i]];
        if ([nubmerStr containsString:str]) {
            [avaliableContent appendString:str];
        }
    }
    return avaliableContent;
}

// 键盘出现处理事件
- (void)handleKeyboardDidShow:(NSNotification *)notification
{
    [self configDoneInKeyBoardButton:notification];
    // NSNotification中的 userInfo字典中包含键盘的位置和大小等信息
    NSDictionary *userInfo = [notification userInfo];
    // UIKeyboardAnimationDurationUserInfoKey 对应键盘弹出的动画时间
    CGFloat animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    // UIKeyboardAnimationCurveUserInfoKey 对应键盘弹出的动画类型
    NSInteger animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    //数字彩,数字键盘添加“完成”按钮
    if (doneInKeyboardButton){
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];//设置添加按钮的动画时间
        [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];//设置添加按钮的动画类型
        
        //设置自定制按钮的添加位置(这里为数字键盘添加“完成”按钮)
        doneInKeyboardButton.transform=CGAffineTransformMakeTranslation(0, -(keyBoardSize.height/4));
        
        [UIView commitAnimations];
    }
    
}
// 键盘消失处理事件
- (void)handleKeyboardWillHide:(NSNotification *)notification
{
    // NSNotification中的 userInfo字典中包含键盘的位置和大小等信息
    NSDictionary *userInfo = [notification userInfo];
    // UIKeyboardAnimationDurationUserInfoKey 对应键盘收起的动画时间
    CGFloat animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if (doneInKeyboardButton.superview)
    {
        [UIView animateWithDuration:animationDuration animations:^{
            //动画内容，将自定制按钮移回初始位置
            doneInKeyboardButton.transform=CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            //动画结束后移除自定制的按钮
            [doneInKeyboardButton removeFromSuperview];
        }];
        
    }
}
//初始化，数字键盘“完成”按钮
- (void)configDoneInKeyBoardButton:(NSNotification *)notification{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    NSDictionary * info = notification.userInfo;
    keyBoardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //初始化
    if (doneInKeyboardButton == nil)
    {
        doneInKeyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneInKeyboardButton setTitle:@"完成" forState:UIControlStateNormal];
        [doneInKeyboardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        doneInKeyboardButton.frame = CGRectMake(0, screenHeight, keyBoardSize.width/3, keyBoardSize.height/4);
        
        doneInKeyboardButton.adjustsImageWhenHighlighted = NO;
        [doneInKeyboardButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    }
    //每次必须从新设定“完成”按钮的初始化坐标位置
    doneInKeyboardButton.frame = CGRectMake(0, screenHeight, keyBoardSize.width/3, keyBoardSize.height/4);
    
    //由于ios8下，键盘所在的window视图还没有初始化完成，调用在下一次 runloop 下获得键盘所在的window视图
    [self performSelector:@selector(addDoneButton) withObject:nil afterDelay:0.0f];
    
}

//- (void) addDoneButton{
//    //获得键盘所在的window视图
//    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
//    [tempWindow addSubview:doneInKeyboardButton];    // 注意这里直接加到window上
//
//}
- (void)addDoneButton{
    //获得键盘所在的window视图
    NSArray *array= [[UIApplication sharedApplication]windows];
    
    for (UIWindow *window in array) {
        
        NSString *str=NSStringFromClass([window class]);
        if ([str isEqualToString:@"UIRemoteKeyboardWindow"]) {
            [window addSubview:doneInKeyboardButton];
        }
        
    }
}
//点击“完成”按钮事件，收起键盘
-(void)finishAction{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
}

- (void) updateSlider:(UISlider*)slider {
    [slider setMinimumTrackTintColor:[UIColor colorWithARGB:R_color_slider_l]];
    [slider setMaximumTrackTintColor:[UIColor colorWithARGB:R_color_slider_r]];
//    [slider setMaximumTrackImage:slider_r forState:UIControlStateNormal];
//    [slider setMinimumTrackImage:slider_l forState:UIControlStateNormal];
}

- (void)updateInfo {
    ItemInfo *info = [Data getItemInfoFromInstance:tempObject];
    Stretch *st = [Stretch new];
    st.px = [NSNumber numberWithFloat:sl_px.value];
    st.py = [NSNumber numberWithFloat:sl_py.value];
    st.pz = [NSNumber numberWithFloat:sl_pz.value];
    st.ox = [NSNumber numberWithFloat:sl_ox.value];
    st.oy = [NSNumber numberWithFloat:sl_oy.value];
    st.oz = [NSNumber numberWithFloat:sl_oz.value];
    TilingOffset *ts = [TilingOffset new];
    ts.tx = [NSNumber numberWithFloat:sl_tilingOffsetX.value];
    ts.ty = [NSNumber numberWithFloat:sl_tilingOffsetY.value];
    Scale *sc = [Scale new];
    sc.sx = [NSNumber numberWithFloat:sl_scaleX.value];
    sc.sy = [NSNumber numberWithFloat:sl_scaleY.value];
    sc.sz = [NSNumber numberWithFloat:sl_scaleZ.value];
    info.st = st;
    info.ts = ts;
    info.sc = sc;
    [mStretchPivotObject setAxesVisible:NO recursive:NO];
}

@end
