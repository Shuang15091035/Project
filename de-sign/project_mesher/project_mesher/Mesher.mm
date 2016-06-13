//
//  Mesher.m
//  project_mesher
//
//  Created by MacMini on 15/10/12.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Mesher.h"

#import "Common.h"
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

#import "InspiratedList.h"
#import "InspiratedEdit.h"
#import "InspiratedCamera.h"

#import "TutorialPlanEdit.h"

@interface Mesher(){
    id<IMesherModel> mModel;
    CGFloat right_menu_width;
}
@end

@interface GameMesher : JWGame

@end

@implementation GameMesher

- (void)onContentCreate {
    //设置引擎
    id<JIGameContext> context = self.engine.context;
    [context.sceneLoaderManager registerLoader:[[JWDaeLoader alloc] init] overrideExist:NO];
    [context.sceneLoaderManager registerLoader:[[JWDaxLoader alloc] init] overrideExist:NO];
    
    id<JIGameWorld> world = self.world;
    
    id<JIGameScene> scene = [context createScene];
    [scene setId:@"mainScene"];
    [world addScene:scene];
    [world changeSceneById:scene.Id];
    // 场景背景色
    scene.clearColor = JCColorMake(0.8f, 0.8f, 0.8f, 1.0f);//JCColorMake(0.43f, 0.52f, 0.41f, 1.0f);
    
    self.engine.frame.renderMode = JWGameFrameRenderModeWhenDirty;
}

@end

@implementation Mesher

- (void)onPrepare {
    [self toggleFullscreen];
    [super onPrepare];
}

- (void)onGameConfig {
    JCBufferSetDefaultAllocator(JCMakeBuddyAllocator(64 * JCMegabytes, 4 * JCKilobytes));
//    self.engine.pluginSystem.renderPlugin = [[JWGL20Plugin alloc] init];
#ifdef USE_MOJING
    self.engine.pluginSystem.renderPlugin = [[JWMojingRenderPlugin alloc] init];
    self.engine.pluginSystem.inputPlugin = [[JWMojingInputPlugin alloc] init];
#else
    self.engine.pluginSystem.renderPlugin = [[JWGL20Plugin alloc] init];
#endif
    self.engine.pluginSystem.renderPlugin.MSAA = 4;
}

- (void)onGameBuild {
    self.engine.game = [[GameMesher alloc] init];
}

