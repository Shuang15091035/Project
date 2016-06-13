//
//  PlanEdit.m
//  project_mesher
//
//  Created by MacMini on 15/10/12.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "PlanEdit.h"
#import "MesherModel.h"
#import "GamePhotographer.h"
#import "Plan.h"
#import "PlanLoader.h"
#import <ctrlcv/CCCMath.h>
#import <ctrlcv/CCVJson.h>

#import "ProductList.h"
#import "ProductInfo.h"
#import "OrderList.h"
#import "ItemEdit.h"
#import "ProductLink.h"
#import "ItemAR.h"
#import "LocalPlanTable.h"
#import "ArchitureEdit.h"
#import "CameraFPS.h"
#import "CameraVR.h"

@interface PlanEditInit : BaseState {
    CCVRelativeLayout *btn_build;
    UIImageView *img_build;
    UILabel *tv_build;
    
    CCVRelativeLayout *btn_living_room;
    UIImageView *img_living_room;
    UILabel *tv_living_room;
    
    CCVRelativeLayout *btn_bedroom;
    UIImageView *img_bedroom;
    UILabel *tv_bedroom;
    
    CCVRelativeLayout *btn_kitchen;
    UIImageView *img_kitchen;
    UILabel *tv_kitchen;
    
    CCVRelativeLayout *btn_toilet;
    UIImageView *img_toilet;
    UILabel *tv_toilet;
    
    CCVRelativeLayout *btn_order;
    UIImageView *img_order;
    UILabel *tv_order;
    
    UIImageView *btn_homepage;
}

+ (NSString*) StateName;

@end

@implementation PlanEditInit

+ (NSString *)StateName {
    return @"PlanEditInit";
}

- (UIView *)onCreateView:(UIView *)parent {
    btn_build = (CCVRelativeLayout*)[parent viewWithTag:R_id_btn_build_list];
    img_build = (UIImageView*)[parent viewWithTag:R_id_img_build_list];
    tv_build = (UILabel*)[parent viewWithTag:R_id_tv_build_list];
    
    btn_living_room = (CCVRelativeLayout*)[parent viewWithTag:R_id_btn_living_room];
    img_living_room = (UIImageView*)[parent viewWithTag:R_id_img_living_room];
    tv_living_room = (UILabel*)[parent viewWithTag:R_id_tv_living_room];
    
    btn_bedroom = (CCVRelativeLayout*)[parent viewWithTag:R_id_btn_bedroom];
    img_bedroom = (UIImageView*)[parent viewWithTag:R_id_img_bedroom];
    tv_bedroom = (UILabel*)[parent viewWithTag:R_id_tv_bedroom];
    
    btn_kitchen = (CCVRelativeLayout*)[parent viewWithTag:R_id_btn_kitchen];
    img_kitchen = (UIImageView*)[parent viewWithTag:R_id_img_kitchen];
    tv_kitchen = (UILabel*)[parent viewWithTag:R_id_tv_kitchen];
    
    btn_toilet = (CCVRelativeLayout*)[parent viewWithTag:R_id_btn_toilet];
    img_toilet = (UIImageView*)[parent viewWithTag:R_id_img_toilet];
    tv_toilet = (UILabel*)[parent viewWithTag:R_id_tv_toilet];
    
    btn_order = (CCVRelativeLayout*)[parent viewWithTag:R_id_btn_order];
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
    btn_build.backgroundColor = [UIColor clearColor];
    img_build.image = [UIImage imageByResourceDrawable:@"btn_build_n.png"];
    tv_build.textColor = [UIColor whiteColor];
    
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
    
    PlanEditInit* weakSelf = self;
    __block id<IMesherModel> model = mModel;
    mModel.itemSelectAndMoveBehaviour.onSelect = (^(id<ICVGameObject> object) {
        if (object == nil) {
            return;
        }
        ItemInfo *it = [Data getItemInfoFromInstance:object];
        if (it.type == ItemTypeItem) {
            [weakSelf.parentMachine changeStateTo:[States ItemEdit]];
        } else if (it.type != ItemTypeItem) {
            model.borderObject = object;
            [weakSelf.parentMachine changeStateTo:[States ArchitureEdit]];
        }
    });
    mModel.itemSelectAndMoveBehaviour.canMove = NO;
    mModel.photographer.cameraEnabled = YES;
}

- (void)onStateLeave {
    [super onStateLeave];
    self.view.visible = YES;
}

@end

@interface PlanEdit() {
    id<ICVGameObject> mSelectObject;
    UIProgressView* pb_progress;
    BOOL mHouseOk;
    
    CCVRelativeLayout *btn_build;
    UIImageView* img_build;
    UILabel *tv_build;
    CCVRelativeLayout *btn_living_room;
    UIImageView* img_living_room;
    UILabel *tv_living_room;
    CCVRelativeLayout *btn_bedroom;
    UIImageView* img_bedroom;
    UILabel *tv_bedroom;
    CCVRelativeLayout *btn_kitchen;
    UIImageView* img_kitchen;
    UILabel *tv_kitchen;
    CCVRelativeLayout *btn_toilet;
    UIImageView* img_toilet;
    UILabel *tv_toilet;
    
    CCVRelativeLayout *btn_order;
    UIImageView* img_order;
    UILabel *tv_order;
    
