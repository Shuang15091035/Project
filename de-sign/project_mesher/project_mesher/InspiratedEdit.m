//
//  InspiratedEdit.m
//  project_mesher
//
//  Created by mac zdszkj on 16/4/6.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "InspiratedEdit.h"
#import "MesherModel.h"
#import "OrderList.h"
#import "GamePhotographer.h"
#import "inspiratedPlan.h"
#import "InspiratedProductList.h"
#import "InspiratedProductInfo.h"
#import "InspiratedItemEdit.h"
#import "InspiratedBehaviour.h"
#import "InspiratedImagePickerController.h"
#import "App.h"
#import <jw/CMDeviceMotion+JWCoreCategory.h>
#import <jw/UIDevice+JWCoreCategory.h>
#import "LocalInspiratedPlanTable.h"
#import "PlanLoader.h"
#import "InspiratedCameraBehaviour.h"

@interface InspiratedEditInit : BaseState {
    JWRelativeLayout *btn_exchange;
    UIImageView *img_exchange;
    UILabel *tv_exchange;
    
    JWRelativeLayout *btn_living_room;
    UIImageView *img_living_room;
    UILabel *tv_living_room;
    
    JWRelativeLayout *btn_bedroom;
    UIImageView *img_bedroom;
    UILabel *tv_bedroom;
    
    JWRelativeLayout *btn_kitchen;
    UIImageView *img_kitchen;
    UILabel *tv_kitchen;
    
    JWRelativeLayout *btn_toilet;
    UIImageView *img_toilet;
    UILabel *tv_toilet;
    
    JWRelativeLayout *btn_order;
    UIImageView *img_order;
    UILabel *tv_order;
    
    UIImageView *btn_homepage;
}

+ (NSString*) StateName;

@end

@implementation InspiratedEditInit

+ (NSString *)StateName {
    return @"InspiratedEditInit";
}

- (UIView *)onCreateView:(UIView *)parent {
    btn_exchange = (JWRelativeLayout*)[parent viewWithTag:R_id_btn_exchange];
    img_exchange = (UIImageView*)[parent viewWithTag:R_id_img_exchange];
    tv_exchange = (UILabel*)[parent viewWithTag:R_id_tv_exchange];
    
    btn_living_room = (JWRelativeLayout*)[parent viewWithTag:R_id_btn_living_room];
    img_living_room = (UIImageView*)[parent viewWithTag:R_id_img_living_room];
    tv_living_room = (UILabel*)[parent viewWithTag:R_id_tv_living_room];
    
    btn_bedroom = (JWRelativeLayout*)[parent viewWithTag:R_id_btn_bedroom];
    img_bedroom = (UIImageView*)[parent viewWithTag:R_id_img_bedroom];
    tv_bedroom = (UILabel*)[parent viewWithTag:R_id_tv_bedroom];
    
    btn_kitchen = (JWRelativeLayout*)[parent viewWithTag:R_id_btn_kitchen];
    img_kitchen = (UIImageView*)[parent viewWithTag:R_id_img_kitchen];
    tv_kitchen = (UILabel*)[parent viewWithTag:R_id_tv_kitchen];
    
    btn_toilet = (JWRelativeLayout*)[parent viewWithTag:R_id_btn_toilet];
    img_toilet = (UIImageView*)[parent viewWithTag:R_id_img_toilet];
    tv_toilet = (UILabel*)[parent viewWithTag:R_id_tv_toilet];
    
    btn_order = (JWRelativeLayout*)[parent viewWithTag:R_id_btn_order];
    img_order = (UIImageView*)[parent viewWithTag:R_id_img_order];
    tv_order = (UILabel*)[parent viewWithTag:R_id_tv_order];
    
    btn_homepage = (UIImageView*)[parent viewWithTag:R_id_btn_homepage];
    btn_homepage.userInteractionEnabled = YES;
    btn_undo = (UIImageView*)[parent viewWithTag:R_id_btn_undo];
    btn_undo.userInteractionEnabled = YES;
    btn_redo = (UIImageView*)[parent viewWithTag:R_id_btn_redo];
    btn_redo.userInteractionEnabled = YES;
    
    return parent;
}

- (void)onStateEnter:(NSDictionary *)data {
    [super onStateEnter:data];
    btn_exchange.backgroundColor = [UIColor clearColor];
    img_exchange.image = [UIImage imageByResourceDrawable:@"btn_exchange_n.png"];
    tv_exchange.textColor = [UIColor whiteColor];
    
    btn_living_room.backgroundColor = [UIColor clearColor];
    img_living_room.image = [UIImage imageByResourceDrawable:@"btn_living_room_n.png"];
    tv_living_room.textColor = [UIColor whiteColor];
    
    btn_bedroom.backgroundColor = [UIColor clearColor];
    img_bedroom.image = [UIImage imageByResourceDrawable:@"btn_bedroom_n.png"];
    tv_bedroom.textColor = [UIColor whiteColor];
    
    btn_kitchen.backgroundColor = [UIColor clearColor];
    img_kitchen.image = [UIImage imageByResourceDrawable:@"btn_kitchen_n.png"];
    tv_kitchen.textColor = [UIColor whiteColor];
    
    btn_toilet.backgroundColor = [UIColor clearColor];
    img_toilet.image = [UIImage imageByResourceDrawable:@"btn_toilet_n.png"];
    tv_toilet.textColor = [UIColor whiteColor];
    
    btn_order.backgroundColor = [UIColor clearColor];
    img_order.image = [UIImage imageByResourceDrawable:@"btn_order_n.png"];
    tv_order.textColor = [UIColor whiteColor];
    
    [self updateUndoRedoState];
    
    InspiratedEditInit* weakSelf = self;
//    __block id<IMesherModel> model = mModel;
    mModel.inspiratedBehaviour.selectedMask = SelectedMaskAllArchs | SelectedMaskAllItems;
    mModel.inspiratedBehaviour.onSelect = (^(id<JIGameObject> object) {
        if (object == nil) {
            return;
        }
        [weakSelf.parentMachine changeStateTo:[States InspiratedItemEdit]];
    });
    mModel.inspiratedBehaviour.canMove = NO;
}

- (void)onStateLeave {
    [super onStateLeave];
    self.view.visible = YES;
}

@end

