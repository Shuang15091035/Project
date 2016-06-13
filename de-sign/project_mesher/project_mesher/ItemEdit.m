//
//  ItemEdit.m
//  project_mesher
//
//  Created by MacMini on 15/10/12.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "ItemEdit.h"
#import "MesherModel.h"
#import "GamePhotographer.h"
#import <jw/JCMath.h>
#import "Data.h"
#import "ProductList.h"
#import "ItemMoveCommand.h"
#import "ItemRotateCommand.h"
#import "ItemLongPressRotateCommand.h"
#import "StyleListAdapter.h"
#import "ItemDeleteCommand.h"
#import "ItemTools.h"

@interface ItemEdit () <UIGestureRecognizerDelegate> {
    JWRelativeLayout *lo_item_edit;
    UILabel *tv_name;
    UIImageView* img_image;
    JWImageOptions* opt_img_image;
    UILabel *tv_price;
    JWFrameLayout* lo_object_menu_container; // 物件上的菜单容器
    JWLinearLayout* lo_object_menu;
    
    id<JIViewTag> mItemEditMenu;
    JWRect4CornersDecals *mItemRectFrameDecals; // 物件上的边栏
    
    JWRadioViewGroup *rg_option;
    UIButton *btn_change_color;
    UIButton *btn_description;
    JWCollectionView *cv_style;
    
    StyleListAdapter *mStyleListAdapter;

    float edit_pointX;
    float object_menu_width;
    
    UILabel *lv_degree;
    UIButton *btn_rotate;
    UIButton *btn_tools;
    UIButton *btn_left;
    UIButton *btn_right;
    UIButton *btn_link;
    UIButton *btn_AR;
    UIButton *btn_delete;
    
    CGFloat angle;
    
    JWRelativeLayout *lo_style;
    JWRelativeLayout *lo_description;
    UIWebView *wv_description;
    
    // option的按钮的下划线
    JWRelativeLayout *lo_button1_line1;
    JWRelativeLayout *lo_button2_line1;
    JWRelativeLayout *lo_button2_line2;
    JWRelativeLayout *lo_button3_line1;
    
    NSTimer *rotate_timer_left;
    NSTimer *rotate_timer_right;
    
    id<JIGameObject> tempObject;
    BOOL isRotated;
    
    NSInteger timeIndex;
}

@property (nonatomic, readwrite) float mObject_menu_width;
@property (nonatomic, readwrite) BOOL mIsRotated;

@end

@implementation ItemEdit

//@synthesize itemObject = mItemObject;
@synthesize mObject_menu_width = object_menu_width;
@synthesize mIsRotated = isRotated;

//- (void)onCreated {
//    [self.subMachine addState:[[ItemTools alloc] initWithModel:mModel] withName:[States ItemTools]];
//}

- (UIView *)onCreateView:(UIView *)parent{
    
    lo_item_edit = (JWRelativeLayout *)[parent viewWithTag:R_id_lo_item_edit];
    
    JWLinearLayout *lo_menu_edit_linear = [JWLinearLayout layout];
    lo_menu_edit_linear.layoutParams.width = JWLayoutMatchParent;
    lo_menu_edit_linear.layoutParams.height = JWLayoutMatchParent;
    lo_menu_edit_linear.orientation = JWLayoutOrientationVertical;
    [lo_item_edit addSubview:lo_menu_edit_linear];
    
    JWRelativeLayout* lo_item_name = [JWRelativeLayout layout];
    lo_item_name.layoutParams.width = JWLayoutMatchParent;
    lo_item_name.layoutParams.height = JWLayoutWrapContent;
    [lo_menu_edit_linear addSubview:lo_item_name];
    
    UIImage *btn_back_n = [UIImage imageByResourceDrawable:@"btn_close_n.png"];
    UIImageView *btn_back = [[UIImageView alloc] initWithImage:btn_back_n];
    btn_back.tag = R_id_btn_back;
    btn_back.layoutParams.width = JWLayoutWrapContent;
    btn_back.layoutParams.height = JWLayoutWrapContent;
    btn_back.layoutParams.alignment = JWLayoutAlignParentLeft | JWLayoutAlignCenterVertical;
    btn_back.layoutParams.marginLeft = [MesherModel uiWidthBy:20.0f];
    [lo_item_name addSubview:btn_back];
    
    tv_name = [[UILabel alloc] init];
    tv_name.layoutParams.width = JWLayoutWrapContent;
    tv_name.layoutParams.height = JWLayoutWrapContent;
    tv_name.layoutParams.alignment = JWLayoutAlignCenterInParent;
    tv_name.textColor = [UIColor colorWithARGB:R_color_item_title];
    tv_name.labelTextSize = 17;
    [lo_item_name addSubview:tv_name];
    
    UIImage *img_divider_dark_520_img = [UIImage imageByResourceDrawable:@"img_divider_dark_520.png"];
    UIImageView *img_divider_dark_520 = [[UIImageView alloc] initWithImage:img_divider_dark_520_img];
    img_divider_dark_520.layoutParams.width = JWLayoutMatchParent;
    img_divider_dark_520.layoutParams.height = JWLayoutWrapContent;
    img_divider_dark_520.layoutParams.marginLeft = [self uiWidthBy:20.0f];
    img_divider_dark_520.layoutParams.marginRight = [self uiWidthBy:20.0f];
    [lo_menu_edit_linear addSubview:img_divider_dark_520];

    img_image = [[UIImageView alloc] init];
    CGFloat img_width = [MesherModel uiWidthBy:320.0f];
    CGFloat img_height = [MesherModel uiHeightBy:460.0f];
    CGFloat img_size = img_width > img_height ? img_width : img_height;
    img_image.layoutParams.width = img_size;
    img_image.layoutParams.height = img_size;
    img_image.layoutParams.marginLeft = [MesherModel uiWidthBy:10.0f];
    img_image.layoutParams.alignment = JWLayoutAlignCenterHorizontal;
    [lo_menu_edit_linear addSubview:img_image];
    //    opt_img_image = [JWImageOptions options];
    //    opt_img_image.requestWidth = img_size;
    //    opt_img_image.requestHeight = img_size;
    opt_img_image = nil;

#pragma mark 显示价格的容器
    JWRelativeLayout *lo_price = [JWRelativeLayout layout];
    lo_price.layoutParams.width = JWLayoutMatchParent;
    lo_price.layoutParams.height = JWLayoutWrapContent;
    [lo_menu_edit_linear addSubview:lo_price];
    
    CGFloat titleTextSize = 0.0f;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        titleTextSize = 15;
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        titleTextSize = 10;
    }
    
    UILabel *tv_price_title = [[UILabel alloc] init];
    tv_price_title.layoutParams.width = JWLayoutWrapContent;
    tv_price_title.layoutParams.height = JWLayoutWrapContent;
    tv_price_title.layoutParams.alignment = JWLayoutAlignParentLeft;
    tv_price_title.layoutParams.marginLeft = [MesherModel uiWidthBy:170.0f];
    tv_price_title.text = @"价格:￥";
    tv_price_title.labelTextSize = titleTextSize;
    [lo_price addSubview:tv_price_title];
    
    tv_price = [[UILabel alloc] init];
    tv_price.textColor = [UIColor colorWithARGB:R_color_product_price];
    tv_price.labelTextSize = titleTextSize;
    tv_price.layoutParams.width = JWLayoutWrapContent;
    tv_price.layoutParams.height = JWLayoutWrapContent;
    tv_price.layoutParams.alignment = JWLayoutAlignCenterHorizontal;
    tv_price.layoutParams.rightOf = tv_price_title;
    [lo_price addSubview:tv_price];
    
