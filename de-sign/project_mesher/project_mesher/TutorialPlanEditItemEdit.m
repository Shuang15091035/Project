//
//  TutorialPlanEditItemEdit.m
//  project_mesher
//
//  Created by mac zdszkj on 16/5/16.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "TutorialPlanEditItemEdit.h"
#import "MesherModel.h"
#import "GamePhotographer.h"
#import <jw/JCMath.h>
#import "Data.h"
#import "ItemMoveCommand.h"
#import "ItemRotateCommand.h"
#import "ItemLongPressRotateCommand.h"
#import "StyleListAdapter.h"
#import "ItemDeleteCommand.h"

@interface TutorialPlanEditItemEdit () <UIGestureRecognizerDelegate> {
    JWRelativeLayout *lo_item_edit;
    UILabel *tv_name;
    UIImageView* img_image;
    JWImageOptions* opt_img_image;
    UILabel *tv_price;
    JWRelativeLayout* lo_object_menu_container; // 物件上的菜单容器
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
    
    UIImage *btn_rotate_n;
    UILabel *lv_degree;
    UIButton *btn_rotate;
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
    
    NSTimer *rotate_timer_left;
    NSTimer *rotate_timer_right;
    
    BOOL isRotated;
    
    id<JIGameObject> tempObject;
    
    JWRelativeLayout *lo_teachMov;
    
    UIImageView *teachMove;
    NSTimer *moveTimer;
    BOOL isMoving;
    
    UIImageView *teachRotate;
    NSTimer *rotateTimer;
    CAKeyframeAnimation *rotatedAnimation;
    CGFloat tempObjectRotateDegree;
    
    CGPoint tempMovePoint;
    JCVector3 tempObjectBasePosition;
    
    NSTimer *inTeachObj;
    BOOL isMove;
    
    JWRelativeLayout *lo_teachLoad;
    
    NSTimer *teachAgain;
    CAAnimationGroup *toMoveGroup;
    CAAnimationGroup *toRotateGroup;
    
    BOOL notFirstTeach;
    UIImageView *lo_cg;
    
    BOOL rotating;
}

@property (nonatomic, readwrite) float mObject_menu_width;
@property (nonatomic, readwrite) BOOL mIsRotated;

@end

@implementation TutorialPlanEditItemEdit

@synthesize mObject_menu_width = object_menu_width;
@synthesize mIsRotated = isRotated;

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
    tv_name.textColor = [UIColor colorWithARGB:0xff35c6ff];
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
    lo_object_menu_container = (JWRelativeLayout*)[parent viewWithTag:R_id_lo_control];
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
//    btn_delete.layoutParams.marginLeft = 2;
    [lo_object_menu addSubview:btn_delete];
    
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
    lv_degree.layoutParams.alignment = JWLayoutAlignCenterInParent;
    lv_degree.layoutParams.height = JWLayoutWrapContent;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        lv_degree.layoutParams.width = [self uiWidthBy:80.0f];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        lv_degree.layoutParams.width = [self uiWidthBy:110.0f];
    }
    [lo_rotate_degree addSubview:lv_degree];
    
    btn_rotate_n = [UIImage imageByResourceDrawable:@"btn_rotate_n"];
    btn_rotate = [[UIButton alloc] initWithImage:btn_rotate_n highlightedImage:btn_rotate_n];
    btn_rotate.tag = R_id_btn_rotate;
    btn_rotate.layoutParams.width = JWLayoutWrapContent;
    btn_rotate.layoutParams.height = JWLayoutWrapContent;
    btn_rotate.layoutParams.marginLeft = 2;
    [lo_object_menu addSubview:btn_rotate];
    [self.viewEventBinder bindEventsToView:btn_rotate willBindSubviews:NO andFilter:nil];

#pragma mark teach动画遮罩 防止误点击操作用
    lo_teachLoad = [JWRelativeLayout layout];
    lo_teachLoad.tag = R_id_lo_teach_load;
    lo_teachLoad.layoutParams.width = JWLayoutMatchParent;
    lo_teachLoad.layoutParams.height = JWLayoutMatchParent;
    lo_teachLoad.backgroundColor = [UIColor clearColor];
    lo_teachLoad.clickable = YES;
    [lo_object_menu_container addSubview:lo_teachLoad];
    lo_teachLoad.hidden = YES;
    [self.viewEventBinder bindEventsToView:lo_teachLoad willBindSubviews:NO andFilter:nil];
    