@interface InspiratedEdit() <UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    JWRelativeLayout *lo_inspiratedEdit;
    JWRelativeLayout *lo_game_view;
    UIView *gameView;
    JWFrameLayout *lo_menu_right;
    CGRect rect_lo;
    CGRect rect;
    
    JWRelativeLayout *btn_exchange;
    UIImageView* img_exchange;
    UILabel *tv_exchange;
    JWRelativeLayout *btn_living_room;
    UIImageView* img_living_room;
    UILabel *tv_living_room;
    JWRelativeLayout *btn_bedroom;
    UIImageView* img_bedroom;
    UILabel *tv_bedroom;
    JWRelativeLayout *btn_kitchen;
    UIImageView* img_kitchen;
    UILabel *tv_kitchen;
    JWRelativeLayout *btn_toilet;
    UIImageView* img_toilet;
    UILabel *tv_toilet;
    
    JWRelativeLayout *btn_order;
    UIImageView* img_order;
    UILabel *tv_order;
    
    JWFrameLayout *lo_screenshot;
    JWFrameLayout *lo_load;
    
    UIActivityIndicatorView *crl_loading;
    
    //UIImageView *img;
    
    EditorCamera *mInspiratedCamera;
    id<JICamera> inspiratedCamera;
    
//    UIImageView *aaa;
//    JCQuaternion quater;
}

@end

@implementation InspiratedEdit

- (void)onCreated {
    [self.subMachine addState:[[InspiratedEditInit alloc] initWithModel:mModel] withName:[InspiratedEditInit StateName]];
    [self.subMachine addState:[[InspiratedProductList alloc]initWithModel:mModel] withName:[States InspiratedProductList]];
    [self.subMachine addState:[[InspiratedProductInfo alloc]initWithModel:mModel] withName:[States InspiratedProductInfo]];
    [self.subMachine addState:[[OrderList alloc]initWithModel:mModel] withName:[States OrderList]];
    [self.subMachine addState:[[InspiratedItemEdit alloc]initWithModel:mModel] withName:[States InspiratedItemEdit]];
    
    [self.subMachine changeStateTo:[InspiratedEditInit StateName]];
}

