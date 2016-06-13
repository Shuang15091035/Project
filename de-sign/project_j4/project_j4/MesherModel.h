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

@protocol OnCurrentPlanIndexChangedDelegate <NSObject>

- (void) onCurrentPlanIndexChanged:(NSUInteger)index;

@end

@protocol IMesherModel <ICVObject>

+ (NSUInteger) CanSelectMask;
+ (NSUInteger) CanNotSelectMask;

@property (nonatomic, readwrite) id<ICVGameWorld> world;
@property (nonatomic, readwrite) id<ICVGameContext> currentContext;
@property (nonatomic, readwrite) id<ICVGameScene> currentScene;
@property (nonatomic, readwrite) id<ICVGameScene> arScene;
@property (nonatomic, readwrite) id<ICVGameObject> gridsObject;
@property (nonatomic, readwrite) id<ICVGameObject> backgroundSprite;
@property (nonatomic, readwrite) ItemSelectAndMoveBehaviour* itemSelectAndMoveBehaviour;
@property (nonatomic, readwrite) GamePhotographer* photographer;
@property (nonatomic, readonly) id<ICVCommandMachine> commandMachine;
@property (nonatomic, readwrite) UIView *lo_game_view;
@property (nonatomic, readwrite) UIView *gameView;

@property (nonatomic, readwrite) Area currentArea;
@property (nonatomic, readwrite) Product *currentProduct;// 选中的产品
@property (nonatomic, readwrite) id<ICVGameObject> selectedObject; // 当前选中的场景对象
@property (nonatomic, readwrite) id<ICVGameObject> preSelectedObject; // 之前选中的场景对象
@property (nonatomic, readwrite) id<ICVGameObject> arObject; // AR状态的文件
@property (nonatomic, readwrite) id<ICVMaterial> arVideoMaterial;
@property (nonatomic, readwrite) Plan* currentPlan; // 当前编辑的方案
@property (nonatomic, readwrite) Plan* prePlan; // 旧的方案
@property (nonatomic, readonly) Project* project;
@property (nonatomic, readwrite) Item *roomItem; // 户型的item 选择户型创建plan时使用
@property (nonatomic, readwrite) NSArray *currentRoomShapes; // RoomShape里记录当前点选的数组
@property (nonatomic, readwrite) CCCVector3 cameraPosition;

@property (nonatomic, readwrite) CCVRect4CornersDecals *itemRectFrameDecals;
@property (nonatomic, readwrite) NSInteger launchIndex;
@property (nonatomic, readwrite) CGFloat gameViewWidth;
@property (nonatomic, readwrite) CGFloat rightMenuWidth;
@property (nonatomic, readwrite) id<ICVGameObject> borderObject; // 边框对象(墙体,地板,天花...)

@property (nonatomic, readonly) NSUInteger currentPlanIndex;
- (void) setCurrentPlanIndex:(NSInteger)currentPlanIndex byTarget:(id)target;
- (void) registerOnCurrentPlanIndexChangedDelegate:(id<OnCurrentPlanIndexChangedDelegate>)delegate;
- (void) unregisterOnCurrentPlanIndexChangedDelegate:(id<OnCurrentPlanIndexChangedDelegate>)delegate;

@end

@interface MesherModel : CCVObject <IMesherModel>

//设置宽高
+ (CGFloat) uiWidthBy:(CGFloat)width;
+ (CGFloat) uiHeightBy:(CGFloat)height;

@end