#pragma mark 物件边框 初始化
    id<JIFile> file = [JWFile fileWithBundle:[NSBundle mainBundle] path:[JWResourceBundle nameForDrawable:@"item_rect_frame.png"]];
    mItemRectFrameDecals = [[JWRect4CornersDecals alloc] initWithContext:mModel.currentContext parent:mModel.currentScene.root innerWidth:1.0f innerHeight:1.0f cornerOffsetX:0.15f cornerOffsetY:0.15f thickness:0.06f cornerOffsetU:0.0f cornerOffsetV:0.0f uvThickness:0.346f decalsFile:file];
    mItemRectFrameDecals.decalsObject.visible = NO;
    mItemRectFrameDecals.decalsObject.queryMask = SelectedMaskCannotSelect;
    [mItemRectFrameDecals.decalsObject.transform setInheritScale:NO];
    mModel.itemRectFrameDecals = mItemRectFrameDecals;
    
    
    btn_undo = (UIImageView*)[parent viewWithTag:R_id_btn_undo];
    btn_redo = (UIImageView*)[parent viewWithTag:R_id_btn_redo];
    
    UILongPressGestureRecognizer* longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    [longPressGestureRecognizer setNumberOfTapsRequired:1];
    [longPressGestureRecognizer setNumberOfTouchesRequired:1];
    longPressGestureRecognizer.minimumPressDuration = 0.5f;
    longPressGestureRecognizer.delegate = self;
    [btn_left addGestureRecognizer:longPressGestureRecognizer];
    [btn_right addGestureRecognizer:longPressGestureRecognizer];
    
    lo_teachMov = (JWRelativeLayout*)[parent viewWithTag:R_id_lo_teach_mov];
    
    lo_cg = (UIImageView*)[parent viewWithTag:R_id_lo_cg];
    lo_cg.alpha = 0.0f;
    
    return lo_item_edit;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString *an = [anim valueForKey:@"moveGroup"];
    if ([an isEqual:@"moving"]) {
        isMoving = YES;
    }
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
        JCBounds3 objectBounds = object.scaleBounds;
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
            [mItemRectFrameDecals.decalsObject.transform rotateDegrees:90 byAxis:JCVector3Make(1, 0, 0)];
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

- (void)move {
    lo_teachLoad.hidden = NO;
    CALayer *moveTeachLayer = [teachMove.layer presentationLayer];//要从所有layer中取出有用的layer
    CGPoint p =[[UIScreen mainScreen] pointInPixelsByPoint:moveTeachLayer.position];//点转像素
    if (isMoving) {
        isMoving = NO;
        //停止动画
        teachMove.hidden = YES;
        [teachMove.layer removeAllAnimations];
        [moveTimer invalidate];
        isMove = YES;
    }else {
        id<JIGameScene> scene = mModel.currentScene;
        JCRayPlaneIntersectResult result = [scene getCameraRayToUnitYZeroPlaneResultFromScreenX:p.x screenY:p.y];//和地面求交
        JCVector3 point = result.point;
        point.y = 0.01f;
        [tempObject.transform setPosition:point inSpace:JWTransformSpaceWorld];
    }
    tempMovePoint = p;
}

- (void)teachAgain {
    if (!mModel.completedMove) {
        teachMove.hidden = NO;
        isMoving = NO;
        isMove = NO;
        
        CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnimation.calculationMode = kCAAnimationPaced;
        moveAnimation.fillMode = kCAFillModeForwards;
        moveAnimation.removedOnCompletion = NO;
        moveAnimation.duration = 2.0f;
        moveAnimation.repeatCount = 1;
        CGMutablePathRef movePath = CGPathCreateMutable();
        CGPathMoveToPoint(movePath, NULL, mModel.teachTouchUpPoint.x, mModel.teachTouchUpPoint.y);
        CGPathAddLineToPoint(movePath, NULL, mModel.gameViewWidth/2, [UIScreen mainScreen].bounds.size.height/2);
        moveAnimation.path = movePath;
        CGPathRelease(movePath);
        toMoveGroup = [CAAnimationGroup animation];
        toMoveGroup.fillMode = kCAFillModeForwards;
        toMoveGroup.removedOnCompletion = NO;
        [toMoveGroup setAnimations:[NSArray arrayWithObjects: moveAnimation, nil]];
        toMoveGroup.duration = 2.0f;
        toMoveGroup.delegate = self;
        [toMoveGroup setValue:@"moving" forKey:@"moveGroup"];
        [teachMove.layer addAnimation:toMoveGroup forKey:@"move"];
        
        moveTimer =  [NSTimer scheduledTimerWithTimeInterval:0.0167 target:self selector:@selector(move) userInfo:nil repeats:YES];
        rotateTimer = [NSTimer scheduledTimerWithTimeInterval:0.0167 target:self selector:@selector(rotated) userInfo:nil repeats:YES];
    }
}

