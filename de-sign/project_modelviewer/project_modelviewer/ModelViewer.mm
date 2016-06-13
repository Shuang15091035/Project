//
//  ModelViewer.m
//  project_modelviewer
//
//  Created by GavinLo on 15/1/23.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "ModelViewer.h"
#import <AVFoundation/AVFoundation.h>

@interface GameModelViewer : CCVGame {
    UIImageView* img_image;
    UILabel* tv_name;
}

@end

@implementation GameModelViewer

- (UIView *)onUiCreate:(UIView *)parent {
    CCVRelativeLayout* view = [CCVRelativeLayout layout];
    view.layoutParams.width = CCVLayoutMatchParent;
    view.layoutParams.height = CCVLayoutMatchParent;
    
    UIView* gameView = self.engine.frame.view;
    [view addSubview:gameView];
    gameView.layoutParams.width = CCVLayoutMatchParent;
    gameView.layoutParams.height = CCVLayoutMatchParent;
    
    img_image = [[UIImageView alloc] init];
    [view addSubview:img_image];
    img_image.layoutParams.width = CCVLayoutWrapContent;
    img_image.layoutParams.height = CCVLayoutWrapContent;
    img_image.layoutParams.alignment = CCVLayoutAlignParentTopLeft;
    img_image.backgroundColor = [UIColor whiteColor];
    
    CCVFrameLayout* lo_name = [CCVFrameLayout layout];
    lo_name.layoutParams.width = CCVLayoutMatchParent;
    lo_name.layoutParams.height = CCVLayoutMatchParent;
    [view addSubview:lo_name];
    
    tv_name = [[UILabel alloc] init];
    tv_name.layoutParams.width = CCVLayoutWrapContent;
    tv_name.layoutParams.height = CCVLayoutWrapContent;
    tv_name.text = @"我是物件";
    [lo_name addSubview:tv_name];
    
    return view;
}

