//
//  TutorialPlanEdit.m
//  project_mesher
//
//  Created by mac zdszkj on 16/5/16.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "TutorialPlanEdit.h"
#import "MesherModel.h"
#import "GamePhotographer.h"
#import "Plan.h"
#import "PlanLoader.h"
#import "LocalPlanTable.h"
#ifdef USE_MOJING
#import "CameraVR.h"
#endif
#import "GlassListAdapter.h"
#import "Glass.h"

#import "UIButton+GlassButton.h"

#import "TutorialPlanEditAddItem.h"
#import "TutorialPlanEditItemEdit.h"
#import "TutorialPlanEditChangeToBirdCamera.h"
#import "TutorialPlanEditChangeToEditorCamera.h"
#import "TutorialPlanEditScreenshot.h"
#import "TutorialPlanEditFinish.h"

@interface TutorialPlanEdit() {
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
    
    JWRelativeLayout *lo_launchScreen;
    UIImageView *img_launchScreen;
    
    JWRelativeLayout *lo_enter;
    
    JWRelativeLayout *lo_teachMov;
    JWRelativeLayout *lo_rightMov;
    
    UIImageView *lo_teachTap_animation;
    NSMutableArray *mTeachTapImages;
    
    UIImageView *lo_cg;
    NSMutableArray *mCgImages;
    
    UIImageView *lo_teach_camera_tip;
    UIImageView *lo_teach_tap_static;
    
    UIImage *img_mainMenu;
    UIImage *btn_homepage_n;
    UIImage *btn_vr_camera_n;
    
    BOOL outPlanEdit;
    CAAnimationGroup *toLivingGroup;
    UIImage *btn_order_n;
    
    JWFrameLayout *lo_menu_right_gray;
    JWFrameLayout *lo_menu_edu;
}

@end

@implementation TutorialPlanEdit

- (void)onCreated {
    [self.subMachine addState:[[TutorialPlanEditAddItem alloc] initWithModel:mModel] withName:[States EducationAddItem]];
    [self.subMachine addState:[[TutorialPlanEditItemEdit alloc] initWithModel:mModel] withName:[States EducationItemEdit]];
    [self.subMachine addState:[[TutorialPlanEditChangeToBirdCamera alloc] initWithModel:mModel] withName:[States EducationChangeToBirdCamera]];
    [self.subMachine addState:[[TutorialPlanEditChangeToEditorCamera alloc] initWithModel:mModel] withName:[States EducationChangeToEditorCamera]];
    [self.subMachine addState:[[TutorialPlanEditScreenshot alloc] initWithModel:mModel] withName:[States EducationShot]];
    [self.subMachine addState:[[TutorialPlanEditFinish alloc] initWithModel:mModel] withName:[States EducationEnd]];
}

