//
//  ProductInfo.m
//  project_mesher
//
//  Created by MacMini on 15/10/28.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "ProductInfo.h"
#import "MesherModel.h"
#import "GamePhotographer.h"
#import "Data.h"
#import "ProductList.h"
#import "ItemMoveCommand.h"
#import "ItemRotateCommand.h"
#import "ItemCreateCommand.h"
#import "StyleListAdapter.h"
#import "LocalPlanTable.h"
#import "PlanLoader.h"

@interface ProductInfo () <UIGestureRecognizerDelegate> {
    JWRelativeLayout *lo_product_info;
    UILabel *tv_name;
    UIImageView* img_image;
    UILabel *tv_price;
    JWImageOptions* opt_img_image;
    
    JWRelativeLayout *lo_moving;
    JWFrameLayout* lo_loading;
    JWFrameLayout *lo_move;
    UIImageView *img_item_preview;
    JWImageOptions *opt_item_preview;
    CGPoint mPoint;
    id<JIGameObject> mTempParentForSetNewPosition;
    
    id<JIGameObject> mItemObject;
    
    JWRadioViewGroup *rg_option;
    UIButton *btn_change_color;
    UIButton *btn_description;
    StyleListAdapter *mStyleListAdapter;
    JWCollectionView *cv_style;
    JWRelativeLayout *lo_style;
    JWRelativeLayout *lo_description;
    UIWebView *wv_description;
    
    // option的按钮的下划线
    JWRelativeLayout *lo_button1_line1;
    JWRelativeLayout *lo_button2_line1;
    JWRelativeLayout *lo_button2_line2;
    
//    NSIndexPath *index;
}

@property (nonatomic, readwrite) id<JIGameObject> itemObject;

@end

@implementation ProductInfo

@synthesize itemObject = mItemObject;

- (UIView *)onCreateView:(UIView *)parent{
    
    lo_product_info = (JWRelativeLayout *)[parent viewWithTag:R_id_lo_product_info];
    
    JWLinearLayout *lo_menu_product_linear = [JWLinearLayout layout];
    lo_menu_product_linear.layoutParams.width = JWLayoutMatchParent;
    lo_menu_product_linear.layoutParams.height = JWLayoutMatchParent;
    lo_menu_product_linear.orientation = JWLayoutOrientationVertical;
    [lo_product_info addSubview:lo_menu_product_linear];
    
    JWRelativeLayout* lo_item_name = [JWRelativeLayout layout];
    lo_item_name.layoutParams.width = JWLayoutMatchParent;
    lo_item_name.layoutParams.height = JWLayoutWrapContent;
    [lo_menu_product_linear addSubview:lo_item_name];
    
    UIImage *btn_back_n = [UIImage imageByResourceDrawable:@"btn_back_n.png"];
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
    [lo_menu_product_linear addSubview:img_divider_dark_520];
    
    img_image = [[UIImageView alloc] init];
    img_image.userInteractionEnabled = YES;
    CGFloat img_width = [MesherModel uiWidthBy:320.0f];
    CGFloat img_height = [MesherModel uiHeightBy:460.0f];
    CGFloat img_size = img_width > img_height ? img_width : img_height;
    img_image.layoutParams.width = img_size;
    img_image.layoutParams.height = img_size;
    img_image.layoutParams.marginLeft = [MesherModel uiWidthBy:10.0f];
    img_image.layoutParams.alignment = JWLayoutAlignCenterHorizontal;
    [lo_menu_product_linear addSubview:img_image];
    //    opt_img_image = [JWImageOptions options];
    //    opt_img_image.requestWidth = img_size;
    //    opt_img_image.requestHeight = img_size;
    opt_img_image = nil;
    
#pragma mark 拖动新建物件
    lo_move = (JWFrameLayout*)[parent viewWithTag:R_id_lo_move];
    lo_move.visible = YES;
    
    lo_moving = [JWRelativeLayout layout];
    lo_moving.layoutParams.width = JWLayoutWrapContent;
    lo_moving.layoutParams.height = JWLayoutWrapContent;
    lo_moving.hidden = YES;
    [lo_move addSubview:lo_moving];
    
    img_item_preview = [[UIImageView alloc] init];
    img_item_preview.layoutParams.width = [MesherModel uiWidthBy:500.0f];
    img_item_preview.layoutParams.height = img_item_preview.layoutParams.width;
    [lo_moving addSubview:img_item_preview];
    opt_item_preview = [JWImageOptions options];
    opt_item_preview.requestWidth = [MesherModel uiWidthBy:500.0f];
    opt_item_preview.requestHeight = opt_item_preview.requestWidth;
    
    //    crl_loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //    crl_loading.layoutParams.alignment = JWLayoutAlignCenterInParent;
    //    [lo_load addSubview:crl_loading];
#pragma mark 物件载入loading
    lo_loading = (JWFrameLayout*)[parent viewWithTag:R_id_lo_loading];
    lo_loading.hidden = YES;
//    [self createLoadingAnimationView:lo_loading];
    
    UILongPressGestureRecognizer* longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    longPressGestureRecognizer.minimumPressDuration = 0.3f;
    longPressGestureRecognizer.delegate = self;
    [img_image addGestureRecognizer:longPressGestureRecognizer];
    
#pragma mark 显示价格的容器
    JWRelativeLayout *lo_price = [JWRelativeLayout layout];
    lo_price.layoutParams.width = JWLayoutMatchParent;
    lo_price.layoutParams.height = JWLayoutWrapContent;
    [lo_menu_product_linear addSubview:lo_price];
    
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
    [lo_menu_product_linear addSubview:lo_option];
    
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
    
    rg_option = [JWRadioViewGroup group];
    [rg_option addView:btn_change_color];
    [rg_option addView:btn_description];
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
    
#pragma mark 物件的款式
    lo_style = [JWRelativeLayout layout];
    lo_style.layoutParams.width = JWLayoutMatchParent;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        lo_style.layoutParams.height = [MesherModel uiHeightBy:700.0f];
        lo_style.layoutParams.marginBottom = [MesherModel uiHeightBy:130.0f];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        lo_style.layoutParams.height = [MesherModel uiHeightBy:560.0f];
        lo_style.layoutParams.marginBottom = [MesherModel uiHeightBy:110.0f];
    }
    //lo_style.backgroundColor = [UIColor redColor];
    lo_style.layoutParams.alignment = JWLayoutAlignParentBottom | JWLayoutAlignCenterHorizontal;
    [lo_product_info addSubview:lo_style];
    
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
    cv_style.showsHorizontalScrollIndicator = NO; // 取消水平滚动条
    cv_style.showsVerticalScrollIndicator = NO; // 取消垂直滚动条
    cv_style.allowsMultipleSelection = NO; // 取消多选模式
    