- (UIView *)onCreateView:(UIView *)parent {
    lo_inspiratedEdit = [JWRelativeLayout layout];
    lo_inspiratedEdit.layoutParams.width = JWLayoutMatchParent;
    lo_inspiratedEdit.layoutParams.height = JWLayoutMatchParent;
    lo_inspiratedEdit.backgroundColor = [UIColor clearColor];
    [parent addSubview:lo_inspiratedEdit];
    
#pragma mark 物件上的UI
    JWRelativeLayout *lo_control_fm = [JWRelativeLayout layout];
    lo_control_fm.tag = R_id_lo_control;
    lo_control_fm.layoutParams.width = JWLayoutMatchParent;
    lo_control_fm.layoutParams.height = JWLayoutMatchParent;
    lo_control_fm.backgroundColor = [UIColor clearColor];
    lo_control_fm.hidden = YES;
    [lo_inspiratedEdit addSubview:lo_control_fm];
    
#pragma mark 左上角胶囊型菜单容器
    JWRelativeLayout *lo_mainMenu1_container = [[JWRelativeLayout alloc] init];
    lo_mainMenu1_container.tag = R_id_lo_mainMenu1_container;
    lo_mainMenu1_container.layoutParams.width = JWLayoutWrapContent;
    lo_mainMenu1_container.layoutParams.height = JWLayoutWrapContent;
    lo_mainMenu1_container.layoutParams.marginLeft = [self uiWidthBy:80.0f];
    lo_mainMenu1_container.layoutParams.marginTop = [self uiHeightBy:80.0f];
    [lo_inspiratedEdit addSubview:lo_mainMenu1_container];
    
    UIImageView *bg_mainMenu = [[UIImageView alloc] initWithImage:[UIImage imageByResourceDrawable:@"bg_main_menu.png"]];
    bg_mainMenu.layoutParams.width = JWLayoutWrapContent;
    bg_mainMenu.layoutParams.height = JWLayoutWrapContent;
    [lo_mainMenu1_container addSubview:bg_mainMenu];
    
    // 左上角胶囊型菜单
    JWLinearLayout *lo_mainMenu1 = [JWLinearLayout layout];
    lo_mainMenu1.layoutParams.width = JWLayoutWrapContent;
    lo_mainMenu1.layoutParams.height = JWLayoutWrapContent;
    lo_mainMenu1.layoutParams.alignment = JWLayoutAlignCenterInParent;
    lo_mainMenu1.orientation = JWLayoutOrientationVertical;
    [lo_mainMenu1_container addSubview:lo_mainMenu1];
    
    // home按钮
    UIImage *btn_homepage_n = [UIImage imageByResourceDrawable:@"btn_homepage_n"];
    UIImageView *btn_homepage = [[UIImageView alloc] initWithImage:btn_homepage_n];
    btn_homepage.tag = R_id_btn_homepage;
    btn_homepage.layoutParams.width = JWLayoutWrapContent;
    btn_homepage.layoutParams.height = JWLayoutWrapContent;
    btn_homepage.layoutParams.alignment = JWLayoutAlignCenterHorizontal;
    [lo_mainMenu1 addSubview:btn_homepage];
    
    // 撤销按钮
    UIImage *btn_undo_n = [UIImage imageByResourceDrawable:@"btn_undo_n.png"];
    btn_undo = [[UIImageView alloc] initWithImage:btn_undo_n];
    btn_undo.tag = R_id_btn_undo;
    btn_undo.layoutParams.width = JWLayoutWrapContent;
    btn_undo.layoutParams.height = JWLayoutWrapContent;
    btn_undo.layoutParams.alignment = JWLayoutAlignCenterHorizontal;
    btn_undo.layoutParams.marginTop = [self uiHeightBy:8.0f];
    [lo_mainMenu1 addSubview:btn_undo];
    
    // 重做按钮
    UIImage *btn_redo_n = [UIImage imageByResourceDrawable:@"btn_redo_n.png"];
    btn_redo = [[UIImageView alloc] initWithImage:btn_redo_n];
    btn_redo.tag = R_id_btn_redo;
    btn_redo.layoutParams.width = JWLayoutWrapContent;
    btn_redo.layoutParams.height = JWLayoutWrapContent;
    btn_redo.layoutParams.alignment = JWLayoutAlignCenterHorizontal;
    btn_redo.layoutParams.marginTop = [self uiHeightBy:8.0f];
    [lo_mainMenu1 addSubview:btn_redo];
    
    // 截屏按钮
    UIImage *btn_screenshot_p = [UIImage imageByResourceDrawable:@"btn_screenshot_p"];
    UIImageView *btn_screenshot = [[UIImageView alloc] initWithImage:btn_screenshot_p];
    btn_screenshot.tag = R_id_btn_screenshot;
    btn_screenshot.layoutParams.width = JWLayoutWrapContent;
    btn_screenshot.layoutParams.height = JWLayoutWrapContent;
    btn_screenshot.layoutParams.alignment = JWLayoutAlignCenterHorizontal;
    btn_screenshot.layoutParams.marginTop = [self uiHeightBy:8.0f];
    [lo_mainMenu1 addSubview:btn_screenshot];
    
#pragma mark 右边竖条菜单容器
    JWFrameLayout *lo_menu_right_gray = (JWFrameLayout*)[parent viewWithTag:R_id_lo_menu_right_gray];
    JWFrameLayout *lo_menuR = [JWFrameLayout layout];
    lo_menuR.layoutParams.width = lo_menu_right_gray.frame.size.width;
    lo_menuR.layoutParams.height = JWLayoutMatchParent;
    lo_menuR.layoutParams.alignment = JWLayoutAlignParentRight;
    [lo_inspiratedEdit addSubview:lo_menuR];
    UIImageView *bg_menuR = [[UIImageView alloc] initWithImage:[UIImage imageByResourceDrawable:@"bg_menu_right_blue.png"]];
    bg_menuR.layoutParams.width = JWLayoutWrapContent;
    bg_menuR.layoutParams.height = JWLayoutMatchParent;
    [lo_menuR addSubview:bg_menuR];
    
    // 右边竖条菜单
    JWLinearLayout *lo_menu_right_gray_linear = [JWLinearLayout layout];
    lo_menu_right_gray_linear.layoutParams.width = JWLayoutMatchParent;
    lo_menu_right_gray_linear.layoutParams.height = JWLayoutMatchParent;
    lo_menu_right_gray_linear.layoutParams.alignment = JWLayoutAlignCenterHorizontal;
    lo_menu_right_gray_linear.orientation = JWLayoutOrientationVertical;
    [lo_menuR addSubview:lo_menu_right_gray_linear];
    
    // 结构列表按钮
    btn_exchange = [JWRelativeLayout layout];
    btn_exchange.tag = R_id_btn_exchange;
    btn_exchange.layoutParams.width = JWLayoutMatchParent;
    btn_exchange.layoutParams.height = JWLayoutWrapContent;
    [lo_menu_right_gray_linear addSubview:btn_exchange];
    UIImage *btn_exchange_n = [UIImage imageByResourceDrawable:@"btn_exchange_n.png"];
    img_exchange = [[UIImageView alloc] initWithImage:btn_exchange_n];
    img_exchange.tag = R_id_img_exchange;
    img_exchange.layoutParams.width = JWLayoutWrapContent;
    img_exchange.layoutParams.height = JWLayoutWrapContent;
    img_exchange.layoutParams.alignment = JWLayoutAlignCenterHorizontal;
    img_exchange.layoutParams.marginTop = [MesherModel uiHeightBy:10.0f];
    img_exchange.layoutParams.marginBottom = [MesherModel uiHeightBy:30.0f];
    [btn_exchange addSubview:img_exchange];
    tv_exchange = [UILabel new];
    tv_exchange.tag = R_id_tv_exchange;
    tv_exchange.layoutParams.width = JWLayoutWrapContent;
    tv_exchange.layoutParams.height = JWLayoutWrapContent;
    tv_exchange.layoutParams.alignment = JWLayoutAlignParentBottom | JWLayoutAlignCenterHorizontal;
    tv_exchange.layoutParams.marginTop = [MesherModel uiHeightBy:10.0f];
    tv_exchange.layoutParams.marginBottom = [MesherModel uiHeightBy:10.0f];
    tv_exchange.text = @"替 换";
    tv_exchange.textColor = [UIColor whiteColor];
    tv_exchange.labelTextSize = 8;
    [btn_exchange addSubview:tv_exchange];
    
    // 分割线
    UIImageView *img_divide_line = [[UIImageView alloc] initWithImage:[UIImage imageByResourceDrawable:@"img_divider_120.png"]];
    img_divide_line.layoutParams.width = JWLayoutMatchParent;
    img_divide_line.layoutParams.height = JWLayoutWrapContent;
    [lo_menu_right_gray_linear addSubview:img_divide_line];
    
    // 客厅按钮
    btn_living_room = [JWRelativeLayout layout];
    btn_living_room.tag = R_id_btn_living_room;
    btn_living_room.layoutParams.width = JWLayoutMatchParent;
    btn_living_room.layoutParams.height = JWLayoutWrapContent;
    [lo_menu_right_gray_linear addSubview:btn_living_room];
    UIImage *btn_living_room_n = [UIImage imageByResourceDrawable:@"btn_living_room_n.png"];
    img_living_room = [[UIImageView alloc] initWithImage:btn_living_room_n];
    img_living_room.tag = R_id_img_living_room;
    img_living_room.layoutParams.width = JWLayoutWrapContent;
    img_living_room.layoutParams.height = JWLayoutWrapContent;
    img_living_room.layoutParams.alignment = JWLayoutAlignCenterHorizontal;
    img_living_room.layoutParams.marginTop = [MesherModel uiHeightBy:10.0f];
    img_living_room.layoutParams.marginBottom = [MesherModel uiHeightBy:30.0f];
    [btn_living_room addSubview:img_living_room];
    tv_living_room = [UILabel new];
    tv_living_room.tag = R_id_tv_living_room;
    tv_living_room.layoutParams.width = JWLayoutWrapContent;
    tv_living_room.layoutParams.height = JWLayoutWrapContent;
    tv_living_room.layoutParams.alignment = JWLayoutAlignParentBottom | JWLayoutAlignCenterHorizontal;
    tv_living_room.layoutParams.marginTop = [MesherModel uiHeightBy:10.0f];
    tv_living_room.layoutParams.marginBottom = [MesherModel uiHeightBy:10.0f];
    tv_living_room.text = @"客 厅";
    tv_living_room.textColor = [UIColor whiteColor];
    tv_living_room.labelTextSize = 8;
    [btn_living_room addSubview:tv_living_room];
    
    // 分割线
    img_divide_line = [[UIImageView alloc] initWithImage:[UIImage imageByResourceDrawable:@"img_divider_120.png"]];
    img_divide_line.layoutParams.width = JWLayoutMatchParent;
    img_divide_line.layoutParams.height = JWLayoutWrapContent;
    [lo_menu_right_gray_linear addSubview:img_divide_line];
    
    // 卧室按钮
    btn_bedroom = [JWRelativeLayout layout];
    btn_bedroom.tag = R_id_btn_bedroom;
    btn_bedroom.layoutParams.width = JWLayoutMatchParent;
    btn_bedroom.layoutParams.height = JWLayoutWrapContent;
    [lo_menu_right_gray_linear addSubview:btn_bedroom];
    UIImage *btn_bedroom_n = [UIImage imageByResourceDrawable:@"btn_bedroom_n.png"];
    img_bedroom = [[UIImageView alloc] initWithImage:btn_bedroom_n];
    img_bedroom.tag = R_id_img_bedroom;
    img_bedroom.layoutParams.width = JWLayoutWrapContent;
    img_bedroom.layoutParams.height = JWLayoutWrapContent;
    img_bedroom.layoutParams.alignment = JWLayoutAlignCenterHorizontal;
    img_bedroom.layoutParams.marginTop = [MesherModel uiHeightBy:10.0f];
    img_bedroom.layoutParams.marginBottom = [MesherModel uiHeightBy:30.0f];
    [btn_bedroom addSubview:img_bedroom];
    tv_bedroom = [UILabel new];
    tv_bedroom.tag = R_id_tv_bedroom;
    tv_bedroom.layoutParams.width = JWLayoutWrapContent;
    tv_bedroom.layoutParams.height = JWLayoutWrapContent;
    tv_bedroom.layoutParams.alignment = JWLayoutAlignParentBottom | JWLayoutAlignCenterHorizontal;
    tv_bedroom.layoutParams.marginTop = [MesherModel uiHeightBy:10.0f];
    tv_bedroom.layoutParams.marginBottom = [MesherModel uiHeightBy:10.0f];
    tv_bedroom.text = @"卧 室";
    tv_bedroom.textColor = [UIColor whiteColor];
    tv_bedroom.labelTextSize = 8;
    [btn_bedroom addSubview:tv_bedroom];
    
    // 分割线
    img_divide_line = [[UIImageView alloc] initWithImage:[UIImage imageByResourceDrawable:@"img_divider_120.png"]];
    img_divide_line.layoutParams.width = JWLayoutMatchParent;
    img_divide_line.layoutParams.height = JWLayoutWrapContent;
    [lo_menu_right_gray_linear addSubview:img_divide_line];
    
    // 厨房按钮
    btn_kitchen = [JWRelativeLayout layout];
    btn_kitchen.tag = R_id_btn_kitchen;
    btn_kitchen.layoutParams.width = JWLayoutMatchParent;
    btn_kitchen.layoutParams.height = JWLayoutWrapContent;
    [lo_menu_right_gray_linear addSubview:btn_kitchen];
    UIImage *btn_kitchen_n = [UIImage imageByResourceDrawable:@"btn_kitchen_n.png"];
    img_kitchen = [[UIImageView alloc] initWithImage:btn_kitchen_n];
    img_kitchen.tag = R_id_img_kitchen;
    img_kitchen.layoutParams.width = JWLayoutWrapContent;
    img_kitchen.layoutParams.height = JWLayoutWrapContent;
    img_kitchen.layoutParams.alignment = JWLayoutAlignCenterHorizontal;
    img_kitchen.layoutParams.marginTop = [MesherModel uiHeightBy:10.0f];
    img_kitchen.layoutParams.marginBottom = [MesherModel uiHeightBy:30.0f];
    [btn_kitchen addSubview:img_kitchen];
    tv_kitchen = [UILabel new];
    tv_kitchen.tag = R_id_tv_kitchen;
    tv_kitchen.layoutParams.width = JWLayoutWrapContent;
    tv_kitchen.layoutParams.height = JWLayoutWrapContent;
    tv_kitchen.layoutParams.alignment = JWLayoutAlignParentBottom | JWLayoutAlignCenterHorizontal;
    tv_kitchen.layoutParams.marginTop = [MesherModel uiHeightBy:10.0f];
    tv_kitchen.layoutParams.marginBottom = [MesherModel uiHeightBy:10.0f];
    tv_kitchen.text = @"厨 房";
    tv_kitchen.textColor = [UIColor whiteColor];
    tv_kitchen.labelTextSize = 8;
    [btn_kitchen addSubview:tv_kitchen];
    
    // 分割线
    img_divide_line = [[UIImageView alloc] initWithImage:[UIImage imageByResourceDrawable:@"img_divider_120.png"]];
    img_divide_line.layoutParams.width = JWLayoutMatchParent;
    img_divide_line.layoutParams.height = JWLayoutWrapContent;
    [lo_menu_right_gray_linear addSubview:img_divide_line];
    
    // 卫生间按钮
    btn_toilet = [JWRelativeLayout layout];
    btn_toilet.tag = R_id_btn_toilet;
    btn_toilet.layoutParams.width = JWLayoutMatchParent;
    btn_toilet.layoutParams.height = JWLayoutWrapContent;
    [lo_menu_right_gray_linear addSubview:btn_toilet];
    UIImage *btn_toilet_n = [UIImage imageByResourceDrawable:@"btn_toilet_n.png"];
    img_toilet = [[UIImageView alloc] initWithImage:btn_toilet_n];
    img_toilet.tag = R_id_img_toilet;
    img_toilet.layoutParams.width = JWLayoutWrapContent;
    img_toilet.layoutParams.height = JWLayoutWrapContent;
    img_toilet.layoutParams.alignment = JWLayoutAlignCenterHorizontal;
    img_toilet.layoutParams.marginTop = [MesherModel uiHeightBy:10.0f];
    img_toilet.layoutParams.marginBottom = [MesherModel uiHeightBy:30.0f];
    [btn_toilet addSubview:img_toilet];
    tv_toilet = [UILabel new];
    tv_toilet.tag = R_id_tv_toilet;
    tv_toilet.layoutParams.width = JWLayoutWrapContent;
    tv_toilet.layoutParams.height = JWLayoutWrapContent;
    tv_toilet.layoutParams.alignment = JWLayoutAlignParentBottom | JWLayoutAlignCenterHorizontal;
    tv_toilet.layoutParams.marginTop = [MesherModel uiHeightBy:10.0f];
    tv_toilet.layoutParams.marginBottom = [MesherModel uiHeightBy:10.0f];
    tv_toilet.text = @"卫 生 间";
    tv_toilet.textColor = [UIColor whiteColor];
    tv_toilet.labelTextSize = 8;
    [btn_toilet addSubview:tv_toilet];
    
    // 分割线
    img_divide_line = [[UIImageView alloc] initWithImage:[UIImage imageByResourceDrawable:@"img_divider_120.png"]];
    img_divide_line.layoutParams.width = JWLayoutMatchParent;
    img_divide_line.layoutParams.height = JWLayoutWrapContent;
    [lo_menu_right_gray_linear addSubview:img_divide_line];
    
    // 报价单按钮
    btn_order = [JWRelativeLayout layout];
    btn_order.tag = R_id_btn_order;
    btn_order.layoutParams.width = JWLayoutMatchParent;
    btn_order.layoutParams.height = JWLayoutWrapContent;
    //btn_order.layoutParams.alignment = JWLayoutAlignParentBottomRight;
    [lo_menu_right_gray_linear addSubview:btn_order];
    UIImage *btn_order_n = [UIImage imageByResourceDrawable:@"btn_order_n.png"];
    img_order = [[UIImageView alloc] initWithImage:btn_order_n];
    img_order.tag = R_id_img_order;
    img_order.layoutParams.width = JWLayoutWrapContent;
    img_order.layoutParams.height = JWLayoutWrapContent;
    img_order.layoutParams.alignment = JWLayoutAlignCenterHorizontal;
    img_order.layoutParams.marginTop = [MesherModel uiHeightBy:10.0f];
    img_order.layoutParams.marginBottom = [MesherModel uiHeightBy:30.0f];
    [btn_order addSubview:img_order];
    tv_order = [UILabel new];
    tv_order.tag = R_id_tv_order;
    tv_order.layoutParams.width = JWLayoutWrapContent;
    tv_order.layoutParams.height = JWLayoutWrapContent;
    tv_order.layoutParams.alignment = JWLayoutAlignParentBottom | JWLayoutAlignCenterHorizontal;
    tv_order.layoutParams.marginTop = [MesherModel uiHeightBy:10.0f];
    tv_order.layoutParams.marginBottom = [MesherModel uiHeightBy:10.0f];
    tv_order.text = @"报 价 单";
    tv_order.textColor = [UIColor whiteColor];
    tv_order.labelTextSize = 8;
    [btn_order addSubview:tv_order];
    
    // 分割线
    img_divide_line = [[UIImageView alloc] initWithImage:[UIImage imageByResourceDrawable:@"img_divider_120.png"]];
    img_divide_line.layoutParams.width = JWLayoutMatchParent;
    img_divide_line.layoutParams.height = JWLayoutWrapContent;
    [lo_menu_right_gray_linear addSubview:img_divide_line];
    
#pragma mark UI InProductList
    JWRelativeLayout *lo_product_list = [JWRelativeLayout layout];
    lo_product_list.tag = R_id_lo_inspirate_product_list;
    lo_product_list.layoutParams.width = [self uiWidthBy:520.0f];
    lo_product_list.layoutParams.height = JWLayoutMatchParent;
    lo_product_list.layoutParams.leftOf = lo_menuR;
    [lo_inspiratedEdit addSubview:lo_product_list];
    lo_product_list.hidden = YES;
    
    UIImage *bg_menu_right = [UIImage imageByResourceDrawable:@"bg_menu_right"];
    UIImageView *bg_product_list = [[UIImageView alloc] initWithImage:bg_menu_right];
    bg_product_list.layoutParams.width = [self uiWidthBy:520.0f];
    bg_product_list.layoutParams.height = JWLayoutMatchParent;
    [lo_product_list addSubview:bg_product_list];
    
    UIImage *img_vertical_line_n = [UIImage imageByResourceDrawable:@"img_vertical_line"];
    UIImageView *img_vertical_line = [[UIImageView alloc] initWithImage:img_vertical_line_n];
    img_vertical_line.layoutParams.width = JWLayoutWrapContent;
    
#pragma mark UI InProductInfo
    JWRelativeLayout *lo_product_info = [JWRelativeLayout layout];
    lo_product_info.tag = R_id_lo_inspirate_product_info;
    lo_product_info.layoutParams.width = [self uiWidthBy:521.0f];
    lo_product_info.layoutParams.height = JWLayoutMatchParent;
    lo_product_info.layoutParams.leftOf = lo_menuR;
    [lo_inspiratedEdit addSubview:lo_product_info];
    lo_product_info.hidden = YES;
    
    UIImageView *bg_product_info = [[UIImageView alloc] initWithImage:bg_menu_right];
    bg_product_info.layoutParams.width = [self uiWidthBy:521.0f];
    bg_product_info.layoutParams.height = JWLayoutMatchParent;
    [lo_product_info addSubview:bg_product_info];
    
#pragma mark loading界面
    lo_load = [JWRelativeLayout layout];
    lo_load.tag = R_id_lo_loading;
    lo_load.layoutParams.width = JWLayoutMatchParent;
    lo_load.layoutParams.height = JWLayoutMatchParent;
    lo_load.hidden = YES;
    [lo_inspiratedEdit addSubview:lo_load];
//    [self createLoadingAnimationView:lo_load];
    [self.viewEventBinder bindEventsToView:lo_load willBindSubviews:NO andFilter:nil];
    
#pragma mark 物件拖动frame
    JWFrameLayout *lo_move = [JWFrameLayout layout];
    lo_move.tag = R_id_lo_move;
    lo_move.layoutParams.width = JWLayoutMatchParent;
    lo_move.layoutParams.height = JWLayoutMatchParent;
    lo_move.backgroundColor = [UIColor clearColor];
    lo_move.hidden = YES;
    [lo_inspiratedEdit addSubview:lo_move];
    
#pragma mark UI InItemEdit
    JWRelativeLayout *lo_item_edit = [JWRelativeLayout layout];
    lo_item_edit.tag = R_id_lo_inspirate_item_edit;
    lo_item_edit.layoutParams.width = [self uiWidthBy:521.0f];
    lo_item_edit.layoutParams.height = JWLayoutMatchParent;
    lo_item_edit.layoutParams.leftOf = lo_menuR;
    [lo_inspiratedEdit addSubview:lo_item_edit];
    lo_item_edit.hidden = YES;
    //lo_item_edit.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bg_item_edit = [[UIImageView alloc] initWithImage:bg_menu_right];
    bg_item_edit.layoutParams.width = [self uiWidthBy:521.0f];
    bg_item_edit.layoutParams.height = JWLayoutMatchParent;
    [lo_item_edit addSubview:bg_item_edit];
    
#pragma mark 控制物件的buttons的容器
    JWLinearLayout *lo_button = [JWLinearLayout layout];
    lo_button.tag = R_id_lo_inspirate_buttons;
    lo_button.layoutParams.width = JWLayoutWrapContent;
    lo_button.layoutParams.height = JWLayoutWrapContent;
    lo_button.orientation = JWLayoutOrientationVertical;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        lo_button.layoutParams.marginLeft = [self uiWidthBy:120.0f];
        lo_button.layoutParams.marginBottom = [self uiHeightBy:300.0f];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        lo_button.layoutParams.marginLeft = [self uiWidthBy:118.0f];
        lo_button.layoutParams.marginBottom = [self uiHeightBy:100.0f];
    }
    lo_button.layoutParams.alignment = JWLayoutAlignParentBottomLeft;
    lo_button.hidden = YES;
    [lo_inspiratedEdit addSubview:lo_button];
    
