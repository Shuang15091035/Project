//
//  Mesher.m
//  project_mesher
//
//  Created by MacMini on 15/10/12.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Mesher.h"

#import "MainPage.h"
#import "Suit.h"
#import "DIY.h"
#import "RoomShape.h"
#import "PlanEdit.h"
#import "ItemAR.h"
#import "ProductList.h"
#import "ItemEdit.h"
#import "OrderList.h"
#import "MesherModel.h"
#import "GamePhotographer.h"
#import "MesherModel.h"
#import "PlanLoader.h"
#import <MojingSDK/MojingGamepad.h>
#import <MojingSDK/MojingIOSAPI.h>
#import <MojingSDK/MojingKeyCode.h>

@interface Mesher(){
    id<IMesherModel> mModel;
    CGFloat right_menu_width;
}
@end

@interface GameMesher : CCVGame

@end

@implementation GameMesher

- (void)onContentCreate {
    //设置引擎
    id<ICVGameContext> context = self.engine.context;
    id<ICVGameWorld> world = self.world;
    
    id<ICVGameScene> scene = [context createScene];
    [world addScene:scene];
    [world changeSceneById:scene.Id];
    // 场景背景色
    scene.clearColor = CCCColorMake(0.8f, 0.8f, 0.8f, 1.0f);//CCCColorMake(0.43f, 0.52f, 0.41f, 1.0f);
    
    self.engine.frame.renderMode = CCVGameFrameRenderModeWhenDirty;
}

@end

@implementation Mesher

- (void)onPrepare {
    [self toggleFullscreen];
    [super onPrepare];
}

- (void)onGameConfig {
    self.engine.pluginSystem.renderPlugin = [[CCVGL20Plugin alloc] init];
    self.engine.pluginSystem.renderPlugin.MSAA = 4;
}

- (void)onGameBuild {
    self.engine.game = [[GameMesher alloc] init];
}

- (UIView *)onCreateView:(UIView *)parent {
    CCVRelativeLayout *lo_main_screen = [CCVRelativeLayout layout];
    lo_main_screen.tag = R_id_lo_main_screen;
    lo_main_screen.layoutParams.width = CCVLayoutMatchParent;
    lo_main_screen.layoutParams.height = CCVLayoutMatchParent;
    [parent addSubview:lo_main_screen];
    
//    CCVCameraView *cameraView = [[CCVCameraView alloc] init];
//    cameraView.tag = R_id_camera_view;
//    cameraView.layoutParams.width = CCVLayoutMatchParent;
//    cameraView.layoutParams.height = CCVLayoutMatchParent;
//    cameraView.hidden = YES;
//    [lo_main_screen addSubview:cameraView];
    
    CCVRelativeLayout *lo_menu = [CCVRelativeLayout layout];
//    lo_menu.tag = R_id_lo_menu_right_gray;
    lo_menu.backgroundColor = [UIColor clearColor];
    lo_menu.layoutParams.width = CCVLayoutWrapContent;
    lo_menu.layoutParams.height = CCVLayoutMatchParent;
    lo_menu.layoutParams.alignment = CCVLayoutAlignParentRight;
    [lo_main_screen addSubview:lo_menu];
    UIImageView *bg_menu_right = [[UIImageView alloc] initWithImage:[UIImage imageByResourceDrawable:@"bg_menu_right_red.png"]];
    bg_menu_right.layoutParams.width = CCVLayoutWrapContent;
    bg_menu_right.layoutParams.height = CCVLayoutMatchParent;
    bg_menu_right.hidden = YES;
    [lo_menu addSubview:bg_menu_right];

    right_menu_width = bg_menu_right.frame.size.width;
    
    CCVRelativeLayout *lo_game_view = [CCVRelativeLayout layout];
    lo_game_view.tag = R_id_lo_game_view;
    lo_game_view.layoutParams.width = CCVLayoutMatchParent;
    lo_game_view.layoutParams.height = CCVLayoutMatchParent;
    lo_game_view.backgroundColor = [UIColor whiteColor];
    [lo_main_screen addSubview:lo_game_view];
    
    UIView* gameView = self.engine.frame.view;// 获取场景的view
    gameView.tag = R_id_game_view;
    gameView.layoutParams.height = CCVLayoutMatchParent;
    gameView.layoutParams.width = CCVLayoutMatchParent;
    
    [lo_game_view addSubview:gameView];
    
    CCVRelativeLayout *lo_empty = [CCVRelativeLayout layout];
    lo_empty.tag = R_id_lo_empty;
    lo_empty.layoutParams.width = CCVLayoutMatchParent;
    lo_empty.layoutParams.height = CCVLayoutMatchParent;
    lo_empty.hidden = YES;
    [lo_main_screen addSubview:lo_empty];

    return lo_main_screen;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[MojingGamepad sharedGamepad]registerGamepad:self];
    //    [[MojingGamepad sharedGamepad]setAutoScan:true];
}