    UIButton *btn_bird_camera;
    UIButton *btn_fps_camera;
    UIButton *btn_editor_camera;
    UIButton *btn_VR_camera;
    
    CCVRadioViewGroup *rg_camera;
    
    CCVFrameLayout *lo_screenshot;
    CCVFrameLayout *lo_load;
    
    UIActivityIndicatorView *crl_loading;
    
    Plan *mCurrentPlan;
    BOOL isFPS;
}
@end

@implementation PlanEdit

- (void)onCreated {
    [self.subMachine addState:[[PlanEditInit alloc] initWithModel:mModel] withName:[PlanEditInit StateName]];
    [self.subMachine addState:[[ProductList alloc]initWithModel:mModel] withName:[States ProductList]];
    [self.subMachine addState:[[ProductInfo alloc]initWithModel:mModel] withName:[States ProductInfo]];
    [self.subMachine addState:[[OrderList alloc]initWithModel:mModel] withName:[States OrderList]];
    [self.subMachine addState:[[ItemEdit alloc]initWithModel:mModel] withName:[States ItemEdit]];
    [self.subMachine addState:[[ProductLink alloc] initWithModel:mModel] withName:[States ItemLink]];
    [self.subMachine addState:[[ArchitureEdit alloc] initWithModel:mModel] withName:[States ArchitureEdit]];
    [self.subMachine addState:[[CameraFPS alloc] initWithModel:mModel] withName:[States CameraFPS]];
    [self.subMachine addState:[[CameraVR alloc] initWithModel:mModel] withName:[States CameraVR]];
    [self.subMachine changeStateTo:[PlanEditInit StateName]];
}

- (UIView *)onCreateView:(UIView *)parent{
    CCVRelativeLayout *lo_PlanEdit = [[CCVRelativeLayout alloc] init];
    lo_PlanEdit.layoutParams.width = CCVLayoutMatchParent;
    lo_PlanEdit.layoutParams.height = CCVLayoutMatchParent;
    [parent addSubview:lo_PlanEdit];
   
    CCVRelativeLayout* lo_game_view = (CCVRelativeLayout*)[parent viewWithTag:R_id_lo_game_view];
    mModel.lo_game_view = lo_game_view;
    UIView *gameView = (UIView*)[parent viewWithTag:R_id_game_view];
    mModel.gameView = gameView;
    
#pragma mark 左上角胶囊型菜单容器
    CCVRelativeLayout *lo_mainMenu1_container = [[CCVRelativeLayout alloc] init];
    lo_mainMenu1_container.tag = R_id_lo_mainMenu1_container;
    lo_mainMenu1_container.layoutParams.width = CCVLayoutWrapContent;
    lo_mainMenu1_container.layoutParams.height = CCVLayoutWrapContent;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        lo_mainMenu1_container.layoutParams.marginLeft = [self uiWidthBy:80.0f];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        lo_mainMenu1_container.layoutParams.marginLeft = [self uiWidthBy:20.0f];
    }
    lo_mainMenu1_container.layoutParams.marginTop = [self uiHeightBy:80.0f];
    [lo_PlanEdit addSubview:lo_mainMenu1_container];
    
    UIImageView *bg_mainMenu = [[UIImageView alloc] initWithImage:[UIImage imageByResourceDrawable:@"bg_main_menu.png"]];
    bg_mainMenu.alpha = 0.0f;
    bg_mainMenu.layoutParams.width = CCVLayoutWrapContent;
    bg_mainMenu.layoutParams.height = CCVLayoutWrapContent;
    [lo_mainMenu1_container addSubview:bg_mainMenu];
    
    // 左上角胶囊型菜单
    CCVLinearLayout *lo_mainMenu1 = [CCVLinearLayout layout];
    lo_mainMenu1.layoutParams.width = CCVLayoutWrapContent;
    lo_mainMenu1.layoutParams.height = CCVLayoutWrapContent;
    lo_mainMenu1.layoutParams.alignment = CCVLayoutAlignCenterInParent;
    lo_mainMenu1.orientation = CCVLayoutOrientationVertical;
    [lo_mainMenu1_container addSubview:lo_mainMenu1];
    
    // home按钮
    UIImage *btn_homepage_n = [UIImage imageByResourceDrawable:@"btn_homepage_n"];
    UIImageView *btn_homepage = [[UIImageView alloc] initWithImage:btn_homepage_n];
    btn_homepage.tag = R_id_btn_homepage;
    btn_homepage.layoutParams.width = CCVLayoutWrapContent;
    btn_homepage.layoutParams.height = CCVLayoutWrapContent;
    btn_homepage.layoutParams.alignment = CCVLayoutAlignCenterHorizontal;
    [lo_mainMenu1 addSubview:btn_homepage];
    
    // 撤销按钮
    UIImage *btn_undo_n = [UIImage imageByResourceDrawable:@"btn_undo_n.png"];
    btn_undo = [[UIImageView alloc] initWithImage:btn_undo_n];
    btn_undo.tag = R_id_btn_undo;
    btn_undo.layoutParams.width = CCVLayoutWrapContent;
    btn_undo.layoutParams.height = CCVLayoutWrapContent;
    btn_undo.layoutParams.alignment = CCVLayoutAlignCenterHorizontal;
    btn_undo.layoutParams.marginTop = [self uiHeightBy:8.0f];
    [lo_mainMenu1 addSubview:btn_undo];
    
    // 重做按钮
    UIImage *btn_redo_n = [UIImage imageByResourceDrawable:@"btn_redo_n.png"];
    btn_redo = [[UIImageView alloc] initWithImage:btn_redo_n];
    btn_redo.tag = R_id_btn_redo;
    btn_redo.layoutParams.width = CCVLayoutWrapContent;
    btn_redo.layoutParams.height = CCVLayoutWrapContent;
    btn_redo.layoutParams.alignment = CCVLayoutAlignCenterHorizontal;
    btn_redo.layoutParams.marginTop = [self uiHeightBy:8.0f];
    [lo_mainMenu1 addSubview:btn_redo];
    
    // 截屏按钮
    UIImage *btn_screenshot_p = [UIImage imageByResourceDrawable:@"btn_screenshot_p"];
    UIImageView *btn_screenshot = [[UIImageView alloc] initWithImage:btn_screenshot_p];
    btn_screenshot.tag = R_id_btn_screenshot;
    btn_screenshot.layoutParams.width = CCVLayoutWrapContent;
    btn_screenshot.layoutParams.height = CCVLayoutWrapContent;
    btn_screenshot.layoutParams.alignment = CCVLayoutAlignCenterHorizontal;
    btn_screenshot.layoutParams.marginTop = [self uiHeightBy:8.0f];
    [lo_mainMenu1 addSubview:btn_screenshot];
    
