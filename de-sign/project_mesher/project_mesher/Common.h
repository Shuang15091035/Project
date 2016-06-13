//
//  Common.h
//  project_mesher
//
//  Created by MacMini on 15/10/12.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <jw/jw_core.h>
#import <jw/jw_app.h>
#import <jw/jw_game.h>
#import <jw/jw_loader.h>
#import <jw/jw_opengl.h>
#ifdef USE_MOJING
#import <jw/jw_mojing.h>
#endif

@class Source;
@class Item;
@class Product;
@class Plan;
@class PlanOrder;
@class ItemInfo;
@class ItemAnimation;

@protocol IMesherModel;
@class GamePhotographer;

@interface States : NSObject

+ (NSString *) Mesher;
+ (NSString *) MainPage; // 第一次进入的页面
+ (NSString *) Suit; // 固有模型的进入页面
+ (NSString *) DIY; // 自定义的进入页面
+ (NSString *) RoomShape; // 房型选择
+ (NSString *) PlanEdit; // 方案编辑
+ (NSString *) ItemAR; // AR视角
+ (NSString *) CameraFPS; // FPS视角(旧的VR)
+ (NSString *) CameraVR; // VR视角
+ (NSString *) ProductList; // 产品列表
+ (NSString *) ProductInfo; // 产品信息
+ (NSString *) ItemEdit; // 物件编辑
+ (NSString *) ItemTools; // 工具
+ (NSString *) ItemLink; // 网页链接
+ (NSString *) OrderList; // 报价单
+ (NSString *) ArchitureEdit; // 墙体编辑

#pragma mark inspriation
+ (NSString *) InspiratedList; //场景列表
+ (NSString *) InspiratedEdit; //设计场景
+ (NSString *) InspiratedProductList; //物件列表
+ (NSString *) InspiratedProductInfo; //物件详情
+ (NSString *) InspiratedItemEdit; //物件编辑
+ (NSString *) InspiratedCamera; // 拍照

#pragma mark 教学
+ (NSString *) TeachPlanEdit;
+ (NSString *) TeachProductList;
+ (NSString *) TeachProductInfo;
+ (NSString *) TeachItemEdit;
+ (NSString *) TeachOrderList;
+ (NSString *) TeachArchitureEdit;
+ (NSString *) TeachCameraFPS;
+ (NSString *) TeachCameraVR;

#pragma mark Education
+ (NSString *) EducationStart;
+ (NSString *) EducationAddItem;
+ (NSString *) EducationItemEdit;
+ (NSString *) EducationChangeToBirdCamera;
+ (NSString *) EducationChangeToEditorCamera;
+ (NSString *) EducationShot;
+ (NSString *) EducationEnd;

@end