#pragma mark 为了截屏做的白屏
    lo_screenshot = [JWFrameLayout layout];
    lo_screenshot.layoutParams.width = JWLayoutMatchParent;
    lo_screenshot.layoutParams.height = JWLayoutMatchParent;
    lo_screenshot.backgroundColor = [UIColor whiteColor];
    lo_screenshot.alpha = 0.5f;
    lo_screenshot.hidden = YES;
    [lo_inspiratedEdit addSubview:lo_screenshot];
    
    crl_loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    crl_loading.layoutParams.alignment = JWLayoutAlignCenterInParent;
    [lo_screenshot addSubview:crl_loading];

    
#pragma mark 交互动作
    //左边按钮
    btn_homepage.userInteractionEnabled = YES;
    [self.gestureEventBinder bindEventsWithType:JWGestureTypeSingleTap toView:btn_homepage willBindSubviews:NO andFilter:nil];
    btn_undo.userInteractionEnabled = YES;
    [self.gestureEventBinder bindEventsWithType:JWGestureTypeSingleTap toView:btn_undo willBindSubviews:NO andFilter:nil];
    btn_redo.userInteractionEnabled = YES;
    [self.gestureEventBinder bindEventsWithType:JWGestureTypeSingleTap toView:btn_redo willBindSubviews:NO andFilter:nil];
    btn_screenshot.userInteractionEnabled = YES;
    [self.gestureEventBinder bindEventsWithType:JWGestureTypeSingleTap toView:btn_screenshot willBindSubviews:NO andFilter:nil];
    
    //右边按钮
    btn_exchange.clickable = YES;
    [self.viewEventBinder bindEventsToView:btn_exchange willBindSubviews:NO andFilter:nil];
    btn_living_room.clickable = YES;
    [self.viewEventBinder bindEventsToView:btn_living_room willBindSubviews:NO andFilter:nil];
    btn_bedroom.clickable = YES;
    [self.viewEventBinder bindEventsToView:btn_bedroom willBindSubviews:NO andFilter:nil];
    btn_kitchen.clickable = YES;
    [self.viewEventBinder bindEventsToView:btn_kitchen willBindSubviews:NO andFilter:nil];
    btn_toilet.clickable = YES;
    [self.viewEventBinder bindEventsToView:btn_toilet willBindSubviews:NO andFilter:nil];
    
    btn_order.clickable = YES;
    [self.viewEventBinder bindEventsToView:btn_order willBindSubviews:NO andFilter:nil];
    
    lo_game_view = (JWRelativeLayout*)[parent viewWithTag:R_id_lo_game_view];
    gameView = [parent viewWithTag:R_id_game_view];
    lo_menu_right = (JWFrameLayout*)[parent viewWithTag:R_id_lo_menu_right_gray];
    rect_lo = lo_game_view.frame;
    rect = gameView.frame;