#pragma mark camera操作
    CCVLinearLayout *lo_camera = [CCVLinearLayout layout];
    lo_camera.tag = R_id_lo_camera;
    lo_camera.layoutParams.width = CCVLayoutWrapContent;
    lo_camera.layoutParams.height = CCVLayoutWrapContent;
    lo_camera.layoutParams.marginLeft = [self uiWidthBy:66.0f];
    lo_camera.layoutParams.marginBottom = [self uiHeightBy:50.0f];
    lo_camera.layoutParams.alignment = CCVLayoutAlignParentBottomLeft;
    [lo_PlanEdit addSubview:lo_camera];
    
    UIImage *btn_vr_camera_n = [UIImage imageByResourceDrawable:@"btn_vr_camera_n"];
    UIImage *btn_vr_camera_p = [UIImage imageByResourceDrawable:@"btn_vr_camera_p"];
    btn_VR_camera = [[UIButton alloc] initWithImage:btn_vr_camera_n selectedImage:btn_vr_camera_p];
    btn_VR_camera.layoutParams.width = CCVLayoutWrapContent;
    btn_VR_camera.layoutParams.height = CCVLayoutWrapContent;
    btn_VR_camera.tag = R_id_btn_vr_camera;
    [lo_camera addSubview:btn_VR_camera];
    
    UIImage *btn_bird_camera_n = [UIImage imageByResourceDrawable:@"btn_bird_camera_n.png"];
    UIImage *btn_bird_camera_p = [UIImage imageByResourceDrawable:@"btn_bird_camera_p.png"];
    btn_bird_camera = [[UIButton alloc] initWithImage:btn_bird_camera_n selectedImage:btn_bird_camera_p];
    btn_bird_camera.layoutParams.width = CCVLayoutWrapContent;
    btn_bird_camera.layoutParams.height = CCVLayoutWrapContent;
    btn_bird_camera.tag = R_id_btn_brid_camera;
    [lo_camera addSubview:btn_bird_camera];
    
    UIImage *btn_fps_camera_n = [UIImage imageByResourceDrawable:@"btn_fps_camera_n"];
    UIImage *btn_fps_camera_p = [UIImage imageByResourceDrawable:@"btn_fps_camera_p"];
    btn_fps_camera = [[UIButton alloc] initWithImage:btn_fps_camera_n selectedImage:btn_fps_camera_p];
    btn_fps_camera.layoutParams.width = CCVLayoutWrapContent;
    btn_fps_camera.layoutParams.height = CCVLayoutWrapContent;
    btn_fps_camera.tag = R_id_btn_fps_camera;
    
    [lo_camera addSubview:btn_fps_camera];
    
    UIImage *btn_editor_camera_n = [UIImage imageByResourceDrawable:@"btn_editor_camera_n"];
    UIImage *btn_editor_camera_p = [UIImage imageByResourceDrawable:@"btn_editor_camera_p"];
    btn_editor_camera = [[UIButton alloc] initWithImage:btn_editor_camera_n selectedImage:btn_editor_camera_p];
    btn_editor_camera.layoutParams.width = CCVLayoutWrapContent;
    btn_editor_camera.layoutParams.height = CCVLayoutWrapContent;
    btn_editor_camera.tag = R_id_btn_editor_camera;
    
    [lo_camera addSubview:btn_editor_camera];
    
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        lo_camera.layoutParams.marginLeft = [self uiWidthBy:100.0f];
        lo_camera.layoutParams.marginBottom = [self uiHeightBy:100.0f];
        lo_camera.orientation = CCVLayoutOrientationVertical;
        btn_bird_camera.layoutParams.marginTop = [self uiHeightBy:20.0f];
        btn_fps_camera.layoutParams.marginTop = [self uiHeightBy:20.0f];
        btn_editor_camera.layoutParams.marginTop = [self uiHeightBy:20.0f];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        lo_camera.orientation = CCVLayoutOrientationHorizontal;
        btn_bird_camera.layoutParams.marginLeft = [self uiWidthBy:20.0f];
        btn_fps_camera.layoutParams.marginLeft = [self uiWidthBy:20.0f];
        btn_editor_camera.layoutParams.marginLeft = [self uiWidthBy:20.0f];
    }
    
    rg_camera = [[CCVRadioViewGroup alloc] init];
    [rg_camera addView:btn_bird_camera];
    [rg_camera addView:btn_fps_camera];
    [rg_camera addView:btn_editor_camera];
    [rg_camera addView:btn_VR_camera];
    rg_camera.onChecked =  (^(BOOL checked, NSUInteger index, UIView* view){
        UIButton *button = (UIButton*)view;
        [button setSelected:checked];
    });
    rg_camera.checkedView = btn_editor_camera; // 初始角度在editor上
    
    [self.viewEventBinder bindEventsToView:btn_bird_camera willBindSubviews:NO andFilter:nil];
    [self.viewEventBinder bindEventsToView:btn_fps_camera willBindSubviews:NO andFilter:nil];
    [self.viewEventBinder bindEventsToView:btn_editor_camera willBindSubviews:NO andFilter:nil];
    [self.viewEventBinder bindEventsToView:btn_VR_camera willBindSubviews:NO andFilter:nil];
    
