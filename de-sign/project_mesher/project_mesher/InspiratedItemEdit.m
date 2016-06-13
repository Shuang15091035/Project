//
//  InspiratedItemEdit.m
//  project_mesher
//
//  Created by mac zdszkj on 16/4/7.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "InspiratedItemEdit.h"
#import "MesherModel.h"
#import "GamePhotographer.h"
#import <jw/JCMath.h>
#import "Data.h"
#import "ItemMoveCommand.h"
#import "ItemRotateCommand.h"
#import "ItemLongPressRotateCommand.h"
#import "StyleListAdapter.h"
#import "ItemDeleteCommand.h"

@interface InspiratedItemEdit () <UIGestureRecognizerDelegate> {
    JWRelativeLayout *lo_inspiratedItemEdit;
    UILabel *tv_name;
    UIImageView* img_image;
    JWImageOptions* opt_img_image;
    UILabel *tv_price;
    JWRelativeLayout* lo_object_menu_container; // 物件上的菜单容器
    JWRelativeLayout *lo_gesture;
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
    
    UILabel *lv_height;
    UIButton *btn_updown;
    UIButton *btn_delete;
    UIButton *btn_detail;
    
    JWRelativeLayout *lo_style;
    JWRelativeLayout *lo_description;
    UIWebView *wv_description;
    
    // option的按钮的下划线
    JWRelativeLayout *lo_button1_line1;
    JWRelativeLayout *lo_button2_line1;
    JWRelativeLayout *lo_button2_line2;

    CGPoint oldPoint;
    CGPoint newPoint;
    CGPoint oldPoint_d;
    CGPoint newPoint_d;
    
    JCVector3 oldPosition;
    JCVector3 newPosition;
    JCVector3 oldPosition_d;
    JCVector3 newPosition_d;
    JCVector3 oldPosition_p;
    JCVector3 newPosition_p;
    
    ItemMoveCommand *moveCommand;
    ItemRotateCommand* rotateCommand;
    CGFloat angle;
    
    JWLinearLayout *lo_button;
    
    NSTimer *timer_up;
    NSTimer *timer_down;
}

@property (nonatomic, readwrite) float mObject_menu_width;

@end

@implementation InspiratedItemEdit

@synthesize mObject_menu_width = object_menu_width;

- (UIView *)onCreateView:(UIView *)parent {
    lo_inspiratedItemEdit = (JWRelativeLayout *)[parent viewWithTag:R_id_lo_inspirate_item_edit];
    
    JWLinearLayout *lo_menu_edit_linear = [JWLinearLayout layout];
    lo_menu_edit_linear.layoutParams.width = JWLayoutMatchParent;
    lo_menu_edit_linear.layoutParams.height = JWLayoutMatchParent;
    lo_menu_edit_linear.orientation = JWLayoutOrientationVertical;
    [lo_inspiratedItemEdit addSubview:lo_menu_edit_linear];
    
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
    tv_name.labelTextSize = 26;
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
    lo_option.layoutParams.marginTop = [MesherModel uiHeightBy:40.0f];
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
        lo_style.layoutParams.height = [MesherModel uiHeightBy:710.0f];
        //lo_style.layoutParams.marginBottom = [MesherModel uiHeightBy:110.0f];
    }
    //lo_style.backgroundColor = [UIColor redColor];
    lo_style.layoutParams.alignment = JWLayoutAlignParentBottom | JWLayoutAlignCenterHorizontal;
    [lo_inspiratedItemEdit addSubview:lo_style];
    
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
        lo_description.layoutParams.height = [MesherModel uiHeightBy:710.0f];
    }
    lo_description.layoutParams.alignment = JWLayoutAlignParentBottom | JWLayoutAlignCenterHorizontal;
    lo_description.hidden = YES;
    [lo_inspiratedItemEdit addSubview:lo_description];
    
    wv_description = [[UIWebView alloc] init];
    wv_description.layoutParams.width = [MesherModel uiWidthBy:500.0f];
    wv_description.layoutParams.height = JWLayoutMatchParent;
    wv_description.layoutParams.alignment = JWLayoutAlignParentBottomRight;
    [lo_description addSubview:wv_description];
    