#pragma mark camera
    //创建
//    mInspiratedCamera = [[EditorCamera alloc] initWithContext:mModel.currentContext parent:mModel.inspirateScene.root cameraId:@"inspirated camera" initPicth:-10.0f initYaw:15.0f initZoom:10.0f];
//    mInspiratedCamera.camera.zNear = 0.1f;
//    mInspiratedCamera.camera.zFar = 100.0f;
//    mInspiratedCamera.move1Speed = 0.2f;
//    mInspiratedCamera.scaleSpeed = 1.5f;
//    mInspiratedCamera.move2Enabled = YES; // 双指操作设置
//    mInspiratedCamera.move2Speed = 0.01f;
//    mInspiratedCamera.pitchConstraintEnabled = YES;
//    mInspiratedCamera.minPitch = -90.0f;
//    mInspiratedCamera.maxPitch = -10.0f;
//    [mInspiratedCamera.camera.host.transform setPositionX:0.0f Y:2.0f Z:0.0f inSpace:JWTransformSpaceWorld];
//    // 创建完需要将自己场景使用camera
//    [mModel.inspirateScene changeCameraById:mInspiratedCamera.camera.Id];
//    mInspiratedCamera.camera.host.enabled = NO;
//    [mInspiratedCamera.root setQueryMask:SelectedMaskCannotSelect recursive:YES];
//    mModel.inspiratedEditorCamera = mInspiratedCamera;
    
    id<JIGameObject> inspiratedCameraObject = [mModel.currentContext createObject];
    inspiratedCamera = [mModel.currentContext createCamera];
    mModel.inspiratedCamera = inspiratedCamera;
    inspiratedCamera.Id = @"inspirated camera";
    [inspiratedCameraObject addComponent:inspiratedCamera];
    inspiratedCameraObject.parent = mModel.inspirateScene.root;
    [mModel.inspirateScene changeCameraById:inspiratedCamera.Id];
    [inspiratedCameraObject setQueryMask:SelectedMaskCannotSelect recursive:YES];
    [inspiratedCamera.host.transform setPosition:JCVector3Make(0.0f, 2.0f, 0.0f) inSpace:JWTransformSpaceWorld];
    InspiratedCameraBehaviour *inspiratedCameraBehaviour = [[InspiratedCameraBehaviour alloc] initWithContext:mModel.currentContext AndModel:mModel];
    [inspiratedCamera.host addComponent:inspiratedCameraBehaviour];
    mModel.inspiratedCamera.host.enabled = NO;
    