#pragma mark UI ProductList
    CCVRelativeLayout *lo_product_list = [CCVRelativeLayout layout];
    lo_product_list.tag = R_id_lo_product_list;
    lo_product_list.layoutParams.width = [self uiWidthBy:520.0f] + mModel.rightMenuWidth;
    lo_product_list.layoutParams.height = CCVLayoutMatchParent;
    lo_product_list.layoutParams.alignment = CCVLayoutAlignParentRight;
    [lo_PlanEdit addSubview:lo_product_list];
    lo_product_list.hidden = YES;
    
    UIImage *bg_menu_right = [UIImage imageByResourceDrawable:@"bg_list_info"];
    UIImageView *bg_product_list = [[UIImageView alloc] initWithImage:bg_menu_right];
    bg_product_list.layoutParams.width = CCVLayoutMatchParent;
    bg_product_list.layoutParams.height = CCVLayoutMatchParent;
//    bg_product_list.layoutParams.alignment = CCVLayoutAlignParentRight;
    [lo_product_list addSubview:bg_product_list];
    
    UIImage *img_vertical_line_n = [UIImage imageByResourceDrawable:@"img_vertical_line"];
    UIImageView *img_vertical_line = [[UIImageView alloc] initWithImage:img_vertical_line_n];
    img_vertical_line.layoutParams.width = CCVLayoutWrapContent;
    
#pragma mark UI ItemEdit
    CCVRelativeLayout *lo_item_edit = [CCVRelativeLayout layout];
    lo_item_edit.tag = R_id_lo_item_edit;
    lo_item_edit.layoutParams.width = [self uiWidthBy:521.0f] + mModel.rightMenuWidth;
    lo_item_edit.layoutParams.height = CCVLayoutMatchParent;
    lo_item_edit.layoutParams.alignment = CCVLayoutAlignParentRight;
    [lo_PlanEdit addSubview:lo_item_edit];
    lo_item_edit.hidden = YES;
    
    UIImageView *bg_item_edit = [[UIImageView alloc] initWithImage:bg_menu_right];
    bg_item_edit.layoutParams.width = [self uiWidthBy:503.0f] + mModel.rightMenuWidth;
    bg_item_edit.layoutParams.height = CCVLayoutMatchParent;
    bg_item_edit.layoutParams.alignment = CCVLayoutAlignParentRight;
    [lo_item_edit addSubview:bg_item_edit];
    
#pragma mark UI ProductInfo
    CCVRelativeLayout *lo_product_info = [CCVRelativeLayout layout];
    lo_product_info.tag = R_id_lo_product_info;
    lo_product_info.layoutParams.width = [self uiWidthBy:521.0f] + mModel.rightMenuWidth;
    lo_product_info.layoutParams.height = CCVLayoutMatchParent;
    lo_product_info.layoutParams.alignment = CCVLayoutAlignParentRight;
    [lo_PlanEdit addSubview:lo_product_info];
    lo_product_info.hidden = YES;
    
    UIImageView *bg_product_info = [[UIImageView alloc] initWithImage:bg_menu_right];
    bg_product_info.layoutParams.width = [self uiWidthBy:503.0f] + mModel.rightMenuWidth;
    bg_product_info.layoutParams.height = CCVLayoutMatchParent;
    bg_product_info.layoutParams.alignment = CCVLayoutAlignParentRight;
    [lo_product_info addSubview:bg_product_info];
    