- (UIView *)onCreateView:(UIView *)parent {
    JWRelativeLayout *lo_PlanEdit = [[JWRelativeLayout alloc] init];
    lo_PlanEdit.tag = R_id_lo_teach_main;
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
    
    img_mainMenu = [UIImage imageByResourceDrawable:@"bg_main_menu.png"];
    UIImageView *bg_mainMenu = [[UIImageView alloc] init];
    bg_mainMenu.image = img_mainMenu;
    bg_mainMenu.layoutParams.width = JWLayoutWrapContent;
    bg_mainMenu.layoutParams.height = JWLayoutWrapContent;
    [lo_mainMenu1_container addSubview:bg_mainMenu];
    
#pragma mark 教学模式Tips
    JWRelativeLayout *lo_eduLogo = [JWRelativeLayout layout];
    lo_eduLogo.layoutParams.width = JWLayoutWrapContent;
    lo_eduLogo.layoutParams.height = JWLayoutWrapContent;
    lo_eduLogo.layoutParams.alignment = JWLayoutAlignParentTopLeft;
    lo_eduLogo.layoutParams.marginTop = [self uiHeightBy:120.0f];
    lo_eduLogo.layoutParams.marginLeft = [self uiWidthBy:100.0f] + img_mainMenu.size.width;
    [lo_PlanEdit addSubview:lo_eduLogo];
    lo_eduLogo.layer.borderColor = [UIColor whiteColor].CGColor;
    lo_eduLogo.layer.borderWidth = 2;
    
    UILabel *lv_eduLogo = [UILabel new];
    lv_eduLogo.layoutParams.width = JWLayoutWrapContent;
    lv_eduLogo.layoutParams.height = JWLayoutWrapContent;
    lv_eduLogo.layoutParams.alignment = JWLayoutAlignParentTopLeft;
    lv_eduLogo.layoutParams.marginTop = [self uiHeightBy:10.0f];
    lv_eduLogo.layoutParams.marginLeft = [self uiWidthBy:10.0f];
    lv_eduLogo.layoutParams.marginRight = [self uiWidthBy:10.0f];
    lv_eduLogo.layoutParams.marginBottom = [self uiWidthBy:10.0f];
    [lo_eduLogo addSubview:lv_eduLogo];
    lv_eduLogo.text = @"教 学 模 式";
    lv_eduLogo.shadowOffset = CGSizeMake(1, 1);
    lv_eduLogo.shadowColor = [UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:1];
    lv_eduLogo.textColor = [UIColor whiteColor];
    lv_eduLogo.labelTextSize = 20;
//    lv_eduLogo.layer.borderColor = [UIColor whiteColor].CGColor;
//    lv_eduLogo.layer.borderWidth = 2;
//    NSLog(@"%f,%f",lv_eduLogo.frame.size.width,lv_eduLogo.frame.size.height);
    
    // 左上角胶囊型菜单
    JWLinearLayout *lo_mainMenu1 = [JWLinearLayout layout];
    lo_mainMenu1.layoutParams.width = JWLayoutWrapContent;
    lo_mainMenu1.layoutParams.height = JWLayoutWrapContent;
    lo_mainMenu1.layoutParams.alignment = JWLayoutAlignCenterInParent;
    lo_mainMenu1.orientation = JWLayoutOrientationVertical;
    [lo_mainMenu1_container addSubview:lo_mainMenu1];
    
    // home按钮
    btn_homepage_n = [UIImage imageByResourceDrawable:@"btn_homepage_n"];
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
    
    btn_vr_camera_n = [UIImage imageByResourceDrawable:@"btn_vr_camera_n"];
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
    __weak TutorialPlanEdit *weakSelf = self;
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
    
    
#pragma mark 右边竖条菜单容器
    lo_menu_right_gray = (JWFrameLayout*)[parent viewWithTag:R_id_lo_menu_edu];
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
    btn_build.tag = R_id_btn_build_list_t;
    btn_build.layoutParams.width = JWLayoutMatchParent;
    btn_build.layoutParams.height = JWLayoutWrapContent;
    [lo_menu_right_gray_linear addSubview:btn_build];
    UIImage *btn_build_n = [UIImage imageByResourceDrawable:@"btn_build_n.png"];
    img_build = [[UIImageView alloc] initWithImage:btn_build_n];
    img_build.tag = R_id_img_build_list_t;
    img_build.layoutParams.width = JWLayoutWrapContent;
    img_build.layoutParams.height = JWLayoutWrapContent;
    img_build.layoutParams.alignment = JWLayoutAlignCenterHorizontal;
    img_build.layoutParams.marginTop = [MesherModel uiHeightBy:10.0f];
    img_build.layoutParams.marginBottom = [MesherModel uiHeightBy:30.0f];
    [btn_build addSubview:img_build];
    tv_build = [UILabel new];
    tv_build.tag = R_id_tv_build_list_t;
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
    btn_living_room.tag = R_id_btn_living_room_t;
    btn_living_room.layoutParams.width = JWLayoutMatchParent;
    btn_living_room.layoutParams.height = JWLayoutWrapContent;
    [lo_menu_right_gray_linear addSubview:btn_living_room];
    UIImage *btn_living_room_n = [UIImage imageByResourceDrawable:@"btn_living_room_n.png"];
    img_living_room = [[UIImageView alloc] initWithImage:btn_living_room_n];
    img_living_room.tag = R_id_img_living_room_t;
    img_living_room.layoutParams.width = JWLayoutWrapContent;
    img_living_room.layoutParams.height = JWLayoutWrapContent;
    img_living_room.layoutParams.alignment = JWLayoutAlignCenterHorizontal;
    img_living_room.layoutParams.marginTop = [MesherModel uiHeightBy:10.0f];
    img_living_room.layoutParams.marginBottom = [MesherModel uiHeightBy:30.0f];
    [btn_living_room addSubview:img_living_room];
    tv_living_room = [UILabel new];
    tv_living_room.tag = R_id_tv_living_room_t;
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
    btn_bedroom.tag = R_id_btn_bedroom_t;
    btn_bedroom.layoutParams.width = JWLayoutMatchParent;
    btn_bedroom.layoutParams.height = JWLayoutWrapContent;
    [lo_menu_right_gray_linear addSubview:btn_bedroom];
    UIImage *btn_bedroom_n = [UIImage imageByResourceDrawable:@"btn_bedroom_n.png"];
    img_bedroom = [[UIImageView alloc] initWithImage:btn_bedroom_n];
    img_bedroom.tag = R_id_img_bedroom_t;
    img_bedroom.layoutParams.width = JWLayoutWrapContent;
    img_bedroom.layoutParams.height = JWLayoutWrapContent;
    img_bedroom.layoutParams.alignment = JWLayoutAlignCenterHorizontal;
    img_bedroom.layoutParams.marginTop = [MesherModel uiHeightBy:10.0f];
    img_bedroom.layoutParams.marginBottom = [MesherModel uiHeightBy:30.0f];
    [btn_bedroom addSubview:img_bedroom];
    tv_bedroom = [UILabel new];
    tv_bedroom.tag = R_id_tv_bedroom_t;
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
    btn_kitchen.tag = R_id_btn_kitchen_t;
    btn_kitchen.layoutParams.width = JWLayoutMatchParent;
    btn_kitchen.layoutParams.height = JWLayoutWrapContent;
    [lo_menu_right_gray_linear addSubview:btn_kitchen];
    UIImage *btn_kitchen_n = [UIImage imageByResourceDrawable:@"btn_kitchen_n.png"];
    img_kitchen = [[UIImageView alloc] initWithImage:btn_kitchen_n];
    img_kitchen.tag = R_id_img_kitchen_t;
    img_kitchen.layoutParams.width = JWLayoutWrapContent;
    img_kitchen.layoutParams.height = JWLayoutWrapContent;
    img_kitchen.layoutParams.alignment = JWLayoutAlignCenterHorizontal;
    img_kitchen.layoutParams.marginTop = [MesherModel uiHeightBy:10.0f];
    img_kitchen.layoutParams.marginBottom = [MesherModel uiHeightBy:30.0f];
    [btn_kitchen addSubview:img_kitchen];
    tv_kitchen = [UILabel new];
    tv_kitchen.tag = R_id_tv_kitchen_t;
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
    btn_toilet.tag = R_id_btn_toilet_t;
    btn_toilet.layoutParams.width = JWLayoutMatchParent;
    btn_toilet.layoutParams.height = JWLayoutWrapContent;
    [lo_menu_right_gray_linear addSubview:btn_toilet];
    UIImage *btn_toilet_n = [UIImage imageByResourceDrawable:@"btn_toilet_n.png"];
    img_toilet = [[UIImageView alloc] initWithImage:btn_toilet_n];
    img_toilet.tag = R_id_img_toilet_t;
    img_toilet.layoutParams.width = JWLayoutWrapContent;
    img_toilet.layoutParams.height = JWLayoutWrapContent;
    img_toilet.layoutParams.alignment = JWLayoutAlignCenterHorizontal;
    img_toilet.layoutParams.marginTop = [MesherModel uiHeightBy:10.0f];
    img_toilet.layoutParams.marginBottom = [MesherModel uiHeightBy:30.0f];
    [btn_toilet addSubview:img_toilet];
    tv_toilet = [UILabel new];
    tv_toilet.tag = R_id_tv_toilet_t;
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
    btn_order.tag = R_id_btn_order_t;
    btn_order.layoutParams.width = JWLayoutMatchParent;
    btn_order.layoutParams.height = JWLayoutWrapContent;
    //btn_order.layoutParams.alignment = JWLayoutAlignParentBottomRight;
    [lo_menu_right_gray_linear addSubview:btn_order];
    btn_order_n = [UIImage imageByResourceDrawable:@"btn_order_n.png"];
    img_order = [[UIImageView alloc] initWithImage:btn_order_n];
    img_order.tag = R_id_img_order;
    img_order.layoutParams.width = JWLayoutWrapContent;
    img_order.layoutParams.height = JWLayoutWrapContent;
    img_order.layoutParams.alignment = JWLayoutAlignCenterHorizontal;
    img_order.layoutParams.marginTop = [MesherModel uiHeightBy:10.0f];
    img_order.layoutParams.marginBottom = [MesherModel uiHeightBy:30.0f];
    [btn_order addSubview:img_order];
    tv_order = [UILabel new];
    tv_order.tag = R_id_tv_order_t;
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
    
#pragma mark Teach遮罩
    lo_teachMov = [JWRelativeLayout layout];
    lo_teachMov.tag = R_id_lo_teach_mov;
    lo_teachMov.layoutParams.width = mModel.gameViewWidth;
    lo_teachMov.layoutParams.height = JWLayoutMatchParent;
    lo_teachMov.layoutParams.alignment = JWLayoutAlignParentLeft;
    lo_teachMov.backgroundColor = [UIColor clearColor];
    [lo_PlanEdit addSubview:lo_teachMov];
    lo_teachMov.alpha = 0.8f;
    lo_teachMov.clickable = YES;
    [self.viewEventBinder bindEventsToView:lo_teachMov willBindSubviews:NO andFilter:nil];
    
    lo_rightMov = [JWRelativeLayout layout];
    lo_rightMov.tag = R_id_lo_right_mov;
    lo_rightMov.layoutParams.width = ([UIScreen mainScreen].boundsByOrientation.size.width - mModel.gameViewWidth);
    lo_rightMov.layoutParams.height = JWLayoutMatchParent;
    lo_rightMov.layoutParams.alignment = JWLayoutAlignParentRight;
    lo_rightMov.backgroundColor = [UIColor clearColor];
    
    [lo_PlanEdit addSubview:lo_rightMov];
    lo_rightMov.alpha = 1.0f;
    //    lo_rightMov.clickable = YES;
    //    [self.viewEventBinder bindEventsToView:lo_rightMov willBindSubviews:NO andFilter:nil];
    if (mTeachTapImages == nil) {
        mTeachTapImages = [NSMutableArray array];
    }
    if (lo_teachTap_animation == nil) {
        lo_teachTap_animation = [UIImageView new];
        lo_teachTap_animation.tag = R_id_lo_teach_tap;
    }
    for (int i = 1; i <= 10; i++) {
        NSString *imageName = [NSString stringWithFormat:@"teach_tap%d",i];
        UIImage *image = [UIImage imageByResourceDrawable:imageName];
        [mTeachTapImages add:image];
    }
    lo_teachTap_animation.image = mTeachTapImages[0];
    lo_teachTap_animation.layoutParams.width = JWLayoutWrapContent;
    lo_teachTap_animation.layoutParams.height = JWLayoutWrapContent;
    lo_teachTap_animation.animationImages = mTeachTapImages;
    lo_teachTap_animation.animationDuration = 1.0;
    lo_teachTap_animation.layoutParams.alignment = JWLayoutAlignParentRight;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        lo_teachTap_animation.marginTop = btn_order_n.size.height*2 + 1.0f;
    }else if ([UIDevice currentDevice].type == UIDeviceTypeIPhone) {
        lo_teachTap_animation.marginTop = btn_order_n.size.height*1.5 + 1.0f;
    }
    [lo_PlanEdit addSubview:lo_teachTap_animation];
    lo_teachTap_animation.alpha = 0.0f;
    //    [self startTeachTapAnimation];
    