#pragma mark 选项按钮的容器
    JWRelativeLayout *lo_option = [JWRelativeLayout layout];
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        lo_option.layoutParams.height = [MesherModel uiHeightBy:80.0f];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        lo_option.layoutParams.height = [MesherModel uiHeightBy:100.0f];
    }
    lo_option.layoutParams.width = JWLayoutMatchParent;
    //lo_option.orientation = JWLayoutOrientationHorizontal;
    lo_option.layoutParams.marginTop = [MesherModel uiHeightBy:40.0f];
    //lo_option.backgroundColor = [UIColor redColor];
    [lo_menu_edit_linear addSubview:lo_option];
    
    CGFloat textsize = 0;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        textsize = 15.0f;
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        textsize = 10.0f;
    }
    
    btn_change_color = [[UIButton alloc] init];
    btn_change_color.tag = R_id_btn_change_color;
    btn_change_color.layoutParams.width = [MesherModel uiWidthBy:150.0f];
    btn_change_color.layoutParams.height = JWLayoutMatchParent;
    btn_change_color.layoutParams.alignment = JWLayoutAlignParentLeft;
    btn_change_color.layoutParams.marginLeft = [MesherModel uiWidthBy:20.0f];
    [btn_change_color setTitle:@"颜 色" forState:UIControlStateNormal];
    [btn_change_color setTitle:@"颜 色" forState:UIControlStateSelected];
    [btn_change_color setTitleColor:[UIColor colorWithARGB:R_color_option_info_n] forState:UIControlStateNormal];
    [btn_change_color setTitleColor:[UIColor colorWithARGB:R_color_option_info_p] forState:UIControlStateSelected];
    [btn_change_color setButtonTextSize:textsize];
    [btn_change_color setBackgroundImage:[UIImage imageByResourceDrawable:@"btn_style_n"] forState:UIControlStateNormal];
    [btn_change_color setBackgroundImage:[UIImage imageByResourceDrawable:@"btn_style_p"] forState:UIControlStateSelected];
    [lo_option addSubview:btn_change_color];
    [self.viewEventBinder bindEventsToView:btn_change_color willBindSubviews:NO andFilter:nil];
    
    btn_description = [[UIButton alloc] init];
    btn_description.tag = R_id_btn_description;
    btn_description.layoutParams.width = [MesherModel uiWidthBy:150.0f];
    btn_description.layoutParams.height = JWLayoutMatchParent;
    btn_description.layoutParams.rightOf = btn_change_color;
    [btn_description setTitle:@"详 情" forState:UIControlStateNormal];
    [btn_description setTitle:@"详 情" forState:UIControlStateSelected];
    [btn_description setTitleColor:[UIColor colorWithARGB:R_color_option_info_n] forState:UIControlStateNormal];
    [btn_description setTitleColor:[UIColor colorWithARGB:R_color_option_info_p] forState:UIControlStateSelected];
    [btn_description setButtonTextSize:textsize];
    [btn_description setBackgroundImage:[UIImage imageByResourceDrawable:@"btn_description_n"] forState:UIControlStateNormal];
    [btn_description setBackgroundImage:[UIImage imageByResourceDrawable:@"btn_description_p"] forState:UIControlStateSelected];
    [lo_option addSubview:btn_description];
    [self.viewEventBinder bindEventsToView:btn_description willBindSubviews:NO andFilter:nil];
    