#pragma mark 关于网格
    JCColor gridColor = JCColorMake(0.21f, 0.78f, 1.0f, 0.6f);//JCColorMake(0.7f, 0.7f, 0.7f, 1.0f)
    id<JIGameObject> gridsObject = [JWPrefabUtils createGridsWithContext:mModel.currentContext parent:mModel.inspirateScene.root startRow:-10 startColumn:-10 numRows:20 numColumns:20 gridWidth:1.0f gridHeight:1.0f color:gridColor];
    gridsObject.queryMask = SelectedMaskCannotSelect;
    mModel.inspiratedGridsObject = gridsObject;
    mModel.inspiratedGridsObject.visible = NO;
    
//    aaa = [[UIImageView alloc] init];
//    aaa.layoutParams.width = 0.3;
//    aaa.layoutParams.height = 0.3;
//    aaa.layoutParams.alignment = JWLayoutAlignParentBottomLeft;
//    [lo_inspiratedEdit addSubview:aaa];
    
    return lo_inspiratedEdit;
}

- (void)onStateEnter:(NSDictionary *)data {
    [super onStateEnter:data];
    mModel.inspiratedGridsObject.visible = NO;
    [mModel.world changeSceneById:mModel.inspirateScene.Id];
    
//    aaa.image = mModel.inspiratedImage;
    
    mModel.fromInspiration = YES;
    
    [self updateUndoRedoState];
    mModel.inspiratedBehaviour.enabled = YES;//进入状态把移动的behaviour开启
    
    if (!mModel.fromExchange && !mModel.isInspiratedCreate) {
        [mModel.prePlan destroyAllObjects];
        InspiratedPlan* currentPlan = (InspiratedPlan*)mModel.currentPlan;
        id<IMesherModel> model = mModel;
        [mModel.inspiratedBackgroundSprite.spriteTexture.manager destroyByFile:mModel.inspiratedBackgroundSprite.spriteTexture.file];// 先移除旧的图
        [mModel.inspiratedBackgroundSprite setSpriteTextureFile:mModel.currentPlan.inspirateBackground];
        JWSceneLoaderOnLoadingListener* listener = [[JWSceneLoaderOnLoadingListener alloc] init];
        listener.onFinish = (^(id<JIFile> file, id<JIGameObject> parent, id<JIGameObject> object){
            
            JCQuaternion q = JCQuaternionMake(model.currentPlan.qw, model.currentPlan.qx, model.currentPlan.qy, model.currentPlan.qz);
            [model.inspiratedCamera.host.transform setOrientation:q inSpace:JWTransformSpaceWorld];
            [model.inspiratedCamera.host.transform setPosition:JCVector3Make(model.currentPlan.cameraX, model.currentPlan.cameraY, model.currentPlan.cameraZ) inSpace:JWTransformSpaceWorld];
            [[JWCorePluginSystem instance].imageCache getBy:model.currentPlan.inspirateBackground options:nil async:YES onGet:^(UIImage *image) {
                model.inspiratedImage = image;
            }];
            lo_load.hidden = YES;
//            [self stopLoadingAnimation];
        });
        listener.onFailed = (^(id<JIFile> file, id<JIGameObject> parent, NSError* error) {
            lo_load.hidden = YES;
//            [self stopLoadingAnimation];
        });
        [mModel.prePlan destroyAllObjects];
        id<JIGameContext> context = mModel.currentContext;
        id<JIGameScene> scene = mModel.currentScene;
        PlanLoader* planLoader = (PlanLoader*)[context.sceneLoaderManager getLoaderForFile:currentPlan.scene];
        planLoader.plan = mModel.currentPlan;
        [planLoader loadFile:currentPlan.scene parent:scene.root params:nil async:YES listener:listener];
        lo_load.hidden = NO;
//        [self startLoadingAnimation];
    }else if(mModel.fromExchange) {
        mModel.fromExchange = NO;
    }

    if (mModel.isInspiratedCreate) {
        [mModel.prePlan destroyAllObjects];
        JCQuaternion q = JCQuaternionMake(mModel.currentPlan.qw, mModel.currentPlan.qx, mModel.currentPlan.qy, mModel.currentPlan.qz);
        [mModel.inspiratedCamera.host.transform setOrientation:q inSpace:JWTransformSpaceWorld];
        [mModel.inspiratedCamera.host.transform setPosition:JCVector3Make(0.0f, 2.0f, 0.0f) inSpace:JWTransformSpaceWorld];
        mModel.isInspiratedCreate = NO;
        [mModel.inspiratedBackgroundSprite.spriteTexture.manager destroyByFile:mModel.inspiratedBackgroundSprite.spriteTexture.file];// 先移除旧的图
        [mModel.inspiratedBackgroundSprite setSpriteTextureFile:mModel.currentPlan.inspirateBackground];
        lo_load.hidden = YES;
//        [self stopLoadingAnimation];
        mModel.fromExchange = NO;
    }
    if (mModel.fromPhotoLibrary) {
//        mModel.inspiratedEditorCamera.camera.host.enabled = YES;
        mModel.inspiratedCamera.host.enabled = YES;
        mModel.inspiratedGridsObject.visible = YES;
        mModel.fromPhotoLibrary = NO;
    }
    
    lo_game_view.backgroundColor = [UIColor clearColor];
    lo_game_view.layoutParams.width = JWLayoutMatchParent;
    lo_game_view.layoutParams.height = JWLayoutMatchParent;
    gameView.layoutParams.width = JWLayoutMatchParent;
    gameView.layoutParams.height = JWLayoutMatchParent;
    gameView.layoutParams.marginTop = 0;
    gameView.layoutParams.marginLeft = 0;
    gameView.layoutParams.marginBottom = 0;
    gameView.layoutParams.marginRight = lo_menu_right.frame.size.width;
    
}