#pragma mark Teach视角切换tips
    UIImage *img_camera_tip_ipad = [UIImage imageByResourceDrawable:@"img_teach_camera_tip_ipad"];
    UIImage *img_camera_tip_iphone = [UIImage imageByResourceDrawable:@"img_teach_camera_tip_iphone"];
    lo_teach_camera_tip = [[UIImageView alloc] init];
    lo_teach_camera_tip.tag = R_id_lo_teach_camera;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        lo_teach_camera_tip.image = img_camera_tip_ipad;
        lo_teach_camera_tip.layoutParams.marginLeft = [self uiWidthBy:220.0f];
        lo_teach_camera_tip.layoutParams.marginBottom = [self uiHeightBy:180.0f];
    }else if ([UIDevice currentDevice].type == UIDeviceTypeIPhone) {
        lo_teach_camera_tip.image = img_camera_tip_iphone;
        lo_teach_camera_tip.layoutParams.marginLeft = [self uiWidthBy:96.0f];
        lo_teach_camera_tip.layoutParams.marginBottom = [self uiHeightBy:50.0f] + btn_vr_camera_n.size.height;
    }
    lo_teach_camera_tip.layoutParams.alignment = JWLayoutAlignParentBottomLeft;
    lo_teach_camera_tip.alpha = 0.0f;
    [lo_PlanEdit addSubview:lo_teach_camera_tip];
    
    //    UIImage *img_teach_shot = [UIImage imageByResourceDrawable:@"img_teach_shot"];
    //    UIImageView *lo_teach_shot = [[UIImageView alloc] initWithImage:img_teach_shot];
    //    lo_teach_shot.tag = R_id_lo_teach_shot;
    //    lo_teach_shot.layoutParams.alignment = JWLayoutAlignParentTopLeft;
    //    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
    //        lo_teach_shot.layoutParams.marginTop = [MesherModel uiHeightBy:60.0f] + img_mainMenu.size.height - btn_homepage_n.size.height;
    //    }else if ([UIDevice currentDevice].type == UIDeviceTypeIPhone) {
    //        lo_teach_shot.layoutParams.marginTop = [MesherModel uiHeightBy:50.0f] + img_mainMenu.size.height - btn_homepage_n.size.height;
    //    }
    //    lo_teach_shot.alpha = 0.0f;
    //    lo_teach_shot.layoutParams.marginLeft = [MesherModel uiWidthBy:90.0f] + img_mainMenu.size.width;
    //    [lo_PlanEdit addSubview:lo_teach_shot];
    //
    //    UIImage *img_teach_save = [UIImage imageByResourceDrawable:@"img_teach_save"];
    //    UIImageView *lo_teach_save = [[UIImageView alloc] initWithImage:img_teach_save];
    //    lo_teach_save.tag = R_id_lo_teach_save;
    //    lo_teach_save.layoutParams.alignment = JWLayoutAlignParentTopLeft;
    //    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
    //        lo_teach_save.layoutParams.marginTop = [MesherModel uiHeightBy:40.0f] + btn_homepage_n.size.height;
    //    }else if ([UIDevice currentDevice].type == UIDeviceTypeIPhone) {
    //        lo_teach_save.layoutParams.marginTop = [MesherModel uiHeightBy:0.0f] + btn_homepage_n.size.height;
    //    }
    //    lo_teach_save.alpha = 0.0f;
    //    lo_teach_save.layoutParams.marginLeft = [MesherModel uiWidthBy:90.0f] + img_mainMenu.size.width;
    //    [lo_PlanEdit addSubview:lo_teach_save];
    
    UIImage *img_teach_tap_static = [UIImage imageByResourceDrawable:@"img_teach_tap_static"];
    lo_teach_tap_static = [[UIImageView alloc] initWithImage:img_teach_tap_static];
    lo_teach_tap_static.tag = R_id_lo_teach_tap_static;
    lo_teach_tap_static.alpha = 0.0f;
    [lo_PlanEdit addSubview:lo_teach_tap_static];
    
    UIImage *img_teach_tap_right = [UIImage imageByResourceDrawable:@"img_teach_tap_right"];
    UIImageView *lo_teach_tap_right = [[UIImageView alloc] initWithImage:img_teach_tap_right];
    lo_teach_tap_right.tag = R_id_lo_teach_tap_right;
    lo_teach_tap_right.alpha = 0.0f;
    [lo_PlanEdit addSubview:lo_teach_tap_right];
    
    UIImage *img_teach_double_static = [UIImage imageByResourceDrawable:@"img_teach_double_static"];
    UIImageView *lo_teach_double_static = [[UIImageView alloc] initWithImage:img_teach_double_static];
    lo_teach_double_static.tag = R_id_lo_teach_double_static;
    lo_teach_double_static.alpha = 0.0f;
    [lo_PlanEdit addSubview:lo_teach_double_static];
    
    CAKeyframeAnimation *toLivingButton = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    toLivingButton.calculationMode = kCAAnimationPaced;
    toLivingButton.fillMode = kCAFillModeForwards;
    toLivingButton.removedOnCompletion = NO;
    toLivingButton.duration = 2.5f;
    toLivingButton.repeatCount = 1; // 循环次数
    CGMutablePathRef toLiving = CGPathCreateMutable();
    CGPathMoveToPoint(toLiving, NULL, [UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        CGPathAddLineToPoint(toLiving, NULL, [UIScreen mainScreen].bounds.size.width - btn_order_n.size.width/2, btn_order_n.size.height*2.5 + 1.0f);
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        CGPathAddLineToPoint(toLiving, NULL, [UIScreen mainScreen].bounds.size.width - btn_order_n.size.width/2,btn_order_n.size.height*2 + 3.0f);
    }
    toLivingButton.path = toLiving;
    CGPathRelease(toLiving);
    
    toLivingGroup = [CAAnimationGroup animation];
    toLivingGroup.fillMode = kCAFillModeForwards;
    toLivingGroup.removedOnCompletion = NO;
    [toLivingGroup setAnimations:[NSArray arrayWithObjects: toLivingButton, nil]];
    toLivingGroup.duration = 2.5f;
    toLivingGroup.delegate = self;
    [toLivingGroup setValue:@"toLiving" forKey:@"toLivingRoom"];
    
    JWRelativeLayout *lo_teaching = [JWRelativeLayout layout];
    lo_teaching.tag = R_id_lo_teaching;
    lo_teaching.layoutParams.width = JWLayoutMatchParent;
    lo_teaching.layoutParams.height = JWLayoutMatchParent;
    lo_teaching.backgroundColor = [UIColor clearColor];
    lo_teaching.hidden = YES;
    lo_teaching.clickable = YES;
    [lo_PlanEdit addSubview:lo_teaching];
    [self.viewEventBinder bindEventsToView:lo_teaching willBindSubviews:NO andFilter:nil];
    
#pragma mark 中间动画
    if (mCgImages == nil) {
        mCgImages = [NSMutableArray array];
    }
    if (lo_cg == nil) {
        lo_cg = [UIImageView new];
        lo_cg.tag = R_id_lo_cg;
    }
    for (int i = 1; i <= 6; i++) {
        NSString *imageName = [NSString stringWithFormat:@"img_cg%d",i];
        UIImage *image = [UIImage imageByResourceDrawable:imageName];
        [mCgImages add:image];
    }
    lo_cg.image = mCgImages[0];
    lo_cg.layoutParams.width = JWLayoutWrapContent;
    lo_cg.layoutParams.height = JWLayoutWrapContent;
    lo_cg.animationImages = mCgImages;
    lo_cg.animationDuration = 0.5;
    lo_cg.alpha = 0.0f;
    lo_cg.layoutParams.alignment = JWLayoutAlignCenterInParent;
    [lo_PlanEdit addSubview:lo_cg];
    
#pragma mark 用于存放UI的view
    JWRelativeLayout *lo_edu_empty = [JWRelativeLayout layout];
    lo_edu_empty.tag = R_id_lo_edu_empty;
    lo_edu_empty.layoutParams.width = JWLayoutMatchParent;
    lo_edu_empty.layoutParams.height = JWLayoutMatchParent;
    lo_edu_empty.backgroundColor = [UIColor clearColor];
    lo_edu_empty.hidden = YES;
    [lo_PlanEdit addSubview:lo_edu_empty];
    
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
//    JWRelativeLayout *lo_product_info = [JWRelativeLayout layout];
//    lo_product_info.tag = R_id_lo_product_info;
//    lo_product_info.layoutParams.width = [self uiWidthBy:521.0f];
//    lo_product_info.layoutParams.height = JWLayoutMatchParent;
//    lo_product_info.layoutParams.leftOf = lo_menu_right_gray;
//    [lo_PlanEdit addSubview:lo_product_info];
//    lo_product_info.hidden = YES;
//    
//    UIImageView *bg_product_info = [[UIImageView alloc] initWithImage:bg_menu_right];
//    bg_product_info.layoutParams.width = [self uiWidthBy:521.0f];
//    bg_product_info.layoutParams.height = JWLayoutMatchParent;
//    [lo_product_info addSubview:bg_product_info];
    
#pragma mark loading界面
//    lo_load = [JWRelativeLayout layout];
//    lo_load.tag = R_id_lo_loading;
//    lo_load.layoutParams.width = JWLayoutMatchParent;
//    lo_load.layoutParams.height = JWLayoutMatchParent;
//    lo_load.clickable = YES;
//    lo_load.hidden = YES;
//    [lo_PlanEdit addSubview:lo_load];
//    [self createLoadingAnimationView:lo_load];
//    [self.viewEventBinder bindEventsToView:lo_load willBindSubviews:NO andFilter:nil];
    
#pragma mark 物件上的UI
    JWRelativeLayout *lo_control_fm = [JWRelativeLayout layout];
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
    
    JWRelativeLayout *lo_teach_move = [JWRelativeLayout layout];
    lo_teach_move.tag = R_id_lo_teach_move;
    lo_teach_move.layoutParams.width = JWLayoutMatchParent;
    lo_teach_move.layoutParams.height = JWLayoutMatchParent;
    lo_teach_move.hidden = YES;
    [lo_PlanEdit addSubview:lo_teach_move];
    
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
    btn_living_room.clickable = NO;
    [self.viewEventBinder bindEventsToView:btn_living_room willBindSubviews:NO andFilter:nil];
    
    isFPS = NO;
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    
#pragma mark launch设置
    lo_launchScreen = [JWRelativeLayout layout];
    lo_launchScreen.layoutParams.width = JWLayoutMatchParent;
    lo_launchScreen.layoutParams.height = JWLayoutMatchParent;
    lo_launchScreen.backgroundColor = [UIColor colorWithARGB:0xfffef3d3];
//    lo_launchScreen.backgroundColor = [UIColor whiteColor];
    [lo_PlanEdit addSubview:lo_launchScreen];
    
    UIImage *img_launch = [UIImage imageByResourceDrawable:@"img_launch"];
    img_launchScreen = [[UIImageView alloc] initWithImage:img_launch];
    img_launchScreen.contentMode = UIViewContentModeScaleAspectFit; // 图片等比缩放
    img_launchScreen.layoutParams.width = screenBounds.size.width * 0.75f;//[MesherModel uiWidthBy:1850.0f];
    img_launchScreen.layoutParams.height = screenBounds.size.height * 0.75f;//[MesherModel uiHeightBy:1500.0f];
    img_launchScreen.layoutParams.alignment = JWLayoutAlignCenterInParent;
    [lo_launchScreen addSubview:img_launchScreen];
    
#pragma mark 设置字体 暂时不用
    //    UILabel *lv_logo = [[UILabel alloc] init];
    //    lv_logo.font = [UIFont fontWithName:@"MFYueHei_Noncommercial-Regular" size:30.0f];
    //    lv_logo.text = @"为我们想要的家  梦想触手可及";
    //    lv_logo.textColor = [UIColor whiteColor];
    //    lv_logo.layoutParams.alignment = JWLayoutAlignParentTopLeft;
    //    lv_logo.layoutParams.marginTop = [MesherModel uiHeightBy:340.0f];
    //    lv_logo.layoutParams.marginLeft = [MesherModel uiWidthBy:130.0f];
    //    [lo_launchScreen addSubview:lv_logo];
    
#pragma mark 基础逻辑判断设置
//    mModel.isTeach = YES;
//    mModel.isTeachMove = YES;
//    mModel.completedMove = NO;
//    mModel.completedTeach = NO;
//    mModel.isTouchBirdCamera = NO;
//    mModel.isTouchEditCamera = NO;
//    mModel.isTouchShot = NO;
//    mModel.isTouchHome = NO;
    return lo_PlanEdit;
}