- (UIView *)onCreateView:(UIView *)parent {
    JWRelativeLayout *lo_main_screen = [JWRelativeLayout layout];
    lo_main_screen.tag = R_id_lo_main_screen;
    lo_main_screen.layoutParams.width = JWLayoutMatchParent;
    lo_main_screen.layoutParams.height = JWLayoutMatchParent;
    [parent addSubview:lo_main_screen];
    
//    JWCameraView *cameraView = [[JWCameraView alloc] init];
//    cameraView.tag = R_id_camera_view;
//    cameraView.layoutParams.width = JWLayoutMatchParent;
//    cameraView.layoutParams.height = JWLayoutMatchParent;
//    cameraView.hidden = YES;
//    [lo_main_screen addSubview:cameraView];
    
    JWFrameLayout *lo_menu = [JWFrameLayout layout];
    lo_menu.hidden = YES;
    lo_menu.tag = R_id_lo_menu_right_gray;
    lo_menu.layoutParams.width = JWLayoutWrapContent;
    lo_menu.layoutParams.height = JWLayoutMatchParent;
    lo_menu.layoutParams.alignment = JWLayoutAlignParentRight;
    [lo_main_screen addSubview:lo_menu];
    UIImageView *bg_menu_right = [[UIImageView alloc] initWithImage:[UIImage imageByResourceDrawable:@"bg_menu_right_orange2.png"]];
    bg_menu_right.layoutParams.width = JWLayoutWrapContent;
    bg_menu_right.layoutParams.height = JWLayoutMatchParent;
    [lo_menu addSubview:bg_menu_right];
    
    JWFrameLayout *lo_edu_menu = [JWFrameLayout layout];
    lo_edu_menu.hidden = YES;
    lo_edu_menu.tag = R_id_lo_menu_edu;
    lo_edu_menu.layoutParams.width = JWLayoutWrapContent;
    lo_edu_menu.layoutParams.height = JWLayoutMatchParent;
    lo_edu_menu.layoutParams.alignment = JWLayoutAlignParentRight;
    [lo_main_screen addSubview:lo_edu_menu];
    UIImageView *bg_menu_right_edu = [[UIImageView alloc] initWithImage:[UIImage imageByResourceDrawable:@"bg_menu_right_orange2.png"]];
    bg_menu_right_edu.layoutParams.width = JWLayoutWrapContent;
    bg_menu_right_edu.layoutParams.height = JWLayoutMatchParent;
    [lo_edu_menu addSubview:bg_menu_right_edu];

    right_menu_width = bg_menu_right.frame.size.width;
    mModel.rightMenuWidth = right_menu_width;
    
    JWRelativeLayout *lo_game_view = [JWRelativeLayout layout];
    lo_game_view.tag = R_id_lo_game_view;
    lo_game_view.layoutParams.width = [UIScreen mainScreen].boundsByOrientation.size.width - right_menu_width;
    
    lo_game_view.layoutParams.height = JWLayoutMatchParent;
    lo_game_view.backgroundColor = [UIColor whiteColor];
    [lo_main_screen addSubview:lo_game_view];
    
    UIView* gameView = self.engine.frame.view;// 获取场景的view
    gameView.tag = R_id_game_view;
    gameView.layoutParams.height = JWLayoutMatchParent;
    gameView.layoutParams.width = JWLayoutMatchParent;
    gameView.layoutParams.marginTop = 10;
    gameView.layoutParams.marginLeft = 10;
    gameView.layoutParams.marginBottom = 10;
    gameView.layoutParams.marginRight = 10;
    
    [lo_game_view addSubview:gameView];
    
    JWRelativeLayout *lo_inspiratedCamera = [JWRelativeLayout layout];
    lo_inspiratedCamera.tag = R_id_lo_inspirated_camera;
    lo_inspiratedCamera.layoutParams.width = JWLayoutMatchParent;
    lo_inspiratedCamera.layoutParams.height = JWLayoutMatchParent;
    lo_inspiratedCamera.hidden = YES;
    lo_inspiratedCamera.backgroundColor = [UIColor clearColor];
    [lo_main_screen addSubview:lo_inspiratedCamera];
    
    JWRelativeLayout *lo_empty = [JWRelativeLayout layout];
    lo_empty.tag = R_id_lo_empty;
    lo_empty.layoutParams.width = JWLayoutMatchParent;
    lo_empty.layoutParams.height = JWLayoutMatchParent;
    lo_empty.hidden = YES;
    [lo_main_screen addSubview:lo_empty];
    
//    JWRelativeLayout *lo_inspiratedEdit = [JWRelativeLayout layout];
//    lo_inspiratedEdit.tag = R_id_lo_inspiratedEdit;
//    lo_inspiratedEdit.layoutParams.width = JWLayoutMatchParent;
//    lo_inspiratedEdit.layoutParams.height = JWLayoutMatchParent;
//    lo_inspiratedEdit.hidden = YES;
//    [lo_main_screen addSubview:lo_inspiratedEdit];

    return lo_main_screen;
}

- (void)viewDidLoad {
    [super viewDidLoad];
#ifdef USE_MOJING
    [[JWMojingManager instance] setupMojingWithController:self];
#endif
    mModel.mainController = self;
}