#pragma mark 物件上的UI
    lo_object_menu_container = (JWRelativeLayout*)[parent viewWithTag:R_id_lo_control];
    lo_object_menu_container.tag = R_id_lo_control;
    lo_object_menu_container.hidden = NO;
    
#pragma mark 手势相关
    lo_object_menu_container.userInteractionEnabled = YES;
    lo_object_menu_container.clickable = YES;
    [self.gestureEventBinder bindEventsWithType:JWGestureTypeSingleTap toView:lo_object_menu_container willBindSubviews:NO andFilter:nil];
//    [self.gestureEventBinder bindEventsWithType:JWGestureTypeDoubleDrag toView:lo_object_menu_container willBindSubviews:NO andFilter:nil];
    [self.viewEventBinder bindEventsToView:lo_object_menu_container willBindSubviews:NO andFilter:nil];
    [self.gestureEventBinder bindEventsWithType:JWGestureTypePinch toView:lo_object_menu_container willBindSubviews:NO andFilter:nil];
    
//    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(onPinch:)];
//    [lo_object_menu_container addGestureRecognizer:pinch];

    UIRotationGestureRecognizer * rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
    [lo_object_menu_container addGestureRecognizer:rotate];
    
//    [pinch requireGestureRecognizerToFail:rotate]; // 优先判定rotate 失败了在判定pinch
    
    lo_object_menu = [JWLinearLayout layout];
    lo_object_menu.layoutParams.width = JWLayoutWrapContent;
    lo_object_menu.layoutParams.height = JWLayoutWrapContent;
    lo_object_menu.orientation = JWLayoutOrientationHorizontal;
    [lo_object_menu_container addSubview:lo_object_menu];

#pragma mark 物件上的按钮
    lv_height = [[UILabel alloc] init];
    lv_height.backgroundColor = [UIColor clearColor];
    lv_height.textColor = [UIColor whiteColor];
    lv_height.labelTextSize = 15;
    lv_height.shadowOffset = CGSizeMake(1, 1);
    lv_height.shadowColor = [UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:1];
    lv_height.layoutParams.width = JWLayoutWrapContent;
    lv_height.layoutParams.height = JWLayoutWrapContent;
    [lo_object_menu addSubview:lv_height];
    
    UIImage *btn_updown_n = [UIImage imageByResourceDrawable:@"btn_updown_n"];
    btn_updown = [[UIButton alloc] initWithImage:btn_updown_n highlightedImage:btn_updown_n];
    btn_updown.tag = R_id_btn_updown;
    btn_updown.layoutParams.width = JWLayoutWrapContent;
    btn_updown.layoutParams.height = JWLayoutWrapContent;
    btn_updown.layoutParams.marginLeft = 2;
    [lo_object_menu addSubview:btn_updown];
    [self.viewEventBinder bindEventsToView:btn_updown willBindSubviews:NO andFilter:nil];
    
    UIImage *btn_delete_n = [UIImage imageByResourceDrawable:@"btn_delete_n"];
    UIImage *btn_delete_p = [UIImage imageByResourceDrawable:@"btn_delete_p"];
    btn_delete = [[UIButton alloc] initWithImage:btn_delete_n highlightedImage:btn_delete_p];
    btn_delete.tag = R_id_btn_delete;
    btn_delete.layoutParams.width = JWLayoutWrapContent;
    btn_delete.layoutParams.height = JWLayoutWrapContent;
    btn_delete.layoutParams.marginLeft = 2;
    [lo_object_menu addSubview:btn_delete];
    
    UIImage *btn_detail_n = [UIImage imageByResourceDrawable:@"btn_details_n"];
    UIImage *btn_detail_p = [UIImage imageByResourceDrawable:@"btn_details_p"];
    btn_detail = [[UIButton alloc] initWithImage:btn_detail_n highlightedImage:btn_detail_p];
    btn_detail.tag = R_id_btn_details;
    btn_detail.layoutParams.width = JWLayoutWrapContent;
    btn_detail.layoutParams.height = JWLayoutWrapContent;
    btn_detail.layoutParams.marginLeft = 2;
    [lo_object_menu addSubview:btn_detail];
    