//    btn_tools = [[UIButton alloc] init];
//    btn_tools.tag = R_id_btn_tools;
//    btn_tools.layoutParams.width = [MesherModel uiWidthBy:150.0f];
//    btn_tools.layoutParams.height = JWLayoutMatchParent;
//    btn_tools.layoutParams.rightOf = btn_description;
//    [btn_tools setTitle:@"工 具" forState:UIControlStateNormal];
//    [btn_tools setTitle:@"工 具" forState:UIControlStateSelected];
//    [btn_tools setTitleColor:[UIColor colorWithARGB:R_color_option_info_n] forState:UIControlStateNormal];
//    [btn_tools setTitleColor:[UIColor colorWithARGB:R_color_option_info_p] forState:UIControlStateSelected];
//    [btn_tools setButtonTextSize:textsize];
//    [btn_tools setBackgroundImage:[UIImage imageByResourceDrawable:@"btn_description_n"] forState:UIControlStateNormal];
//    [btn_tools setBackgroundImage:[UIImage imageByResourceDrawable:@"btn_description_p"] forState:UIControlStateSelected];
//    [lo_option addSubview:btn_tools];
//    [self.viewEventBinder bindEventsToView:btn_tools willBindSubviews:NO andFilter:nil];
    
    rg_option = [JWRadioViewGroup group];
    [rg_option addView:btn_change_color];
    [rg_option addView:btn_description];
//    [rg_option addView:btn_tools];
    rg_option.onChecked = (^(BOOL checked, NSUInteger index, UIView* view){
        UIButton *button = (UIButton*)view; // view是button类型的  强转
        [button setSelected:checked]; // 把button状态设为选中状态
    });
    rg_option.checkedView = btn_change_color; // 初始角度在颜色按钮上
    
    lo_button1_line1 = [JWRelativeLayout layout];
    lo_button1_line1.layoutParams.width = [MesherModel uiWidthBy:358.0f];
    lo_button1_line1.layoutParams.height = 1;
    lo_button1_line1.layoutParams.alignment = JWLayoutAlignParentBottomRight;
    lo_button1_line1.backgroundColor = [UIColor colorWithARGB:R_color_option_line];
    [lo_option addSubview:lo_button1_line1];
    
    lo_button2_line1 = [JWRelativeLayout layout];
    lo_button2_line1.layoutParams.width = [MesherModel uiWidthBy:152.0f];
    lo_button2_line1.layoutParams.height = 1;
    lo_button2_line1.layoutParams.alignment = JWLayoutAlignParentBottomLeft;
    lo_button2_line1.layoutParams.marginLeft = [MesherModel uiWidthBy:20.0f];
    lo_button2_line1.backgroundColor = [UIColor colorWithARGB:R_color_option_line];
    [lo_option addSubview:lo_button2_line1];
    lo_button2_line1.hidden = YES;
    lo_button2_line2 = [JWRelativeLayout layout];
    lo_button2_line2.layoutParams.width = [MesherModel uiWidthBy:205.0f];
    lo_button2_line2.layoutParams.height = 1;
    lo_button2_line2.layoutParams.alignment = JWLayoutAlignParentBottomRight;
    lo_button2_line2.backgroundColor = [UIColor colorWithARGB:R_color_option_line];
    [lo_option addSubview:lo_button2_line2];
    lo_button2_line2.hidden = YES;
    
//    lo_button3_line1 = [JWRelativeLayout layout];
//    lo_button3_line1.layoutParams.width = [MesherModel uiWidthBy:303.0f];
//    lo_button3_line1.layoutParams.height = 1;
//    lo_button3_line1.layoutParams.alignment = JWLayoutAlignParentBottomLeft;
//    lo_button3_line1.layoutParams.marginLeft = [MesherModel uiWidthBy:20.0f];
//    lo_button3_line1.backgroundColor = [UIColor colorWithARGB:R_color_option_line];
//    [lo_option addSubview:lo_button3_line1];
//    lo_button3_line1.hidden = YES;

#pragma mark 物件的款式
    lo_style = [JWRelativeLayout layout];
    lo_style.layoutParams.width = JWLayoutMatchParent;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        lo_style.layoutParams.height = [MesherModel uiHeightBy:830.0f];
        //lo_style.layoutParams.marginBottom = [MesherModel uiHeightBy:130.0f];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        lo_style.layoutParams.height = [MesherModel uiHeightBy:680.0f];
        //lo_style.layoutParams.marginBottom = [MesherModel uiHeightBy:110.0f];
    }
    //lo_style.backgroundColor = [UIColor redColor];
    lo_style.layoutParams.alignment = JWLayoutAlignParentBottom | JWLayoutAlignCenterHorizontal;
    [lo_item_edit addSubview:lo_style];
    
    cv_style = [JWCollectionView collectionView];
    cv_style.layoutParams.width = [MesherModel uiWidthBy:480.0f];
    cv_style.layoutParams.height = JWLayoutMatchParent;
    cv_style.layoutParams.marginLeft = [MesherModel uiWidthBy:30.0f];
    //gv_style.layoutParams.alignment = JWLayoutAlignCenterHorizontal;
    cv_style.numColumns = 3;
    cv_style.backgroundColor = [UIColor whiteColor];
    [lo_style addSubview:cv_style];
    mStyleListAdapter = [[StyleListAdapter alloc] init];
    cv_style.adapter = mStyleListAdapter;
    cv_style.alwaysBounceVertical = NO;
    cv_style.showsHorizontalScrollIndicator = NO;
    cv_style.showsVerticalScrollIndicator = NO;
    
#pragma mark 物件的描述
    lo_description = [JWRelativeLayout layout];
    lo_description.layoutParams.width = JWLayoutMatchParent;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        lo_description.layoutParams.height = [MesherModel uiHeightBy:830.0f];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        lo_description.layoutParams.height = [MesherModel uiHeightBy:680.0f];
    }
    lo_description.layoutParams.alignment = JWLayoutAlignParentBottom | JWLayoutAlignCenterHorizontal;
    lo_description.hidden = YES;
    [lo_item_edit addSubview:lo_description];
    
    wv_description = [[UIWebView alloc] init];
    wv_description.layoutParams.width = [MesherModel uiWidthBy:500.0f];
    wv_description.layoutParams.height = JWLayoutMatchParent;
    wv_description.layoutParams.alignment = JWLayoutAlignParentBottomRight;
    [lo_description addSubview:wv_description];
    