- (void)onStateEnter:(NSDictionary *)data{
    [super onStateEnter:data];
    [self updateUndoRedoState];
    
    lo_menu_right_gray.hidden = YES;
    lo_menu_edu.hidden = NO;
    
    mModel.isTeach = YES;
    mModel.isTeachMove = YES;
    
    btn_living_room.clickable = NO;
    
    lo_cg.alpha = 0.0f;
    mModel.isTeachTime = YES;
    lo_teachTap_animation.alpha = 0.0f;
    outPlanEdit = NO;
    mModel.fromTeach = NO;
    lo_teachMov.hidden = NO;
//    lo_teach_tap_static.alpha = 1.0f;
    lo_teachTap_animation.layoutParams.alignment = JWLayoutAlignParentRight;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        lo_teachTap_animation.marginTop = btn_order_n.size.height*2 + 1.0f;
    }else if ([UIDevice currentDevice].type == UIDeviceTypeIPhone) {
        lo_teachTap_animation.marginTop = btn_order_n.size.height*1.5 + 1.0f;
    }
    
    //    [lo_cg startAnimating];
    
#pragma mark launch动画
    if (mModel.launchIndex == 0){
        [UIView animateWithDuration:1.0 animations:^{
            lo_launchScreen.alpha = 0.99;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1.0 animations:^{ // 类方法实现UIView的动画效果
                lo_launchScreen.alpha = 0;
            } completion:^(BOOL finished) {
                lo_launchScreen.hidden = YES;
                mModel.launchIndex++;
            }];
        }];
    } else if (mModel.launchIndex != 0) {
        lo_launchScreen.hidden = YES;
    }
    
    
    //    mModel.currentPlan = [mModel.project createPlan];
    //    [mModel.project savePlans];
    //    mModel.currentPlan.isCreate = YES;
    
    [mModel.world changeSceneById:mModel.currentScene.Id];
    
    btn_fps_switch.alpha = 0.0f;
    
    [cv_glassList selectItemAtPosition:glassIndex animated:NO scrollPosition:UICollectionViewScrollPositionLeft];
    lo_glassMenu.hidden = YES;
    
    btn_undo.userInteractionEnabled = NO;
    btn_redo.userInteractionEnabled = NO;
    rg_camera.checkedView = btn_editor_camera; // 默认进来在editor视角
    JWEditorCameraPrefab *camera = [mModel.photographer changeToEditorCamera:1000];
    [camera setYaw:-45.0f];
    [camera setPicth:-60.0f];
    [camera setZoom:10.0f];
    
    lo_load.hidden = NO;
    //        [self startLoadingAnimation];
    [mModel.currentPlan destroyAllObjects];
    [mModel.prePlan destroyAllObjects];
    [mModel.project loadSuitPlans];
    Plan *suitPlan = [mModel.project suitPlanAtIndex:0];
    Plan *plan = [mModel.project copySuitPlan:suitPlan];
    mModel.currentPlan = plan;
    Plan* currentPlan = mModel.currentPlan;
    JWSceneLoaderOnLoadingListener* listener = [[JWSceneLoaderOnLoadingListener alloc] init];
    listener.onFinish = (^(id<JIFile> file, id<JIGameObject> parent, id<JIGameObject> object){
        lo_load.hidden = YES;
        JCVector3 position = [mModel.teachObject.transform positionInSpace:JWTransformSpaceWorld];
        [camera.root.transform setPosition:position];
        
        lo_teach_tap_static.alpha = 1.0f;
        
//        PlanCamera *planCamera = mModel.currentPlan.camera;
//        
//        JWTransform* transform = [[JWTransform alloc] initWithContext:mModel.currentContext];
//        [transform setPositionX:planCamera.px Y:planCamera.py Z:planCamera.pz];
//        [transform setOrientationQ:JCQuaternionMake(planCamera.rw, planCamera.rx, planCamera.ry, planCamera.rz) inSpace:JWTransformSpaceLocal];
//        [camera adjustCameraTransform:transform];
        
        [lo_teach_tap_static.layer addAnimation:toLivingGroup forKey:@"toLivingButton"];
    });
    listener.onFailed = (^(id<JIFile> file, id<JIGameObject> parent, NSError* error) {
        lo_load.hidden = YES;
        //            [self stopLoadingAnimation];
    });
    if (currentPlan.isCreate) {
        [currentPlan loadItem:mModel.roomItem position:JCVector3Zero() orientation:JCQuaternionIdentity() async:YES listener:listener];
        currentPlan.isCreate = NO;
    }else {
        id<JIGameContext> context = mModel.currentContext;
        id<JIGameScene> scene = mModel.currentScene;
        PlanLoader* planLoader = (PlanLoader*)[context.sceneLoaderManager getLoaderForFile:currentPlan.scene];
        planLoader.plan = mModel.currentPlan;
        [planLoader loadFile:currentPlan.scene parent:scene.root params:nil async:YES listener:listener];
    }
    mModel.fromInspiration = NO;
    
    mModel.currentPlan.fromAR = NO;
    mCurrentPlan = mModel.currentPlan;
    if (mModel.currentPlan.architectureObject == nil) {
        mModel.gridsObject.visible = YES;
    }
    mModel.itemSelectAndMoveBehaviour.enabled = YES;//进入状态把移动的behaviour开启