#pragma mark 右边竖条菜单容器
    // 右边竖条菜单
    CCVLinearLayout *lo_menu_right_gray_linear = [CCVLinearLayout layout];
    lo_menu_right_gray_linear.tag = R_id_lo_menu_right_gray;
    lo_menu_right_gray_linear.layoutParams.width = mModel.rightMenuWidth;
    lo_menu_right_gray_linear.layoutParams.height = CCVLayoutMatchParent;
    lo_menu_right_gray_linear.layoutParams.alignment = CCVLayoutAlignParentRight;
    lo_menu_right_gray_linear.orientation = CCVLayoutOrientationVertical;
    lo_menu_right_gray_linear.backgroundColor = [UIColor clearColor];
    [lo_PlanEdit addSubview:lo_menu_right_gray_linear];
    
    // 结构列表按钮
    btn_build = [CCVRelativeLayout layout];
    btn_build.tag = R_id_btn_build_list;
    btn_build.layoutParams.width = CCVLayoutMatchParent;
    btn_build.layoutParams.height = CCVLayoutWrapContent;
    [lo_menu_right_gray_linear addSubview:btn_build];
    UIImage *btn_build_n = [UIImage imageByResourceDrawable:@"btn_build_n.png"];
    img_build = [[UIImageView alloc] initWithImage:btn_build_n];
    img_build.tag = R_id_img_build_list;
    img_build.layoutParams.width = CCVLayoutWrapContent;
    img_build.layoutParams.height = CCVLayoutWrapContent;
    img_build.layoutParams.alignment = CCVLayoutAlignCenterHorizontal;
    [btn_build addSubview:img_build];
    
    // 客厅按钮
    btn_living_room = [CCVRelativeLayout layout];
    btn_living_room.tag = R_id_btn_living_room;
    btn_living_room.layoutParams.width = CCVLayoutMatchParent;
    btn_living_room.layoutParams.height = CCVLayoutWrapContent;
    [lo_menu_right_gray_linear addSubview:btn_living_room];
    UIImage *btn_living_room_n = [UIImage imageByResourceDrawable:@"btn_living_room_n.png"];
    img_living_room = [[UIImageView alloc] initWithImage:btn_living_room_n];
    img_living_room.tag = R_id_img_living_room;
    img_living_room.layoutParams.width = CCVLayoutWrapContent;
    img_living_room.layoutParams.height = CCVLayoutWrapContent;
    img_living_room.layoutParams.alignment = CCVLayoutAlignCenterHorizontal;
    [btn_living_room addSubview:img_living_room];
    
    // 卧室按钮
    btn_bedroom = [CCVRelativeLayout layout];
    btn_bedroom.tag = R_id_btn_bedroom;
    btn_bedroom.layoutParams.width = CCVLayoutMatchParent;
    btn_bedroom.layoutParams.height = CCVLayoutWrapContent;
    [lo_menu_right_gray_linear addSubview:btn_bedroom];
    UIImage *btn_bedroom_n = [UIImage imageByResourceDrawable:@"btn_bedroom_n.png"];
    img_bedroom = [[UIImageView alloc] initWithImage:btn_bedroom_n];
    img_bedroom.tag = R_id_img_bedroom;
    img_bedroom.layoutParams.width = CCVLayoutWrapContent;
    img_bedroom.layoutParams.height = CCVLayoutWrapContent;
    img_bedroom.layoutParams.alignment = CCVLayoutAlignCenterHorizontal;
    [btn_bedroom addSubview:img_bedroom];
    
    // 厨房按钮
    btn_kitchen = [CCVRelativeLayout layout];
    btn_kitchen.tag = R_id_btn_kitchen;
    btn_kitchen.layoutParams.width = CCVLayoutMatchParent;
    btn_kitchen.layoutParams.height = CCVLayoutWrapContent;
    [lo_menu_right_gray_linear addSubview:btn_kitchen];
    UIImage *btn_kitchen_n = [UIImage imageByResourceDrawable:@"btn_kitchen_n.png"];
    img_kitchen = [[UIImageView alloc] initWithImage:btn_kitchen_n];
    img_kitchen.tag = R_id_img_kitchen;
    img_kitchen.layoutParams.width = CCVLayoutWrapContent;
    img_kitchen.layoutParams.height = CCVLayoutWrapContent;
    img_kitchen.layoutParams.alignment = CCVLayoutAlignCenterHorizontal;
    [btn_kitchen addSubview:img_kitchen];
    
    // 卫生间按钮
    btn_toilet = [CCVRelativeLayout layout];
    btn_toilet.tag = R_id_btn_toilet;
    btn_toilet.layoutParams.width = CCVLayoutMatchParent;
    btn_toilet.layoutParams.height = CCVLayoutWrapContent;
    [lo_menu_right_gray_linear addSubview:btn_toilet];
    UIImage *btn_toilet_n = [UIImage imageByResourceDrawable:@"btn_toilet_n.png"];
    img_toilet = [[UIImageView alloc] initWithImage:btn_toilet_n];
    img_toilet.tag = R_id_img_toilet;
    img_toilet.layoutParams.width = CCVLayoutWrapContent;
    img_toilet.layoutParams.height = CCVLayoutWrapContent;
    img_toilet.layoutParams.alignment = CCVLayoutAlignCenterHorizontal;
    [btn_toilet addSubview:img_toilet];
    
    // 报价单按钮
    btn_order = [CCVRelativeLayout layout];
    btn_order.tag = R_id_btn_order;
    btn_order.layoutParams.width = CCVLayoutMatchParent;
    btn_order.layoutParams.height = CCVLayoutWrapContent;
    //btn_order.layoutParams.alignment = CCVLayoutAlignParentBottomRight;
    [lo_menu_right_gray_linear addSubview:btn_order];
    UIImage *btn_order_n = [UIImage imageByResourceDrawable:@"btn_order_n.png"];
    img_order = [[UIImageView alloc] initWithImage:btn_order_n];
    img_order.tag = R_id_img_order;
    img_order.layoutParams.width = CCVLayoutWrapContent;
    img_order.layoutParams.height = CCVLayoutWrapContent;
    img_order.layoutParams.alignment = CCVLayoutAlignCenterHorizontal;
    [btn_order addSubview:img_order];
    
    CCVRelativeLayout *bg_right_lay = [CCVRelativeLayout layout];
    bg_right_lay.layoutParams.width = CCVLayoutMatchParent;
    bg_right_lay.layoutParams.height = CCVLayoutMatchParent;
    bg_right_lay.layoutParams.weight = 1;
    bg_right_lay.layoutParams.below = btn_order;
    [lo_menu_right_gray_linear addSubview:bg_right_lay];
    UIImageView *bg_menu_right_red = [[UIImageView alloc] initWithImage:[UIImage imageByResourceDrawable:@"bg_menu_right_red.png"]];
    bg_menu_right_red.layoutParams.width = CCVLayoutMatchParent;
    bg_menu_right_red.layoutParams.height = CCVLayoutMatchParent;
    [bg_right_lay addSubview:bg_menu_right_red];
    