#pragma mark 物件的描述
    lo_description = [JWRelativeLayout layout];
    lo_description.layoutParams.width = JWLayoutMatchParent;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        lo_description.layoutParams.height = [MesherModel uiHeightBy:700.0f];
        lo_description.layoutParams.marginBottom = [MesherModel uiHeightBy:130.0f];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        lo_description.layoutParams.height = [MesherModel uiHeightBy:560.0f];
        lo_description.layoutParams.marginBottom = [MesherModel uiHeightBy:110.0f];
    }
    lo_description.layoutParams.alignment = JWLayoutAlignParentBottom | JWLayoutAlignCenterHorizontal;
    lo_description.hidden = YES;
    [lo_product_info addSubview:lo_description];
    
    wv_description = [[UIWebView alloc] init];
    wv_description.layoutParams.width = [MesherModel uiWidthBy:500.0f];
    wv_description.layoutParams.height = JWLayoutMatchParent;
    wv_description.layoutParams.alignment = JWLayoutAlignParentBottomRight;
    [lo_description addSubview:wv_description];
    wv_description.scrollView.showsHorizontalScrollIndicator = NO;
    
#pragma mark undo redo
    btn_undo = (UIImageView*)[parent viewWithTag:R_id_btn_undo];
    btn_redo = (UIImageView*)[parent viewWithTag:R_id_btn_redo];
    
#pragma mark 交互按钮
    btn_back.userInteractionEnabled = YES;
    [self.gestureEventBinder bindEventsWithType:JWGestureTypeSingleTap toView:btn_back willBindSubviews:NO andFilter:nil];
    
    return lo_product_info;
}

//进入状态的前置条件
- (BOOL)onPreCondition {
    if(mModel.currentProduct == nil) {
        return NO;
    }
    return YES;
}