- (void)rotated {
    Item *it = [Data getItemFromInstance:mModel.selectedObject];
    if (it.Id == 21) {
        if (isMove) {
            lo_teachLoad.hidden = NO;
            if (rotatedAnimation == nil) {
                teachRotate.hidden = NO;
                rotatedAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
                rotatedAnimation.calculationMode = kCAAnimationPaced;
                rotatedAnimation.fillMode = kCAFillModeForwards;
                rotatedAnimation.removedOnCompletion = NO;
                rotatedAnimation.duration = 2.0f;
                rotatedAnimation.repeatCount = 1;
                CGMutablePathRef rotatedPath = CGPathCreateMutable();
                
                CGPathMoveToPoint(rotatedPath, NULL, lo_object_menu.frame.origin.x + btn_rotate_n.size.width * 3 , lo_object_menu.frame.origin.y);
                CGPathAddLineToPoint(rotatedPath, NULL, lo_object_menu.frame.origin.x + btn_rotate_n.size.width*3, lo_object_menu.frame.origin.y + [MesherModel uiHeightBy:250.0f]);
                rotatedAnimation.path = rotatedPath;
                CGPathRelease(rotatedPath);
            }
            teachRotate.hidden = NO;
            teachRotate.alpha = 1.0f;
            if (!rotating) {
                rotating = YES;
                [teachRotate.layer addAnimation:rotatedAnimation forKey:@"rotate"];
            }
            btn_link.alpha = 0.0f;
            btn_AR.alpha = 0.0f;
            btn_delete.alpha = 0.0f;
            lv_degree.visible = YES;
            tempObjectRotateDegree = 1.0f;
            [mModel.selectedObject.transform rotateUpDegrees:tempObjectRotateDegree];
            CGFloat degree = tempObject.transform.yawing;
            lv_degree.text = [NSString stringWithFormat:@"%.1f°",degree];
            if (degree >= 89.0f) {
                rotating = NO;
                [teachRotate.layer removeAllAnimations];
                teachRotate.alpha = 0.0f;
                btn_link.alpha = 1.0f;
                btn_AR.alpha = 1.0f;
                btn_delete.alpha = 1.0f;
                lv_degree.visible = NO;
                lv_degree.text = nil;
                [mModel.selectedObject.transform rotateUpDegrees:-90.0f];
                if (notFirstTeach) {
                    [mModel.selectedObject.transform setPosition:mModel.teachMoveLastPosition inSpace:JWTransformSpaceWorld];
                }else {
                    [mModel.selectedObject.transform setPosition:tempObjectBasePosition inSpace:JWTransformSpaceWorld];
                }
                lo_teachLoad.hidden = YES;
                notFirstTeach = YES;
                [rotateTimer invalidate];
            }
        }
    }
}

- (void)inTeachObj {
    if (mModel.isInTeachObject && notFirstTeach) {
        mModel.completedMove = YES;
        [mModel.teachDeacls setVisible:NO];
        [mModel.preSelectedObject removeComponent:mItemEditMenu]; // 先取下之前对象的edit菜单
        mModel.selectedObject = nil;
        [self showRectFrameToItem:mModel.selectedObject];
        [self updateUndoRedoState];
        [inTeachObj invalidate];
        [UIView animateWithDuration:2.5 animations:^{
            lo_cg.alpha = 1.0f;
            [lo_cg startAnimating];
        } completion:^(BOOL finished) {
            lo_cg.alpha = 1.0f;
            [UIView animateWithDuration:1.0f animations:^{
                lo_cg.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [lo_cg stopAnimating];
                [self.parentMachine changeStateTo:[States EducationChangeToBirdCamera] pushState:NO];
            }];
        }];
    }
}