#pragma mark loading界面
    lo_load = [CCVRelativeLayout layout];
    lo_load.tag = R_id_lo_loading;
    lo_load.layoutParams.width = CCVLayoutMatchParent;
    lo_load.layoutParams.height = CCVLayoutMatchParent;
    lo_load.hidden = YES;
    [lo_PlanEdit addSubview:lo_load];
    [self createLoadingAnimationView:lo_load];
    
#pragma mark 物件上的UI
    CCVFrameLayout *lo_control_fm = [CCVFrameLayout layout];
    lo_control_fm.tag = R_id_lo_control;
    lo_control_fm.layoutParams.width = CCVLayoutMatchParent;
    lo_control_fm.layoutParams.height = CCVLayoutMatchParent;
    lo_control_fm.backgroundColor = [UIColor clearColor];
    lo_control_fm.hidden = YES;
    [lo_PlanEdit addSubview:lo_control_fm];
    
#pragma mark 物件拖动frame
    CCVFrameLayout *lo_move = [CCVFrameLayout layout];
    lo_move.tag = R_id_lo_move;
    lo_move.layoutParams.width = CCVLayoutMatchParent;
    lo_move.layoutParams.height = CCVLayoutMatchParent;
    lo_move.backgroundColor = [UIColor clearColor];
    lo_move.hidden = YES;
    [lo_PlanEdit addSubview:lo_move];
    
#pragma mark 为了截屏做的白屏
    lo_screenshot = [CCVFrameLayout layout];
    lo_screenshot.layoutParams.width = CCVLayoutMatchParent;
    lo_screenshot.layoutParams.height = CCVLayoutMatchParent;
    lo_screenshot.backgroundColor = [UIColor whiteColor];
    lo_screenshot.alpha = 0.5f;
    lo_screenshot.hidden = YES;
    [lo_PlanEdit addSubview:lo_screenshot];
    
    crl_loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    crl_loading.layoutParams.alignment = CCVLayoutAlignCenterInParent;
    [lo_screenshot addSubview:crl_loading];
    
#pragma mark 交互动作
    //左边按钮
    btn_homepage.userInteractionEnabled = YES;
    [self.gestureEventBinder bindEventsWithType:CCVGestureTypeSingleTap toView:btn_homepage willBindSubviews:NO andFilter:nil];
    btn_undo.userInteractionEnabled = YES;
    [self.gestureEventBinder bindEventsWithType:CCVGestureTypeSingleTap toView:btn_undo willBindSubviews:NO andFilter:nil];
    btn_redo.userInteractionEnabled = YES;
    [self.gestureEventBinder bindEventsWithType:CCVGestureTypeSingleTap toView:btn_redo willBindSubviews:NO andFilter:nil];
    btn_screenshot.userInteractionEnabled = YES;
    [self.gestureEventBinder bindEventsWithType:CCVGestureTypeSingleTap toView:btn_screenshot willBindSubviews:NO andFilter:nil];
    
    //右边按钮
    btn_build.clickable = YES;
    [self.viewEventBinder bindEventsToView:btn_build willBindSubviews:NO andFilter:nil];
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
    
    isFPS = NO;
    
    return lo_PlanEdit;
}

- (BOOL)onPreCondition {
    return mModel.currentPlan != nil;
}