- (void)onStateLeave {
    mModel.inspiratedBehaviour.enabled = NO;//离开状态把移动的behaviour关闭
    
    lo_game_view.backgroundColor = [UIColor whiteColor];
    lo_game_view.frame = rect_lo;
    gameView.frame = rect;
    gameView.layoutParams.marginTop = 10;
    gameView.layoutParams.marginLeft = 10;
    gameView.layoutParams.marginBottom = 10;
    gameView.layoutParams.marginRight = lo_menu_right.frame.size.width + 10;
    [mModel.world changeSceneById:mModel.currentScene.Id];
    
    [super onStateLeave];
}

- (void)updateMenuButton {
    tv_exchange.textColor = [UIColor whiteColor];
    tv_living_room.textColor = [UIColor whiteColor];
    tv_bedroom.textColor = [UIColor whiteColor];
    tv_kitchen.textColor = [UIColor whiteColor];
    tv_toilet.textColor = [UIColor whiteColor];
    tv_order.textColor = [UIColor whiteColor];
    
    img_exchange.image = [UIImage imageByResourceDrawable:@"btn_exchange_n.png"];
    img_living_room.image = [UIImage imageByResourceDrawable:@"btn_living_room_n"];
    img_bedroom.image = [UIImage imageByResourceDrawable:@"btn_bedroom_n"];
    img_kitchen.image = [UIImage imageByResourceDrawable:@"btn_kitchen_n"];
    img_toilet.image = [UIImage imageByResourceDrawable:@"btn_toilet_n"];
    img_order.image = [UIImage imageByResourceDrawable:@"btn_order_n"];
}

