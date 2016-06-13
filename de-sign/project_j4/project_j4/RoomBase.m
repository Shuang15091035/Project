//
//  RoomBase.m
//  project_mesher
//
//  Created by mac zdszkj on 15/12/29.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "RoomBase.h"
#import "MesherModel.h"

@interface RoomBase () {

}

@end

@implementation RoomBase

- (UIView *)onCreateView:(UIView *)parent {
    lo_view = [CCVRelativeLayout layout];
    lo_view.tag = R_id_lo_room_base;
    lo_view.layoutParams.width = CCVLayoutMatchParent;
    lo_view.layoutParams.height = CCVLayoutMatchParent;
    //lo_view.backgroundColor = [UIColor colorWithARGB:R_color_room_base_background];
    [parent addSubview:lo_view];
    
    UIImage *bg_apartment = [UIImage imageByResourceDrawable:@"bg_apartment"];
    UIImageView *bg_view = [[UIImageView alloc] initWithImage:bg_apartment];
    bg_view.layoutParams.width = CCVLayoutMatchParent;
    bg_view.layoutParams.height = CCVLayoutMatchParent;
    [lo_view addSubview:bg_view];
 
    UIImage *btn_close_clear = [UIImage imageByResourceDrawable:@"btn_close_clear"];
    UIButton *btn_close = [[UIButton alloc] initWithImage:btn_close_clear selectedImage:btn_close_clear];
    btn_close.layoutParams.width = CCVLayoutWrapContent;
    btn_close.layoutParams.height = CCVLayoutWrapContent;
    btn_close.layoutParams.alignment = CCVLayoutAlignParentTopRight;
    btn_close.layoutParams.marginTop = [MesherModel uiHeightBy:20.0f];
    btn_close.layoutParams.marginRight = [MesherModel uiWidthBy:20.0f];
    [lo_view addSubview:btn_close];
    [btn_close addTarget:self action:@selector(backToDIY:) forControlEvents:UIControlEventTouchUpInside];
    
    lo_game_view = (CCVRelativeLayout*)[parent viewWithTag:R_id_lo_game_view];
    lo_menu = (CCVRelativeLayout*)[parent viewWithTag:R_id_lo_menu_right_gray];
    
    lo_architecture = [CCVRelativeLayout layout];
    lo_architecture.layoutParams.width = [MesherModel uiWidthBy:250.0f];
    lo_architecture.layoutParams.height = [MesherModel uiHeightBy:1352.0f];
    lo_architecture.layoutParams.alignment = CCVLayoutAlignCenterVertical | CCVLayoutAlignParentLeft;
    lo_architecture.layoutParams.marginLeft = [MesherModel uiWidthBy:60.0f];
    [lo_view addSubview:lo_architecture];
    
    UIImage *ball_ipad = [UIImage imageByResourceDrawable:@"ball"];
    UIImage *ball_iphone = [UIImage imageByResourceDrawable:@"ball_iphone"];
    UIImage *select_ball = [UIImage imageByResourceDrawable:@"select_ball"];
    UIImage *ball_ipad_d = [UIImage imageByResourceDrawable:@"ball_ipad_d"];
    UIImage *ball_iphone_d = [UIImage imageByResourceDrawable:@"ball_iphone_d"];
    
    UIImage *ball_line = [UIImage imageByResourceDrawable:@"ball_line"];
    UIImageView *bg_ball_line = [[UIImageView alloc] init];
    bg_ball_line.image = ball_line;
    bg_ball_line.layoutParams.width = [MesherModel uiWidthBy:10.0f];
    bg_ball_line.layoutParams.height = [MesherModel uiHeightBy:1260.0f];
    bg_ball_line.layoutParams.alignment = CCVLayoutAlignCenterVertical | CCVLayoutAlignParentLeft;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        bg_ball_line.layoutParams.marginLeft = ball_ipad.size.width/2 - [MesherModel uiWidthBy:10.0f]/2;
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        bg_ball_line.layoutParams.marginLeft = ball_iphone.size.width/2 - [MesherModel uiWidthBy:10.0f]/2;
    }
    [lo_architecture addSubview:bg_ball_line];
    
    lo_architecture_name = [CCVLinearLayout layout];
    lo_architecture_name.layoutParams.width = CCVLayoutMatchParent;
    lo_architecture_name.layoutParams.height = CCVLayoutWrapContent;
    lo_architecture_name.orientation = CCVLayoutOrientationVertical;
    lo_architecture_name.layoutParams.alignment = CCVLayoutAlignCenterVertical | CCVLayoutAlignParentLeft;
    [lo_architecture addSubview:lo_architecture_name];
    
    roomNames = [self getRoomNames];
    roomTags = [self getRoomTags];
    
    for (NSUInteger i = 0; i< RoomsMaxNum; i++) {
        btn_room_tags[i] = [roomTags[i] integerValue];
        btn_room_names[i] = [[UIButton alloc] init];
        UIButton *btn_room_name = btn_room_names[i];
        btn_room_name.tag = (NSInteger)btn_room_tags[i];
        btn_room_name.layoutParams.width = [MesherModel uiWidthBy:200.0f];
        btn_room_name.layoutParams.height = [MesherModel uiWidthBy:60.0f];
        [btn_room_name setTitle:roomNames[i] forState:UIControlStateNormal];
        [btn_room_name setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_room_name setTitle:roomNames[i] forState:UIControlStateSelected];
        [btn_room_name setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn_room_name.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft; // 内容居左
        if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
            btn_room_name.buttonTextSize = 17;
            [btn_room_name setImage:ball_ipad forState:UIControlStateNormal];
            [btn_room_name setImage:ball_ipad_d forState:UIControlStateSelected];
            [btn_room_name setImage:ball_ipad_d         forState:UIControlStateHighlighted];
        }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
            btn_room_name.buttonTextSize = 12;
            [btn_room_name setImage:ball_iphone forState:UIControlStateNormal];
            [btn_room_name setImage:ball_iphone_d forState:UIControlStateSelected];
            [btn_room_name setImage:ball_iphone forState:UIControlStateHighlighted];
        }
        [btn_room_name setBackgroundImage:select_ball forState:UIControlStateSelected];
        [self.viewEventBinder bindEventsToView:btn_room_name willBindSubviews:NO andFilter:nil];
    }
    
    rg_architecture_button = [[CCVRadioViewGroup alloc] init];
    [rg_architecture_button addView:btn_room_names[0]];
    rg_architecture_button.onChecked = (^(BOOL checked, NSUInteger index, UIView* view){
        UIButton *button = (UIButton*)view;
        [button setSelected:checked];
    });
    rg_architecture_button.checkedView = btn_room_names[0]; // 初始默认点击第一项
    
