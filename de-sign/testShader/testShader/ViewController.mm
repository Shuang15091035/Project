//
//  ViewController.m
//  testShader
//
//  Created by mac zdszkj on 16/2/24.
//  Copyright © 2016年 mac zdszkj. All rights reserved.
//

#import "ViewController.h"
#import <ctrlcv/ctrlcv_opengl.h>
#import <ctrlcv/CCVEffect.h>

@interface GameV : CCVGame

@end

@implementation GameV

- (void)onContentCreate {
    //设置引擎
    id<ICVGameContext> context = self.engine.context;
    id<ICVGameWorld> world = self.world;
    
    id<ICVGameScene> scene = [context createScene];
    [world addScene:scene];
    [world changeSceneById:scene.Id];
    // 场景背景色
    scene.clearColor = CCCColorMake(0.0f, 0.8f, 0.8f, 1.0f);//CCCColorMake(0.43f, 0.52f, 0.41f, 1.0f);
    
    self.engine.frame.renderMode = CCVGameFrameRenderModeWhenDirty;
    
#pragma mark shader设置
    id<ICVGameObject> testObj = [context createObject]; // 创建目标对象
    testObj.parent = scene.root; // 将对象挂到当前场景根节点上
    // 读取贴图文件 (纹理)
    id<ICVFile> texFile = [CCVFile fileWithBundle:nil path:@"233.jpg"];
    id<ICVTexture> texture = (id<ICVTexture>)[[context textureManager] createFromFile:texFile];
    [texture load]; // 载入贴图
    // 读取材质
    id<ICVMaterial> mat = (id<ICVMaterial>)[[context materialManager] createFromFile:[CCVFile fileWithName:@"mat" content:nil]]; // 暂时没指定材质 定义一个name即可
//    [mat setOutlineColor:CCCColorMake(0.32156, 0.013, 0.013, 1)];
    [mat setOutlineColor:CCCColorRed()];
    [mat setOutlineWidth:1.0f];
    [mat setDiffuseTexture:texture]; // 设置材质的贴图
    [mat load]; // 载入材质
    // 读取
    id<ICVFile> vertFile = [CCVFile fileWithBundle:nil path:@"test.vert"];
    id<ICVFile> fragFile = [CCVFile fileWithBundle:nil path:@"test.frag"];
    id<ICVFile> effFile = [CCVFile fileWithFiles:@[vertFile, fragFile]]; // 读取2个文件 可以用数组包含
    // 读取shader
    id<ICVEffect> eff = (id<ICVEffect>)[[context effectManager] createFromFile:effFile]; // 创建
    [eff load]; // 载入shader
    // 创建mesh
    id<ICVMesh> mesh = (id<ICVMesh>)[[context meshManager] createFromFile:[CCVFile fileWithName:@"mesh" content:nil]];
    [mesh makeWithNumVertices:4 numIndices:6]; // 1个4边型 由 2个3角组成 so 有4个顶点  6个索引
    [mesh beginOperation:CCCRenderOperationTriangles update:NO]; // begin
    [mesh positionX:-1 y:1 z:0]; // 第一个顶点 右手左边 为了可见 逆时针
    [mesh texCoordU:0 v:0]; // 顶点设置完设置UV  左上 0,0  右下 1,1
    /*
     0,0    1,0
     0,1    1,1
     */
    [mesh positionX:-1 y:-1 z:0];
    [mesh texCoordU:0 v:1];
    [mesh positionX:1 y:-1 z:0];
    [mesh texCoordU:1 v:1];
    [mesh positionX:1 y:1 z:0];
    [mesh texCoordU:1 v:0];
    [mesh quadWithP1:0 P2:1 P3:2 P4:3];
    [mesh end]; // end
    [mesh load]; // 载入mesh
    // 创建renderable 渲染
    id<ICVMeshRenderer> mf = [context createMeshRenderer];
    mf.mesh = mesh; // 设置渲染mesh
    mf.material = mat; // 设置渲染材质
    mf.effect = eff; // 设置渲染shader 效果
    mf.autoEffect = NO; // 关闭自动效果
    [testObj addComponent:mf]; // 将渲染 加入到 目标对象上
    
    // 设置相机
    id<ICVGameObject> cameraObj = [context createObject]; // 创建相机对象
    cameraObj.parent = scene.root; // 挂到场景根节点
    id<ICVCamera> camera = [context createCamera]; // 创建相机
    // 基础属性设置
    camera.zNear = 0.1; // 最小距离
    camera.zFar = 100; // 最远距离
    [cameraObj addComponent:camera]; // 把相机添加到相机对象上
    [cameraObj.transform translateX:0 Y:0 Z:5]; // 设置对象距离
    [scene changeCameraById:camera.Id]; // 设置当前使用的相机
}

@end

@interface ViewController () {
    
}

@end

@implementation ViewController

- (void)onPrepare {
    [self toggleFullscreen];
    [super onPrepare];
}

- (void)onGameConfig {
    self.engine.pluginSystem.renderPlugin = [[CCVGL20Plugin alloc] init];
    self.engine.pluginSystem.renderPlugin.MSAA = 4;
}

- (void)onGameBuild {
    self.engine.game = [[GameV alloc] init];
}

@end