#pragma mark touch事件
- (BOOL)onTouchUp:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    switch (touch.view.tag) {
        case R_id_btn_exchange: {
            mModel.fromExchange = YES;
            mModel.inspiratedCamera.host.enabled = NO;
            JCVector3 position = [mModel.inspiratedCamera.host.transform positionInSpace:JWTransformSpaceWorld];
            mModel.currentPlan.cameraX = position.x;
            mModel.currentPlan.cameraY = position.y;
            mModel.currentPlan.cameraZ = position.z;
            id<JIGameEngine> engine = mModel.currentContext.engine;
            id<JIRenderTimer> renderTimer = engine.renderTimer;
            JWOnSnapshotListener* listener = [[JWOnSnapshotListener alloc] init];
            id<IMesherModel> model = mModel;
            listener.onSnapshot = (^(UIImage* screenshot) {
                InspiratedPlan* plan = nil;
                plan = (InspiratedPlan*)model.currentPlan;
                [plan saveScene];
                [UIImagePNGRepresentation(screenshot) writeToFile:plan.preview.realPath atomically:YES];
                [UIImagePNGRepresentation(model.inspiratedImage) writeToFile:plan.inspirateBackground.realPath atomically:YES];
                [[JWCorePluginSystem instance].imageCache removeBy:plan.preview];
                [model.commandMachine clear];
                [self updateMenuButton];
                [self.subMachine changeStateTo:[InspiratedEditInit StateName] pushState:NO];
                [self.parentMachine changeStateTo:[States InspiratedList]];
            });
            CGRect frame = engine.frame.view.frameInPixels;
            JCRect rect_home = JCRectMake(0.0f, 0.0f, frame.size.width, frame.size.height);
            [renderTimer snapshotByRect:rect_home async:YES listener:listener];
            
            break;
        }
        case R_id_btn_living_room: {
            mModel.inspiratedCamera.host.enabled = NO;
            [self.subMachine changeStateTo:[InspiratedEditInit StateName]];
            btn_living_room.backgroundColor = [UIColor whiteColor];
            [self updateMenuButton];
            tv_living_room.textColor = [UIColor colorWithARGB:R_color_right_menu_label_textcolor];
            img_living_room.image = [UIImage imageByResourceDrawable:@"btn_living_room_p"];
            mModel.currentArea = AreaLivingRoom;
            [self.subMachine changeStateTo:[States InspiratedProductList]];
            break;
        }
        case R_id_btn_bedroom: {
            mModel.inspiratedCamera.host.enabled = NO;
            [self.subMachine changeStateTo:[InspiratedEditInit StateName]];
            btn_bedroom.backgroundColor = [UIColor whiteColor];
            [self updateMenuButton];
            tv_bedroom.textColor = [UIColor colorWithARGB:R_color_right_menu_label_textcolor];
            img_bedroom.image = [UIImage imageByResourceDrawable:@"btn_bedroom_p"];
            mModel.currentArea = AreaBedroom;
            [self.subMachine changeStateTo:[States InspiratedProductList]];
            break;
        }
        case R_id_btn_kitchen: {
            mModel.inspiratedCamera.host.enabled = NO;
            [self.subMachine changeStateTo:[InspiratedEditInit StateName]];
            btn_kitchen.backgroundColor = [UIColor whiteColor];
            [self updateMenuButton];
            tv_kitchen.textColor = [UIColor colorWithARGB:R_color_right_menu_label_textcolor];
            img_kitchen.image = [UIImage imageByResourceDrawable:@"btn_kitchen_p"];
            mModel.currentArea = AreaKitchen;
            [self.subMachine changeStateTo:[States InspiratedProductList]];
            break;
        }
        case R_id_btn_toilet: {
            mModel.inspiratedCamera.host.enabled = NO;
            [self.subMachine changeStateTo:[InspiratedEditInit StateName]];
            btn_toilet.backgroundColor = [UIColor whiteColor];
            [self updateMenuButton];
            tv_toilet.textColor = [UIColor colorWithARGB:R_color_right_menu_label_textcolor];
            img_toilet.image = [UIImage imageByResourceDrawable:@"btn_toilet_p"];
            mModel.currentArea = AreaToilet;
            [self.subMachine changeStateTo:[States InspiratedProductList]];
            break;
        }
        case R_id_btn_order:{
            mModel.inspiratedCamera.host.enabled = NO;
            [self.subMachine changeStateTo:[States OrderList]];
            break;
        }
    }
    return YES;
}

- (void)onSingleTap:(UITapGestureRecognizer *)singleTap {
    switch (singleTap.view.tag) {
        case R_id_btn_homepage: {
            JCVector3 position = [mModel.inspiratedCamera.host.transform positionInSpace:JWTransformSpaceWorld];
            mModel.currentPlan.cameraX = position.x;
            mModel.currentPlan.cameraY = position.y;
            mModel.currentPlan.cameraZ = position.z;
            id<JIGameEngine> engine = mModel.currentContext.engine;
            id<JIRenderTimer> renderTimer = engine.renderTimer;
            JWOnSnapshotListener* listener = [[JWOnSnapshotListener alloc] init];
            listener.onSnapshot = (^(UIImage* screenshot) {
                InspiratedPlan* plan = nil;
                plan = (InspiratedPlan*)mModel.currentPlan;
                [plan saveScene];
                [UIImagePNGRepresentation(screenshot) writeToFile:plan.preview.realPath atomically:YES];
                [UIImagePNGRepresentation(mModel.inspiratedImage) writeToFile:plan.inspirateBackground.realPath atomically:YES];
                [[JWCorePluginSystem instance].imageCache removeBy:plan.preview];
                [mModel.commandMachine clear];
                [self.subMachine changeStateTo:[InspiratedEditInit StateName] pushState:NO];
                [self.parentMachine changeStateTo:[States DIY] pushState:NO];
            });
            CGRect frame = engine.frame.view.frameInPixels;
            JCRect rect_home = JCRectMake(0.0f, 0.0f, frame.size.width, frame.size.height);
            [renderTimer snapshotByRect:rect_home async:YES listener:listener];
            break;
        }
        case R_id_btn_undo: {
            [mModel.commandMachine undo];
            [self updateUndoRedoState];
            break;
        }
        case R_id_btn_redo: {
            [mModel.commandMachine redo];
            [self updateUndoRedoState];
            break;
        }
        case R_id_btn_screenshot: {
            id<JIGameEngine> engine = mModel.currentContext.engine;
            id<JIRenderTimer> renderTimer = engine.renderTimer;
            JWOnSnapshotListener* listener = [[JWOnSnapshotListener alloc] init];
            listener.onSnapshot = (^(UIImage* screenshot) {
                NSLog(@"screenshot");
                UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil);
                lo_screenshot.hidden = YES;
                [crl_loading stopAnimating];
            });
            CGRect frame = engine.frame.view.frameInPixels;
            JCRect rect_shot = JCRectMake(0.0f, 0.0f, frame.size.width, frame.size.height);
            lo_screenshot.hidden = NO;
            [crl_loading startAnimating];
            [renderTimer snapshotByRect:rect_shot async:YES listener:listener];
            [JWCoreUtils playCameraSound];
            break;
        }
        case R_id_lo_loading: {
            NSLog(@"loading");
            break;
        }
        default:
            break;
    }
}

@end