- (void)onCreated
{
    [super onCreated];
    
    mModel = [[MesherModel alloc] init];
    //[mModel.localItemProvider load];
    
    id<ICVGameEngine> engine = self.engine;
    id<ICVGameContext> context = engine.context;
    id<ICVGameWorld> world = engine.game.world;
    id<ICVGameScene> scene = world.currentScene;
    mModel.currentContext = context;
    mModel.currentScene = scene;
    scene.root.queryMask = [MesherModel CanNotSelectMask];

#pragma mark 创建arScene
    id<ICVGameScene> arScene = [context createScene];
    mModel.arScene = arScene;
    [world addScene:arScene];
    arScene.root.queryMask = [MesherModel CanNotSelectMask];
    CGRect bounds = [[UIScreen mainScreen] boundsInPixels];
    
#pragma mark ar&shader相关
    CCCRectF rect = CCCRectFMake(0, 0, bounds.size.width+(10*[UIScreen mainScreen].scale), bounds.size.height+(10*[UIScreen mainScreen].scale));
    id<ICVGameObject> videoObject = [context createObject];
    videoObject.parent = arScene.root;
    NSString* videoName = [NSString stringWithFormat:@"video_%@", @(videoObject.hash)];
    id<ICVMesh> videoMesh = (id<ICVMesh>)[context.meshManager createFromFile:[CCVFile fileWithName:videoName content:nil]];
    [videoMesh spriteRect:rect];
    [videoMesh load];
    id<ICVVideoTexture> videoTexture = (id<ICVVideoTexture>)[context.videoTextureManager createFromFile:[CCVFile fileWithName:videoName content:nil]];
    id<ICVMaterial> videoMat = (id<ICVMaterial>)[context.materialManager createFromFile:[CCVFile fileWithName:videoName content:nil]];
    videoMat.videoTexture = videoTexture;
    videoMat.depthCheck = NO;
    mModel.arVideoMaterial = videoMat;
    [videoMat load];
    
    // 读取
    id<ICVFile> vertFile = [CCVFile fileWithBundle:nil path:@"res/shader/ARShader.vert"];
    id<ICVFile> fragFile = [CCVFile fileWithBundle:nil path:@"res/shader/ARShader.frag"];
    id<ICVFile> effFile = [CCVFile fileWithFiles:@[vertFile, fragFile]]; // 读取2个文件 可以用数组包含
    // 读取shader
    id<ICVEffect> eff = (id<ICVEffect>)[[context effectManager] createFromFile:effFile]; // 创建
    [eff load]; // 载入shader
    
    id<ICVMeshRenderer> videoRenderer = [context createMeshRenderer];
    videoRenderer.renderOrder = CCVRenderOrderBackgroundDefault;
    videoRenderer.mesh = videoMesh;
    videoRenderer.material = videoMat;
    videoRenderer.effect = eff;
    videoRenderer.autoEffect = NO;
    [videoObject addComponent:videoRenderer];
    
    engine.eventBinder.gestureEventBinder.lastLongPressGestureRecognizer.minimumPressDuration = 0.3f;
    mModel.world = world;
    //设置相机
    GamePhotographer* photographer = [[GamePhotographer alloc] initWithModel:mModel scene:scene];
    mModel.photographer = photographer;
    
#pragma mark 设置背景
    id<ICVFile> file = [CCVFile fileWithBundle:[NSBundle mainBundle] path:[CCVResourceBundle nameForDrawable:@"bg_main2.png"]];
    id<ICVGameObject> backgroundSprite = [CCVPrefabUtils createSpriteWithContext:context parent:scene.root rect:CCCRectFMake(0, 0, bounds.size.width, bounds.size.height) textureFile:file];
    mModel.backgroundSprite = backgroundSprite;
    
#pragma mark 设置网格
    CCCColor gridColor = CCCColorMake(1.0f, 1.0f, 1.0f, 0.6f);//CCCColorMake(0.7f, 0.7f, 0.7f, 1.0f)
    id<ICVGameObject> gridsObject = [CCVPrefabUtils createGridsWithContext:context parent:scene.root startRow:-25 startColumn:-25 numRows:50 numColumns:50 gridWidth:1.0f gridHeight:1.0f color:gridColor];
    
    //将网格设置成不能触发点击事件的状态 防止bug
    gridsObject.queryMask = [MesherModel CanNotSelectMask];
    mModel.gridsObject = gridsObject;
    
    // 创建物件选中和移动行为
    id<ICVGameObject> itemSelectAndMoveObject = [context createObject];
    itemSelectAndMoveObject.parent = scene.root;
    ItemSelectAndMoveBehaviour* itemSelectAndMoveBehaviour = [ItemSelectAndMoveBehaviour behaviourWithContext:context];
    [itemSelectAndMoveObject addComponent:itemSelectAndMoveBehaviour];
    itemSelectAndMoveBehaviour.model = mModel;
    mModel.itemSelectAndMoveBehaviour = itemSelectAndMoveBehaviour;
    
    // 注册PlanLoader
    [context.sceneLoaderManager registerLoader:[[PlanLoader alloc] initWithContext:context] overrideExist:NO];
    
    mModel.gameViewWidth = [UIScreen mainScreen].boundsByOrientation.size.width - right_menu_width;
    mModel.rightMenuWidth = right_menu_width;
    
    // 加载本地数据
    [mModel.project loadProducts];
    
    //把状态加入状态机
    [self.subMachine addState:[[MainPage alloc] initWithModel:mModel] withName:[States MainPage]];
    [self.subMachine addState:[[Suit alloc] initWithModel:mModel] withName:[States Suit]];
    // 固有模型进入的页面
    [self.subMachine addState:[[DIY alloc] initWithModel:mModel] withName:[States DIY]]; // 自定义创建的进入页面
    [self.subMachine addState:[[PlanEdit alloc] initWithModel:mModel] withName:[States PlanEdit]];
    [self.subMachine addState:[[ItemAR alloc] initWithModel:mModel] withName:[States ItemAR]];
    [self.subMachine addState:[[RoomShape alloc] initWithModel:mModel] withName:[States RoomShape]]; // 房型选择的页面
    
    //状态机跳转到 方案编辑
    [self.subMachine changeStateTo:[States DIY] pushState:NO]; // 直接跳到DIY状态
}

@end