#pragma mark 物件边框 初始化
    id<JIFile> file = [JWFile fileWithBundle:[NSBundle mainBundle] path:[JWResourceBundle nameForDrawable:@"item_rect_frame.png"]];
    mItemRectFrameDecals = [[JWRect4CornersDecals alloc] initWithContext:mModel.currentContext parent:mModel.world.currentScene.root innerWidth:1.0f innerHeight:1.0f cornerOffsetX:0.15f cornerOffsetY:0.15f thickness:0.06f cornerOffsetU:0.0f cornerOffsetV:0.0f uvThickness:0.346f decalsFile:file];
    mItemRectFrameDecals.decalsObject.visible = NO;
    mItemRectFrameDecals.decalsObject.queryMask = SelectedMaskCannotSelect;
    [mItemRectFrameDecals.decalsObject.transform setInheritScale:NO];
    mModel.itemRectFrameDecals = mItemRectFrameDecals;
    
    // 按钮动作
    btn_back.userInteractionEnabled = YES;
    [self.gestureEventBinder bindEventsWithType:JWGestureTypeSingleTap toView:btn_back willBindSubviews:NO andFilter:nil];
    
    btn_delete.userInteractionEnabled = YES;
    [self.viewEventBinder bindEventsToView:btn_delete willBindSubviews:NO andFilter:nil];
    btn_detail.userInteractionEnabled = YES;
    [self.viewEventBinder bindEventsToView:btn_detail willBindSubviews:NO andFilter:nil];
    
    btn_undo = (UIImageView*)[parent viewWithTag:R_id_btn_undo];
    btn_redo = (UIImageView*)[parent viewWithTag:R_id_btn_redo];