#pragma mark 物件上的UI
    lo_object_menu_container = (JWFrameLayout*)[parent viewWithTag:R_id_lo_control];
    lo_object_menu_container.hidden = NO;
    lo_object_menu = [JWLinearLayout layout];
    lo_object_menu.layoutParams.width = JWLayoutWrapContent;
    lo_object_menu.layoutParams.height = JWLayoutWrapContent;
    lo_object_menu.orientation = JWLayoutOrientationHorizontal;
    [lo_object_menu_container addSubview:lo_object_menu];
    
#pragma mark 物件上的按钮
    UIImage *btn_delete_n = [UIImage imageByResourceDrawable:@"btn_delete_n"];
    UIImage *btn_delete_p = [UIImage imageByResourceDrawable:@"btn_delete_p"];
    btn_delete = [[UIButton alloc] initWithImage:btn_delete_n highlightedImage:btn_delete_p];
    btn_delete.tag = R_id_btn_delete;
    btn_delete.layoutParams.width = JWLayoutWrapContent;
    btn_delete.layoutParams.height = JWLayoutWrapContent;
    btn_delete.layoutParams.marginLeft = 2;
    [lo_object_menu addSubview:btn_delete];
    
//    UIImage *btn_left_n = [UIImage imageByResourceDrawable:@"btn_left_n"];
//    UIImage *btn_left_p = [UIImage imageByResourceDrawable:@"btn_left_p"];
//    btn_left = [[UIButton alloc] initWithImage:btn_left_n highlightedImage:btn_left_p];
//    btn_left.tag = R_id_btn_left;
//    btn_left.layoutParams.width = JWLayoutWrapContent;
//    btn_left.layoutParams.height = JWLayoutWrapContent;
//    btn_left.layoutParams.marginLeft = 2;
//    [lo_object_menu addSubview:btn_left];
//
//    UIImage *btn_right_n = [UIImage imageByResourceDrawable:@"btn_right_n"];
//    UIImage *btn_right_p = [UIImage imageByResourceDrawable:@"btn_right_p"];
//    btn_right = [[UIButton alloc] initWithImage:btn_right_n highlightedImage:btn_right_p];
//    btn_right.tag = R_id_btn_right;
//    btn_right.layoutParams.width = JWLayoutWrapContent;
//    btn_right.layoutParams.height = JWLayoutWrapContent;
//    btn_right.layoutParams.marginLeft = 2;
//    [lo_object_menu addSubview:btn_right];
    
    UIImage *btn_link_n = [UIImage imageByResourceDrawable:@"btn_link_n"];
    UIImage *btn_link_p = [UIImage imageByResourceDrawable:@"btn_link_p"];
    btn_link = [[UIButton alloc] initWithImage:btn_link_n highlightedImage:btn_link_p];
    btn_link.tag = R_id_btn_link;
    btn_link.layoutParams.width = JWLayoutWrapContent;
    btn_link.layoutParams.height = JWLayoutWrapContent;
    btn_link.layoutParams.marginLeft = 2;
    [lo_object_menu addSubview:btn_link];
    
    JWFrameLayout *lo_rotate_degree = [JWFrameLayout layout];
    lo_rotate_degree.layoutParams.width = JWLayoutWrapContent;
    lo_rotate_degree.layoutParams.height = JWLayoutWrapContent;
    lo_rotate_degree.layoutParams.marginLeft = 2;
    [lo_object_menu addSubview:lo_rotate_degree];
    
    UIImage *btn_AR_n = [UIImage imageByResourceDrawable:@"btn_AR_n"];
    UIImage *btn_AR_p = [UIImage imageByResourceDrawable:@"btn_AR_p"];
    btn_AR = [[UIButton alloc] initWithImage:btn_AR_n highlightedImage:btn_AR_p];
    btn_AR.tag = R_id_btn_AR;
    btn_AR.layoutParams.width = JWLayoutWrapContent;
    btn_AR.layoutParams.height = JWLayoutWrapContent;
//    btn_AR.layoutParams.marginLeft = 2;
    [lo_rotate_degree addSubview:btn_AR];
    
    lv_degree = [[UILabel alloc] init];
    lv_degree.backgroundColor = [UIColor clearColor];
    lv_degree.textColor = [UIColor whiteColor];
    lv_degree.labelTextSize = 10;
    lv_degree.shadowOffset = CGSizeMake(1, 1);
    lv_degree.shadowColor = [UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:1];
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        lv_degree.layoutParams.width = [self uiWidthBy:80.0f];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        lv_degree.layoutParams.width = [self uiWidthBy:110.0f];
    }
    lv_degree.layoutParams.height = JWLayoutWrapContent;
    lv_degree.layoutParams.alignment = JWLayoutAlignCenterInParent;
    [lo_rotate_degree addSubview:lv_degree];
    
    UIImage *btn_rotate_n = [UIImage imageByResourceDrawable:@"btn_rotate_n"];
    btn_rotate = [[UIButton alloc] initWithImage:btn_rotate_n highlightedImage:btn_rotate_n];
    btn_rotate.tag = R_id_btn_rotate;
    btn_rotate.layoutParams.width = JWLayoutWrapContent;
    btn_rotate.layoutParams.height = JWLayoutWrapContent;
    btn_rotate.layoutParams.marginLeft = 2;
    [lo_object_menu addSubview:btn_rotate];
    [self.viewEventBinder bindEventsToView:btn_rotate willBindSubviews:NO andFilter:nil];
    
    UIImage *btn_tools_n = [UIImage imageByResourceDrawable:@"btn_tools_n"];
    btn_tools = [[UIButton alloc] initWithImage:btn_tools_n highlightedImage:btn_tools_n];
    btn_tools.tag = R_id_btn_tools;
    btn_tools.layoutParams.width = JWLayoutWrapContent;
    btn_tools.layoutParams.height = JWLayoutWrapContent;
    btn_tools.layoutParams.marginLeft = 2;
    [lo_object_menu addSubview:btn_tools];
    [self.viewEventBinder bindEventsToView:btn_tools willBindSubviews:NO andFilter:nil];
    
