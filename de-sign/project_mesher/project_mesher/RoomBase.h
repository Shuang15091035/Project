//
//  RoomBase.h
//  project_mesher
//
//  Created by mac zdszkj on 15/12/29.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "BaseAppState.h"

@interface RoomBase : BaseAppState {
    NSArray *roomNames;
    NSArray *roomTags;
    
    JWRelativeLayout *lo_view;
    JWRelativeLayout *lo_game_view;
    JWRelativeLayout *lo_menu;
    
    JWRelativeLayout *lo_architecture;
    JWLinearLayout *lo_architecture_name;
    UIButton *btn_room_names[RoomsMaxNum];
    NSInteger btn_room_tags[RoomsMaxNum];
    
    JWRadioViewGroup *rg_architecture_button;
    NSMutableArray *buttons;
    NSMutableArray *rooms; // 用于接收户型数组的数组
    
    JWCollectionView *cv_collection;
    
    BOOL isFirstTime;
}

- (void)swipeUpdateGrideView:(NSInteger)index;
- (NSArray*)getRoomNames;
- (NSArray*)getRoomTags;

@end