- (void) updateCurrentItemInfoUI {
    if(mModel.currentProduct == nil) {
        lo_product_info.hidden = YES;
        return;
    }
    lo_product_info.hidden = NO;
    [self updateUndoRedoState];
    mStyleListAdapter.data = mModel.currentProduct.items;
    [mStyleListAdapter notifyDataSetChanged];
    
    // 判断一个字符串是一个有效的网址 正则表达式
    NSString *description = mModel.currentProduct.description;
    if (description != nil) {
        [wv_description loadHTMLString:description baseURL:nil];
    }
    
    tv_name.text = mModel.currentProduct.name == nil ? @"未知物件" : mModel.currentProduct.name;
    Item *item = mModel.currentProduct.items[0];
    //    id<IMesherModel> model = mModel;
    //    gv_style.onItemClick = (^(NSUInteger position, id item){
    //        Item *it = model.currentProduct.items[position];
    //        // 如果点中是gv中的其他项 改变menu属性
    //        // TODO
    //    });
    
    tv_price.text = [NSString stringWithFormat:@"%.2f",item.price];
    if (mModel.currentProduct.preview != nil){
        [[JWCorePluginSystem instance].imageCache getBy:mModel.currentProduct.preview options:opt_img_image async:YES onGet:^(UIImage *image) {
            img_image.image = image;
        }];
    }
}