#pragma mark 控制物件高度
//    lo_button = (JWLinearLayout *)[parent viewWithTag:R_id_lo_inspirate_buttons];
//    UIImage *btn_up_n = [UIImage imageByResourceDrawable:@"btn_up"];
//    UIImage *btn_down_n = [UIImage imageByResourceDrawable:@"btn_down"];
//    
//    UIButton *btn_up = [[UIButton alloc] initWithImage:btn_up_n selectedImage:btn_up_n];
//    btn_up.tag = R_id_lo_inspirate_button_up;
//    btn_up.layoutParams.width = JWLayoutWrapContent;
//    btn_up.layoutParams.height = JWLayoutWrapContent;
//    [lo_button addSubview:btn_up];
//    [self.gestureEventBinder bindEventsWithType:JWGestureTypeLongPress toView:btn_up willBindSubviews:NO andFilter:nil];
//    [btn_up addTarget:self action:@selector(up) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *btn_down = [[UIButton alloc] initWithImage:btn_down_n selectedImage:btn_down_n];
//    btn_down.tag = R_id_lo_inspirate_button_down;
//    btn_down.layoutParams.width = JWLayoutWrapContent;
//    btn_down.layoutParams.height = JWLayoutWrapContent;
//    [lo_button addSubview:btn_down];
//    btn_down.layoutParams.marginTop = [MesherModel uiHeightBy:20.0f];
//    [self.gestureEventBinder bindEventsWithType:JWGestureTypeLongPress toView:btn_down willBindSubviews:NO andFilter:nil];
//    [btn_down addTarget:self action:@selector(down) forControlEvents:UIControlEventTouchUpInside];

    return lo_inspiratedItemEdit;
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
        lo_inspiratedItemEdit.hidden = YES;
        return;
    }
    
    mStyleListAdapter.data = currentItem.product.items;
    [mStyleListAdapter notifyDataSetChanged];
    
    
    NSString *description = currentItem.product.description;
    if (description != nil) {
        [wv_description loadHTMLString:description baseURL:nil];
    }
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
        mItemRectFrameDecals.decalsObject.parent = mModel.world.currentScene.root;
        mItemRectFrameDecals.decalsObject.visible = NO;
    } else {
        Item *item = [Data getItemFromInstance:object];
        JCBounds3 objectBounds = object.scaleBounds;
        JCVector3 objectSize = JCBounds3GetSize(&objectBounds);
        if (item.product.position == PositionGround || item.product.position == PositionOnItem || item.product.position == PositionInWall) {
            [mItemRectFrameDecals updateInnerWidth:objectSize.x innerHeight:objectSize.z];
            [mItemRectFrameDecals.decalsObject.transform reset:NO];
            mItemRectFrameDecals.decalsObject.parent = object;
            [mItemRectFrameDecals.decalsObject.transform translate:JCVector3Make(0.0f, 0.02f, 0.0f)]; // 防止z-fighting
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

- (void)onStateEnter:(NSDictionary *)data {
    [super onStateEnter:data];
    [self updateUndoRedoState];
    
    lv_height.alpha = 0.0f;
    
    lo_button.hidden = NO;
    lo_style.hidden = NO;
    lo_description.hidden = YES;
    rg_option.checkedView = btn_change_color;
    lo_button1_line1.hidden = NO;
    lo_button2_line1.hidden = YES;
    lo_button2_line2.hidden = YES;
    angle = 0.0f;
    
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        [btn_change_color setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [btn_description setTitleEdgeInsets:UIEdgeInsetsMake(10, 0, 0, 0)];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        [btn_change_color setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [btn_description setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    }
    
    [self showRectFrameToItem:mModel.selectedObject];
    
    InspiratedItemEdit* weakSelf = self;
    // 物件菜单跟随物件移动组件
    if (mItemEditMenu == nil) {
        mItemEditMenu = [mModel.currentContext createViewTag];
        mItemEditMenu.view = lo_object_menu;
        mItemEditMenu.viewOffset = CGPointMake(-50, -120);
        mItemEditMenu.onChange = (^CGPoint (CGPoint position) {
            edit_pointX = lo_inspiratedItemEdit.frame.origin.x;
            weakSelf.mObject_menu_width = btn_detail.frame.size.width * 2;
            float x = edit_pointX - weakSelf.mObject_menu_width - 20;
            float y = 20.0f;
            float minX = lo_inspiratedItemEdit.frame.size.width/5;
            float maxY = [UIScreen mainScreen].boundsInPixels.size.height - 20.0f;
            if (position.x > x) {
                position.x = x;
            }
            if (position.y < y) {
                position.y = y;
            }
            if (position.x < minX) {
                position.x = minX;
            }
            if (position.y > maxY) {
                position.y = maxY;
            }
            return position;
        });
    }
    [mModel.selectedObject addComponent:mItemEditMenu]; // 将edit菜单加到选中的对象上
    
    lo_inspiratedItemEdit.hidden = YES;
    lo_object_menu_container.hidden = NO;
}

- (void)onStateLeave{
    [timer_up invalidate];
    [timer_down invalidate];
    
    lo_object_menu_container.hidden = YES;
    lo_button.hidden = YES;
    [self showRectFrameToItem:nil];
    [mModel.selectedObject removeComponent:mItemEditMenu]; // 离开状态时 把edit菜单从绑定的对象上取下 以便之后进入重新绑定
    mModel.inspiratedBehaviour.onSelect = nil;
    
    oldPoint = CGPointZero;
    newPoint = CGPointZero;
    oldPoint_d = CGPointZero;
    newPoint_d = CGPointZero;
    oldPosition = JCVector3Zero();
    newPosition = JCVector3Zero();
    oldPosition_d = JCVector3Zero();
    newPosition_d = JCVector3Zero();
    
    [super onStateLeave];
}

- (void)onDestroy {
    if ([timer_up isValid]) {
        [timer_up invalidate];
        timer_up = nil;
    }
    if ([timer_down isValid]) {
        [timer_down invalidate];
        timer_down = nil;
    }
    [super onDestroy];
}

- (void)onSingleTap:(UITapGestureRecognizer *)singleTap{
    switch (singleTap.view.tag) {
        case R_id_btn_back: {
            lo_inspiratedItemEdit.hidden = YES;
            break;
        }
        case R_id_lo_control: {
            [mModel.preSelectedObject removeComponent:mItemEditMenu];
            [self showRectFrameToItem:mModel.selectedObject];
            [self updateUndoRedoState];
            mModel.inspiratedGridsObject.visible = NO;
            [self.parentMachine revertState];
            break;
        }
        default:
            break;
    }
}

- (BOOL)onTouchDown:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    switch (touch.view.tag) {
        case R_id_lo_control: {
            oldPoint = touch.positionInPixels;
            oldPosition = [mModel.selectedObject.transform positionInSpace:JWTransformSpaceWorld];
            mModel.inspiratedGridsObject.visible = YES;
            break;
        }
        case R_id_btn_updown: {
            lv_height.alpha = 1.0f;
            btn_delete.alpha = 0.0f;
            btn_detail.alpha = 0.0f;
            oldPosition_d = [mModel.selectedObject.transform positionInSpace:JWTransformSpaceWorld];
            CGFloat height = oldPosition_d.y;
            lv_height.text = [NSString stringWithFormat:@"%.1fm",height];
            mModel.inspiratedGridsObject.visible = YES;
            break;
        }
        default:
            break;
    }
    return YES;
}

- (BOOL)onTouchMove:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    JCVector3 cp = [mModel.inspiratedCamera.host.transform positionInSpace:JWTransformSpaceWorld];
    JCVector3 op = [mModel.selectedObject.transform positionInSpace:JWTransformSpaceWorld];
    JCVector3 d = JCVector3Subv(&cp, &op);
    CGFloat s = JCVector3SquareLength(&d)*0.001;
    switch (touch.view.tag) {
        case R_id_lo_control: {
            newPoint = touch.positionInPixels;
//            CGFloat insertX = (newPoint.x - oldPoint.x)/200;
//            CGFloat insertY = (newPoint.y - oldPoint.y)/200;
            
            float speed = 0.01f;
            JCVector3 xAxis = mModel.inspiratedCamera.host.transform.xAxis;
            JCVector3 zAxis = mModel.inspiratedCamera.host.transform.zAxis;
            xAxis.y = 0.0f;
            zAxis.y = 0.0f;
            CGPoint du = touch.deltaPosition;
            JCVector3 dux = JCVector3Muls(&xAxis, du.x * speed);
            JCVector3 duy = JCVector3Muls(&zAxis, du.y * speed);
            JCVector3 d = JCVector3Addv(&dux, &duy);
            d.x *= (1 + s);
            d.y *= (1 + s);
            d.z *= (1 + s);
            [mModel.selectedObject.transform translate:d inSpace:JWTransformSpaceWorld];
            newPosition = [mModel.selectedObject.transform positionInSpace:JWTransformSpaceWorld];
//            newPosition = JCVector3Make(oldPosition.x + insertX, oldPosition.y, oldPosition.z + insertY);
//            [mModel.selectedObject.transform setPositionV:newPosition inSpace:JWTransformSpaceWorld];
            if (moveCommand == nil) {
                moveCommand = [[ItemMoveCommand alloc] init];
                moveCommand.plan = mModel.currentPlan;
                moveCommand.object = mModel.selectedObject;
                moveCommand.originPosition = oldPosition;
            }
            
            [timer_up invalidate];
            [timer_down invalidate];
            
            break;
        }
        case R_id_btn_updown: {
            CGPoint du = touch.deltaPosition;
            JCVector3 position = [mModel.selectedObject.transform positionInSpace:JWTransformSpaceWorld];
            position.y += -((du.x+du.y)/2)*0.03*(1+s);
            lv_height.text = [NSString stringWithFormat:@"%.1fm",position.y];
            [mModel.selectedObject.transform setPosition:position inSpace:JWTransformSpaceWorld];
            newPosition_d = [mModel.selectedObject.transform positionInSpace:JWTransformSpaceWorld];
            if (moveCommand == nil) {
                moveCommand = [[ItemMoveCommand alloc] init];
                moveCommand.plan = mModel.currentPlan;
                moveCommand.object = mModel.selectedObject;
                moveCommand.originPosition = oldPosition_d;
            }
            break;
        }
        default:
            break;
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
        case R_id_btn_delete: {
            [mModel.selectedObject removeComponent:mItemEditMenu]; // 删除GameObject之前先把ViewTag移除，以免同时删除ViewTag
            ItemDeleteCommand *command = [[ItemDeleteCommand alloc] init];
            command.object = mModel.selectedObject;
            command.plan = mModel.currentPlan;
            [mModel.commandMachine todoCommand:command];
            //[mModel.plan destroyObject:mModel.selectedObject];
            mModel.selectedObject = nil;
            mModel.preSelectedObject = nil;
            mItemRectFrameDecals.decalsObject.parent = mModel.world.currentScene.root;
            mItemRectFrameDecals.decalsObject.visible = NO;
            [mModel.currentPlan showOverlap];
            [self updateUndoRedoState];
            [self.parentMachine revertState];
            break;
        }
        case R_id_btn_details: {
            lo_inspiratedItemEdit.hidden = !lo_inspiratedItemEdit.hidden;
            [self updateCurrentItemInfoUI];
            [self updateUndoRedoState];
            break;
        }
        case R_id_lo_control: {
            if (moveCommand != nil) {
                moveCommand.plan = mModel.currentPlan;
                moveCommand.destPosition = newPosition;
                [mModel.commandMachine doneCommand:moveCommand];
                moveCommand = nil;
                mModel.inspiratedGridsObject.visible = NO;
            }
            [self updateUndoRedoState];
            break;
        }
        case R_id_btn_updown: {
            lv_height.alpha = 0.0f;
            btn_delete.alpha = 1.0f;
            btn_detail.alpha = 1.0f;
            if (moveCommand != nil) {
                moveCommand.plan = mModel.currentPlan;
                moveCommand.destPosition = newPosition_d;
                [mModel.commandMachine doneCommand:moveCommand];
                moveCommand = nil;
                mModel.inspiratedGridsObject.visible = NO;
            }
            [self updateUndoRedoState];
            break;
        }
        default:
            break;
    }
    return YES;
}

- (void)rotate:(UIRotationGestureRecognizer *)rotate {
    switch (rotate.state) {
        case UIGestureRecognizerStateBegan: {
            NSLog(@"start");
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGFloat sinAngle = - JCRad2Deg(rotate.rotation);
            [mModel.selectedObject.transform rotateUpDegrees:sinAngle];
            if (rotateCommand == nil) {
                rotateCommand = [[ItemRotateCommand alloc] init];
                rotateCommand.object = mModel.selectedObject;
            }
            angle = angle + sinAngle;
            rotateCommand.angle = angle;
            rotate.rotation = 0.0f;
            
            [timer_up invalidate];
            [timer_down invalidate];
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (rotateCommand != nil) {
                [mModel.commandMachine doneCommand:rotateCommand];
                rotateCommand = nil;
            }
            [self updateUndoRedoState];
            break;
        }
        default:
            break;
    }
}

- (void)onDoubleDrag:(UIPanGestureRecognizer *)doubleDrag {
    switch (doubleDrag.state) {
        case UIGestureRecognizerStateBegan: {
            mModel.inspiratedGridsObject.visible = YES;
            oldPoint_d = doubleDrag.positionInPixels;
            oldPosition_d = [mModel.selectedObject.transform positionInSpace:JWTransformSpaceWorld];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            newPoint_d = doubleDrag.positionInPixels;
            CGFloat insertX = (newPoint_d.x - oldPoint_d.x);
            CGFloat insertY = (newPoint_d.y - oldPoint_d.y);
            CGFloat insert = -(insertX + insertY)/400;
            newPosition_d = JCVector3Make(oldPosition_d.x, oldPosition_d.y + insert, oldPosition_d.z);
            [mModel.selectedObject.transform setPosition:newPosition_d inSpace:JWTransformSpaceWorld];
            if (moveCommand == nil) {
                moveCommand = [[ItemMoveCommand alloc] init];
                moveCommand.plan = mModel.currentPlan;
                moveCommand.object = mModel.selectedObject;
                moveCommand.originPosition = oldPosition_d;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (moveCommand != nil) {
                moveCommand.plan = mModel.currentPlan;
                moveCommand.destPosition = newPosition_d;
                [mModel.commandMachine doneCommand:moveCommand];
                moveCommand = nil;
            }
            [self updateUndoRedoState];
            mModel.inspiratedGridsObject.visible = NO;
            break;
        }
        default:
            break;
    }
}

- (void)up {
    JCVector3 p =  [mModel.selectedObject.transform positionInSpace:JWTransformSpaceWorld];
    p.y += 0.01f;
    [mModel.selectedObject.transform setPosition:p inSpace:JWTransformSpaceWorld];
}

- (void)down {
    JCVector3 p =  [mModel.selectedObject.transform positionInSpace:JWTransformSpaceWorld];
    p.y -= 0.01f;
    [mModel.selectedObject.transform setPosition:p inSpace:JWTransformSpaceWorld];
}

- (void)onLongPress:(UILongPressGestureRecognizer *)longPress {
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            oldPosition_d = [mModel.selectedObject.transform positionInSpace:JWTransformSpaceWorld];
            if (moveCommand == nil) {
                moveCommand = [[ItemMoveCommand alloc] init];
                moveCommand.plan = mModel.currentPlan;
                moveCommand.object = mModel.selectedObject;
                moveCommand.originPosition = oldPosition_d;
            }
            mModel.inspiratedGridsObject.visible = YES;
            switch (longPress.view.tag) {
                case R_id_lo_inspirate_button_up: {
                    timer_up = [NSTimer scheduledTimerWithTimeInterval:0.0167f target:self selector:@selector(up) userInfo:nil repeats:YES];
                    break;
                }
                case R_id_lo_inspirate_button_down: {
                    timer_down = [NSTimer scheduledTimerWithTimeInterval:0.0167f target:self selector:@selector(down) userInfo:nil repeats:YES];
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
            newPosition_d = [mModel.selectedObject.transform positionInSpace:JWTransformSpaceWorld];
            if (moveCommand != nil) {
                moveCommand.plan = mModel.currentPlan;
                moveCommand.destPosition = newPosition_d;
                [mModel.commandMachine doneCommand:moveCommand];
                moveCommand = nil;
            }
            [timer_up invalidate];
            [timer_down invalidate];
            [self updateUndoRedoState];
            mModel.inspiratedGridsObject.visible = NO;
            break;
        }
        default:
            break;
    }

}

- (void)onPinch:(UIPinchGestureRecognizer *)pinch {
    switch (pinch.state) {
        case UIGestureRecognizerStateBegan: {
            mModel.inspiratedGridsObject.visible = YES;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            JCVector3 zAxis = mModel.inspiratedCamera.host.transform.zAxis;
            JCVector3 d = JCVector3Muls(&zAxis, (1.0f - pinch.scale)*3.0f);
            NSLog(@"%f",d.y);
            [mModel.inspiratedCamera.host.transform translate:d];
            JCVector3 position = [mModel.inspiratedCamera.host.transform positionInSpace:JWTransformSpaceWorld];
//            position.z += (1.0f - pinch.scale);
            [mModel.inspiratedCamera.host.transform setPosition:position inSpace:JWTransformSpaceWorld];
//            JCVector3 position = [mModel.inspiratedCamera.host.transform positionInSpace:JWTransformSpaceWorld];
            NSLog(@"%f,%f,%f",position.x,position.y,position.z);
            pinch.scale = 1.0f;
            
            [timer_up invalidate];
            [timer_down invalidate];
            
//            JCVector3 scale = mModel.selectedObject.transform.scale;
//            //                     地址       增量
//            scale = JCVector3Muls(&scale, pinch.scale);
//            [mModel.selectedObject.transform setScale:scale];
//            pinch.scale = 1.0f;
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            pinch.scale = 1.0f;
            mModel.inspiratedGridsObject.visible = NO;
        }
        default:
            break;
    }
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return NO;
//}

@end