#pragma mark 物件边框 初始化
    id<JIFile> file = [JWFile fileWithBundle:[NSBundle mainBundle] path:[JWResourceBundle nameForDrawable:@"item_rect_frame.png"]];
//    mItemRectFrameDecals = [[JWRectFrameDecals alloc] initWithContext:mModel.currentContext parent:mModel.currentScene.root InnerWidth:1.0f innerHeight:1.0f thickness:0.1f uvThickness:0.346f decalsFile:file];
//    [mItemRectFrameDecals.decalsObject.transform translateX:0.0f Y:0.01f Z:0.0f];
    mItemRectFrameDecals = [[JWRect4CornersDecals alloc] initWithContext:mModel.currentContext parent:mModel.currentScene.root innerWidth:1.0f innerHeight:1.0f cornerOffsetX:0.15f cornerOffsetY:0.15f thickness:0.06f cornerOffsetU:0.0f cornerOffsetV:0.0f uvThickness:0.346f decalsFile:file];
    mItemRectFrameDecals.decalsObject.visible = NO;
    mItemRectFrameDecals.decalsObject.queryMask = SelectedMaskCannotSelect;
    [mItemRectFrameDecals.decalsObject.transform setInheritScale:NO];
    mItemRectFrameDecals.decalsObject.inheritStretch = NO;
    mModel.itemRectFrameDecals = mItemRectFrameDecals;
    
    // 按钮动作
    btn_back.userInteractionEnabled = YES;
    [self.gestureEventBinder bindEventsWithType:JWGestureTypeSingleTap toView:btn_back willBindSubviews:NO andFilter:nil];
    
//    btn_left.userInteractionEnabled = YES;
//    [self.viewEventBinder bindEventsToView:btn_left willBindSubviews:NO andFilter:nil];
//    [self.gestureEventBinder bindEventsWithType:JWGestureTypeSingleTap toView:btn_left willBindSubviews:NO andFilter:nil];
//    [self.gestureEventBinder bindEventsWithType:JWGestureTypeLongPress toView:btn_left willBindSubviews:NO andFilter:nil];
//    [self.viewEventBinder bindEventsToView:btn_left willBindSubviews:NO andFilter:nil];
    
//    btn_right.userInteractionEnabled = YES;
//    [self.viewEventBinder bindEventsToView:btn_right willBindSubviews:NO andFilter:nil];
//    [self.gestureEventBinder bindEventsWithType:JWGestureTypeSingleTap toView:btn_right willBindSubviews:NO andFilter:nil];
//    [self.gestureEventBinder bindEventsWithType:JWGestureTypeLongPress toView:btn_right willBindSubviews:NO andFilter:nil];
    
    btn_delete.userInteractionEnabled = YES;
    [self.viewEventBinder bindEventsToView:btn_delete willBindSubviews:NO andFilter:nil];
    
    btn_link.userInteractionEnabled = YES;
    [self.viewEventBinder bindEventsToView:btn_link willBindSubviews:NO andFilter:nil];
    
    btn_AR.userInteractionEnabled = YES;
    [self.viewEventBinder bindEventsToView:btn_AR willBindSubviews:NO andFilter:nil];
    
    btn_undo = (UIImageView*)[parent viewWithTag:R_id_btn_undo];
    btn_redo = (UIImageView*)[parent viewWithTag:R_id_btn_redo];
    
//    UITapGestureRecognizer* singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
//    singleTapGestureRecognizer.numberOfTapsRequired = 1;
//    singleTapGestureRecognizer.delegate = self;
//    [btn_left addGestureRecognizer:singleTapGestureRecognizer];
//    [btn_right addGestureRecognizer:singleTapGestureRecognizer];
    
    UILongPressGestureRecognizer* longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    longPressGestureRecognizer.minimumPressDuration = 0.5f;
    longPressGestureRecognizer.delegate = self;
    [btn_left addGestureRecognizer:longPressGestureRecognizer];
    [btn_right addGestureRecognizer:longPressGestureRecognizer];
    
//    [singleTapGestureRecognizer requireGestureRecognizerToFail:longPressGestureRecognizer];
    
    return lo_item_edit;
}

//进入状态的前置条件
- (BOOL)onPreCondition {
    id<JIGameObject> itemObject = mModel.selectedObject;
    Item* currentItem = [Data getItemFromInstance:itemObject];
    if(currentItem == nil) {
        return NO;
    }
    return YES;
}

- (void) updateCurrentItemInfoUI {
    Item* currentItem = [Data getItemFromInstance:mModel.selectedObject];
    if(currentItem == nil) {
        lo_item_edit.hidden = YES;
        return;
    }
    
    mStyleListAdapter.data = currentItem.product.items;
    [mStyleListAdapter notifyDataSetChanged];
    
    
    NSString *description = currentItem.product.description;
    if (description != nil) {
        [wv_description loadHTMLString:description baseURL:nil];
    }
// 判断一个字符串是一个有效的网址
//    NSRange range = [description rangeOfString:@"^\[a-zA-z]+://(\\w+(-\\w+)*)(\\.(\\w+(-\\w+)*))*(\\?\\S*)?$" options:NSRegularExpressionSearch];
//    if (range.location != NSNotFound){
//        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:mModel.currentProduct.description]];
//        [wv_description loadRequest:request];
//    }else {
//        [wv_description loadHTMLString:description baseURL:nil];
//    }
    
    lo_item_edit.hidden = NO;
    tv_name.text = currentItem.product == nil ? currentItem.name : currentItem.product.name;
    NSString *price = [NSString stringWithFormat:@"%.2f",currentItem.price];
    tv_price.text = price;
    if (currentItem.preview != nil){
        [[JWCorePluginSystem instance].imageCache getBy:currentItem.previewBig options:opt_img_image async:YES onGet:^(UIImage *image) {
            img_image.image = image;
        }];
    }
}

