//
//  MesherModel.h
//  project_mesher
//
//  Created by MacMini on 15/10/12.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Data.h"
#import "Project.h"
#import "ItemSelectAndMoveBehaviour.h"
#import "Product.h"
#import "EditorCamera.h"

#import "InspiratedBehaviour.h"

typedef NS_ENUM(NSInteger, SelectedMask) {
    SelectedMaskItem = 0x1 << ItemTypeItem,
    SelectedMaskWall = 0x1 << ItemTypeWall,
    SelectedMaskFloor = 0x1 << ItemTypeFloor,
    SelectedMaskCeil = 0x1 << ItemTypeCeil,
    
    SelectedMaskGround = 0x1 << (ItemTypeLast + PositionGround),
    SelectedMaskTop = 0x1 << (ItemTypeLast + PositionTop),
    SelectedMaskOnItem = 0x1 << (ItemTypeLast + PositionOnItem),
    SelectedMaskInWall = 0x1 << (ItemTypeLast + PositionInWall),
    SelectedMaskOnWall = 0x1 << (ItemTypeLast + PositionOnWall),

    SelectedMaskArch = 0x1 << (ItemTypeLast + PositionLast + 1),
    SelectedMaskCannotSelect = 0x1 << (ItemTypeLast + PositionLast + 2),
    
    SelectedMaskAllItems = SelectedMaskGround | SelectedMaskTop | SelectedMaskOnItem | SelectedMaskInWall | SelectedMaskOnWall,
    SelectedMaskAllArchs = SelectedMaskWall | SelectedMaskFloor | SelectedMaskCeil,
    
    SelectedMaskAllArchsExceptCeil = SelectedMaskWall | SelectedMaskFloor,
    SelectedMaskAllItemsExceptTop = SelectedMaskGround | SelectedMaskOnItem | SelectedMaskInWall | SelectedMaskOnWall,
};

@protocol OnCurrentPlanIndexChangedDelegate <NSObject>

- (void) onCurrentPlanIndexChanged:(NSUInteger)index;

@end

@protocol IMesherModel <JIObject>

//+ (NSUInteger) CanSelectMask;
//+ (NSUInteger) CanNotSelectMask;

@property (nonatomic, readwrite) id<JIGameWorld> world;
@property (nonatomic, readwrite) id<JIGameContext> currentContext;
@property (nonatomic, readwrite) id<JIGameScene> currentScene;
@property (nonatomic, readwrite) id<JIGameScene> arScene;
@property (nonatomic, readwrite) id<JIGameScene> inspirateScene;
@property (nonatomic, readwrite) id<JIGameObject> gridsObject;
@property (nonatomic, readwrite) id<JIGameObject> backgroundSprite;
@property (nonatomic, readwrite) id<JIGameObject> itemSelectAndMoveObject;
@property (nonatomic, readwrite) ItemSelectAndMoveBehaviour* itemSelectAndMoveBehaviour;
@property (nonatomic, readwrite) id<JIGameObject> inspiratedObject;
@property (nonatomic, readwrite) InspiratedBehaviour *inspiratedBehaviour;
@property (nonatomic, readwrite) id<JICamera> inspiratedCamera;
@property (nonatomic, readwrite) EditorCamera* inspiratedEditorCamera;
@property (nonatomic, readwrite) id<JIGameObject> inspiratedGridsObject;
@property (nonatomic, readwrite) BOOL fromPhotoLibrary;
@property (nonatomic, readwrite) BOOL fromExchange;

@property (nonatomic, readwrite) GamePhotographer* photographer;
@property (nonatomic, readwrite) JWCameraPrefab *currentCamera;
@property (nonatomic, readonly) id<JICommandMachine> commandMachine;
@property (nonatomic, readwrite) UIView *lo_game_view;
@property (nonatomic, readwrite) UIView *gameView;