- (void)onStateEnter:(NSDictionary *)data{
    [super onStateEnter:data];
    
    isMove = NO;
    isMoving = NO;
    mModel.isInTeachObject = NO;
    rotating = NO;
    
#pragma mark teach移动
    UIImage *img_teachMove = [UIImage imageByResourceDrawable:@"img_teach_tap_static"];
    teachMove = [[UIImageView alloc] initWithImage:img_teachMove];
    [lo_object_menu_container addSubview:teachMove];
    
    moveTimer =  [NSTimer scheduledTimerWithTimeInterval:0.0167 target:self selector:@selector(move) userInfo:nil repeats:YES];
    
    CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnimation.calculationMode = kCAAnimationPaced;
    moveAnimation.fillMode = kCAFillModeForwards;
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.duration = 2.0f;
    moveAnimation.repeatCount = 1;
    
    CGMutablePathRef movePath = CGPathCreateMutable();
    CGPathMoveToPoint(movePath, NULL, mModel.teachTouchUpPoint.x, mModel.teachTouchUpPoint.y);
    CGPathAddLineToPoint(movePath, NULL, mModel.gameViewWidth/2, [UIScreen mainScreen].bounds.size.height/2);
    moveAnimation.path = movePath;
    CGPathRelease(movePath);
    
    toMoveGroup = [CAAnimationGroup animation];
    toMoveGroup.fillMode = kCAFillModeForwards;
    toMoveGroup.removedOnCompletion = NO;
    [toMoveGroup setAnimations:[NSArray arrayWithObjects: moveAnimation, nil]];
    toMoveGroup.duration = 2.0f;
    toMoveGroup.delegate = self;
    [toMoveGroup setValue:@"moving" forKey:@"moveGroup"];
    
    [teachMove.layer addAnimation:toMoveGroup forKey:@"move"];
    teachMove.alpha = 1.0f;
    
#pragma mark teach旋转
    UIImage *img_teachRotate = [UIImage imageByResourceDrawable:@"img_teach_rotate"];
    teachRotate = [[UIImageView alloc] initWithImage:img_teachRotate];
    [lo_object_menu_container addSubview:teachRotate];
    teachRotate.hidden = YES;
    
    rotateTimer = [NSTimer scheduledTimerWithTimeInterval:0.0167 target:self selector:@selector(rotated) userInfo:nil repeats:YES];
    
    inTeachObj = [NSTimer scheduledTimerWithTimeInterval:0.0167 target:self selector:@selector(inTeachObj) userInfo:nil repeats:YES];
    
    teachAgain = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(teachAgain) userInfo:nil repeats:YES];
    notFirstTeach = NO;
    
    [mModel.teachDeacls setVisible:YES];
    lo_teachMov.hidden = YES;
    
    lv_degree.visible = NO;
    [self updateUndoRedoState];
    lo_style.hidden = NO;
    lo_description.hidden = YES;
    rg_option.checkedView = btn_change_color;
    lo_button1_line1.hidden = NO;
    lo_button2_line1.hidden = YES;
    lo_button2_line2.hidden = YES;
    
    tempObject = mModel.selectedObject;
    tempObjectBasePosition = [mModel.selectedObject.transform positionInSpace:JWTransformSpaceWorld];
    
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        [btn_change_color setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [btn_description setTitleEdgeInsets:UIEdgeInsetsMake(10, 0, 0, 0)];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        [btn_change_color setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [btn_description setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    }
    
    [self updateCurrentItemInfoUI];// 为右边的menu赋值
    [self showRectFrameToItem:mModel.selectedObject];
    
    TutorialPlanEditItemEdit* weakSelf = self;
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
    
//#pragma mark 选中逻辑
    __block id<IMesherModel> model = mModel;
//    id<JIViewTag> itemEditMenu = mItemEditMenu;
    // 执行物件移动的逻辑
    //    isRotated = NO;
    //    BOOL isRotated_b = isRotated;
    mModel.itemSelectAndMoveBehaviour.selectedMask = SelectedMaskAllItems | SelectedMaskAllArchs;
//    mModel.itemSelectAndMoveBehaviour.onSelect = (^(id<JIGameObject> object) {
//        
//#pragma mark 设置点击任何物件都返回之前的状态 防止多余的误操作
//        if (!weakSelf.mIsRotated) {
//            if (model.completedMove) {
//                [model.preSelectedObject removeComponent:itemEditMenu]; // 先取下之前对象的edit菜单
//                [weakSelf showRectFrameToItem:object];
//                [weakSelf updateUndoRedoState];
////                [weakSelf.parentMachine revertState];
//            }
//        }
//    });
    
    mModel.itemSelectAndMoveBehaviour.canMove = YES; // 在ItemEdit状态下 物件是可以移动的
    mModel.itemSelectAndMoveBehaviour.onItemEndMove = ^(CGPoint positionInView){
        model.teachTouchUpPoint = positionInView;
        CGPoint positionInPixels = [[UIScreen mainScreen] pointInPixelsByPoint: positionInView];
        model.teachMoveLastPosition = [model.selectedObject.transform positionInSpace:JWTransformSpaceWorld];
        JCRayPlaneIntersectResult result = [model.currentScene getCameraRayToUnitYZeroPlaneResultFromScreenX:positionInPixels.x screenY:positionInPixels.y];//和地面求交
        JCVector3 minT = model.teachObject.transformBounds.min;
        JCVector3 maxT = model.teachObject.transformBounds.max;
        JCVector3 tp = result.point;
        if (tp.x > minT.x && tp.z > minT.z && tp.x < maxT.x && tp.z < maxT.z) {
            
        }
        JCVector3 objMin = model.selectedObject.transformBounds.min;
        JCVector3 objMax = model.selectedObject.transformBounds.max;
        JCVector3 teachObjMin = model.teachObject.transformBounds.min;
        JCVector3 teachObjMax = model.teachObject.transformBounds.max;
        
        BOOL over1 = objMax.x < teachObjMax.x;
        BOOL over2 = objMax.z < teachObjMax.z;
        BOOL over3 = objMin.x > teachObjMin.x;
        BOOL over4 = objMin.z > teachObjMin.z;
        if (over1 && over2 && over3 && over4) {
            model.isInTeachObject = YES;
        }
    };
    mModel.photographer.cameraEnabled = NO;
    
    lo_object_menu_container.hidden = NO;
}

//离开状态时
- (void)onStateLeave{
    toRotateGroup = nil;
    tempObject = nil;
    rotatedAnimation = nil;
    lo_cg.alpha = 0.0f;
    [teachAgain invalidate];
    teachAgain = nil;
    moveTimer = nil;
    rotateTimer = nil;
    inTeachObj = nil;
    [rotate_timer_left invalidate];
    [rotate_timer_right invalidate];
    lo_object_menu_container.hidden = YES;
    [self showRectFrameToItem:nil];
    [mModel.selectedObject removeComponent:mItemEditMenu]; // 离开状态时 把edit菜单从绑定的对象上取下 以便之后进入重新绑定
    mModel.itemSelectAndMoveBehaviour.onSelect = nil;
    [super onStateLeave];
}

- (BOOL)onTouchDown:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    switch (touch.view.tag) {
        case R_id_btn_rotate: {
            isRotated = YES;
            btn_link.alpha = 0.0f;
            btn_AR.alpha = 0.0f;
            btn_delete.alpha = 0.0f;
            lv_degree.visible = YES;
            CGFloat degree = tempObject.transform.yawing;
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
//                NSLog(@"angle:%f",angle);
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
        case R_id_btn_rotate: {
            btn_link.alpha = 1.0f;
            btn_AR.alpha = 1.0f;
            btn_delete.alpha = 1.0f;
            lv_degree.visible = NO;
            ItemRotateCommand* command = [[ItemRotateCommand alloc] init];
            command.object = tempObject;
            command.angle = angle;
            [mModel.commandMachine doneCommand:command];
            [self updateUndoRedoState];
            mModel.currentPlan.sceneDirty = YES;
            angle = 0.0f;
            isRotated = NO;
            mModel.selectedObject = tempObject;
            
            JCVector3 objMin = mModel.selectedObject.transformBounds.min;
            JCVector3 objMax = mModel.selectedObject.transformBounds.max;
            JCVector3 teachObjMin = mModel.teachObject.transformBounds.min;
            JCVector3 teachObjMax = mModel.teachObject.transformBounds.max;
            BOOL over1 = objMax.x < teachObjMax.x;
            BOOL over2 = objMax.z < teachObjMax.z;
            BOOL over3 = objMin.x > teachObjMin.x;
            BOOL over4 = objMin.z > teachObjMin.z;
            if (over1 && over2 && over3 && over4) {
                mModel.completedMove = YES;
                [mModel.teachDeacls setVisible:NO];
                [mModel.preSelectedObject removeComponent:mItemEditMenu]; // 先取下之前对象的edit菜单
                mModel.selectedObject = nil;
                [self showRectFrameToItem:mModel.selectedObject];
                [self updateUndoRedoState];
                [UIView animateWithDuration:2.5 animations:^{
                    lo_cg.alpha = 1.0f;
                    [lo_cg startAnimating];
                } completion:^(BOOL finished) {
                    lo_cg.alpha = 1.0f;
                    [UIView animateWithDuration:1.0f animations:^{
                        lo_cg.alpha = 0.0f;
                    } completion:^(BOOL finished) {
                        [lo_cg stopAnimating];
                        [self.parentMachine changeStateTo:[States EducationChangeToBirdCamera] pushState:NO];
                    }];
                }];
            }
            break;
        }
        case R_id_lo_teach_load: {
            NSLog(@"teach load");
            break;
        }
        default:
            break;
    }
    return YES;
}

@end