- (void)showRectFrameToItem:(id<JIGameObject>)object {
    // 物件点中边栏逻辑
    if (object == nil) {
        mItemRectFrameDecals.decalsObject.parent = mModel.currentScene.root;
        mItemRectFrameDecals.decalsObject.visible = NO;
    } else {
        Item *item = [Data getItemFromInstance:object];
//        JCBounds3 objectBounds = object.scaleBounds;
        JCBounds3 objectBounds = object.scaleBoundsByStretch;
        JCVector3 objectSize = JCBounds3GetSize(&objectBounds);
        if (item.product.position == PositionGround || item.product.position == PositionOnItem || item.product.position == PositionInWall) {
            [mItemRectFrameDecals updateInnerWidth:objectSize.x innerHeight:objectSize.z];
            [mItemRectFrameDecals.decalsObject.transform reset:NO];
            mItemRectFrameDecals.decalsObject.parent = object;
            [mItemRectFrameDecals.decalsObject.transform translate:JCVector3Make(0.0f, 0.025f, 0.0f)]; // 防止z-fighting
        } else if (item.product.position == PositionOnWall) {
            [mItemRectFrameDecals updateInnerWidth:objectSize.x innerHeight:objectSize.y];
            [mItemRectFrameDecals.decalsObject.transform reset:NO];
            mItemRectFrameDecals.decalsObject.parent = object;
            [mItemRectFrameDecals.decalsObject.transform rotateDegrees:-90 byAxis:JCVector3Make(1, 0, 0)];
            [mItemRectFrameDecals.decalsObject.transform translate:JCVector3Make(0.0f, objectSize.y * 0.5f, 0.0f)]; // 防止z-fighting
        } else if (item.product.position == PositionTop) {
            [mItemRectFrameDecals updateInnerWidth:objectSize.x innerHeight:objectSize.z];
            [mItemRectFrameDecals.decalsObject.transform reset:NO];
            mItemRectFrameDecals.decalsObject.parent = object;
            [mItemRectFrameDecals.decalsObject.transform rotateDegrees:180.0 byAxis:JCVector3Make(0, 0, 1)];
            [mItemRectFrameDecals.decalsObject.transform translate:JCVector3Make(0.0f, objectSize.y - 0.08f, 0.0f)]; // 防止z-fighting
        }
        mItemRectFrameDecals.decalsObject.visible = YES;
    }
}