@property (nonatomic, readwrite) Area currentArea;
@property (nonatomic, readwrite) Product *currentProduct;// 选中的产品
@property (nonatomic, readwrite) id<JIGameObject> selectedObject; // 当前选中的场景对象
@property (nonatomic, readwrite) id<JIGameObject> preSelectedObject; // 之前选中的场景对象
@property (nonatomic, readwrite) id<JIGameObject> arObject; // AR状态的文件
@property (nonatomic, readwrite) id<JIMaterial> arVideoMaterial;
@property (nonatomic, readwrite) Plan* currentPlan; // 当前编辑的方案
@property (nonatomic, readwrite) Plan* prePlan; // 旧的方案
@property (nonatomic, readonly) Project* project;
@property (nonatomic, readwrite) Item *roomItem; // 户型的item 选择户型创建plan时使用
@property (nonatomic, readwrite) NSArray *currentRoomShapes; // RoomShape里记录当前点选的数组
@property (nonatomic, readwrite) JCVector3 cameraPosition;
#ifdef USE_MOJING
@property (nonatomic, readwrite) MojingType mojingType;
#endif
@property (nonatomic, readwrite) BOOL autoFPS;

@property (nonatomic, readwrite) JWRect4CornersDecals *itemRectFrameDecals;
@property (nonatomic, readwrite) JWRect4CornersDecals *itemOverlapDecals;
@property (nonatomic, readwrite) NSInteger launchIndex;
@property (nonatomic, readwrite) CGFloat gameViewWidth;
@property (nonatomic, readwrite) CGFloat rightMenuWidth;
@property (nonatomic, readwrite) id<JIGameObject> borderObject; // 边框对象(墙体,地板,天花...)
@property (nonatomic, readwrite) BOOL isFPS;

@property (nonatomic, readwrite) UIViewController *mainController;
@property (nonatomic, readwrite) UIImage *inspiratedImage;
@property (nonatomic, readwrite) JWBackgroundSpritePrefab* inspiratedBackgroundSprite;
@property (nonatomic, readwrite) id<JIGameScene> inspiratedCameraScene;
@property (nonatomic, readwrite) BOOL fromInspiration; // 从Inspiration回来
@property (nonatomic, readwrite) BOOL isInspiratedCreate;
@property (nonatomic, readwrite) BOOL isTeach;
@property (nonatomic, readwrite) id<JIGameObject> teachObject;
@property (nonatomic, readwrite) id<JIGameObject> teachDeacls;
@property (nonatomic, readwrite) CGPoint teachTouchUpPoint;
@property (nonatomic, readwrite) BOOL isTeachMove;
@property (nonatomic, readwrite) BOOL isInTeachObject;
@property (nonatomic, readwrite) BOOL completedMove;
@property (nonatomic, readwrite) BOOL completedTeach;
@property (nonatomic, readwrite) BOOL fromTeach;

@property (nonatomic, readwrite) BOOL isTouchBirdCamera;
@property (nonatomic, readwrite) BOOL isTouchEditCamera;
@property (nonatomic, readwrite) BOOL isTouchShot;
@property (nonatomic, readwrite) BOOL isTouchHome;
@property (nonatomic, readwrite) BOOL isTeachTime;
@property (nonatomic, readwrite) BOOL loadScene;
@property (nonatomic, readwrite) JCVector3 teachMoveLastPosition;

@property (nonatomic, readonly) NSUInteger currentPlanIndex;
- (void) setCurrentPlanIndex:(NSInteger)currentPlanIndex byTarget:(id)target;
- (void) registerOnCurrentPlanIndexChangedDelegate:(id<OnCurrentPlanIndexChangedDelegate>)delegate;
- (void) unregisterOnCurrentPlanIndexChangedDelegate:(id<OnCurrentPlanIndexChangedDelegate>)delegate;

@end

@interface MesherModel : JWObject <IMesherModel>

//设置宽高
+ (CGFloat) uiWidthBy:(CGFloat)width;
+ (CGFloat) uiHeightBy:(CGFloat)height;

@end