- (void)onContentCreate
{
    id<ICVGameContext> context = self.engine.context;
    [context.sceneLoaderManager registerLoader:[[CCVDaeLoader alloc] init] overrideExist:NO];
    [context.sceneLoaderManager registerLoader:[[CCVDaxLoader alloc] init] overrideExist:NO];
    id<ICVGameWorld> world = self.world;
    
    id<ICVGameScene> scene = [context createScene];
    [world addScene:scene];
    [world changeSceneById:scene.Id];
    
    scene.clearColor = CCCColorGray();
    //scene.clearColor= CCCColorTransparent();
    //scene.clearColor = CCCColorMake(0.1, 0.1, 0.1, 0.9);
    
    //self.engine.frame.renderMode = CCVGameFrameRenderModeContinuously;
    self.engine.frame.renderMode = CCVGameFrameRenderModeWhenDirty;
    
    //    id<ICVGameObject> spotLightObject = [context createObject];
    //    spotLightObject.parent = scene.root;
    //    id<ICVSpotLight> spotLight = [context createSpotLight];
    //    [spotLightObject addComponent:spotLight];
    //    spotLight.cutoff = 45;
    //    [spotLightObject.transform setPositionX:0 Y:1 Z:-4];
    
    [CCVPrefabUtils createGridsWithContext:context parent:scene.root startRow:-25 startColumn:-25 numRows:50 numColumns:50 gridWidth:1.0f gridHeight:1.0f color:CCCColorWhite()];
    
//    [CCVPrefabUtils createSpriteWithContext:context parent:scene.root rect:CCCRectFMake(0, 0, 300, 300) textureFile:[CCVFile fileWithBundle:nil path:[CCVAssetsBundle nameForPath:@"test_color/texture/t_wa_living_room4_ld.jpg"]]];
    
    CCVEditorCameraPrefab* cp = [[CCVEditorCameraPrefab alloc] initWithContext:context parent:scene.root cameraId:@"c" initPicth:0 initYaw:0 initZoom:6];
    cp.camera.zNear = 0.1f;
    cp.camera.zFar = 100.0f;
    cp.move1Speed = 0.1;
    cp.scaleSpeed = 0.5;
    [scene changeCameraById:cp.camera.Id];
    
//    CCVDeviceCamera* cp = [[CCVDeviceCamera alloc] initWithContext:context parent:scene.root cameraId:@"c"];
//    cp.camera.zNear = 0.1f;
//    cp.camera.zFar = 100.0f;
//    [scene changeCameraById:cp.camera.Id];
//    [cp start];
    
////    CCVVREditorCameraPrefab* cp = [[CCVVREditorCameraPrefab alloc] initWithContext:context parent:scene.root cameraId:@"c" initPicth:0 initYaw:0 initZoom:3];
//    CCVVRDeviceCamera* cp = [[CCVVRDeviceCamera alloc] initWithContext:context parent:scene.root cameraId:@"c"];
////    id<ICVVRCamera> vrCam = (id<ICVVRCamera>)cp.camera;
////    vrCam.IPD = 0.06f;
//    cp.camera.zNear = 0.1f;
//    cp.camera.zFar = 100.0f;
//    [scene changeCameraById:cp.camera.Id];
//    [cp.root.transform translateX:0.0f Y:0.0f Z:2.0f];
//    [cp start];
    
//    CCVDeviceMotionCamera* cp = [[CCVDeviceMotionCamera alloc] initWithContext:context parent:scene.root cameraId:@"c"];
//    cp.camera.zNear = 0.1f;
//    cp.camera.zFar = 100.0f;
//    [scene changeCameraById:cp.camera.Id];
//    [cp start];
//    
//    id<ICVBehaviour> b = [CCVBehaviour behaviourWithContext:context];
//    b.onDoubleTap = (^(UITapGestureRecognizer* doubleTap) {
//        [cp calibrate];
//    });
//    [scene.root addComponent:b];
    
    id<ICVBehaviour> b = [CCVBehaviour behaviourWithContext:context];
    b.onDoubleTap = (^(UITapGestureRecognizer* doubleTap) {
        CCCRect rect = CCCRectMake(0, 0, 200, 400);
        CCVOnSnapshotListener* listener = [[CCVOnSnapshotListener alloc] init];
        listener.onSnapshot = (^(UIImage* snapshot) {
            UIImageWriteToSavedPhotosAlbum(snapshot, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            //img_image.image = snapshot;
        });
        [self.engine.renderTimer snapshotByRect:rect async:YES listener:listener];
    });
    [scene.root addComponent:b];
    
    //id<ICVFile> file = [CCVFile fileWithType:CCVFileTypeBundle path:@"b/b.dae"];
    //id<ICVFile> file = [CCVFile fileWithType:CCVFileTypeBundle path:[CCVAssetsBundle nameForPath:@"scenes/yuanzhuo_jian.DAE"]];
//    id<ICVFile> file = [CCVFile fileWithType:CCVFileTypeBundle path:[CCVAssetsBundle nameForPath:@"yangbanjian/scenes/yangbanjian_01.DAE"]];
    //id<ICVFile> file = [CCVFile fileWithType:CCVFileTypeBundle path:[CCVAssetsBundle nameForPath:@"mesh/ball_pool.DAE"]];
//    id<ICVFile> file = [CCVFile fileWithType:CCVFileTypeBundle path:[CCVAssetsBundle nameForPath:@"test_color/mesh/first_bedroom_frame.dae"]];
    //id<ICVFile> file = [CCVFile fileWithType:CCVFileTypeBundle path:[CCVAssetsBundle nameForPath:@"test_ar/mesh/cheer004.dae"]];
    
    //id<ICVFile> file = [CCVFile fileWithType:CCVFileTypeBundle path:[CCVAssetsBundle nameForPath:@"test_home/mesh/sofa.dae"]];
    //id<ICVFile> file = [CCVFile fileWithType:CCVFileTypeBundle path:[CCVAssetsBundle nameForPath:@"test_home/mesh/knot.dae"]];
    //id<ICVFile> file = [CCVFile fileWithType:CCVFileTypeBundle path:[CCVAssetsBundle nameForPath:@"test_refl/mesh/refrigerator002.dae"]];
    
    //id<ICVFile> file = [CCVFile fileWithType:CCVFileTypeBundle path:[CCVAssetsBundle nameForPath:@"test_color/mesh/testball.dae"]];
    
//    id<ICVFile> file = [CCVFile fileWithType:CCVFileTypeBundle path:[CCVAssetsBundle nameForPath:@"test_exr/mesh/testball.dax"]];
//    id<ICVFile> file = [CCVFile fileWithType:CCVFileTypeBundle path:[CCVAssetsBundle nameForPath:@"test_export/mesh/bear_tree.dae"]];
//    id<ICVFile> file = [CCVFile fileWithType:CCVFileTypeBundle path:[CCVAssetsBundle nameForPath:@"jiajuzhanting/scenes/zhengtihuxing.dae"]];
    //id<ICVFile> file = [CCVFile fileWithType:CCVFileTypeBundle path:[CCVAssetsBundle nameForPath:@"shijie2/scenes/ojyangban.DAE"]];
    
//    id<ICVFile> file = [CCVFile fileWithType:CCVFileTypeBundle path:[CCVAssetsBundle nameForPath:@"test_anim/mesh/door002.dae"]];
//    id<ICVFile> file = [CCVFile fileWithType:CCVFileTypeBundle path:[CCVAssetsBundle nameForPath:@"test_anim/mesh/door002t.dae"]];

    //id<ICVFile> file = [CCVFile fileWithType:CCVFileTypeBundle path:[CCVAssetsBundle nameForPath:@"test_anim/mesh/door002_aroundX.dae"]];
//    id<ICVFile> file = [CCVFile fileWithType:CCVFileTypeBundle path:[CCVAssetsBundle nameForPath:@"test_anim/mesh/door002_translatexandz.dae"]];
//     id<ICVFile> file = [CCVFile fileWithType:CCVFileTypeBundle path:[CCVAssetsBundle nameForPath:@"test_anim/mesh/door002_translatex_rotatey.dae"]];
    
//    id<ICVFile> file = [CCVFile fileWithType:CCVFileTypeBundle path:[CCVAssetsBundle nameForPath:@"test_model/mesh/bar001.dae"]];
//      id<ICVFile> file = [CCVFile fileWithType:CCVFileTypeBundle path:[CCVAssetsBundle nameForPath:@"test_model/mesh/curtain003.dae"]];
    id<ICVFile> file = [CCVFile fileWithType:CCVFileTypeBundle path:[CCVAssetsBundle nameForPath:@"test_anim/mesh/door_anim.dax"]];
    
//    id<ICVFile> file = [CCVFile fileWithType:CCVFileTypeBundle path:[CCVAssetsBundle nameForPath:@"shijie/scenes/sf_safa_03_jian1.DAE"]];
    //id<ICVFile> file = nil;
    
    id<ICVFile> decalsFile = [CCVFile fileWithBundle:nil path:[CCVAssetsBundle nameForPath:@"texture/512item_rect_frame.png"]];
//    CCVRectFrameDecals* decals = [[CCVRectFrameDecals alloc] initWithContext:context parent:scene.root InnerWidth:8 innerHeight:8 thickness:0.4 uvThickness:0.346 decalsFile:decalsFile];
//    [decals.decalsObject.transform translateX:0.0f Y:0.01f Z:0.0f];
    CCVRect4CornersDecals* decals = [[CCVRect4CornersDecals alloc] initWithContext:context parent:scene.root innerWidth:1.0f innerHeight:1.0f cornerOffsetX:0.15f cornerOffsetY:0.15f thickness:0.1f cornerOffsetU:0.0f cornerOffsetV:0.0f uvThickness:0.346f decalsFile:decalsFile];
//    id<ICVGameObject> parent = scene.root;
    
    //[decals updateInnerWidth:6 innerHeight:6];
    
//    id<ICVVideoTexture> videoTexture = (id<ICVVideoTexture>)[context.videoTextureManager createFromFile:[CCVFile fileWithName:@"v" content:nil]];
//    id<ICVMaterial> videoMaterial = (id<ICVMaterial>)[context.materialManager createFromFile:[CCVFile fileWithName:@"vm" content:nil]];
//    videoMaterial.videoTexture = videoTexture;
//    videoMaterial.depthCheck = NO;
//    [videoMaterial load];
//    id<ICVMesh> videoMesh = (id<ICVMesh>)[context.meshManager createFromFile:[CCVFile fileWithName:@"vm" content:nil]];
//    [videoMesh spriteRect:CCCRectFMake(0, 0, 1, 1)];
//    [videoMesh load];
//    id<ICVMeshRenderer> videoMeshRenderer = [context createMeshRenderer];
//    videoMeshRenderer.mesh = videoMesh;
//    videoMeshRenderer.material  = videoMaterial;
//    id<ICVGameObject> videoObject = [context createObject];
//    videoObject.Id = @"video";
//    [videoObject addComponent:videoMeshRenderer];
//    videoObject.parent = scene.root;
//    videoMeshRenderer.renderOrder = CCVRenderOrderBackgroundDefault;
    //[videoObject.transform yawDegrees:180];
    
//    CGRect bounds = [[UIScreen mainScreen] boundsInPixels];
//    [CCVPrefabUtils createVideoBackgroundWithContext:context parent:scene.root rect:CCCRectFMake(0, 0, bounds.size.width, bounds.size.height)];
    
    id<ICVSceneLoader> loader = [context.sceneLoaderManager getLoaderForFile:file];
    CCVSceneLoaderOnLoadingListener* listener = [[CCVSceneLoaderOnLoadingListener alloc] init];
    
    __block NSUInteger textureCount = 0;
    __block NSUInteger textureTotalBytes = 0;
    listener.onResourceLoaded = (^(id<ICVResource> resource) {
        if ([resource conformsToProtocol:@protocol(ICVTexture)]) {
            id<ICVTexture> texture = (id<ICVTexture>)resource;
            textureCount++;
            NSUInteger textureBytes = texture.sizeInMemory;
            textureTotalBytes += textureBytes;
            NSLog(@"第%@个纹理(%@) 内存: %@ MB, 当前总内存: %@ MB", @(textureCount), texture.file, @(CCCGetMegabytes(textureBytes)), @(CCCGetMegabytes(textureTotalBytes)));
        }
    });
    __block NSUInteger startTime = [CCVTimer currentMilliseconds];
    listener.onObjectLoaded = (^(id<ICVGameObject> object) {
//        if ([object.name startsWith:@"sd_"]) {
//            id<ICVRenderable> r = [object renderable];
//            id<ICVMaterial> m = [r material];
////            [m setDepthWrite:NO];
// //           m.transparent = NO;
//   //         [m clearBlending];
//            //[m setBlendingSrcFactor:CCCBlendFactorSrcColor andDstFactor:CCCBlendFactorOneMinusSrcAlpha];
//        }
        object.debugRenderable.visible = YES;
    });
    listener.onFinish = (^(id<ICVFile> file, id<ICVGameObject> parent, id<ICVGameObject> object){

        [object.transform translateX:0 Y:0.1 Z:0];
        [object updateBounds:YES];
        CCCBounds3 bounds = object.scaleBounds;
        CCCVector3 size = CCCBounds3GetSize(&bounds);
        NSLog(@"模型大小：(%.2f, %.2f, %.2f)", size.x, size.y, size.z);
        float cpx = CCCLerpf(bounds.min.x, bounds.max.x, 0.5f);
        //float cpy = CCCLerpf(bounds.min.y, bounds.max.y, 0.5f);
        float cpy = 0.0f;
        float cpz = CCCLerpf(bounds.min.z, bounds.max.z, 0.5f);
        //[cp.root.transform setPositionX:cpx Y:cpy Z:cpz];
        
        id<ICVViewTag> vt = [context createViewTag];
        vt.view = tv_name;
        [object addComponent:vt];
        [vt notifyViewUpdate];
        
        [decals updateInnerWidth:size.x innerHeight:size.z];
        
        NSLog(@"加载纹理%@个 总占用内存: %@ MB", @(textureCount), @(CCCGetMegabytes(textureTotalBytes)));
        float second = ([CCVTimer currentMilliseconds] - startTime) / 1000.0f;
        NSLog(@"加载完毕，耗时：%@秒", @(second));
        [self performSelector:@selector(showGeometryInfo) withObject:nil afterDelay:2];
        
//        [object objectForId:@"door002_joint_part01" recursive:YES].transform.scale = CCCVector3Make(100, 100, 100);
        id<ICVAnimation> animation = [object animationForId:@"Take 001" recursive:YES];
        //id<ICVAnimation> animation = [object animationForId:@"door002_joint.rotateX_door002_joint" recursive:YES];
        animation.loop = YES;
        [animation play];
//        animation = [object animationForId:@"door002_joint.rotateY_door002_joint" recursive:YES];
//        animation.loop = YES;
//        [animation play];
        NSArray* allAnimations = scene.root.allAnimations;
        allAnimations = nil;
        
//        id<ICVParticleSystem> ps = [context createParticleSystem];
//        [scene.root addComponent:ps];
//        ps.emitter = [CCVPointParticleEmitter emitter];
//        ps.particleInstance = object;
//        ps.quota = 10;
//        ps.minRate = 5;
//        ps.maxRate = 10;
//        ps.spawnDeathTime = 2000;
//        ps.spawnMinVelocity = CCCVector3Make(-1, -1, -1);
//        ps.spawnMaxVelocity = CCCVector3Make(1, 1, 1);
////        id<ICVGameObject> o = [object copyInstanceWithPrefix:@"copy_"];
////        o.parent = scene.root;
////        [o.transform translateX:0 Y:0 Z:1];
//        CCVOnParticleSystemListener* listener = [CCVOnParticleSystemListener listener];
//        listener.onParticleSpawn = (^(id<ICVParticle> particle) {
//            id<ICVAnimation> animation = [particle.host animationForId:@"joint1.rotateY_joint1" recursive:YES];
//            animation.loop = YES;
//            [animation play];
//        });
//        ps.listener = listener;
        
        //[scene.renderQueue dumpTree];
    });
    listener.onFailed = (^(id<ICVFile> file, id<ICVGameObject> parent, NSError* error) {
        NSLog(@"加载失败, 原因：%@", error.description);
    });
    
    [loader loadFile:file parent:scene.root params:nil async:YES listener:listener];
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    NSString* et = error.localizedDescription;
    NSLog(@"%@", et);
}

- (void) showGeometryInfo {
    NSLog(@"面数:%@", @(self.engine.renderTimer.geometryInfo.faceCount));
}

@end

@interface ModelViewer () <CCVOnAnalogStickEventListener> {
    CCVCameraView* cv_camera;
    CCVAnalogStick* as_analog;
}

@end

@implementation ModelViewer

- (void)onPrepare
{
    [self toggleFullscreen];
    [super onPrepare];
}

- (void)onGameConfig
{
    self.engine.pluginSystem.renderPlugin = [[CCVGL20Plugin alloc] init];
    self.engine.pluginSystem.renderPlugin.MSAA = 4;
}

- (void)onGameBuild
{
    self.engine.game = [[GameModelViewer alloc] init];
}

- (UIView *)onCreateView:(UIView *)parent {
    //CCVFrameLayout* container = [CCVFrameLayout layout];
    CCVRelativeLayout* container = [CCVRelativeLayout layout];
    container.layoutParams.width = CCVLayoutMatchParent;
    container.layoutParams.height = CCVLayoutMatchParent;
    
//    cv_camera = [CCVCameraView cameraView];
//    cv_camera.layoutParams.width = CCVLayoutMatchParent;
//    cv_camera.layoutParams.height = CCVLayoutMatchParent;
//    [container addSubview:cv_camera];
    
    UIView* gameView = self.engine.frame.view;
    if (gameView != nil) {
        gameView.layoutParams.width = CCVLayoutMatchParent;
        gameView.layoutParams.height = CCVLayoutMatchParent;
        [container addSubview:gameView];
    }
//    gameView.opaque = NO;
//    gameView.backgroundColor = [UIColor clearColor];
    
//    as_analog = [CCVAnalogStick analogStick];
//    as_analog.layoutParams.alignment = CCVLayoutAlignParentBottomRight;
//    as_analog.backgroundView.image = [UIImage imageByResourceDrawable:@"as_bg.png"];
//    as_analog.stickView.image = [UIImage imageByResourceDrawable:@"as_fg.png"];
//    as_analog.listener = self;
//    [container addSubview:as_analog];

    return container;
}

- (void)analogStick:(CCVAnalogStick *)analogStick didOffset:(CGPoint)offset {
    NSLog(@"as(%.2f, %.2f)", offset.x, offset.y);
}

- (void)analogStickDidReset:(CCVAnalogStick *)analogStick {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[cv_camera startCamera];
    //[self.engine.context.cameraCapturer startCapture];
    //[self.engine.context.cameraCapturer start];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[cv_camera stopCamera];
    //[self.engine.context.cameraCapturer stopCapture];
    //[self.engine.context.cameraCapturer stop];
}

@end