typedef NS_ENUM(NSInteger, R_id_){
    R_id_invalid = 0,
    
    R_id_lo_inspirate_product_list,
    R_id_lo_inspirate_product_info,
    R_id_lo_inspirate_item_edit,
    R_id_lo_inspirate_buttons,
    R_id_lo_inspirate_button_up,
    R_id_lo_inspirate_button_down,
    
    R_id_lo_teach_mov,
    R_id_lo_right_mov,
    
    R_id_lo_teach_move,
    R_id_lo_teach_main,
    R_id_lo_teach_load,
    R_id_lo_teach_camera,
    R_id_lo_teaching,
    R_id_lo_teach_tap,
    R_id_lo_teach_shot,
    R_id_lo_teach_save,
    R_id_lo_teach_tap_static,
    R_id_lo_teach_tap_right,
    R_id_lo_teach_double_static,
    R_id_lo_cg,
    R_id_lo_edu_empty,
    
    R_id_lo_shot,
    R_id_lo_photo_library,
    
    R_id_lo_main_screen,
    R_id_camera_view,
    R_id_lo_empty,
    R_id_lo_inspirated_camera,
    R_id_lo_inspiratedEdit,
    R_id_lo_game_view,
    R_id_game_view,
    
    R_id_btn_architecture_all,
    R_id_btn_architecture_one,
    R_id_btn_architecture_two,
    R_id_btn_architecture_three,
    R_id_btn_architecture_other,
    
    R_id_lo_room_base,
    R_id_lo_rooms_collection,
    
    R_id_lo_mainMenu1_container, // 场景里左上角椭圆容器
    R_id_lo_camera, // 场景里摄像头选项容器
    R_id_lo_gesture,
    
    R_id_lo_glass_view,
    R_id_MojingType2,
    R_id_MojingType3Standard,
    R_id_MojingType3PlusB,
    R_id_MojingType3PlusA,
    R_id_MojingType4,
    R_id_MojingTypeGuanYingJing,
    R_id_MojingTypeXiaoD,
    
    R_id_lo_main_ground,
    R_id_left_lo_suit,
    R_id_right_lo_DIY,
    R_id_btn_rest,
    R_id_btn_Lshape,
    
    R_id_lo_center,
    R_id_lo_small_plan,
    R_id_btn_named,
    R_id_btn_copy,
    R_id_btn_delete_enter,
    R_id_btn_upload,
    R_id_btn_add,
    R_id_btn_download,
    R_id_lo_point,
    
    R_id_cv_plans,
    R_id_cv_small_plans,
    
    R_id_btn_room_shape_base,
    R_id_btn_room_shape_one,
    R_id_btn_room_shape_two,
    R_id_btn_room_shape_three,
    R_id_btn_room_shape_other,
    
    R_id_lo_wall_edit,
    
    R_id_btn_homepage,
    R_id_btn_undo,
    R_id_btn_redo,
    R_id_btn_screenshot,
    
    R_id_btn_brid_camera,
    R_id_btn_fps_camera,
    R_id_btn_editor_camera,
    R_id_btn_vr_camera,
    R_id_btn_fps_switch,
    
    R_id_btn_exchange,
    R_id_img_exchange,
    R_id_tv_exchange,
    
    R_id_btn_build_list,
    R_id_img_build_list,
    R_id_tv_build_list,
    R_id_btn_build_list_t,
    R_id_img_build_list_t,
    R_id_tv_build_list_t,
    
    R_id_btn_living_room,
    R_id_img_living_room,
    R_id_tv_living_room,
    R_id_btn_living_room_t,
    R_id_img_living_room_t,
    R_id_tv_living_room_t,
    
    R_id_btn_bedroom,
    R_id_img_bedroom,
    R_id_tv_bedroom,
    R_id_btn_bedroom_t,
    R_id_img_bedroom_t,
    R_id_tv_bedroom_t,
    
    R_id_btn_kitchen,
    R_id_img_kitchen,
    R_id_tv_kitchen,
    R_id_btn_kitchen_t,
    R_id_img_kitchen_t,
    R_id_tv_kitchen_t,
    
    R_id_btn_toilet,
    R_id_img_toilet,
    R_id_tv_toilet,
    R_id_btn_toilet_t,
    R_id_img_toilet_t,
    R_id_tv_toilet_t,
    
    R_id_btn_order,
    R_id_img_order,
    R_id_tv_order,
    R_id_btn_order_t,
    R_id_img_order_t,
    R_id_tv_order_t,
    
    R_id_btn_change_color,
    R_id_btn_description,
    R_id_btn_tools,
    R_id_lo_tools,
    R_id_btn_change_texture,
    
    R_id_btn_rotate,
    R_id_btn_updown,
    R_id_btn_left,
    R_id_btn_right,
    R_id_btn_delete,
    R_id_btn_link,
    R_id_btn_AR,
    R_id_btn_brush,
    R_id_btn_details,
    
    R_id_lo_product_list,
    R_id_gv_product_list,
    R_id_lo_product_info,
    R_id_lo_item_edit,
    R_id_lo_architure_details,
    R_id_lo_menu_right_gray,
    R_id_lo_menu_edu,
    R_id_lo_loading,
    R_id_lo_control,
    R_id_lo_tool_fm,
    R_id_lo_move,
    
    R_id_btn_close,
    R_id_btn_back,
    
    R_id_AR_left,
    R_id_AR_right,
    
    R_id_tools_px,
    R_id_tools_py,
    R_id_tools_pz,
    R_id_tools_ox,
    R_id_tools_oy,
    R_id_tools_oz,
    R_id_tools_tx,
    R_id_tools_ty,
    
    R_id_btn_pay,
};

typedef NS_ENUM(unsigned long, R_color_){
    R_color_suit_background = 0xffdd9347, //0xff35c6ff,
    R_color_shape_background = 0xffdd9347, //0xff35c6ff,
    R_color_room_base_background = 0xffdd9347, //0xff35c6ff,
    R_color_product_name = 0xff333333,
    R_color_product_list_line = 0xffd8dbe2,
    R_color_option_info_n = 0xff999999, //物件详情选项按钮 未按下的颜色
    R_color_option_info_p = 0xfff69f35,//0xff35c6ff, //物件详情选项按钮 按下的颜色
    R_color_item_tools = R_color_option_info_p,
    R_color_item_title = R_color_item_tools,
    R_color_slider_l = R_color_item_tools,
    R_color_slider_r = 0xffb3b3b3,
    R_color_product_price = 0xffe04a00,
    R_color_right_menu_label_textcolor = 0xfff69f35,//0xff35c6ff,
    R_color_order_title_bg_color = 0xffdd9347, //0xff35c6ff, // 0xff252525
    R_color_order_title_bg_pay_color = 0xff35c6ff,
    R_color_order_list_item_count = 0xff333333,
    R_color_order_list_item_total = R_color_order_list_item_count,
    R_color_order_list_area = 0xff559cd9,
    R_color_order_list_area_total_text = R_color_order_list_item_count,
    R_color_order_list_area_total = 0xffe04a00,
    R_color_order_list_item_line = 0xffededed,
    R_color_total_text = 0xff252525,
    R_color_total_price = 0xffe04a00,
    R_color_order_list_line = 0xffd8dbe2,
    R_color_option_line = 0xffd8dbe2,
    R_color_glass_menu_title = 0xff14bbfb,
};

typedef NS_ENUM(NSInteger, ItemType) {
    ItemTypeUnknown = 0,
    ItemTypeItem,
    ItemTypeWall,
    ItemTypeFloor,
    ItemTypeCeil,
    ItemTypeCount,
    ItemTypeLast = ItemTypeCeil,
};

typedef NS_ENUM(NSInteger, Rooms) {
    RoomsNum = 3,
    RoomsOther,
    RoomsMaxIndex,
    RoomsMaxNum = RoomsMaxIndex,
};
