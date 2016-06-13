//
//  EnterMenu.m
//  project_mesher
//
//  Created by mac zdszkj on 15/11/10.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "DIY.h"
#import "MesherModel.h"
#import "MesherCollectionViewCell.h"
#import "LineLayout.h"
#import "EnterIndex.h"
#import "DIYPlanAdapter.h"
#import "DIYSmallPlanAdapter.h"

@interface CenterDelegate : NSObject <OnCurrentPlanIndexChangedDelegate> {
    JWCollectionView *cv_plans;
}

- (id) initWithView:(JWCollectionView*)view;

@end

@implementation CenterDelegate

- (id) initWithView:(JWCollectionView *)view {
    self = [super init];
    if (self != nil) {
        cv_plans = view;
    }
    return self;
}

- (void)onCurrentPlanIndexChanged:(NSUInteger)index {
    //让CollectionView默认选中并显示刚截图的那一项
    [cv_plans selectItemAtPosition:index animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
}

@end

@interface SceneDelegate : NSObject <OnCurrentPlanIndexChangedDelegate> {
    JWCollectionView *cv_small_plans;
}

- (id) initWithView:(JWCollectionView*)view;

@end

@implementation SceneDelegate

- (id) initWithView:(JWCollectionView*)view {
    self = [super init];
    if (self != nil) {
        cv_small_plans = view;
    }
    return self;
}

- (void)onCurrentPlanIndexChanged:(NSUInteger)index {
    //    NSUInteger i = 0;
    //    for (UIView *subview in [gv_small_plans subviews]) {
    //        UIView* lo_small_plan = [subview viewWithTag:R_id_lo_small_plan];
    //        lo_small_plan.hidden = i != index;
    //        i++;
    //    }
    //让CollectionView默认选中并显示刚截图的那一项
    [cv_small_plans selectItemAtPosition:index animated:NO scrollPosition:UICollectionViewScrollPositionLeft];
}

@end

@interface DIY () <UIGestureRecognizerDelegate,UITextFieldDelegate,DIYDelegate> {
    
    JWRelativeLayout *lo_Enter;
    JWRelativeLayout *lo_Center;
    JWLinearLayout *lo_menu_tap;
    JWRelativeLayout *lo_game_view;
    JWRelativeLayout *lo_menu;
    JWRelativeLayout *lo_scene; // 下方小方块缩略图容器
    UIButton *btn_add;
    
    //    UICollectionView* cv_plans; // 方案列表
    JWCollectionView *cv_plans; // 方案列表
    CenterDelegate* gv_plans_delegate;
    DIYPlanAdapter *planAdapter;
    
    JWCollectionView *cv_small_plans;
    DIYSmallPlanAdapter *smallPlanAdapter;
    
    UIScrollView *sv_small_plans;
    SceneDelegate* sv_small_plans_delegate;
    SceneDelegate* gv_small_plans_delegate;
    JWRelativeLayout *lo_small_plans_selected; // 小方案外框
    
    NSMutableArray *mua_selected; // 用于接收所有小方块的边框
    
    NSInteger rowIndex;
    EnterIndex *enterIndex;
    
    UITextField *nameField;
    
    Plan *renamePlan;
    
    NSMutableArray *suitAndDIY;
    Plan *suitPage;
    Plan *inspiration;
    Plan *teachPage;
    
    JWRelativeLayout *lo_launchScreen;
    UIImageView *img_launchScreen;
}

//@property (nonatomic, readwrite) BOOL isAdd;

@end

@implementation DIY

static NSString *const kCellIdentifier = @"Cell";
static NSString *const sCellIdentifier = @"sCell";
static NSInteger chooseCount = 0; // 选中的那一项的下标

- (UIView *)onCreateView:(UIView *)parent {
    
    lo_Enter = [JWRelativeLayout layout];
    lo_Enter.layoutParams.width = JWLayoutMatchParent;
    lo_Enter.layoutParams.height = JWLayoutMatchParent;
    [parent addSubview:lo_Enter];
    
    lo_game_view = (JWRelativeLayout*)[parent viewWithTag:R_id_lo_game_view];
    lo_menu = (JWRelativeLayout*)[parent viewWithTag:R_id_lo_menu_right_gray];
    
#pragma mark 中间方案列表容器
    lo_Center = [JWRelativeLayout layout];
    lo_Center.backgroundColor = [UIColor grayColor];
    lo_Center.layoutParams.width = JWLayoutMatchParent;//[MesherModel uiWidthBy:1460.0f];
    lo_Center.layoutParams.height = [MesherModel uiHeightBy:1100.0f];
    lo_Center.layoutParams.alignment = JWLayoutAlignCenterVertical;
    [lo_Enter addSubview:lo_Center];
    
#pragma mark 中间方案列表
    LineLayout* ll_plans = [[LineLayout alloc] init];
    ll_plans.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    cv_plans = [[JWCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:ll_plans];
    cv_plans.backgroundColor = [UIColor whiteColor];
    cv_plans.layoutParams.width = JWLayoutMatchParent;
    cv_plans.layoutParams.height = JWLayoutMatchParent;
    [lo_Center addSubview:cv_plans];
    planAdapter = [[DIYPlanAdapter alloc] init];
    planAdapter.delegate = self;
    cv_plans.adapter = planAdapter;
    cv_plans.alwaysBounceVertical = NO;
    cv_plans.showsHorizontalScrollIndicator = NO;
    cv_plans.showsVerticalScrollIndicator = NO;
    JWRelativeLayout *lo_Center_b = lo_Center;
    JWCollectionView *cv_plans_b = cv_plans;
    id<IMesherModel> model = mModel;
    gv_plans_delegate = [[CenterDelegate alloc] initWithView:cv_plans];
    [mModel registerOnCurrentPlanIndexChangedDelegate:gv_plans_delegate];
    id gv_plans_delegate_b = gv_plans_delegate;
    cv_plans.onScroll = ^(id<JIAdapterView> view) {
        if (!cv_plans_b.scrollByUser) {
            return;
        }
        //        if (mModel.project.numPlans > 0) {
        //            CGPoint pInView = [lo_Center_b convertPoint:lo_Center_b.center toView:cv_plans_b];
        //            NSIndexPath *indexPathNew = [cv_plans_b indexPathForItemAtPoint:pInView];
        //            //enterIndex_b.index = indexPathNew.row;
        //            [model setCurrentPlanIndex:indexPathNew.row byTarget:gv_plans_delegate_b];
        //        }
        CGPoint pInView = [lo_Center_b convertPoint:lo_Center_b.center toView:cv_plans_b];
        NSIndexPath *indexPathNew = [cv_plans_b indexPathForItemAtPoint:pInView];
        //enterIndex_b.index = indexPathNew.row;
        [model setCurrentPlanIndex:indexPathNew.row byTarget:gv_plans_delegate_b];
    };
    
    //    __block UITextField *nameField_b = nameField;
    __weak typeof(self)weakSelf = self; // 在block内对外界做改动
    
    if (suitAndDIY == nil) {
        suitAndDIY = [NSMutableArray array];
    }
    suitPage = [[Plan alloc] init];
    suitPage.Id = 0;
    suitPage.preview = [JWFile fileWithType:JWFileTypeBundle path:[JWResourceBundle nameForDrawable:@"suitPage.png"]];
    [suitAndDIY add:suitPage];
    
#ifdef USE_INSPIRATE
    //inspiration图片
    inspiration = [[Plan alloc] init];
    inspiration.Id = -1;
    inspiration.preview = [JWFile fileWithType:JWFileTypeBundle path:[JWResourceBundle nameForDrawable:@"inspriation.png"]];
    [suitAndDIY add:inspiration];
#endif
    
    teachPage = [[Plan alloc] init];
    teachPage.Id = -2;
    teachPage.preview = [JWFile fileWithType:JWFileTypeBundle path:[JWResourceBundle nameForDrawable:@"teachPage.png"]];
    [suitAndDIY add:teachPage];
    
    [mModel.project loadPlans];
#ifdef USE_INSPIRATE
    [mModel.project loadInspiratedPlans];
#endif
    
    [self uploadSuitAndDIYAndInspiration];
    NSMutableArray *suitAndDIY_b = suitAndDIY;
    cv_plans.onItemSelected = ^(NSUInteger position, id item, BOOL selected) {
        if (selected) {
            if (position == 0) {
                [weakSelf.parentMachine changeStateTo:[States Suit] pushState:NO];
                return;
            }
#ifdef USE_INSPIRATE
            if (position == 1) {
                [weakSelf.parentMachine changeStateTo:[States InspiratedList]];
                return;
            }
            if (position == 2) {
#else
            if (position == 1) {
#endif
//                model.isTeach = YES;
//                model.isTeachMove = YES;
//                model.completedMove = NO;
//                model.completedTeach = NO;
//                model.isTouchBirdCamera = NO;
//                model.isTouchEditCamera = NO;
//                model.isTouchShot = NO;
//                model.isTouchHome = NO;
//                [model.project loadSuitPlans];
//                Plan *suitPlan = [model.project suitPlanAtIndex:0];
//                Plan *plan = [model.project copySuitPlan:suitPlan];
//                model.currentPlan = plan;
                [weakSelf.parentMachine changeStateTo:[States EducationStart] pushState:NO];
                return;
            }
            if ([suitAndDIY_b[position] isKindOfClass:[InspiratedPlan class]]) {
                InspiratedPlan *plan = suitAndDIY_b[position];
                chooseCount = position;
                model.currentPlan = plan;
                [weakSelf resignKeyBoard];
                [weakSelf.parentMachine changeStateTo:[States InspiratedEdit] pushState:NO];
            } else {
                Plan* plan = suitAndDIY_b[position];
                chooseCount = position;
                model.currentPlan = plan;
                
                [weakSelf resignKeyBoard];
                [weakSelf.parentMachine changeStateTo:[States PlanEdit] pushState:NO];
            }
        }
    };
    
    nameField = [[UITextField alloc] init];
    nameField.layoutParams.width = [MesherModel uiWidthBy:1200.0f];
    nameField.layoutParams.height = 30;
    nameField.backgroundColor = [UIColor whiteColor];
    nameField.layoutParams.alignment = JWLayoutAlignCenterHorizontal | JWLayoutAlignParentTop;
    nameField.layoutParams.marginTop = [MesherModel uiHeightBy:300.0f];
    nameField.returnKeyType = UIReturnKeyDone;
//    nameField.keyboardType = UIKeyboardTypeNumberPad;
    nameField.delegate = self;
    nameField.hidden = YES;
    [lo_Center addSubview:nameField];
    
#pragma mark 下面横向方案菜单
    lo_scene = [JWRelativeLayout layout];
    lo_scene.layoutParams.height = [MesherModel uiHeightBy:100.0f];
    lo_scene.layoutParams.width = [MesherModel uiWidthBy:1620.0f];
    lo_scene.layoutParams.alignment = JWLayoutAlignCenterHorizontal | JWLayoutAlignParentBottom;
    lo_scene.layoutParams.marginTop = [self uiHeightBy:40.0f];
    lo_scene.layoutParams.below = lo_Center;
    [lo_Enter addSubview:lo_scene];
    
    UICollectionViewFlowLayout *small_Layout = [[UICollectionViewFlowLayout alloc] init];
    small_Layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    cv_small_plans = [[JWCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:small_Layout];
    cv_small_plans.backgroundColor = [UIColor whiteColor];
    cv_small_plans.layoutParams.width = [MesherModel uiWidthBy:1500.0f];
    cv_small_plans.layoutParams.height = JWLayoutMatchParent;
    cv_small_plans.layoutParams.alignment = JWLayoutAlignParentBottomRight;
    cv_small_plans.layoutParams.marginLeft = [MesherModel uiWidthBy:10.0f];
    smallPlanAdapter = [[DIYSmallPlanAdapter alloc] init];
    cv_small_plans.adapter = smallPlanAdapter;
    cv_small_plans.alwaysBounceVertical = NO;
    cv_small_plans.showsHorizontalScrollIndicator = NO;
    cv_small_plans.showsVerticalScrollIndicator = NO;
    cv_small_plans.allowsMultipleSelection = NO;
    gv_small_plans_delegate = [[SceneDelegate alloc] initWithView:cv_small_plans];
    [mModel registerOnCurrentPlanIndexChangedDelegate:gv_small_plans_delegate];
    [lo_scene addSubview:cv_small_plans];
    id gv_small_plans_delegate_b = gv_small_plans_delegate;
    cv_small_plans.onItemSelected = ^(NSUInteger position, id item, BOOL selected){
        if (selected) {
            [model setCurrentPlanIndex:position byTarget:gv_small_plans_delegate_b];
        }
    };
    
    UIImage *btn_add_n = [UIImage imageByResourceDrawable:@"btn_add_n"];
    btn_add = [[UIButton alloc] init];
    [btn_add setBackgroundImage:btn_add_n forState:UIControlStateNormal];
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        btn_add.layoutParams.width = [MesherModel uiWidthBy:110.0f];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        btn_add.layoutParams.width = [MesherModel uiWidthBy:90.0f];
    }
    btn_add.layoutParams.height = JWLayoutMatchParent;
    btn_add.layoutParams.alignment = JWLayoutAlignCenterVertical;
    [lo_scene addSubview:btn_add];
    [btn_add addTarget:self action:@selector(addPlan:) forControlEvents:UIControlEventTouchUpInside];
    
    //enterIndex = [[EnterIndex alloc] initWithIndex:0];
    
#pragma mark launch设置
    lo_launchScreen = [JWRelativeLayout layout];
    lo_launchScreen.layoutParams.width = JWLayoutMatchParent;
    lo_launchScreen.layoutParams.height = JWLayoutMatchParent;
    lo_launchScreen.backgroundColor = [UIColor colorWithARGB:0xfffef3d3];
    [lo_Enter addSubview:lo_launchScreen];
    
    //    UIImage *img_launch = [UIImage imageByResourceDrawable:@"img_launch"];
    //    img_launchScreen = [[UIImageView alloc] initWithImage:img_launch];
    //    img_launchScreen.contentMode = UIViewContentModeScaleAspectFit; // 图片等比缩放
    //    img_launchScreen.layoutParams.width = JWLayoutMatchParent;//[MesherModel uiWidthBy:1850.0f];
    //    img_launchScreen.layoutParams.height = JWLayoutMatchParent;//[MesherModel uiHeightBy:1500.0f];
    //    img_launchScreen.layoutParams.alignment = JWLayoutAlignCenterInParent;
    //    [lo_launchScreen addSubview:img_launchScreen];
    
    UIImage *img_launch = [UIImage imageByResourceDrawable:@"img_launch"];
    img_launchScreen = [[UIImageView alloc] initWithImage:img_launch];
    img_launchScreen.contentMode = UIViewContentModeScaleAspectFit; // 图片等比缩放
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    img_launchScreen.layoutParams.width = screenBounds.size.width * 0.75f;//[MesherModel uiWidthBy:1850.0f];
    img_launchScreen.layoutParams.height = screenBounds.size.height * 0.75f;//[MesherModel uiHeightBy:1500.0f];
    img_launchScreen.layoutParams.alignment = JWLayoutAlignCenterInParent;
    [lo_launchScreen addSubview:img_launchScreen];
    
#pragma mark Inspiration背景相关
    CGRect bounds = [[UIScreen mainScreen] boundsInPixels];
    mModel.inspiratedBackgroundSprite = [JWBackgroundSpritePrefab spriteWithContext:mModel.currentContext parent:mModel.inspirateScene.root rect:JCRectFMake(0, 0, bounds.size.width, bounds.size.height) textureFile:nil];
    
    id<JIGameObject> inspiratedObject = [mModel.currentContext createObject];
    inspiratedObject.parent = mModel.inspirateScene.root;
    mModel.inspiratedObject = inspiratedObject;
    InspiratedBehaviour* behaviour = [InspiratedBehaviour behaviourWithContext:mModel.currentContext];
    [inspiratedObject addComponent:behaviour];
    behaviour.model = mModel;
    mModel.inspiratedBehaviour = behaviour;
    
    return lo_Enter;
}
- (void)resignKeyBoard{
    [nameField resignFirstResponder];
    nameField.hidden = YES;
}
- (void)uploadSuitAndDIYAndInspiration {
    if (suitAndDIY != nil) {
        [suitAndDIY clear];
        [suitAndDIY add:suitPage];
#ifdef USE_INSPIRATE
        [suitAndDIY add:inspiration];
#endif
        [suitAndDIY add:teachPage];
        for (int i = 0; i < mModel.project.plans.count; i++) {
            Plan *p = mModel.project.plans[i];
            [suitAndDIY add:p];
        }
#ifdef USE_INSPIRATE
        for (int i = 0; i < mModel.project.inspiratedPlans.count; i++) {
            InspiratedPlan *p = mModel.project.inspiratedPlans[i];
            [suitAndDIY add:p];
        }
#endif
    }
}

- (void)onStateEnter:(NSDictionary *)data {
    [super onStateEnter:data];
    // 读取更新后的方案列表
    [mModel.project loadPlans];
#ifdef USE_INSPIRATE
    [mModel.project loadInspiratedPlans];
#endif
    
    [self uploadSuitAndDIYAndInspiration];
    
    planAdapter.data = suitAndDIY;
    [planAdapter notifyDataSetChanged];
    smallPlanAdapter.data = suitAndDIY;
    [smallPlanAdapter notifyDataSetChanged];
    
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
    
    // 注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    lo_game_view.hidden = YES;
    lo_menu.hidden = YES;
    nameField.hidden = YES;
    
#pragma mark 刷新CollectionView !!!!!
    
    if (mModel.project.numPlans > 0) {
        btn_add.layoutParams.leftOf = sv_small_plans;
        btn_add.layoutParams.marginRight = [MesherModel uiWidthBy:10.0f];
    }
    
    [cv_plans reloadData];
//    if (mModel.fromTeach) {
////        [mModel setCurrentPlanIndex:mModel.project.plans.count+1 byTarget:nil];
//        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
//        
//        [cv_plans selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
//        mModel.fromTeach = NO;
//    }else {
//        
//    }
    if (mModel.currentPlan.isCreatedPlan) {
        [mModel setCurrentPlanIndex:mModel.project.numPlans+1 byTarget:nil];
        mModel.currentPlan.isCreatedPlan = NO;
    } else {
        [mModel setCurrentPlanIndex:mModel.currentPlanIndex byTarget:nil];
    }
}

- (void)changePlanName:(Plan*)plan {
    nameField.hidden = NO;
    [nameField becomeFirstResponder];
    nameField.text = plan.name;
    renamePlan = plan;
    
    [self uploadSuitAndDIYAndInspiration];
    
    planAdapter.data = suitAndDIY;
    [planAdapter notifyDataSetChanged];
    smallPlanAdapter.data = suitAndDIY;
    [smallPlanAdapter notifyDataSetChanged];
}

- (void)copyPlan:(Plan*)plan {
    if ([plan isKindOfClass:[InspiratedPlan class]]) {
        [mModel.project copyInspiratedPlan:plan];
        [mModel.project saveInspiratedPlans];
    }else {
        [mModel.project copyPlan:plan];
        [mModel.project savePlans];
    }

    [self uploadSuitAndDIYAndInspiration];
    
    planAdapter.data = suitAndDIY;
    [planAdapter notifyDataSetChanged];
    smallPlanAdapter.data = suitAndDIY;
    [smallPlanAdapter notifyDataSetChanged];
    
    [mModel setCurrentPlanIndex:(suitAndDIY.count-1) byTarget:nil];
}

- (void)destoryPlan:(Plan*)plan {
    
    if ([plan isKindOfClass:[InspiratedPlan class]]) {
        [mModel.project destoryInspiratedPlan:plan];
        [mModel.prePlan destroyAllObjects];
        [mModel.currentPlan destroyAllObjects];
        mModel.currentPlan = nil;
        [mModel.project saveInspiratedPlans];
    }else {
        [mModel.project destoryPlan:plan];
        [mModel.prePlan destroyAllObjects];
        [mModel.currentPlan destroyAllObjects];
        mModel.currentPlan = nil;
        [mModel.project savePlans];
    }

    [self uploadSuitAndDIYAndInspiration];
    
    planAdapter.data = suitAndDIY;
    [planAdapter notifyDataSetChanged];
    smallPlanAdapter.data = suitAndDIY;
    [smallPlanAdapter notifyDataSetChanged];
    
    NSUInteger destoryPlanIndex = 0;
    if (mModel.currentPlanIndex == 0) {
        destoryPlanIndex = 0;
    } else if (mModel.currentPlanIndex > 0) {
        destoryPlanIndex = mModel.currentPlanIndex - 1;
    }
    [mModel setCurrentPlanIndex:destoryPlanIndex byTarget:nil];
    //    // 如果方案的数量为0 则转到初始进入的页面提示
    //    if (mModel.project.numPlans < 1) {
    //        [self.parentMachine changeStateTo:[States MainPage] pushState:NO];
    //    }
}

- (void)uploadPlan:(Plan*)plan {
    [[[JWCorePluginSystem instance].log withType:JWLogTypeUi] log:@"敬请期待"];
}

- (void)onStateLeave {
    lo_game_view.hidden = NO;
    lo_menu.hidden = NO;
    [super onStateLeave];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([NSString isNilOrBlank:nameField.text]) {
        nameField.hidden = YES;
        [nameField resignFirstResponder];
        return YES;
    }
    NSString *name = nameField.text;
    renamePlan.name = name;
    if([renamePlan isKindOfClass:[InspiratedPlan class]]) {
        [mModel.project saveInspiratedPlans];
    }else {
        [mModel.project savePlans];
    }
    [nameField resignFirstResponder];
    nameField.text = @"";
    nameField.hidden = YES;
    [cv_plans reloadData];
    return YES;
}

- (void)addPlan:(id)sender {
    mModel.currentPlan.isCreatedPlan = YES;
    [self.parentMachine changeStateTo:[States RoomShape] pushState:NO];
}

-(void)keyboardWillBeHidden:(NSNotification*)Notification {
    if ([NSString isNilOrBlank:nameField.text]) {
        nameField.hidden = YES;
        [nameField resignFirstResponder];
        return;
    }
    NSString *name = nameField.text;
    renamePlan.name = name;
    [mModel.project savePlans];
    nameField.text = @"";
    nameField.hidden = YES;
    [cv_plans reloadData];
    [nameField resignFirstResponder];
}

@end