//    mModel.photographer.cameraEnabled = YES;
}

- (void)onStateLeave {
    mModel.itemSelectAndMoveBehaviour.enabled = NO;//离开状态把移动的behaviour关闭
    [super onStateLeave];
}

- (BOOL)onTouchUp:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    switch (touch.view.tag) {
        case R_id_btn_brid_camera:{
            break;
        }
        case R_id_btn_fps_camera:{
            break;
        }
        case R_id_btn_editor_camera:{
            break;
        }
        case R_id_btn_vr_camera:{
            break;
        }
        case R_id_btn_build_list_t: {
            break;
        }
        case R_id_btn_living_room_t: {
            [self stopTeachTapAnimation];
            outPlanEdit = YES;
            [lo_teach_tap_static.layer removeAllAnimations];
            btn_living_room.backgroundColor = [UIColor whiteColor];
            tv_living_room.textColor = [UIColor colorWithARGB:R_color_right_menu_label_textcolor];
            img_living_room.image = [UIImage imageByResourceDrawable:@"btn_living_room_p"];
            mModel.currentArea = AreaLivingRoom;
            [self stopTeachTapAnimation];
            lo_rightMov.hidden = YES;
            lo_teachTap_animation.alpha = 0.0f;
            [self.subMachine changeStateTo:[States EducationAddItem] pushState:NO];
            btn_living_room.clickable = NO;
            break;
        }
        case R_id_lo_teach_mov: {
            NSLog(@"teachMov");
            break;
        }
        case R_id_lo_loading: {
            NSLog(@"loading");
            break;
        }
        case R_id_lo_teaching: {
            NSLog(@"teaching");
            break;
        }
    }
    return YES;
}