- (void)onCreated
{
    [super onCreated];
    
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSString *first = [accountDefaults objectForKey:@"FirstTime"];
    
    mModel = [[MesherModel alloc] init];
    //[mModel.localItemProvider load];
    
    id<JIGameEngine> engine = self.engine;
    id<JIGameContext> context = engine.context;
    id<JIGameWorld> world = engine.game.world;
    id<JIGameScene> scene = world.currentScene;
    mModel.currentContext = context;
    mModel.currentScene = scene;
    scene.root.queryMask = SelectedMaskCannotSelect;

#pragma mark 创建arScene
    id<JIGameScene> arScene = [context createScene];
    [arScene setId:@"ARScene"];
    mModel.arScene = arScene;
    [world addScene:arScene];
    arScene.root.queryMask = SelectedMaskCannotSelect;
    
    CGRect bounds = [[UIScreen mainScreen] boundsInPixels];
    
#pragma mark ar&shader相关
    JCRectF rect = JCRectFMake(0, 0, bounds.size.width+(10*[UIScreen mainScreen].scale), bounds.size.height+(10*[UIScreen mainScreen].scale));
    id<JIGameObject> videoObject = [context createObject];
    videoObject.parent = arScene.root;
    NSString* videoName = [NSString stringWithFormat:@"video_%@", @(videoObject.hash)];
    id<JIMesh> videoMesh = (id<JIMesh>)[context.meshManager createFromFile:[JWFile fileWithName:videoName content:nil]];
    [videoMesh spriteRect:rect color:JCColorNull()];
    [videoMesh load];
    id<JIVideoTexture> videoTexture = (id<JIVideoTexture>)[context.videoTextureManager createFromFile:[JWFile fileWithName:videoName content:nil]];
    id<JIMaterial> videoMat = (id<JIMaterial>)[context.materialManager createFromFile:[JWFile fileWithName:videoName content:nil]];
    videoMat.videoTexture = videoTexture;
    videoMat.depthCheck = NO;
    mModel.arVideoMaterial = videoMat;
    [videoMat load];
    
#pragma mark shader
//    // 读取
//    id<JIFile> vertFile = [JWFile fileWithBundle:nil path:@"res/shader/ARShader.vert"];
//    id<JIFile> fragFile = [JWFile fileWithBundle:nil path:@"res/shader/ARShader.frag"];
//    id<JIFile> effFile = [JWFile fileWithFiles:@[vertFile, fragFile]]; // 读取2个文件 可以用数组包含
//    // 读取shader
//    id<JIEffect> eff = (id<JIEffect>)[[context effectManager] createFromFile:effFile]; // 创建
//    [eff load]; // 载入shader
//    
//    id<JIMeshRenderer> videoRenderer = [context createMeshRenderer];
//    videoRenderer.renderOrder = JWRenderOrderBackgroundDefault;
//    videoRenderer.mesh = videoMesh;
//    videoRenderer.material = videoMat;
//    videoRenderer.effect = eff;
//    videoRenderer.autoEffect = NO;
//    [videoObject addComponent:videoRenderer];
    
    [JWPrefabUtils createVideoBackgroundWithContext:context parent:arScene.root rect:JCRectFMake(20, 20, bounds.size.width, bounds.size.height)];//返回一个gameObject
 
//    id<JIGameScene> modelScene = [context createScene];
//    [world addScene:modelScene];
//    modelScene.root.queryMask = [MesherModel CanNotSelectMask];
    
    engine.eventBinder.gestureEventBinder.lastLongPressGestureRecognizer.minimumPressDuration = 0.3f;
    mModel.world = world;
    //设置相机
    GamePhotographer* photographer = [[GamePhotographer alloc] initWithModel:mModel scene:scene];
    mModel.photographer = photographer;
    
//    id<JIGameObject> gridsObject = [context createObject];
//    gridsObject.name = @"Grids";
//    [gridsObject setParent:scene.root];
//    id<JIMesh> gridsMesh = (id<JIMesh>)[context.meshManager createFromFile:[JWFile fileWithName:@"Grids" content:nil]];
//    [gridsMesh gridsStartRow:-25 startColumn:-25 numRows:50 numColumns:50 gridWidth:1.0f gridHeight:1.0f color:gridColor];
//    [gridsMesh load];
//    id<JIMeshRenderer> gridsRenderer = [context createMeshRenderer];
//    gridsRenderer.mesh = gridsMesh;
//    [gridsObject addComponent:gridsRenderer];
    
    //id<JIFile> file = [JWFile fileWithBundle:[NSBundle mainBundle] path:[JWResourceBundle nameForDrawable:@"bg_main2.png"]];
    
#pragma mark inspirateScene
    id<JIGameScene> inspirateScene = [context createScene];
    [inspirateScene setId:@"inspirateScene"];
    mModel.inspirateScene = inspirateScene;
    [world addScene:inspirateScene];
    inspirateScene.root.queryMask = SelectedMaskCannotSelect;
    
#pragma mark inspiratedCameraScene
    id<JIGameScene> inspiratedCameraScene = [context createScene];
    [inspiratedCameraScene setId:@"inspiratedCameraScene"];
    mModel.inspiratedCameraScene = inspiratedCameraScene;
    [world addScene:inspiratedCameraScene];
    inspiratedCameraScene.root.queryMask = SelectedMaskCannotSelect;
    
    id<JIGameObject> iVideoObject = [context createObject];
    iVideoObject.parent = inspiratedCameraScene.root;
    NSString* iVideoName = [NSString stringWithFormat:@"iVideo_%@", @(iVideoObject.hash)];
    id<JIMesh> iVideoMesh = (id<JIMesh>)[context.meshManager createFromFile:[JWFile fileWithName:iVideoName content:nil]];
    [iVideoMesh spriteRect:rect color:JCColorNull()];
    [iVideoMesh load];
    id<JIVideoTexture> iVideoTexture = (id<JIVideoTexture>)[context.videoTextureManager createFromFile:[JWFile fileWithName:iVideoName content:nil]];
    id<JIMaterial> iVideoMat = (id<JIMaterial>)[context.materialManager createFromFile:[JWFile fileWithName:iVideoName content:nil]];
    iVideoMat.videoTexture = iVideoTexture;
    iVideoMat.depthCheck = NO;
    [videoMat load];
    [JWPrefabUtils createVideoBackgroundWithContext:context parent:inspiratedCameraScene.root rect:JCRectFMake(0, 0, bounds.size.width+(10*[UIScreen mainScreen].scale), bounds.size.height+(10*[UIScreen mainScreen].scale))];
    
#pragma mark 设置背景
    id<JIFile> file = [JWFile fileWithBundle:[NSBundle mainBundle] path:[JWResourceBundle nameForDrawable:@"bg_main4.png"]];
    id<JIGameObject> backgroundSprite = [JWPrefabUtils createSpriteWithContext:context parent:scene.root rect:JCRectFMake(0, 0, bounds.size.width, bounds.size.height) textureFile:file];
    mModel.backgroundSprite = backgroundSprite;
    
#pragma mark 设置网格
    JCColor gridColor = JCColorMake(1.0f, 1.0f, 1.0f, 0.6f);//JCColorMake(0.7f, 0.7f, 0.7f, 1.0f)
    id<JIGameObject> gridsObject = [JWPrefabUtils createGridsWithContext:context parent:scene.root startRow:-25 startColumn:-25 numRows:50 numColumns:50 gridWidth:1.0f gridHeight:1.0f color:gridColor];
    
    //将网格设置成不能触发点击事件的状态 防止bug
    gridsObject.queryMask = SelectedMaskCannotSelect;
    mModel.gridsObject = gridsObject;
    
    // 创建物件选中和移动行为
    id<JIGameObject> itemSelectAndMoveObject = [context createObject];
    itemSelectAndMoveObject.parent = mModel.world.currentScene.root;
    mModel.itemSelectAndMoveObject = itemSelectAndMoveObject;
    ItemSelectAndMoveBehaviour* itemSelectAndMoveBehaviour = [ItemSelectAndMoveBehaviour behaviourWithContext:context];
    [itemSelectAndMoveObject addComponent:itemSelectAndMoveBehaviour];
    itemSelectAndMoveBehaviour.model = mModel;
    mModel.itemSelectAndMoveBehaviour = itemSelectAndMoveBehaviour;
    
    // 注册PlanLoader
    [context.sceneLoaderManager registerLoader:[[PlanLoader alloc] init] overrideExist:NO];
    
    mModel.gameViewWidth = [UIScreen mainScreen].boundsByOrientation.size.width - right_menu_width;
    
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
    
    [self.subMachine addState:[[InspiratedEdit alloc] initWithModel:mModel] withName:[States InspiratedEdit]];
    [self.subMachine addState:[[InspiratedList alloc] initWithModel:mModel] withName:[States InspiratedList]];
    [self.subMachine addState:[[InspiratedCamera alloc] initWithModel:mModel] withName:[States InspiratedCamera]];
    [self.subMachine addState:[[TutorialPlanEdit alloc] initWithModel:mModel] withName:[States EducationStart]];
    
    //状态机跳转到 方案编辑
//    [self.subMachine changeStateTo:[States DIY] pushState:NO]; // 直接跳到DIY状态
    if(!first) {
        [self.subMachine changeStateTo:[States EducationStart] pushState:NO];
        [accountDefaults setObject:@"1" forKey:@"FirstTime"];
        [accountDefaults synchronize];
    }else {
        [self.subMachine changeStateTo:[States DIY] pushState:NO];
    }
//    [self.subMachine changeStateTo:[States TeachPlanEdit] pushState:NO];
    
//    [self.subMachine changeStateTo:[States EducationStart] pushState:NO];
}

@end