- (void)onStateEnter:(NSDictionary *)data{
    [super onStateEnter:data];
    [self updateUndoRedoState];
    
    btn_undo.userInteractionEnabled = YES;
    btn_redo.userInteractionEnabled = YES;
    rg_camera.checkedView = btn_editor_camera; // 默认进来在editor视角
    [mModel.photographer changeToEditorCamera:1000];
//    mModel.cameraPosition = mModel.photographer.root.transform;
    
    
    BOOL dirty = mModel.currentPlan.fileDirty && mModel.currentPlan.sceneDirty;

    if (mCurrentPlan != mModel.currentPlan || dirty) {
        lo_load.hidden = NO;
        [self startLoadingAnimation];
        [mModel.prePlan destroyAllObjects];
        Plan* currentPlan = mModel.currentPlan;
        CCVSceneLoaderOnLoadingListener* listener = [[CCVSceneLoaderOnLoadingListener alloc] init];
        listener.onFinish = (^(id<ICVFile> file, id<ICVGameObject> parent, id<ICVGameObject> object){
            [mModel.currentPlan showOverlap];
            lo_load.hidden = YES;
            [self stopLoadingAnimation];
        });
        listener.onFailed = (^(id<ICVFile> file, id<ICVGameObject> parent, NSError* error) {
            lo_load.hidden = YES;
            [self stopLoadingAnimation];
        });
        if (currentPlan.isCreate) {
            [currentPlan loadItem:mModel.roomItem position:CCCVector3Zero() orientation:CCCQuaternionIdentity() async:YES listener:listener];
            currentPlan.isCreate = NO;
        } else {
            id<ICVGameContext> context = mModel.currentContext;
            id<ICVGameScene> scene = mModel.currentScene;
            PlanLoader* planLoader = (PlanLoader*)[context.sceneLoaderManager getLoaderForFile:currentPlan.scene];
            planLoader.plan = mModel.currentPlan;
            [planLoader loadFile:currentPlan.scene parent:scene.root params:nil async:YES listener:listener];
        }
    }
    
    mCurrentPlan = mModel.currentPlan;
    if (mModel.currentPlan.architectureObject == nil) {
        mModel.gridsObject.visible = YES;
    }
    mModel.itemSelectAndMoveBehaviour.enabled = YES;//进入状态把移动的behaviour开启
    
}

- (void)onStateLeave {
    mModel.itemSelectAndMoveBehaviour.enabled = NO;//离开状态把移动的behaviour关闭
    [super onStateLeave];
}

- (void)updateMenuButton {
    tv_build.textColor = [UIColor whiteColor];
    tv_living_room.textColor = [UIColor whiteColor];
    tv_bedroom.textColor = [UIColor whiteColor];
    tv_kitchen.textColor = [UIColor whiteColor];
    tv_toilet.textColor = [UIColor whiteColor];
    tv_order.textColor = [UIColor whiteColor];
    
    img_build.image = [UIImage imageByResourceDrawable:@"btn_build_n.png"];
    img_living_room.image = [UIImage imageByResourceDrawable:@"btn_living_room_n"];
    img_bedroom.image = [UIImage imageByResourceDrawable:@"btn_bedroom_n"];
    img_kitchen.image = [UIImage imageByResourceDrawable:@"btn_kitchen_n"];
    img_toilet.image = [UIImage imageByResourceDrawable:@"btn_toilet_n"];
    img_order.image = [UIImage imageByResourceDrawable:@"btn_order_n"];
}