- (void)onStateEnter:(NSDictionary *)data{
    [super onStateEnter:data];
    
    if ([[self.subMachine getNameOfState:self.subMachine.currentState] isEqualToString:[States ItemTools]]) {
        [self.subMachine revertState];
    }
    lv_degree.visible = NO;
    timeIndex = 0;
    [self updateUndoRedoState];
    lo_style.hidden = NO;
    lo_description.hidden = YES;
    rg_option.checkedView = btn_change_color;
    lo_button1_line1.hidden = NO;
    lo_button2_line1.hidden = YES;
    lo_button2_line2.hidden = YES;
    
    tempObject = mModel.selectedObject;
    
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        [btn_change_color setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [btn_description setTitleEdgeInsets:UIEdgeInsetsMake(10, 0, 0, 0)];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        [btn_change_color setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [btn_description setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    }
    
    [self updateCurrentItemInfoUI];// 为右边的menu赋值
    [self showRectFrameToItem:mModel.selectedObject];
    
    ItemEdit* weakSelf = self;
    // 物件菜单跟随物件移动组件
    if (mItemEditMenu == nil) {
        mItemEditMenu = [mModel.currentContext createViewTag];
        mItemEditMenu.view = lo_object_menu;
        mItemEditMenu.viewOffset = CGPointMake(-50, -120);
        mItemEditMenu.onChange = (^CGPoint (CGPoint position) {
            edit_pointX = lo_item_edit.frame.origin.x;
            weakSelf.mObject_menu_width = btn_link.frame.size.width * 5;
            float x = edit_pointX - weakSelf.mObject_menu_width - 20;
            float y = 20.0f;
            float minX = lo_item_edit.frame.size.width/6;
            if (position.x > x) {
                position.x = x;
            }
            if (position.y < y) {
                position.y = y;
            }
            if (position.x < minX) {
                position.x = minX;
            }
            return position;
        });
    }
    [mModel.selectedObject addComponent:mItemEditMenu]; // 将edit菜单加到选中的对象上

#pragma mark 选中逻辑
    __block id<IMesherModel> model = mModel;
    id<JIViewTag> itemEditMenu = mItemEditMenu;
//    ItemEdit *weakSelf = self;
    // 执行物件移动的逻辑
    mModel.itemSelectAndMoveBehaviour.selectedMask = SelectedMaskAllItems | SelectedMaskAllArchs;
    mModel.itemSelectAndMoveBehaviour.onSelect = (^(id<JIGameObject> object) {

#pragma mark 设置点击任何物件都返回之前的状态 防止多余的误操作
        if (!weakSelf.mIsRotated) {
//            if ([[weakSelf.subMachine getNameOfState:weakSelf.subMachine.currentState] isEqualToString:[States ItemTools]]) {
//                [weakSelf.subMachine revertState];
//            }
            [model.preSelectedObject removeComponent:itemEditMenu]; // 先取下之前对象的edit菜单
            //model.photographer.cameraEnabled = YES; // 开启相机视角
            [weakSelf showRectFrameToItem:object];
            [weakSelf updateUndoRedoState];
            [weakSelf.parentMachine revertState];
        }
        
//        itemEditMenu.visible = YES; // 显示菜单
//        ItemInfo *it = [Data getItemInfoFromInstance:object];
//        if (object == nil) { // 如果没有点中物件
//            [model.preSelectedObject removeComponent:itemEditMenu]; // 先取下之前对象的edit菜单
//            //model.photographer.cameraEnabled = YES; // 开启相机视角
//#pragma mark bug01解决
//            [weakSelf showRectFrameToItem:object];
//            [weakSelf updateUndoRedoState];
//#pragma mark bug01描述1. 这里转换为PlanEditInit状态，onSelect被修改为PlanEditInit里面的block，转bug01描述2
//            [weakSelf.parentMachine revertState];
//        }else if (object != nil && it.type == ItemTypeItem){
//            model.photographer.cameraEnabled = NO;// 有点中物件的情况下关闭相机视角 以编辑物件
//            if (model.preSelectedObject != object) { // 如果点中的对象不是之前的物件对象
//                [model.preSelectedObject removeComponent:itemEditMenu]; // 先取下之前对象的edit菜单
//                [object addComponent:itemEditMenu]; // 再给点中的对象加上edit菜单
//                [weakSelf updateCurrentItemInfoUI];// 更新右边menu内容 以点中的对象为准
//                [weakSelf updateUndoRedoState];
//#pragma mark bug01解决
//                [weakSelf showRectFrameToItem:object];
//            }
//        }else if (object != nil && it.type != ItemTypeItem) {
//            [model.preSelectedObject removeComponent:itemEditMenu];
//            [weakSelf showRectFrameToItem:nil];
//            model.borderObject = object;
//            [weakSelf.parentMachine changeStateTo:[States ArchitureEdit] pushState:NO];
//        }
//#pragma mark bug01描述2. 由于revertState已经修改onSelect，但此block尚未执行完，故执行以下代码会出错，转bug01解决
//        //[this showRectFrameToItem:object];
    });
    mModel.itemSelectAndMoveBehaviour.canMove = YES; // 在ItemEdit状态下 物件是可以移动的
    mModel.itemSelectAndMoveBehaviour.onItemEndMove = ^(CGPoint positionInView){
        [model.currentPlan showOverlap];
    };

    mModel.photographer.cameraEnabled = NO;
    
    lo_object_menu_container.hidden = NO;
}

//离开状态时
- (void)onStateLeave{
    [rotate_timer_left invalidate];
    [rotate_timer_right invalidate];
    lo_object_menu_container.hidden = YES;
    [self showRectFrameToItem:nil];
    [mModel.selectedObject removeComponent:mItemEditMenu]; // 离开状态时 把edit菜单从绑定的对象上取下 以便之后进入重新绑定
    mModel.itemSelectAndMoveBehaviour.onSelect = nil;
    [super onStateLeave];
}

- (void)onSingleTap:(UITapGestureRecognizer *)singleTap{
    switch (singleTap.view.tag) {
        case R_id_btn_back: {
//            if ([[self.subMachine getNameOfState:self.subMachine.currentState] isEqualToString:[States ItemTools]]) {
//                [self.subMachine revertState];
//            }
            [self.parentMachine revertState];
            break;
        }
        case R_id_btn_left: {
            if ([[self.subMachine getNameOfState:self.subMachine.currentState] isEqualToString:[States ItemTools]]) {
                [self.subMachine revertState];
            }
            btn_undo.image = [UIImage imageByResourceDrawable:@"btn_undo_n.png"];
            ItemRotateCommand* command = [[ItemRotateCommand alloc] init];
            command.object = mModel.selectedObject;
            command.angle = 45.0f;
            [mModel.commandMachine todoCommand:command];
            [self updateUndoRedoState];
            mModel.currentPlan.sceneDirty = YES;
            [mModel.currentPlan showOverlap];
            break;
        }
        case R_id_btn_right: {
            if ([[self.subMachine getNameOfState:self.subMachine.currentState] isEqualToString:[States ItemTools]]) {
                [self.subMachine revertState];
            }
            btn_undo.image = [UIImage imageByResourceDrawable:@"btn_undo_n.png"];
            //逆时针45度
            ItemRotateCommand* command = [[ItemRotateCommand alloc] init];
            command.object = mModel.selectedObject;
            command.angle = -45.0f;
            [mModel.commandMachine todoCommand:command];
            [self updateUndoRedoState];
            mModel.currentPlan.sceneDirty = YES;
            [mModel.currentPlan showOverlap];
            break;
        }
        default:
            break;
    }
}

- (BOOL)onTouchDown:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    switch (touch.view.tag) {
        case R_id_btn_rotate: {
//            if ([[self.subMachine getNameOfState:self.subMachine.currentState] isEqualToString:[States ItemTools]]) {
//                [self.subMachine revertState];
//            }
            isRotated = YES;
            btn_link.alpha = 0.0f;
            btn_AR.alpha = 0.0f;
            btn_delete.alpha = 0.0f;
            btn_tools.alpha = 0.0f;
            lv_degree.visible = YES;
            CGFloat degree = mModel.selectedObject.transform.yawing;
            lv_degree.text = [NSString stringWithFormat:@"%.1f°",degree];
            angle = 0.0f;
            break;
        }
    }
    return YES;
}

- (BOOL)onTouchMove:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    switch (touch.view.tag) {
        case R_id_btn_rotate: {
            if ([mModel.selectedObject isEqual:tempObject]) {
                CGPoint du = touch.deltaPosition;
                angle += (du.x+du.y)/2;
                NSLog(@"angle:%f",angle);
                [mModel.selectedObject.transform rotateUpDegrees:(du.x+du.y)/2];
                CGFloat degree = mModel.selectedObject.transform.yawing;
                lv_degree.text = [NSString stringWithFormat:@"%.1f°",degree];
            }
            break;
        }
    }
    
    return YES;
}