#pragma mark CollectionView
    cv_collection = [CCVCollectionView collectionView];
    cv_collection.tag = R_id_lo_rooms_collection;
    cv_collection.layoutParams.width = [MesherModel uiWidthBy:1740.0f];;
    //cv_collection.layoutParams.weight = 1;
    cv_collection.layoutParams.height = [MesherModel uiHeightBy:1120.0f];
    cv_collection.layoutParams.alignment = CCVLayoutAlignCenterVertical | CCVLayoutAlignParentLeft;
    cv_collection.layoutParams.rightOf = lo_architecture_name;
    cv_collection.layoutParams.marginLeft = [MesherModel uiWidthBy:70.0f];
    cv_collection.backgroundColor = [UIColor clearColor];
    [lo_view addSubview:cv_collection];
    cv_collection.alwaysBounceVertical = NO;
    cv_collection.showsHorizontalScrollIndicator = NO;
    cv_collection.showsVerticalScrollIndicator = NO;
    
#pragma mark 滑动手势
    UISwipeGestureRecognizer *swipe;
    lo_architecture.clickable = YES;
    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionUp];
    [lo_architecture addGestureRecognizer:swipe];
    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionDown];
    [lo_architecture addGestureRecognizer:swipe];
    
    isFirstTime = YES;
    
    return lo_view;
}

- (void)onStateEnter:(NSDictionary *)data {
    [super onStateEnter:data];
    rg_architecture_button.checkedView = btn_room_names[0];
    lo_view.hidden = NO;
    lo_game_view.hidden = YES;
    lo_menu.hidden = YES;
    
    if (buttons == nil) {
        buttons = [NSMutableArray array];
    }
    if (rooms == nil) {
        rooms = [NSMutableArray array];
    }

}

- (void)onStateLeave {
    lo_view.hidden = YES;
    lo_game_view.hidden = NO;
    lo_menu.hidden = NO;
    [super onStateLeave];
}

- (void)backToDIY:(id)sender {
    [self.parentMachine changeStateTo:[States DIY] pushState:NO];
}

- (void)swipe:(UISwipeGestureRecognizer*)swipe {
    int index = 0;
    UIButton *heightLightButton = (UIButton*)rg_architecture_button.checkedView; // 找到当前选中的按钮
    for (int i = 0; i < buttons.count; i++) {
        if (heightLightButton == buttons[i]) {
            index = i;
        }
    }
    UIButton *selectedButton;
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) { // 向上滑动逻辑
        int up = index - 1;
        if (up < 0) {
            up = 0;
        }
        selectedButton = [buttons objectAtIndex:up];
        [self swipeUpdateGrideView:up];
        rg_architecture_button.checkedView = selectedButton;
    }else if (swipe.direction == UISwipeGestureRecognizerDirectionDown) { // 向下滑动逻辑
        int down = index + 1;
        if (down > buttons.count - 1) {
            down = (int)buttons.count - 1;
        }
        selectedButton = [buttons objectAtIndex:down];
        [self swipeUpdateGrideView:down];
        rg_architecture_button.checkedView = selectedButton;
    }
}

#pragma mark - 滑动更新GrideView数据
- (void)swipeUpdateGrideView:(NSInteger)index{
    
}

- (NSArray *)getRoomNames {
    return nil;
}

- (NSArray *)getRoomTags {
    return nil;
}

@end