- (void)onSingleTap:(UITapGestureRecognizer *)singleTap {
    switch (singleTap.view.tag) {
        case R_id_btn_homepage: {
            break;
        }
        case R_id_btn_undo: {
//            [mModel.commandMachine undo];
            [self updateUndoRedoState];
            break;
        }
        case R_id_btn_redo: {
//            [mModel.commandMachine redo];
            [self updateUndoRedoState];
            break;
        }
        case R_id_btn_screenshot: {
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

- (void)startTeachTapAnimation {
    [lo_teachTap_animation startAnimating];
}

- (void)stopTeachTapAnimation {
    [lo_teachTap_animation stopAnimating];
}

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

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//    NSString *an = [anim valueForKey:@"toShotButton"];
//    if ([an isEqual:@"toShot_v"]) {
//        mModel.isTouchHome = YES;
//        mModel.completedTeach = YES;
//        lo_teach_tap_static.alpha = 0.0f;
//        [lo_teach_tap_static.layer removeAllAnimations];
//        lo_teachTap_animation.alpha = 1.0f;
//        lo_teachTap_animation.layoutParams.alignment = JWLayoutAlignParentTopLeft;
//        if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
//            lo_teachTap_animation.layoutParams.marginTop = [MesherModel uiHeightBy:50.0f] + img_mainMenu.size.height - btn_homepage_n.size.height/2;
//            lo_teachTap_animation.layoutParams.marginLeft = [self uiWidthBy:100.0f];
//        }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
//            lo_teachTap_animation.layoutParams.marginTop = [MesherModel uiHeightBy:5.0f] + img_mainMenu.size.height - btn_homepage_n.size.height/2;
//            lo_teachTap_animation.layoutParams.marginLeft = [self uiWidthBy:120.0f];
//        }
//        [lo_teachTap_animation startAnimating];
//    }
    NSString *an_living = [anim valueForKey:@"toLivingRoom"];
    if ([an_living isEqual:@"toLiving"]) {
        btn_living_room.clickable = YES;
        lo_teach_tap_static.alpha = 0.0f;
        [lo_teach_tap_static.layer removeAllAnimations];
        if (!outPlanEdit) {
            lo_teachTap_animation.alpha = 1.0f;
            [lo_teachTap_animation startAnimating];
        }
    }
}

@end