- (BOOL)onTouchUp:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    switch (touch.view.tag) {
        case R_id_btn_change_color: {
            rg_option.checkedView = touch.view;
            if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
                [btn_change_color setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
                [btn_description setTitleEdgeInsets:UIEdgeInsetsMake(10, 0, 0, 0)];
//                [btn_tools setTitleEdgeInsets:UIEdgeInsetsMake(10, 0, 0, 0)];
            }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
                [btn_change_color setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
                [btn_description setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
//                [btn_tools setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
            }
            lo_button1_line1.hidden = NO;
            lo_button2_line1.hidden = YES;
            lo_button2_line2.hidden = YES;
//            lo_button3_line1.hidden = YES;
            lo_description.hidden = YES;
            lo_style.hidden = NO;
            break;
        }
        case R_id_btn_description: {
            rg_option.checkedView = touch.view;
            if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
                [btn_change_color setTitleEdgeInsets:UIEdgeInsetsMake(10, 0, 0, 0)];
                [btn_description setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//                [btn_tools setTitleEdgeInsets:UIEdgeInsetsMake(10, 0, 0, 0)];
            }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
                [btn_change_color setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
                [btn_description setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//                [btn_tools setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
            }
            lo_button1_line1.hidden = YES;
            lo_button2_line1.hidden = NO;
            lo_button2_line2.hidden = NO;
//            lo_button3_line1.hidden = YES;
            lo_description.hidden = NO;
            lo_style.hidden = YES;
            break;
        }
        case R_id_btn_tools: {
//            rg_option.checkedView = touch.view;
//            if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
//                [btn_change_color setTitleEdgeInsets:UIEdgeInsetsMake(10, 0, 0, 0)];
//                [btn_description setTitleEdgeInsets:UIEdgeInsetsMake(10, 0, 0, 0)];
//                [btn_tools setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//            }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
//                [btn_change_color setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
//                [btn_description setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
//                [btn_tools setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//            }
//            lo_button1_line1.hidden = YES;
//            lo_button2_line1.hidden = YES;
//            lo_button2_line2.hidden = YES;
//            lo_button3_line1.hidden = NO;
//            lo_description.hidden = YES;
//            lo_style.hidden = YES;
            [self.parentMachine changeStateTo:[States ItemTools] pushState:NO];
            break;
        }
        case R_id_btn_delete: {
//            if ([[self.subMachine getNameOfState:self.subMachine.currentState] isEqualToString:[States ItemTools]]) {
//                [self.subMachine revertState];
//            }
            [mModel.selectedObject removeComponent:mItemEditMenu]; // 删除GameObject之前先把ViewTag移除，以免同时删除ViewTag
            ItemDeleteCommand *command = [[ItemDeleteCommand alloc] init];
            command.object = mModel.selectedObject;
            command.plan = mModel.currentPlan;
            [mModel.commandMachine todoCommand:command];
            //[mModel.plan destroyObject:mModel.selectedObject];
            mModel.selectedObject = nil;
            mModel.preSelectedObject = nil;
            mItemRectFrameDecals.decalsObject.parent = mModel.currentScene.root;
            mItemRectFrameDecals.decalsObject.visible = NO;
            [mModel.currentPlan showOverlap];
            [self updateUndoRedoState];
            [self.parentMachine revertState];
            break;
        }
        case R_id_btn_link: {
//            if ([[self.subMachine getNameOfState:self.subMachine.currentState] isEqualToString:[States ItemTools]]) {
//                [self.subMachine revertState];
//            }
            [self.parentMachine changeStateTo:[States ItemLink]];
            break;
        }
        case R_id_btn_AR: {
//            if ([[self.subMachine getNameOfState:self.subMachine.currentState] isEqualToString:[States ItemTools]]) {
//                [self.subMachine revertState];
//            }
            mModel.currentPlan.fromAR = YES;
            [self.parentState.parentMachine changeStateTo:[States ItemAR]];
            break;
        }
        case R_id_btn_rotate: {
            isRotated = NO;
            btn_link.alpha = 1.0f;
            btn_AR.alpha = 1.0f;
            btn_delete.alpha = 1.0f;
            btn_tools.alpha = 1.0f;
            lv_degree.visible = NO;
            lv_degree.text = nil;
            ItemRotateCommand* command = [[ItemRotateCommand alloc] init];
            command.object = tempObject;
            command.angle = angle;
            [mModel.commandMachine doneCommand:command];
            [self updateUndoRedoState];
            mModel.currentPlan.sceneDirty = YES;
            angle = 0.0f;
            [mModel.currentPlan showOverlap];
            break;
        }
        default:
            break;
    }
    return YES;
}

- (void)onLongPress:(UILongPressGestureRecognizer *)longPress {
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            switch (longPress.view.tag) {
                case R_id_btn_right: {
                    rotate_timer_right = [NSTimer scheduledTimerWithTimeInterval:0.0167f target:self selector:@selector(rotateRight) userInfo:nil repeats:YES];
                    break;
                }
                case R_id_btn_left: {
                    rotate_timer_left = [NSTimer scheduledTimerWithTimeInterval:0.0167f target:self selector:@selector(rotateLeft) userInfo:nil repeats:YES];
                    break;
                }
            }
        }
        case UIGestureRecognizerStateChanged:{
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:{
            ItemLongPressRotateCommand *command = [[ItemLongPressRotateCommand alloc] init];
            command.object = mModel.selectedObject;
            command.angle = timeIndex;
            [mModel.commandMachine doneCommand:command];
            [self updateUndoRedoState];
            mModel.currentPlan.sceneDirty = YES;
            timeIndex = 0;
            [rotate_timer_left invalidate];
            [rotate_timer_right invalidate];
            [mModel.currentPlan showOverlap];
            break;
        }
        default:
            break;
    }
}

- (void)rotateLeft {
    [mModel.selectedObject.transform rotateUpDegrees:1.0f];
    timeIndex = timeIndex + 1;
}

- (void)rotateRight {
    [mModel.selectedObject.transform rotateUpDegrees:-1.0f];
    timeIndex = timeIndex - 1;
}

@end