- (void)onStateEnter:(NSDictionary *)data {
    [super onStateEnter:data];
    
    lo_style.hidden = NO;
    lo_description.hidden = YES;
    rg_option.checkedView = btn_change_color;
    lo_button1_line1.hidden = NO;
    lo_button2_line1.hidden = YES;
    lo_button2_line2.hidden = YES;
    
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        [btn_change_color setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [btn_description setTitleEdgeInsets:UIEdgeInsetsMake(10, 0, 0, 0)];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        [btn_change_color setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [btn_description setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    }
    
    [self updateCurrentItemInfoUI];// 为右边的menu赋值
    
    // 选中逻辑
    ProductInfo* weakSelf = self;
    __block id<IMesherModel> model = mModel;
    mModel.itemSelectAndMoveBehaviour.selectedMask = SelectedMaskAllArchsExceptCeil | SelectedMaskAllItemsExceptTop;
    mModel.itemSelectAndMoveBehaviour.onSelect = (^(id<JIGameObject> object) {
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

//离开状态时
- (void)onStateLeave{
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

- (BOOL)onTouchUp:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    switch (touch.view.tag) {
        case R_id_btn_change_color: {
            rg_option.checkedView = touch.view;
            if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
                [btn_change_color setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
                [btn_description setTitleEdgeInsets:UIEdgeInsetsMake(10, 0, 0, 0)];
            }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
                [btn_change_color setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
                [btn_description setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
            }
            lo_button1_line1.hidden = NO;
            lo_button2_line1.hidden = YES;
            lo_button2_line2.hidden = YES;
            lo_description.hidden = YES;
            lo_style.hidden = NO;
            break;
        }
        case R_id_btn_description: {
            rg_option.checkedView = touch.view;
            if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
                [btn_change_color setTitleEdgeInsets:UIEdgeInsetsMake(10, 0, 0, 0)];
                [btn_description setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
                [btn_change_color setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
                [btn_description setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            }
            lo_button1_line1.hidden = YES;
            lo_button2_line1.hidden = NO;
            lo_button2_line2.hidden = NO;
            lo_description.hidden = NO;
            lo_style.hidden = YES;
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
            img_item_preview.visible = YES;
            if (mModel.currentProduct.preview != nil){
                [[JWCorePluginSystem instance].imageCache getBy:mModel.currentProduct.preview options:opt_item_preview async:YES onGet:^(UIImage *image) {
                    img_item_preview.image = image;
                }];
            }
            lo_moving.visible = YES;
            CGPoint point = [longPress locationInView:lo_move];
            lo_moving.layoutParams.marginLeft = point.x - img_item_preview.frame.size.width * 0.5f;
            lo_moving.layoutParams.marginTop = point.y - img_item_preview.frame.size.height * 0.5f;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (mModel.currentProduct == nil) {
                break;
            }
            CGPoint point = [longPress locationInView:lo_move];
            lo_moving.layoutParams.marginLeft = point.x - img_item_preview.frame.size.width * 0.5f;
            lo_moving.layoutParams.marginTop = point.y - img_item_preview.frame.size.height * 0.5f;
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if (mModel.currentProduct == nil) {
                break;
            }
            img_item_preview.visible = NO;
            CGPoint point = [longPress positionInPixelsInView:lo_move];
            mPoint = point;
            if(mModel.currentProduct.area == AreaArchitecture && mModel.currentPlan.architectureObject != nil) {  // 新建户型，并让用户选择是否要删除现有场景
                [JWAppUtils showDialogWithTitle:@"新建户型" message:@"是否清除场景？" onButtonChecked:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [mModel.currentPlan destroyAllObjects];// 移除原先的户
                        mModel.selectedObject = nil;
                        mModel.preSelectedObject = nil;
                        [mModel.commandMachine clear];// 场景清空后把commandMachine命令清除
//                        [self loadProduct:mModel.currentProduct atPoint:mPoint];
                        if (mModel.currentPlan.isSuit) {
                            mModel.currentPlan = [mModel.project addSuitPlanToLocal:mModel.currentPlan];
                            mModel.currentPlan.isSuit = NO;
                            [mModel.currentPlan saveScene];
                            id<JIFile> file = [JWFile fileWithType:JWFileTypeDocument path:@"plans.fit"];
                            LocalPlanTable* pt = [[LocalPlanTable alloc] initWithFileType:LocalPlanTableFileTypeDocument model:mModel bundle:nil]; // 保存的路径在沙盒中
                            [pt saveFile:file records:mModel.project.plans];
                            //[plan destroyAllObjects];
                            mModel.currentPlan.isCreatedPlan = YES;
                        }
                        [mModel.project loadBasePlans];
                        Plan *p = [mModel.project.allShapes at:mModel.project.indexPath.row];
                        mModel.currentPlan.scene.data = p.scene.data;
                        [mModel.project savePlans];
                        id<JIGameContext> context = mModel.currentContext;
                        id<JIGameScene> scene = mModel.currentScene;
                        PlanLoader* planLoader = (PlanLoader*)[context.sceneLoaderManager getLoaderForFile:mModel.currentPlan.scene];
                        planLoader.plan = mModel.currentPlan;
                        [planLoader loadFile:mModel.currentPlan.scene parent:scene.root params:nil async:YES listener:nil];
                        //[self loadProduct:mCurrentProduct atPoint:mPoint];
                        mModel.borderObject = nil;
                        [self.parentMachine revertStateStep:2];
                    }
                } cancelButton:@"取消" otherButtons:@"确认", nil];
            } else { // 直接加载产品
                if (mModel.currentProduct.position == PositionOnWall) {
                    id<JIGameScene> scene = mModel.currentScene; // 获取场景
                    scene.rayQuery.willSortByDistance = YES; // 射线查询 按照距离排序 为了找到射线的第一个目标对象
                    scene.rayQuery.mask = SelectedMaskAllItems | SelectedMaskAllArchs;// 可以优化
                    id<JIRayQueryResult> result = [scene getCameraRayQueryResultFromScreenX:point.x screenY:point.y]; // 通过点 来获取射线
                    if (result.numEntries > 0) { // result 是个列表(包含了距离 和 物件) 是射线穿过的物件
                        id<JIGameObject> wall;
                        for (int i = 0; i < result.numEntries; i++) {
                            JWRayQueryResultEntry* e = [result entryAt:i];
                            ItemInfo *itemInfo = [Data getItemInfoFromInstance:e.object];
                            if (itemInfo.type == ItemTypeWall) {
                                wall = e.object;
                                break;
                            }
                        }
                        if (wall == nil) {
                            lo_moving.visible = YES;
                        }else {
                            ItemInfo *itemInfo = [Data getItemInfoFromInstance:wall];
                            JCVector2 cameraXY = [mModel.currentCamera.camera getCoordinatesFromScreenX:point.x screenY:point.y];
                            JCRay3 ray = [mModel.currentCamera.camera getRayFromX:cameraXY.x screenY:cameraXY.y];
                            JCVector3 normal = JCVector3Make([itemInfo.dx floatValue], [itemInfo.dy floatValue], [itemInfo.dz floatValue]);
                            
                            JCFloat distance = fabsf([itemInfo.dx floatValue] * wall.transformBounds.min.x + [itemInfo.dy floatValue] * wall.transformBounds.min.y + [itemInfo.dz floatValue] * wall.transformBounds.min.z);//原点到平面的距离
                            JCPlane ground = JCPlaneMake(normal, distance);//平面的位置
                            JCRayPlaneIntersectResult result = JCRayPlaneIntersect(&ray, &ground);
                            result.point = JCRayPlaneIntersectResultGetHitPoint(&result, &ray);
                            JCVector3 newPosition = JCVector3Zero();
                            if (result.hit) {
                                newPosition = result.point;// 点击到的墙的点
                            }
                            //为了不和墙体重叠 离墙0.01
                            if([itemInfo.dx intValue] != 0) {
                                if ([itemInfo.dx intValue] > 0){
                                    newPosition.x += 0.01f;
                                }else {
                                    newPosition.x -= 0.01f;
                                }
                            }else if ([itemInfo.dz intValue] != 0){
                                if ([itemInfo.dz intValue] > 0){
                                    newPosition.z += 0.01f;
                                }else {
                                    newPosition.z -= 0.01f;
                                }
                            }
                            
                            Item* item = [mModel.currentProduct.items at:0];
                            //异步加载 创建监听
                            JWSceneLoaderOnLoadingListener* listener = [[JWSceneLoaderOnLoadingListener alloc] init];
                            listener.onFinish = (^(id<JIFile> file, id<JIGameObject> parent, id<JIGameObject> object){
                                mModel.selectedObject = object;
                                mModel.currentProduct = nil;
//                                [self stopLoadingAnimation];
                                lo_loading.hidden = YES;
                                lo_moving.hidden = YES;
                                lo_move.clickable = NO;
                                ItemInfo *info = [ItemInfo new];
                                info.type = ItemTypeItem;
                                [Data bindInstance:object toItemInfo:info];
                                [self.parentMachine changeStateTo:[States ItemEdit] pushState:NO];
                            });
                            listener.onFailed = (^(id<JIFile> file, id<JIGameObject> parent, NSError* error){
                                NSLog(@"加载失败");
//                                [self stopLoadingAnimation];
                                lo_loading.hidden = YES;
                                lo_moving.hidden = YES;
                                lo_move.clickable = NO;
                            });
                            lo_move.clickable = YES;
                            lo_moving.hidden = NO;
//                            [self startLoadingAnimation];
                            lo_loading.hidden = NO;
                            [mModel.currentPlan loadItem:item position:newPosition orientation:JCQuaternionIdentity() async:NO listener:listener];
                            JCVector3 selectObjZ = [mModel.selectedObject.transform zAxisInSpace:JWTransformSpaceWorld];
                            float d = JCVector3DotProductv(&normal, &selectObjZ);
                            float radians = acosf(d);
                            float degrees = JCRad2Deg(radians); // 旋转的角度
                            if ([itemInfo.dx intValue] < 0) {
                                degrees =  -degrees;//比较特殊的面
                            }
                            [mModel.selectedObject.transform rotateUpDegrees:degrees+180];
                            ItemCreateCommand *command = [[ItemCreateCommand alloc] init];
                            command.object = mModel.selectedObject;
                            command.plan = mModel.currentPlan;
                            command.gridsObject = mModel.gridsObject;
                            [mModel.commandMachine doneCommand:command];
                            [self updateUndoRedoState];
                        }
                    }else {
                        lo_moving.visible = YES;
                    }
                }else if (mModel.currentProduct.position == PositionInWall) {
                    id<JIGameScene> scene = mModel.currentScene; // 获取场景
                    scene.rayQuery.willSortByDistance = YES; // 射线查询 按照距离排序 为了找到射线的第一个目标对象
                    scene.rayQuery.mask = SelectedMaskAllItems | SelectedMaskAllArchs;// 可以优化
                    id<JIRayQueryResult> result = [scene getCameraRayQueryResultFromScreenX:point.x screenY:point.y]; // 通过点 来获取射线
                    id<JIGameObject> wall;
                    for (int i = 0; i < result.numEntries; i++) {
                        JWRayQueryResultEntry* e = [result entryAt:i];
                        ItemInfo *itemInfo = [Data getItemInfoFromInstance:e.object];
                        if (itemInfo.type == ItemTypeWall) {
                            wall = e.object;
                            break;
                        }
                    }
                    if (wall == nil) {
                        [self loadProduct:mModel.currentProduct atPoint:point];
                    }else {
                        ItemInfo *itemInfo = [Data getItemInfoFromInstance:wall];
                        JCVector2 cameraXY = [mModel.currentCamera.camera getCoordinatesFromScreenX:point.x screenY:point.y];
                        JCRay3 ray = [mModel.currentCamera.camera getRayFromX:cameraXY.x screenY:cameraXY.y];
                        JCVector3 normal = JCVector3Make([itemInfo.dx floatValue], [itemInfo.dy floatValue], [itemInfo.dz floatValue]);
                        
                        JCFloat distance = fabsf([itemInfo.dx floatValue] * wall.transformBounds.min.x + [itemInfo.dy floatValue] * wall.transformBounds.min.y + [itemInfo.dz floatValue] * wall.transformBounds.min.z);//原点到平面的距离
                        JCPlane ground = JCPlaneMake(normal, distance);//平面的位置
                        JCRayPlaneIntersectResult result = JCRayPlaneIntersect(&ray, &ground);
                        result.point = JCRayPlaneIntersectResultGetHitPoint(&result, &ray);
                        JCVector3 newPosition = JCVector3Zero();
                        if (result.hit) {
                            newPosition = result.point;// 点击到的墙的点
                        }
                        //为了不和墙体重叠 离墙0.01
                        if([itemInfo.dx intValue] != 0) {
                            if ([itemInfo.dx intValue] > 0){
                                newPosition.x += 0.01f;
                            }else {
                                newPosition.x -= 0.01f;
                            }
                        }else if ([itemInfo.dz intValue] != 0){
                            if ([itemInfo.dz intValue] > 0){
                                newPosition.z += 0.01f;
                            }else {
                                newPosition.z -= 0.01f;
                            }
                        }
                        newPosition.y = 0.01;
                        Item* item = [mModel.currentProduct.items at:0];
                        //异步加载 创建监听
                        JWSceneLoaderOnLoadingListener* listener = [[JWSceneLoaderOnLoadingListener alloc] init];
                        listener.onFinish = (^(id<JIFile> file, id<JIGameObject> parent, id<JIGameObject> object){
                            mModel.selectedObject = object;
                            mModel.currentProduct = nil;
//                            [self stopLoadingAnimation];
                            lo_loading.hidden = YES;
                            lo_moving.hidden = YES;
                            lo_move.clickable = NO;
                            ItemInfo *info = [ItemInfo new];
                            info.type = ItemTypeItem;
                            [Data bindInstance:object toItemInfo:info];
                            [self.parentMachine changeStateTo:[States ItemEdit] pushState:NO];
                        });
                        listener.onFailed = (^(id<JIFile> file, id<JIGameObject> parent, NSError* error){
                            NSLog(@"加载失败");
//                            [self stopLoadingAnimation];
                            lo_loading.hidden = YES;
                            lo_moving.hidden = YES;
                            lo_move.clickable = NO;
                        });
                        lo_move.clickable = YES;
                        lo_moving.hidden = NO;
//                        [self startLoadingAnimation];
                        lo_loading.hidden = NO;
                        [mModel.currentPlan loadItem:item position:newPosition orientation:JCQuaternionIdentity() async:NO listener:listener];
                        JCVector3 selectObjZ = [mModel.selectedObject.transform zAxisInSpace:JWTransformSpaceWorld];
                        float d = JCVector3DotProductv(&normal, &selectObjZ);
                        float radians = acosf(d);
                        float degrees = JCRad2Deg(radians); // 旋转的角度
                        if ([itemInfo.dx intValue] < 0) {
                            degrees =  -degrees;//比较特殊的面
                        }
                        [mModel.selectedObject.transform rotateUpDegrees:degrees];
                        ItemCreateCommand *command = [[ItemCreateCommand alloc] init];
                        command.object = mModel.selectedObject;
                        command.plan = mModel.currentPlan;
                        command.gridsObject = mModel.gridsObject;
                        [mModel.commandMachine doneCommand:command];
                        [self updateUndoRedoState];
                    }
                }else if (mModel.currentProduct.position == PositionTop){
                    if (mModel.isFPS) {
                        id<JIGameScene> scene = mModel.currentScene; // 获取场景
                        scene.rayQuery.willSortByDistance = YES; // 射线查询 按照距离排序 为了找到射线的第一个目标对象
                        scene.rayQuery.mask = SelectedMaskAllArchs | SelectedMaskAllItems;
                        id<JIRayQueryResult> result = [scene getCameraRayQueryResultFromScreenX:point.x screenY:point.y]; // 通过点 来获取射线
                        id<JIGameObject> ceil = nil;
                        for (int i = 0; i < result.numEntries; i++) {
                            JWRayQueryResultEntry* e = [result entryAt:i];
                            ItemInfo *itemInfo = [Data getItemInfoFromInstance:e.object];
                            if (itemInfo.type == ItemTypeCeil) {
                                ceil = e.object;
                                break;
                            }
                        }
                        if(ceil != nil) {
                            ItemInfo *itemInfo = [Data getItemInfoFromInstance:ceil];
                            JCVector2 cameraXY = [mModel.currentCamera.camera getCoordinatesFromScreenX:point.x screenY:point.y];
                            JCRay3 ray = [mModel.currentCamera.camera getRayFromX:cameraXY.x screenY:cameraXY.y];
                            JCVector3 normal = JCVector3Make([itemInfo.dx floatValue], [itemInfo.dy floatValue], [itemInfo.dz floatValue]);
                            
                            JCFloat distance = fabsf([itemInfo.dx floatValue] * ceil.transformBounds.min.x + [itemInfo.dy floatValue] * ceil.transformBounds.min.y + [itemInfo.dz floatValue] * ceil.transformBounds.min.z);//原点到平面的距离
                            JCPlane ground = JCPlaneMake(normal, distance);//平面的位置
                            JCRayPlaneIntersectResult result = JCRayPlaneIntersect(&ray, &ground);
                            result.point = JCRayPlaneIntersectResultGetHitPoint(&result, &ray);
                            JCVector3 newPosition = JCVector3Zero();
                            if (result.hit) {
                                newPosition = result.point;// 点击到的墙的点
                            }
                            newPosition.y -= 0.01f;
                            Item* item = [mModel.currentProduct.items at:0];
                            //异步加载 创建监听
                            JWSceneLoaderOnLoadingListener* listener = [[JWSceneLoaderOnLoadingListener alloc] init];
                            listener.onFinish = (^(id<JIFile> file, id<JIGameObject> parent, id<JIGameObject> object){
                                mModel.selectedObject = object;
                                mModel.currentProduct = nil;
//                                [self stopLoadingAnimation];
                                lo_loading.hidden = YES;
                                lo_moving.hidden = YES;
                                lo_move.clickable = NO;
                                ItemInfo *info = [ItemInfo new];
                                info.type = ItemTypeItem;
                                [Data bindInstance:object toItemInfo:info];
                                [self.parentMachine changeStateTo:[States ItemEdit] pushState:NO];
                            });
                            listener.onFailed = (^(id<JIFile> file, id<JIGameObject> parent, NSError* error){
                                NSLog(@"加载失败");
//                                [self stopLoadingAnimation];
                                lo_loading.hidden = YES;
                                lo_moving.hidden = YES;
                                lo_move.clickable = NO;
                            });
                            lo_move.clickable = YES;
                            lo_moving.hidden = NO;
//                            [self startLoadingAnimation];
                            lo_loading.hidden = NO;
                            [mModel.currentPlan loadItem:item position:newPosition orientation:JCQuaternionIdentity() async:NO listener:listener];
                            ItemCreateCommand *command = [[ItemCreateCommand alloc] init];
                            command.object = mModel.selectedObject;
                            command.plan = mModel.currentPlan;
                            command.gridsObject = mModel.gridsObject;
                            [mModel.commandMachine doneCommand:command];
                            [self updateUndoRedoState];
                        }
                    }
                }else {
                    [self loadProduct:mModel.currentProduct atPoint:point];
                }
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            if (mModel.currentProduct == nil) {
                break;
            }
            lo_moving.visible = NO;
            break;
        }
        default: {
            break;
        }
    }
}

- (void) loadProduct:(Product*)product atPoint:(CGPoint)point {
    if (product.items == nil || product.items.count == 0) {
        [self.parentMachine revertState];
        return;
    }
    Item* item = [product.items at:0];
    [self loadItem:item atPoint:point];
}

- (void) loadItem:(Item*)item atPoint:(CGPoint)point {
    // 计算出生位置
    JCVector3 newPosition = JCVector3Zero();
    if (item.product.area != AreaArchitecture) {
        JCRayPlaneIntersectResult result = [mModel.currentScene getCameraRayToUnitYZeroPlaneResultFromScreenX:point.x screenY:point.y];
        if (result.hit) {
            newPosition = result.point;
        }
        newPosition.y = 0.01f; // 放到地上
    }
    if (item.source == nil) {
        [self.parentMachine revertState];
        return;
    }
    Source* source = item.source;
    if (source.file == nil) {
        [self.parentMachine revertState];
        return;
    }
    id<JIFile> file = source.file;
    
    //提取model里的对象
    id<JIGameContext> context = mModel.currentContext;//获取context对象
    id<JIGameScene> scene = mModel.currentScene;//获取场景对象
    id<JIGameObject> root = scene.root;//获取场景根结点
    scene.root.queryMask = SelectedMaskCannotSelect;
    id<JISceneLoader> loader = [context.sceneLoaderManager getLoaderForFile:file];//获取一个加载器
    
    if (mTempParentForSetNewPosition == nil) {
        mTempParentForSetNewPosition = [context createObject];
        mTempParentForSetNewPosition.parent = root;
        mTempParentForSetNewPosition.queryMask = SelectedMaskCannotSelect;
    }
    [mTempParentForSetNewPosition.transform setPosition:newPosition inSpace:JWTransformSpaceWorld];
    
    //异步加载 创建监听
    JWSceneLoaderOnLoadingListener* listener = [[JWSceneLoaderOnLoadingListener alloc] init];
    listener.onObjectLoaded = (^(id<JIGameObject> object) {
        object.queryMask = SelectedMaskCannotSelect;
    });
    listener.onProgress = (^(float progress){
        // 可以设置进度条
    });
    listener.onFinish = (^(id<JIFile> file, id<JIGameObject> parent, id<JIGameObject> object){
        // object就是要加载的场景对象
        //[object.transform setPositionV:newPosition inSpace:JWTransformSpaceWorld];
        object.parent = root;
        [object.transform setPosition:[mTempParentForSetNewPosition.transform positionInSpace:JWTransformSpaceWorld] inSpace:JWTransformSpaceWorld];
        
        [Data bindInstance:object toItem:item]; // 绑定item
        //[mModel.plan addObject:object]; // 添加到plan
        mModel.selectedObject = object;
        mModel.currentProduct = nil;
//        [self stopLoadingAnimation];
        lo_loading.hidden = YES;
        lo_moving.hidden = YES;
        lo_move.clickable = NO;
        
        if (item.product.area == AreaArchitecture) { // NOTE 户型不能点击或编辑
            //object.queryMask = [MesherModel CanNotSelectMask];
            mModel.gridsObject.visible = NO; // 户型加载后，默认把网格隐藏
            ItemCreateCommand *command = [[ItemCreateCommand alloc] init];
            command.object = object;
            command.plan = mModel.currentPlan;
            [mModel.commandMachine todoCommand:command];
            [self updateUndoRedoState];
            [self.parentMachine revertState];
        } else {
            //object.queryMask = [MesherModel CanSelectMask];//设置成可点击的 才能在planEdit状态下 点击操作
            ItemCreateCommand *command = [[ItemCreateCommand alloc] init];
            command.object = object;
            command.plan = mModel.currentPlan;
            [mModel.commandMachine todoCommand:command];
            [self updateUndoRedoState];
            // 直接进入编辑状态
            ItemInfo *info = [ItemInfo new];
            info.type = ItemTypeItem;
            info.originScale = object.transform.scale;
            [Data bindInstance:object toItemInfo:info];
            [self.parentMachine changeStateTo:[States ItemEdit] pushState:NO];//不压栈
        }
    });
    listener.onFailed = (^(id<JIFile> file, id<JIGameObject> parent, NSError* error){
        NSLog(@"加载失败");
//        [self stopLoadingAnimation];
        lo_loading.hidden = YES;
        lo_moving.hidden = YES;
        lo_move.clickable = NO;
    });
    lo_move.clickable = YES;
    lo_moving.hidden = NO;
//    [self startLoadingAnimation];
    lo_loading.hidden = NO;
    //加载器                     所要展示的对象
    [loader loadFile:file parent:mTempParentForSetNewPosition params:nil async:YES listener:listener];
}

@end
