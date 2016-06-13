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
#import <jw/JCMath.h>
#import <jw/JWJson.h>

#import "ProductList.h"
#import "ProductInfo.h"
#import "OrderList.h"
#import "ItemEdit.h"
#import "ItemTools.h"
#import "ProductLink.h"
#import "ItemAR.h"
#import "LocalPlanTable.h"
#import "ArchitureEdit.h"
#import "CameraFPS.h"
#ifdef USE_MOJING
#import "CameraVR.h"
#endif
#import "GlassListAdapter.h"
#import "Glass.h"

#import "UIButton+GlassButton.h"

@interface PlanEditInit : BaseState {
    JWRelativeLayout *btn_build;
    UIImageView *img_build;
    UILabel *tv_build;
    
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

@implementation PlanEditInit

+ (NSString *)StateName {
    return @"PlanEditInit";
}

- (UIView *)onCreateView:(UIView *)parent {
    btn_build = (JWRelativeLayout*)[parent viewWithTag:R_id_btn_build_list];
    img_build = (UIImageView*)[parent viewWithTag:R_id_img_build_list];
    tv_build = (UILabel*)[parent viewWithTag:R_id_tv_build_list];
    
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
    if(mModel.isFPS) {
        mModel.itemSelectAndMoveBehaviour.selectedMask = SelectedMaskAllArchs | SelectedMaskAllItems;
    } else {
        mModel.itemSelectAndMoveBehaviour.selectedMask = SelectedMaskAllArchsExceptCeil | SelectedMaskAllItemsExceptTop;
    }
    mModel.itemSelectAndMoveBehaviour.onSelect = (^(id<JIGameObject> object) {
        if (object == nil) {
            return;
        }
        ItemInfo *it = [Data getItemInfoFromInstance:object];
        if (it.type == ItemTypeItem) {
            NSString *a = [object debugDescription];
            NSLog(@"%@",a);
            [weakSelf.parentMachine changeStateTo:[States ItemEdit]];
        } else if (it.type != ItemTypeItem && it.type != ItemTypeCeil) {
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
    id<JIGameObject> mSelectObject;
    UIProgressView* pb_progress;
    BOOL mHouseOk;
    
    JWRelativeLayout *btn_build;
    UIImageView* img_build;
    UILabel *tv_build;
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
    
    JWLinearLayout *lo_camera;
    UIButton *btn_bird_camera;
    UIButton *btn_fps_camera;
    UIButton *btn_editor_camera;
    UIButton *btn_VR_camera;
    UIButton *btn_fps_switch;
    
    JWRadioViewGroup *rg_camera;
    
    JWFrameLayout *lo_screenshot;
    JWFrameLayout *lo_load;
    
    UIActivityIndicatorView *crl_loading;
    
    JWRelativeLayout *lo_glassMenu; // 选择VR镜片的菜单容器
    JWCollectionView *cv_glassList;
    GlassListAdapter *glassAdapter;
    NSMutableArray *glassItems;
    NSInteger glassIndex;
    
    Plan *mCurrentPlan;
    BOOL isFPS;
    id<JIGameObject> itemSelectAndMoveObject;
    ItemSelectAndMoveBehaviour* itemSelectAndMoveBehaviour;
    
    JWFrameLayout *lo_menu_right_gray;
    JWFrameLayout *lo_menu_edu;
}

@end

@implementation PlanEdit

- (void)onCreated {
    [self.subMachine addState:[[PlanEditInit alloc] initWithModel:mModel] withName:[PlanEditInit StateName]];
    [self.subMachine addState:[[ProductList alloc]initWithModel:mModel] withName:[States ProductList]];
    [self.subMachine addState:[[ProductInfo alloc]initWithModel:mModel] withName:[States ProductInfo]];
    [self.subMachine addState:[[OrderList alloc]initWithModel:mModel] withName:[States OrderList]];
    [self.subMachine addState:[[ItemEdit alloc]initWithModel:mModel] withName:[States ItemEdit]];
    [self.subMachine addState:[[ItemTools alloc] initWithModel:mModel] withName:[States ItemTools]];
    [self.subMachine addState:[[ProductLink alloc] initWithModel:mModel] withName:[States ItemLink]];
    [self.subMachine addState:[[ArchitureEdit alloc] initWithModel:mModel] withName:[States ArchitureEdit]];
    [self.subMachine addState:[[CameraFPS alloc] initWithModel:mModel] withName:[States CameraFPS]];
#ifdef USE_MOJING
    [self.subMachine addState:[[CameraVR alloc] initWithModel:mModel] withName:[States CameraVR]];
#endif
    [self.subMachine changeStateTo:[PlanEditInit StateName]];
    
}

- (UIView *)onCreateView:(UIView *)parent{
    JWRelativeLayout *lo_PlanEdit = [[JWRelativeLayout alloc] init];
    lo_PlanEdit.layoutParams.width = JWLayoutMatchParent;
    lo_PlanEdit.layoutParams.height = JWLayoutMatchParent;
    [parent addSubview:lo_PlanEdit];
   
    JWRelativeLayout* lo_game_view = (JWRelativeLayout*)[parent viewWithTag:R_id_lo_game_view];
    mModel.lo_game_view = lo_game_view;
    UIView *gameView = (UIView*)[parent viewWithTag:R_id_game_view];
    mModel.gameView = gameView;
    
#pragma mark 左上角胶囊型菜单容器
    JWRelativeLayout *lo_mainMenu1_container = [[JWRelativeLayout alloc] init];
    lo_mainMenu1_container.tag = R_id_lo_mainMenu1_container;
    lo_mainMenu1_container.layoutParams.width = JWLayoutWrapContent;
    lo_mainMenu1_container.layoutParams.height = JWLayoutWrapContent;
    lo_mainMenu1_container.layoutParams.marginLeft = [self uiWidthBy:80.0f];
    lo_mainMenu1_container.layoutParams.marginTop = [self uiHeightBy:80.0f];
    [lo_PlanEdit addSubview:lo_mainMenu1_container];
    
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
    
#pragma mark camera操作
    lo_camera = [JWLinearLayout layout];
    lo_camera.tag = R_id_lo_camera;
    lo_camera.layoutParams.width = JWLayoutWrapContent;
    lo_camera.layoutParams.height = JWLayoutWrapContent;
    lo_camera.layoutParams.marginLeft = [self uiWidthBy:66.0f];
    lo_camera.layoutParams.marginBottom = [self uiHeightBy:50.0f];
    lo_camera.layoutParams.alignment = JWLayoutAlignParentBottomLeft;
    [lo_PlanEdit addSubview:lo_camera];
    
    UIImage *btn_vr_camera_n = [UIImage imageByResourceDrawable:@"btn_vr_camera_n"];
    UIImage *btn_vr_camera_p = [UIImage imageByResourceDrawable:@"btn_vr_camera_p"];
    btn_VR_camera = [[UIButton alloc] initWithImage:btn_vr_camera_n selectedImage:btn_vr_camera_p];
    btn_VR_camera.layoutParams.width = JWLayoutWrapContent;
    btn_VR_camera.layoutParams.height = JWLayoutWrapContent;
    btn_VR_camera.tag = R_id_btn_vr_camera;
    
#pragma mark IPad下VR按钮隐藏
#if 1
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        btn_VR_camera.hidden = YES;
    }
#endif
    
    [lo_camera addSubview:btn_VR_camera];
    
    UIImage *btn_bird_camera_n = [UIImage imageByResourceDrawable:@"btn_bird_camera_n.png"];
    UIImage *btn_bird_camera_p = [UIImage imageByResourceDrawable:@"btn_bird_camera_p.png"];
    btn_bird_camera = [[UIButton alloc] initWithImage:btn_bird_camera_n selectedImage:btn_bird_camera_p];
    btn_bird_camera.layoutParams.width = JWLayoutWrapContent;
    btn_bird_camera.layoutParams.height = JWLayoutWrapContent;
    btn_bird_camera.tag = R_id_btn_brid_camera;
    [lo_camera addSubview:btn_bird_camera];
    
    
    JWLinearLayout *lo_fps_camera = [JWLinearLayout layout];
    lo_fps_camera.layoutParams.width = JWLayoutWrapContent;
    lo_fps_camera.layoutParams.height = JWLayoutWrapContent;
    [lo_camera addSubview:lo_fps_camera];
    
#pragma mark fps switch
    UIImage *btn_fps_camera_n = [UIImage imageByResourceDrawable:@"btn_fps_camera_n"];
    UIImage *btn_fps_camera_p = [UIImage imageByResourceDrawable:@"btn_fps_camera_p"];
    btn_fps_camera = [[UIButton alloc] initWithImage:btn_fps_camera_n selectedImage:btn_fps_camera_p];
    btn_fps_camera.layoutParams.width = JWLayoutWrapContent;
    btn_fps_camera.layoutParams.height = JWLayoutWrapContent;
    btn_fps_camera.tag = R_id_btn_fps_camera;
    
    UIImage *btn_fps_switch_n = [UIImage imageByResourceDrawable:@"btn_manual_n"];
    UIImage *btn_fps_switch_p = [UIImage imageByResourceDrawable:@"btn_manual_p"];
    btn_fps_switch = [[UIButton alloc] initWithImage:btn_fps_switch_n selectedImage:btn_fps_switch_p];
    btn_fps_switch.layoutParams.width = JWLayoutWrapContent;
    btn_fps_switch.layoutParams.height = JWLayoutWrapContent;
    btn_fps_switch.tag = R_id_btn_fps_switch;
    
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        [lo_fps_camera addSubview:btn_fps_camera];
        [lo_fps_camera addSubview:btn_fps_switch];
        lo_fps_camera.orientation = JWLayoutOrientationHorizontal;
        btn_fps_switch.layoutParams.marginLeft = [MesherModel uiWidthBy:20.0f];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        [lo_fps_camera addSubview:btn_fps_switch];
        [lo_fps_camera addSubview:btn_fps_camera];
        lo_fps_camera.orientation = JWLayoutOrientationVertical;
    }
    
    UIImage *btn_editor_camera_n = [UIImage imageByResourceDrawable:@"btn_editor_camera_n"];
    UIImage *btn_editor_camera_p = [UIImage imageByResourceDrawable:@"btn_editor_camera_p"];
    btn_editor_camera = [[UIButton alloc] initWithImage:btn_editor_camera_n selectedImage:btn_editor_camera_p];
    btn_editor_camera.layoutParams.width = JWLayoutWrapContent;
    btn_editor_camera.layoutParams.height = JWLayoutWrapContent;
    btn_editor_camera.tag = R_id_btn_editor_camera;
    
    [lo_camera addSubview:btn_editor_camera];
    
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        lo_camera.layoutParams.marginLeft = [self uiWidthBy:100.0f];
        lo_camera.layoutParams.marginBottom = [self uiHeightBy:100.0f];
        lo_camera.orientation = JWLayoutOrientationVertical;
        btn_bird_camera.layoutParams.marginTop = [self uiHeightBy:40.0f];
        lo_fps_camera.layoutParams.marginTop = [self uiHeightBy:40.0f];
        btn_editor_camera.layoutParams.marginTop = [self uiHeightBy:40.0f];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        lo_camera.orientation = JWLayoutOrientationHorizontal;
        btn_VR_camera.layoutParams.alignment = JWLayoutAlignParentBottom;
        btn_bird_camera.layoutParams.alignment = JWLayoutAlignParentBottom;
        btn_bird_camera.layoutParams.marginLeft = [self uiWidthBy:20.0f];
        lo_fps_camera.layoutParams.marginLeft = [self uiWidthBy:20.0f];
        btn_editor_camera.layoutParams.alignment = JWLayoutAlignParentBottom;
        btn_editor_camera.layoutParams.marginLeft = [self uiWidthBy:20.0f];
    }
    
    rg_camera = [[JWRadioViewGroup alloc] init];
    [rg_camera addView:btn_bird_camera];
    [rg_camera addView:btn_fps_camera];
    [rg_camera addView:btn_editor_camera];
    [rg_camera addView:btn_VR_camera];
    rg_camera.onChecked =  (^(BOOL checked, NSUInteger index, UIView* view){
        UIButton *button = (UIButton*)view;
        [button setSelected:checked];
    });
    rg_camera.checkedView = btn_editor_camera; // 初始角度在editor上
//    mModel.cameraPosition = mModel.photographer.root.transform;
    
    [self.viewEventBinder bindEventsToView:btn_bird_camera willBindSubviews:NO andFilter:nil];
    [self.viewEventBinder bindEventsToView:btn_fps_camera willBindSubviews:NO andFilter:nil];
    [self.viewEventBinder bindEventsToView:btn_editor_camera willBindSubviews:NO andFilter:nil];
    [self.viewEventBinder bindEventsToView:btn_VR_camera willBindSubviews:NO andFilter:nil];
    
#pragma mark 进入VR前的选择菜单
    lo_glassMenu = [JWRelativeLayout layout];
    lo_glassMenu.layoutParams.width = mModel.gameViewWidth;
    lo_glassMenu.layoutParams.height = JWLayoutMatchParent;
    lo_glassMenu.backgroundColor = [UIColor clearColor];
    lo_glassMenu.layoutParams.alignment = JWLayoutAlignParentLeft;
    lo_glassMenu.tag = R_id_lo_glass_view;
    lo_glassMenu.clickable = YES;
    [self.viewEventBinder bindEventsToView:lo_glassMenu willBindSubviews:NO andFilter:nil];
    [lo_PlanEdit addSubview:lo_glassMenu];
    lo_glassMenu.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *swipe;
    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [lo_glassMenu addGestureRecognizer:swipe];
    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [lo_glassMenu addGestureRecognizer:swipe];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    cv_glassList = [[JWCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    cv_glassList.backgroundColor = [UIColor clearColor];
    cv_glassList.layoutParams.width = [MesherModel uiWidthBy:1351.0f];
    cv_glassList.layoutParams.height = [MesherModel uiHeightBy:140.0];
    cv_glassList.layoutParams.alignment = JWLayoutAlignParentBottom | JWLayoutAlignCenterHorizontal;
    cv_glassList.layoutParams.marginBottom = 20;
    cv_glassList.alwaysBounceVertical = NO;
    cv_glassList.showsHorizontalScrollIndicator = NO;
    cv_glassList.showsVerticalScrollIndicator = NO;
    cv_glassList.allowsMultipleSelection = NO;
    [lo_glassMenu addSubview:cv_glassList];
    glassAdapter = [[GlassListAdapter alloc] init];
    cv_glassList.adapter = glassAdapter;

    JWCollectionView *cv_glassList_b = cv_glassList;
    JWRelativeLayout *lo_glassMenu_b = lo_glassMenu;
    id<IMesherModel> model = mModel;
    __weak PlanEdit *weakSelf = self;
    cv_glassList.onItemSelected = ^(NSUInteger position, id item, BOOL selected) {
        //选择镜片
        if (selected) {
            glassIndex = position;
            [cv_glassList_b selectItemAtPosition:position animated:NO scrollPosition:UICollectionViewScrollPositionLeft];
#ifdef USE_MOJING
            model.mojingType = [weakSelf getMojingTypeByPosition:position];
#endif
            lo_glassMenu_b.hidden = YES;
            [weakSelf.subMachine changeStateTo:[States CameraVR]];
        }
    };
    
    if (glassItems == nil) {
        glassItems = [NSMutableArray array];
    }
    
#pragma mark 设置镜片名称&图标
    NSArray *glassNormalImages = @[
                                   [UIImage imageByResourceDrawable:@"bg_mojingII_n"],
                                   [UIImage imageByResourceDrawable:@"bg_mojingIII_n"],
                                   [UIImage imageByResourceDrawable:@"bg_mojingB_n"],
                                   [UIImage imageByResourceDrawable:@"bg_mojingA_n"],
                                   [UIImage imageByResourceDrawable:@"bg_mojingIV_n"],
                                   [UIImage imageByResourceDrawable:@"bg_mojingGY_n"],
                                   [UIImage imageByResourceDrawable:@"bg_mojingXD_n"],
                                   ];
    
    // 图片数组里的每个对象必须真实有效 否则崩
    NSArray *glassHighlightImages = @[
                                      [UIImage imageByResourceDrawable:@"bg_mojingII_h"],
                                      [UIImage imageByResourceDrawable:@"bg_mojingIII_h"],
                                      [UIImage imageByResourceDrawable:@"bg_mojingB_h"],
                                      [UIImage imageByResourceDrawable:@"bg_mojingA_h"],
                                      [UIImage imageByResourceDrawable:@"bg_mojingIV_h"],
                                      [UIImage imageByResourceDrawable:@"bg_mojingGY_h"],
                                      [UIImage imageByResourceDrawable:@"bg_mojingXD_h"],
                             ];
    
    if (glassNormalImages.count == glassHighlightImages.count) {
        for (int i = 0; i < glassNormalImages.count; i++) {
            Glass *glass = [Glass new];
            glass.normalImage = glassNormalImages[i];
            glass.highlightImage = glassHighlightImages[i];
            [glassItems add:glass];
        }
    }
    if (glassItems.count > 0) {
        glassAdapter.data = glassItems;
        [glassAdapter notifyDataSetChanged];
    }

#pragma mark 用按钮设置镜片 已经废弃
#if 0
    UIImageView *bg_glassMenu = [[UIImageView alloc] initWithImage:[UIImage imageByResourceDrawable:@"bg_glassMenu"]];
    bg_glassMenu.layoutParams.width = JWLayoutMatchParent;
    bg_glassMenu.layoutParams.height = JWLayoutMatchParent;
    [lo_glassMenu addSubview:bg_glassMenu];
    
    JWLinearLayout *lo_glassList = [JWLinearLayout layout];
    lo_glassList.layoutParams.width = JWLayoutMatchParent;
    lo_glassList.layoutParams.height = JWLayoutWrapContent;
    lo_glassList.orientation = JWLayoutOrientationVertical;
    [lo_glassMenu addSubview:lo_glassList];
    
    UIImage *bg_glassButton = [UIImage imageByResourceDrawable:@"bg_glass_button_h"];
    UIColor *highlightColor = [UIColor colorWithARGB:R_color_glass_menu_title];
    CGFloat btn_height = [MesherModel uiHeightBy:70.0f];
    
    UIButton *btn_1 = [UIButton createGlassButtonWithTitle:@"暴风魔镜I"
                                            highlightColor:highlightColor
                                            highlightImage:bg_glassButton
                                                       tag:R_id_MojingType2];
    btn_1.layoutParams.width = JWLayoutMatchParent;
    btn_1.layoutParams.height = btn_height;
    [lo_glassList addSubview:btn_1];
    [self.viewEventBinder bindEventsToView:btn_1 willBindSubviews:NO andFilter:nil];
    
    UIButton *btn_2 = [UIButton createGlassButtonWithTitle:@"暴风魔镜III 标准"
                                            highlightColor:highlightColor
                                            highlightImage:bg_glassButton
                                                       tag:R_id_MojingType3Standard];
    btn_2.layoutParams.width = JWLayoutMatchParent;
    btn_2.layoutParams.height = btn_height;
    [lo_glassList addSubview:btn_2];
    btn_2.layoutParams.marginTop = [MesherModel uiHeightBy:10.0];
    [self.viewEventBinder bindEventsToView:btn_2 willBindSubviews:NO andFilter:nil];
    
    UIButton *btn_3 = [UIButton createGlassButtonWithTitle:@"暴风魔镜III PlusB"
                                            highlightColor:highlightColor
                                            highlightImage:bg_glassButton
                                                       tag:R_id_MojingType3PlusB];
    btn_3.layoutParams.width = JWLayoutMatchParent;
    btn_3.layoutParams.height = [MesherModel uiHeightBy:44.0f];
    [lo_glassList addSubview:btn_3];
    btn_3.layoutParams.marginTop = [MesherModel uiHeightBy:10.0];
    [self.viewEventBinder bindEventsToView:btn_3 willBindSubviews:NO andFilter:nil];
    
    UIButton *btn_4 = [UIButton createGlassButtonWithTitle:@"暴风魔镜III PlusA"
                                            highlightColor:highlightColor
                                            highlightImage:bg_glassButton
                                                       tag:R_id_MojingType3PlusA];
    btn_4.layoutParams.width = JWLayoutMatchParent;
    btn_4.layoutParams.height = btn_height;
    [lo_glassList addSubview:btn_4];
    btn_4.layoutParams.marginTop = [MesherModel uiHeightBy:10.0];
    [self.viewEventBinder bindEventsToView:btn_4 willBindSubviews:NO andFilter:nil];
    
    UIButton *btn_5 = [UIButton createGlassButtonWithTitle:@"暴风魔镜IV"
                                            highlightColor:highlightColor
                                            highlightImage:bg_glassButton
                                                       tag:R_id_MojingType4];
    btn_5.layoutParams.width = JWLayoutMatchParent;
    btn_5.layoutParams.height = btn_height;
    [lo_glassList addSubview:btn_5];
    btn_5.layoutParams.marginTop = [MesherModel uiHeightBy:10.0];
    [self.viewEventBinder bindEventsToView:btn_5 willBindSubviews:NO andFilter:nil];
    
    UIButton *btn_6 = [UIButton createGlassButtonWithTitle:@"暴风魔镜 观影镜"
                                            highlightColor:highlightColor
                                            highlightImage:bg_glassButton
                                                       tag:R_id_MojingTypeGuanYingJing];
    btn_6.layoutParams.width = JWLayoutMatchParent;
    btn_6.layoutParams.height = btn_height;
    [lo_glassList addSubview:btn_6];
    btn_6.layoutParams.marginTop = [MesherModel uiHeightBy:10.0];
    [self.viewEventBinder bindEventsToView:btn_6 willBindSubviews:NO andFilter:nil];
    
    UIButton *btn_7 = [UIButton createGlassButtonWithTitle:@"暴风魔镜 XD"
                                            highlightColor:highlightColor
                                            highlightImage:bg_glassButton
                                                       tag:R_id_MojingTypeXiaoD];
    btn_7.layoutParams.width = JWLayoutMatchParent;
    btn_7.layoutParams.height = btn_height;
    [lo_glassList addSubview:btn_7];
    btn_7.layoutParams.marginTop = [MesherModel uiHeightBy:10.0];
    [self.viewEventBinder bindEventsToView:btn_7 willBindSubviews:NO andFilter:nil];
#endif
    
    
#pragma mark 右边竖条菜单容器
    lo_menu_right_gray = (JWFrameLayout*)[parent viewWithTag:R_id_lo_menu_right_gray];
    lo_menu_edu = (JWFrameLayout*)[parent viewWithTag:R_id_lo_menu_edu];
    [lo_PlanEdit addSubview:lo_menu_right_gray];
    
    // 右边竖条菜单
    JWLinearLayout *lo_menu_right_gray_linear = [JWLinearLayout layout];
    lo_menu_right_gray_linear.layoutParams.width = JWLayoutMatchParent;
    lo_menu_right_gray_linear.layoutParams.height = JWLayoutMatchParent;
    lo_menu_right_gray_linear.layoutParams.alignment = JWLayoutAlignCenterHorizontal;
    lo_menu_right_gray_linear.orientation = JWLayoutOrientationVertical;
    [lo_menu_right_gray addSubview:lo_menu_right_gray_linear];
    
    // 结构列表按钮
    btn_build = [JWRelativeLayout layout];
    btn_build.tag = R_id_btn_build_list;
    btn_build.layoutParams.width = JWLayoutMatchParent;
    btn_build.layoutParams.height = JWLayoutWrapContent;
    [lo_menu_right_gray_linear addSubview:btn_build];
    UIImage *btn_build_n = [UIImage imageByResourceDrawable:@"btn_build_n.png"];
    img_build = [[UIImageView alloc] initWithImage:btn_build_n];
    img_build.tag = R_id_img_build_list;
    img_build.layoutParams.width = JWLayoutWrapContent;
    img_build.layoutParams.height = JWLayoutWrapContent;
    img_build.layoutParams.alignment = JWLayoutAlignCenterHorizontal;
    img_build.layoutParams.marginTop = [MesherModel uiHeightBy:10.0f];
    img_build.layoutParams.marginBottom = [MesherModel uiHeightBy:30.0f];
    [btn_build addSubview:img_build];
    tv_build = [UILabel new];
    tv_build.tag = R_id_tv_build_list;
    tv_build.layoutParams.width = JWLayoutWrapContent;
    tv_build.layoutParams.height = JWLayoutWrapContent;
    tv_build.layoutParams.alignment = JWLayoutAlignParentBottom | JWLayoutAlignCenterHorizontal;
    tv_build.layoutParams.marginTop = [MesherModel uiHeightBy:10.0f];
    tv_build.layoutParams.marginBottom = [MesherModel uiHeightBy:10.0f];
    tv_build.text = @"户 型";
    tv_build.textColor = [UIColor whiteColor];
    tv_build.labelTextSize = 8;
    [btn_build addSubview:tv_build];
    
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
    
#pragma mark UI ProductList
    JWRelativeLayout *lo_product_list = [JWRelativeLayout layout];
    lo_product_list.tag = R_id_lo_product_list;
    lo_product_list.layoutParams.width = [self uiWidthBy:520.0f];
    lo_product_list.layoutParams.height = JWLayoutMatchParent;
    lo_product_list.layoutParams.leftOf = lo_menu_right_gray;
    [lo_PlanEdit addSubview:lo_product_list];
    lo_product_list.hidden = YES;
    
    UIImage *bg_menu_right = [UIImage imageByResourceDrawable:@"bg_menu_right"];
    UIImageView *bg_product_list = [[UIImageView alloc] initWithImage:bg_menu_right];
    bg_product_list.layoutParams.width = [self uiWidthBy:520.0f];
    bg_product_list.layoutParams.height = JWLayoutMatchParent;
    [lo_product_list addSubview:bg_product_list];
    
    UIImage *img_vertical_line_n = [UIImage imageByResourceDrawable:@"img_vertical_line"];
    UIImageView *img_vertical_line = [[UIImageView alloc] initWithImage:img_vertical_line_n];
    img_vertical_line.layoutParams.width = JWLayoutWrapContent;
    
#pragma mark UI ProductInfo
    JWRelativeLayout *lo_product_info = [JWRelativeLayout layout];
    lo_product_info.tag = R_id_lo_product_info;
    lo_product_info.layoutParams.width = [self uiWidthBy:521.0f];
    lo_product_info.layoutParams.height = JWLayoutMatchParent;
    lo_product_info.layoutParams.leftOf = lo_menu_right_gray;
    [lo_PlanEdit addSubview:lo_product_info];
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
    lo_load.clickable = YES;
    lo_load.hidden = YES;
    [lo_PlanEdit addSubview:lo_load];
//    [self createLoadingAnimationView:lo_load];
    [self.viewEventBinder bindEventsToView:lo_load willBindSubviews:NO andFilter:nil];
    
#pragma mark 工具界面用
    JWFrameLayout *lo_tool_fm = [JWFrameLayout layout];
    lo_tool_fm.tag = R_id_lo_tool_fm;
    lo_tool_fm.layoutParams.width = JWLayoutMatchParent;
    lo_tool_fm.layoutParams.height = JWLayoutMatchParent;
    lo_tool_fm.backgroundColor = [UIColor clearColor];
    lo_tool_fm.hidden = YES;
    [lo_PlanEdit addSubview:lo_tool_fm];
    
#pragma mark 物件上的UI
    JWFrameLayout *lo_control_fm = [JWFrameLayout layout];
    lo_control_fm.tag = R_id_lo_control;
    lo_control_fm.layoutParams.width = JWLayoutMatchParent;
    lo_control_fm.layoutParams.height = JWLayoutMatchParent;
    lo_control_fm.backgroundColor = [UIColor clearColor];
    lo_control_fm.hidden = YES;
    [lo_PlanEdit addSubview:lo_control_fm];
    
#pragma mark 物件拖动frame
    JWFrameLayout *lo_move = [JWFrameLayout layout];
    lo_move.tag = R_id_lo_move;
    lo_move.layoutParams.width = JWLayoutMatchParent;
    lo_move.layoutParams.height = JWLayoutMatchParent;
    lo_move.backgroundColor = [UIColor clearColor];
    lo_move.hidden = YES;
    [lo_PlanEdit addSubview:lo_move];
    
#pragma mark UI ItemEdit
    JWRelativeLayout *lo_item_edit = [JWRelativeLayout layout];
    lo_item_edit.tag = R_id_lo_item_edit;
    lo_item_edit.layoutParams.width = [self uiWidthBy:521.0f];
    lo_item_edit.layoutParams.height = JWLayoutMatchParent;
    lo_item_edit.layoutParams.leftOf = lo_menu_right_gray;
    [lo_PlanEdit addSubview:lo_item_edit];
    lo_item_edit.hidden = YES;
    //lo_item_edit.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bg_item_edit = [[UIImageView alloc] initWithImage:bg_menu_right];
    bg_item_edit.layoutParams.width = [self uiWidthBy:521.0f];
    bg_item_edit.layoutParams.height = JWLayoutMatchParent;
    [lo_item_edit addSubview:bg_item_edit];
    
#pragma mark 工具
    JWRelativeLayout *lo_tools = [JWRelativeLayout layout];
    lo_tools.tag = R_id_lo_tools;
    lo_tools.layoutParams.width = [self uiWidthBy:521.0f];
    lo_tools.layoutParams.height = JWLayoutMatchParent;
    lo_tools.backgroundColor = [UIColor whiteColor];
    lo_tools.hidden = YES;
    lo_tools.layoutParams.leftOf = lo_menu_right_gray;
    [lo_PlanEdit addSubview:lo_tools];
    
#pragma mark 为了截屏做的白屏
    lo_screenshot = [JWFrameLayout layout];
    lo_screenshot.layoutParams.width = JWLayoutMatchParent;
    lo_screenshot.layoutParams.height = JWLayoutMatchParent;
    lo_screenshot.backgroundColor = [UIColor whiteColor];
    lo_screenshot.alpha = 0.5f;
    lo_screenshot.hidden = YES;
    [lo_PlanEdit addSubview:lo_screenshot];
    
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
    lo_menu_right_gray.hidden = NO;
    lo_menu_edu.hidden = YES;
    
    [mModel.world changeSceneById:mModel.currentScene.Id];
    
    btn_fps_switch.alpha = 0.0f;
    
    [cv_glassList selectItemAtPosition:glassIndex animated:NO scrollPosition:UICollectionViewScrollPositionLeft];
    lo_glassMenu.hidden = YES;
    
    btn_undo.userInteractionEnabled = YES;
    btn_redo.userInteractionEnabled = YES;
    rg_camera.checkedView = btn_editor_camera; // 默认进来在editor视角
    
    [mModel.photographer changeToEditorCamera:1000];
//    mModel.cameraPosition = mModel.photographer.root.transform;
    
    
    BOOL dirty = mModel.currentPlan.fileDirty && mModel.currentPlan.sceneDirty && !mModel.currentPlan.fromAR;

    if (mCurrentPlan != mModel.currentPlan || dirty || mModel.fromInspiration) {
        lo_load.hidden = NO;
//        [self startLoadingAnimation];
        mModel.loadScene = YES;
        [mModel.prePlan destroyAllObjects];
        Plan* currentPlan = mModel.currentPlan;
        JWSceneLoaderOnLoadingListener* listener = [[JWSceneLoaderOnLoadingListener alloc] init];
        listener.onFinish = (^(id<JIFile> file, id<JIGameObject> parent, id<JIGameObject> object){
            [mModel.currentPlan showOverlap];
            lo_load.hidden = YES;
            mModel.loadScene = NO;
        });
        listener.onFailed = (^(id<JIFile> file, id<JIGameObject> parent, NSError* error) {
            lo_load.hidden = YES;
            mModel.loadScene = NO;
        });
        if (currentPlan.isCreate) {
//            [currentPlan loadItem:mModel.roomItem position:JCVector3Zero() orientation:JCQuaternionIdentity() async:YES listener:listener];
            id<JIGameContext> context = mModel.currentContext;
            id<JIGameScene> scene = mModel.currentScene;
            PlanLoader* planLoader = (PlanLoader*)[context.sceneLoaderManager getLoaderForFile:currentPlan.scene];
            planLoader.plan = mModel.currentPlan;
            [planLoader loadFile:currentPlan.scene parent:scene.root params:nil async:YES listener:listener];
            currentPlan.isCreate = NO;
        } else {
            id<JIGameContext> context = mModel.currentContext;
            id<JIGameScene> scene = mModel.currentScene;
            PlanLoader* planLoader = (PlanLoader*)[context.sceneLoaderManager getLoaderForFile:currentPlan.scene];
            planLoader.plan = mModel.currentPlan;
            [planLoader loadFile:currentPlan.scene parent:scene.root params:nil async:YES listener:listener];
        }
        mModel.fromInspiration = NO;
    }
    
    mModel.currentPlan.fromAR = NO;
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
    
    lo_glassMenu.hidden = YES;
    lo_camera.hidden = NO;
}

#pragma mark touch事件
- (BOOL)onTouchUp:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    switch (touch.view.tag) {
        case R_id_btn_brid_camera:{
            if ([[self.subMachine getNameOfState:self.subMachine.currentState] isEqualToString:[States CameraFPS]]) {
                [self.subMachine revertState];
            }
            isFPS = NO;
            rg_camera.checkedView = touch.view;
            [mModel.photographer changeToBirdCamera:1000];
            btn_fps_switch.alpha = 0.0f;
            mModel.isFPS = NO;
            mModel.itemSelectAndMoveBehaviour.selectedMask = SelectedMaskAllArchsExceptCeil | SelectedMaskAllItemsExceptTop;
            [self.subMachine changeStateTo:[PlanEditInit StateName]];
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
            btn_fps_switch.alpha = 0.0f;
            mModel.isFPS = NO;
            mModel.itemSelectAndMoveBehaviour.selectedMask = SelectedMaskAllArchsExceptCeil | SelectedMaskAllItemsExceptTop;
            [self.subMachine changeStateTo:[PlanEditInit StateName]];
            break;
        }
        case R_id_btn_vr_camera:{
            if ([[self.subMachine getNameOfState:self.subMachine.currentState] isEqualToString:[States CameraFPS]]) {
                [self.subMachine revertState];
                [mModel.photographer changeToEditorCamera:1000];
            }
            isFPS = NO;
            rg_camera.checkedView = btn_editor_camera;
            lo_glassMenu.hidden = NO;
            lo_camera.hidden = YES;
            btn_fps_switch.alpha = 0.0f;
            mModel.isFPS = NO;
            mModel.itemSelectAndMoveBehaviour.selectedMask = SelectedMaskAllArchsExceptCeil | SelectedMaskAllItemsExceptTop;
//            [self.subMachine changeStateTo:[States CameraVR]];//TODO
            break;
        }
        case R_id_btn_build_list: {
            [self besideVRCamera];
            [self.subMachine changeStateTo:[PlanEditInit StateName]];
            btn_build.backgroundColor = [UIColor whiteColor];
            [self updateMenuButton];
            tv_build.textColor = [UIColor colorWithARGB:R_color_right_menu_label_textcolor];
            img_build.image = [UIImage imageByResourceDrawable:@"btn_build_p.png"];
            mModel.currentArea = AreaArchitecture;
            [self.subMachine changeStateTo:[States ProductList]];
            break;
        }
        case R_id_btn_living_room: {
            [self besideVRCamera];
            [self.subMachine changeStateTo:[PlanEditInit StateName]];
            btn_living_room.backgroundColor = [UIColor whiteColor];
            [self updateMenuButton];
            tv_living_room.textColor = [UIColor colorWithARGB:R_color_right_menu_label_textcolor];
            img_living_room.image = [UIImage imageByResourceDrawable:@"btn_living_room_p"];
            mModel.currentArea = AreaLivingRoom;
            [self.subMachine changeStateTo:[States ProductList]];
            break;
        }
        case R_id_btn_bedroom: {
            [self besideVRCamera];
            [self.subMachine changeStateTo:[PlanEditInit StateName]];
            btn_bedroom.backgroundColor = [UIColor whiteColor];
            [self updateMenuButton];
            tv_bedroom.textColor = [UIColor colorWithARGB:R_color_right_menu_label_textcolor];
            img_bedroom.image = [UIImage imageByResourceDrawable:@"btn_bedroom_p"];
            mModel.currentArea = AreaBedroom;
            [self.subMachine changeStateTo:[States ProductList]];
            break;
        }
        case R_id_btn_kitchen: {
            [self besideVRCamera];
            [self.subMachine changeStateTo:[PlanEditInit StateName]];
            btn_kitchen.backgroundColor = [UIColor whiteColor];
            [self updateMenuButton];
            tv_kitchen.textColor = [UIColor colorWithARGB:R_color_right_menu_label_textcolor];
            img_kitchen.image = [UIImage imageByResourceDrawable:@"btn_kitchen_p"];
            mModel.currentArea = AreaKitchen;
            [self.subMachine changeStateTo:[States ProductList]];
            break;
        }
        case R_id_btn_toilet: {
            [self besideVRCamera];
            [self.subMachine changeStateTo:[PlanEditInit StateName]];
            btn_toilet.backgroundColor = [UIColor whiteColor];
            [self updateMenuButton];
            tv_toilet.textColor = [UIColor colorWithARGB:R_color_right_menu_label_textcolor];
            img_toilet.image = [UIImage imageByResourceDrawable:@"btn_toilet_p"];
            mModel.currentArea = AreaToilet;
            [self.subMachine changeStateTo:[States ProductList]];
            break;
        }
        case R_id_btn_order:{
            [self.subMachine changeStateTo:[States OrderList]];
            break;
        }
#ifdef USE_MOJING
        case R_id_MojingType2: {
            mModel.mojingType = MojingType2;
            lo_glassMenu.hidden = YES;
            rg_camera.checkedView = btn_editor_camera;
            [self.subMachine changeStateTo:[States CameraVR]];
            break;
        }
        case R_id_MojingType3Standard: {
            mModel.mojingType = MojingType3Standard;
            lo_glassMenu.hidden = YES;
            rg_camera.checkedView = btn_editor_camera;
            [self.subMachine changeStateTo:[States CameraVR]];
            break;
        }
        case R_id_MojingType3PlusB: {
            mModel.mojingType = MojingType3PlusB;
            lo_glassMenu.hidden = YES;
            rg_camera.checkedView = btn_editor_camera;
            [self.subMachine changeStateTo:[States CameraVR]];
            break;
        }
        case R_id_MojingType3PlusA: {
            mModel.mojingType = MojingType3PlusA;
            lo_glassMenu.hidden = YES;
            rg_camera.checkedView = btn_editor_camera;
            [self.subMachine changeStateTo:[States CameraVR]];
            break;
        }
        case R_id_MojingType4: {
            mModel.mojingType = MojingType4;
            lo_glassMenu.hidden = YES;
            rg_camera.checkedView = btn_editor_camera;
            [self.subMachine changeStateTo:[States CameraVR]];
            break;
        }
        case R_id_MojingTypeGuanYingJing: {
            mModel.mojingType = MojingTypeGuanYingJing;
            lo_glassMenu.hidden = YES;
            rg_camera.checkedView = btn_editor_camera;
            [self.subMachine changeStateTo:[States CameraVR]];
            break;
        }
        case R_id_MojingTypeXiaoD: {
            mModel.mojingType = MojingTypeXiaoD;
            lo_glassMenu.hidden = YES;
            rg_camera.checkedView = btn_editor_camera;
            [self.subMachine changeStateTo:[States CameraVR]];
            break;
        }
#endif
        case R_id_lo_glass_view: {
            lo_glassMenu.hidden = YES;
            lo_camera.hidden = NO;
            break;
        }
        case R_id_lo_loading: {
            NSLog(@"loading");
            break;
        }
    }
    return YES;
}

- (void)besideVRCamera {
    if (mModel.autoFPS) {
        rg_camera.checkedView = btn_editor_camera;
        [mModel.photographer changeToEditorCamera:1000];
        btn_fps_switch.alpha = 0.0f;
    }
}

- (void)onSingleTap:(UITapGestureRecognizer *)singleTap {
    switch (singleTap.view.tag) {
        case R_id_btn_homepage: {
            id<JIGameEngine> engine = mModel.currentContext.engine;
            id<JIRenderTimer> renderTimer = engine.renderTimer;
            JWOnSnapshotListener* listener = [[JWOnSnapshotListener alloc] init];
            listener.onSnapshot = (^(UIImage* screenshot) {
                Plan* plan = nil;
                if (mModel.currentPlan.sceneDirty) {
                    JCVector3 position = [mModel.currentCamera.camera.transform positionInSpace:JWTransformSpaceWorld];
                    JCQuaternion q = [mModel.currentCamera.camera.transform orientationInSpace:JWTransformSpaceWorld];
                    PlanCamera *p = [[PlanCamera alloc] init];
                    p.px = position.x;
                    p.py = position.y;
                    p.pz = position.z;
                    p.rw = q.w;
                    p.rx = q.x;
                    p.ry = q.y;
                    p.rz = q.z;
                    mModel.currentPlan.camera = p;
                    if (mModel.currentPlan.isSuit) {
                        plan = [mModel.project addSuitPlanToLocal:mModel.currentPlan];
                        plan.isSuit = NO;
                        [plan saveScene];
                        id<JIFile> file = [JWFile fileWithType:JWFileTypeDocument path:@"plans.fit"];
                        LocalPlanTable* pt = [[LocalPlanTable alloc] initWithFileType:LocalPlanTableFileTypeDocument model:mModel bundle:nil]; // 保存的路径在沙盒中
                        [pt saveFile:file records:mModel.project.plans];
                        [plan destroyAllObjects];
                        mModel.currentPlan.isCreatedPlan = YES;
                    } else {
                        plan = mModel.currentPlan;
                        [plan saveScene];
                    }
                } else {
                    plan = mModel.currentPlan;
                }
                [UIImagePNGRepresentation(screenshot) writeToFile:plan.preview.realPath atomically:YES];
                [[JWCorePluginSystem instance].imageCache removeBy:plan.preview];
                [mModel.commandMachine clear];
                [self.subMachine changeStateTo:[PlanEditInit StateName] pushState:NO];
                [self.parentMachine changeStateTo:[States DIY] pushState:NO];
            });
            CGRect frame = engine.frame.view.frameInPixels;
            JCRect rect = JCRectMake(0.0f, 0.0f, frame.size.width, frame.size.height);
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
            JCRect rect = JCRectMake(0.0f, 0.0f, frame.size.width, frame.size.height);
            lo_screenshot.hidden = NO;
            [crl_loading startAnimating];
            [renderTimer snapshotByRect:rect async:YES listener:listener];
            [JWCoreUtils playCameraSound];
            break;
        }
        default:
            break;
    }
}

#ifdef USE_MOJING
- (MojingType)getMojingTypeByPosition:(NSUInteger)position {
    MojingType mojingType;
    switch (position) {
        case 0:{
            mojingType = MojingType2;
            break;
        }
        case 1:{
            mojingType = MojingType3Standard;
            break;
        }
        case 2:{
            mojingType = MojingType3PlusB;
            break;
        }
        case 3:{
            mojingType = MojingType3PlusA;
            break;
        }
        case 4:{
            mojingType = MojingType4;
            break;
        }
        case 5:{
            mojingType = MojingTypeGuanYingJing;
            break;
        }
        case 6:{
            mojingType = MojingTypeXiaoD;
            break;
        }
        default:
            mojingType = MojingTypeUnknown;
            break;
    }
    return mojingType;
}
#endif

- (void)swipe:(UISwipeGestureRecognizer*)swipe {
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        glassIndex--;
        if (glassIndex < 0) {
            glassIndex = 0;
        }
        [cv_glassList selectItemAtPosition:glassIndex animated:YES scrollPosition:UICollectionViewScrollPositionLeft];
    }else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        glassIndex++;
        if (glassIndex > glassItems.count - 1) {
            glassIndex = glassItems.count - 1;
        }
        [cv_glassList selectItemAtPosition:glassIndex animated:YES scrollPosition:UICollectionViewScrollPositionLeft];
    }
}

@end