#pragma mark touch事件
- (BOOL)onTouchUp:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    UIImage *btn_menu_right_selected = [UIImage imageByResourceDrawable:@"btn_right_menu_selected"];
    switch (touch.view.tag) {
        case R_id_btn_brid_camera:{
            if ([[self.subMachine getNameOfState:self.subMachine.currentState] isEqualToString:[States CameraFPS]]) {
                [self.subMachine revertState];
            }
            isFPS = NO;
            rg_camera.checkedView = touch.view;
            [mModel.photographer changeToBirdCamera:1000];
            break;
        }
        case R_id_btn_fps_camera:{
            isFPS = YES;
            rg_camera.checkedView = touch.view;
            [self.subMachine changeStateTo:[States CameraFPS]];
            break;
        }
        case R_id_btn_editor_camera:{
            if ([[self.subMachine getNameOfState:self.subMachine.currentState] isEqualToString:[States CameraFPS]]) {
                [self.subMachine revertState];
            }
            isFPS = NO;
            rg_camera.checkedView = touch.view;
            [mModel.photographer changeToEditorCamera:1000];
            break;
        }
        case R_id_btn_vr_camera:{
            if ([[self.subMachine getNameOfState:self.subMachine.currentState] isEqualToString:[States CameraFPS]]) {
                [self.subMachine revertState];
            }
            isFPS = NO;
            rg_camera.checkedView = btn_editor_camera;
            [self.subMachine changeStateTo:[States CameraVR]];
            break;
        }
        case R_id_btn_build_list: {
            [self besideVRCamera];
            [self.subMachine changeStateTo:[PlanEditInit StateName]];
            btn_build.backgroundColor = [UIColor clearColor];
            [self updateMenuButton];
//            tv_build.textColor = [UIColor colorWithARGB:R_color_right_menu_label_textcolor];
            img_build.image = [UIImage imageByResourceDrawable:@"btn_build_p.png"];
            mModel.currentArea = AreaArchitecture;
            [self.subMachine changeStateTo:[States ProductList]];
            break;
        }
        case R_id_btn_living_room: {
            [self besideVRCamera];
            [self.subMachine changeStateTo:[PlanEditInit StateName]];
            btn_living_room.backgroundColor = [UIColor clearColor];
            [self updateMenuButton];
//            tv_living_room.textColor = [UIColor colorWithARGB:R_color_right_menu_label_textcolor];
            img_living_room.image = [UIImage imageByResourceDrawable:@"btn_living_room_p"];
            mModel.currentArea = AreaLivingRoom;
            [self.subMachine changeStateTo:[States ProductList]];
            break;
        }
        case R_id_btn_bedroom: {
            [self besideVRCamera];
            [self.subMachine changeStateTo:[PlanEditInit StateName]];
            btn_bedroom.backgroundColor = [UIColor clearColor];
            [self updateMenuButton];
//            tv_bedroom.textColor = [UIColor colorWithARGB:R_color_right_menu_label_textcolor];
            img_bedroom.image = [UIImage imageByResourceDrawable:@"btn_bedroom_p"];
            mModel.currentArea = AreaBedroom;
            [self.subMachine changeStateTo:[States ProductList]];
            break;
        }
        case R_id_btn_kitchen: {
            [self besideVRCamera];
            [self.subMachine changeStateTo:[PlanEditInit StateName]];
            btn_kitchen.backgroundColor = [UIColor clearColor];
            [self updateMenuButton];
//            tv_kitchen.textColor = [UIColor colorWithARGB:R_color_right_menu_label_textcolor];
            img_kitchen.image = [UIImage imageByResourceDrawable:@"btn_kitchen_p"];
            mModel.currentArea = AreaKitchen;
            [self.subMachine changeStateTo:[States ProductList]];
            break;
        }
        case R_id_btn_toilet: {
            [self besideVRCamera];
            [self.subMachine changeStateTo:[PlanEditInit StateName]];
            btn_toilet.backgroundColor = [UIColor clearColor];
            [self updateMenuButton];
//            tv_toilet.textColor = [UIColor colorWithARGB:R_color_right_menu_label_textcolor];
            img_toilet.image = [UIImage imageByResourceDrawable:@"btn_toilet_p"];
            mModel.currentArea = AreaToilet;
            [self.subMachine changeStateTo:[States ProductList]];
            break;
        }
        case R_id_btn_order:{
            [self.subMachine changeStateTo:[States OrderList]];
        }
    }
    return YES;
}

- (void)besideVRCamera {
    if (isFPS) {
        rg_camera.checkedView = btn_editor_camera;
        [mModel.photographer changeToEditorCamera:1000];
    }
}

- (void)onSingleTap:(UITapGestureRecognizer *)singleTap {
    switch (singleTap.view.tag) {
        case R_id_btn_homepage: {
            id<ICVGameEngine> engine = mModel.currentContext.engine;
            id<ICVRenderTimer> renderTimer = engine.renderTimer;
            CCVOnSnapshotListener* listener = [[CCVOnSnapshotListener alloc] init];
            listener.onSnapshot = (^(UIImage* screenshot) {
                Plan* plan = nil;
                if (mModel.currentPlan.sceneDirty) {
                    if (mModel.currentPlan.isSuit) {
                        plan = [mModel.project addSuitPlanToLocal:mModel.currentPlan];
                        plan.isSuit = NO;
                        [plan saveScene];
                        id<ICVFile> file = [CCVFile fileWithType:CCVFileTypeDocument path:@"plans.fit"];
                        LocalPlanTable* pt = [[LocalPlanTable alloc] initWithFileType:LocalPlanTableFileTypeDocument model:mModel bundle:nil]; // 保存的路径在沙盒中
                        [pt saveFile:file records:mModel.project.plans];
                        [plan destroyAllObjects];
                    } else {
                        plan = mModel.currentPlan;
                        [plan saveScene];
                    }
                } else {
                    plan = mModel.currentPlan;
                }
                [UIImagePNGRepresentation(screenshot) writeToFile:plan.preview.realPath atomically:YES];
                [[CCVCorePluginSystem instance].imageCache removeBy:plan.preview];
                [mModel.commandMachine clear];
                [self.subMachine changeStateTo:[PlanEditInit StateName] pushState:NO];
                [self.parentMachine changeStateTo:[States DIY] pushState:NO];
            });
            CGRect frame = engine.frame.view.frameInPixels;
            CCCRect rect = CCCRectMake(0.0f, 0.0f, frame.size.width, frame.size.height);
            [renderTimer snapshotByRect:rect async:YES listener:listener];
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
            id<ICVGameEngine> engine = mModel.currentContext.engine;
            id<ICVRenderTimer> renderTimer = engine.renderTimer;
            CCVOnSnapshotListener* listener = [[CCVOnSnapshotListener alloc] init];
            listener.onSnapshot = (^(UIImage* screenshot) {
                NSLog(@"screenshot");
                UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil);
                lo_screenshot.hidden = YES;
                [crl_loading stopAnimating];
            });
            CGRect frame = engine.frame.view.frameInPixels;
            CCCRect rect = CCCRectMake(0.0f, 0.0f, frame.size.width, frame.size.height);
            lo_screenshot.hidden = NO;
            [crl_loading startAnimating];
            [renderTimer snapshotByRect:rect async:YES listener:listener];
            [CCVCoreUtils playCameraSound];
            break;
        }
        default:
            break;
    }
}

@end
