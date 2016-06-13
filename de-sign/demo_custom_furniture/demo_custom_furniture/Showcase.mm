//
//  Showcase.m
//  demo_custom_furniture
//
//  Created by ddeyes on 16/5/27.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "Showcase.h"

#pragma mark GameShowcase
@interface GameShowcase : JWGame <UITextFieldDelegate> {
    
    NSMutableArray<id<JIGameObject>>* mObjectParts;
    id<JIGameObject> mCurrentObject;
    NSUInteger mCurrentObjectIndex;
    id<JIGameObject> mStretchPivotObject;
    
    JWRelativeLayout* mView;
    UISlider* sl_rotate_y;
    UISlider* sl_scale_x;
    UISlider* sl_scale_y;
    UISlider* sl_scale_z;
    UIButton* btn_stretch_object_switch;
    UISlider* sl_stretch_pivot_x;
    UISlider* sl_stretch_pivot_y;
    UISlider* sl_stretch_pivot_z;
    UITextField* et_stretch_x;
    UITextField* et_stretch_y;
    UITextField* et_stretch_z;
    UISlider* sl_stretch_x;
    UISlider* sl_stretch_y;
    UISlider* sl_stretch_z;
    UISlider* sl_tilling_x;
    UISlider* sl_tilling_y;
}

@end

@implementation GameShowcase

- (void)onContentCreate {
    
    id<JIGameContext> context = self.engine.context;
    [context.sceneLoaderManager registerLoader:[[JWDaeLoader alloc] init] overrideExist:NO];
    
    id<JIGameWorld> world = self.world;
    
    id<JIGameScene> scene = [context createScene];
    [world addScene:scene];
    [world changeSceneById:scene.Id];
    
    scene.clearColor = JCColorGray();
    self.engine.frame.renderMode = JWGameFrameRenderModeWhenDirty;
    
#pragma mark 地表网格
    [JWPrefabUtils createGridsWithContext:context parent:scene.root startRow:-25 startColumn:-25 numRows:50 numColumns:50 gridWidth:1.0f gridHeight:1.0f color:JCColorWhite()];
    
#pragma mark 观看用摄像机
    JWEditorCameraPrefab* cp = [[JWEditorCameraPrefab alloc] initWithContext:context parent:scene.root cameraId:@"c" initPicth:-45 initYaw:45 initZoom:8];
    cp.camera.zNear = 0.1f;
    cp.camera.zFar = 100.0f;
    cp.move1Speed = 0.1;
    cp.scaleSpeed = 0.5;
    [scene changeCameraById:cp.camera.Id];
    
#pragma mark 测试用模型
    id<JIFile> file = [JWFile fileWithType:JWFileTypeBundle path:[JWAssetsBundle nameForPath:@"test_stretch/mesh/teatable004.dae"]];
    id<JISceneLoader> loader = [context.sceneLoaderManager getLoaderForFile:file];
    JWSceneLoaderOnLoadingListener* listener = [[JWSceneLoaderOnLoadingListener alloc] init];
    listener.onObjectLoaded = ^(id<JIGameObject> object) {
        [mObjectParts addObject:object];
    };
    listener.onFinish = ^(id<JIFile> file, id<JIGameObject> parent, id<JIGameObject> object){
        [mObjectParts addObject:object];
        mCurrentObject = object;
        mCurrentObjectIndex = mObjectParts.count - 1;
        
        mStretchPivotObject = [object.context createObject];
        mStretchPivotObject.parent = mCurrentObject;
        mStretchPivotObject.transform.inheritScale = NO;
        mStretchPivotObject.axisLength = 0.5f;
        [mStretchPivotObject setAxesVisible:YES recursive:NO];
        mStretchPivotObject.transform.position = JCVector3Make(sl_stretch_pivot_x.value, sl_stretch_pivot_y.value, sl_stretch_pivot_z.value);
        
        // NOTE 显示的其实是大小
        JCBounds3 bounds = mCurrentObject.scaleBounds;
        JCVector3 size = JCBounds3GetSize(&bounds);
        et_stretch_x.text = [NSString stringWithFormat:@"%.2f", size.x];
        et_stretch_y.text = [NSString stringWithFormat:@"%.2f", size.y];
        et_stretch_z.text = [NSString stringWithFormat:@"%.2f", size.z];
    };
    listener.onFailed = (^(id<JIFile> file, id<JIGameObject> parent, NSError* error) {
        NSLog(@"加载失败, 原因：%@", error.description);
    });
    
    mObjectParts = [NSMutableArray array];
    JWSceneLoadParams* params = [[JWSceneLoadParams alloc] init];
//    params.independent = NO;
//    params.compressUV = YES;
//    params.compressTBN = YES;
//    params.compressVertexColor = YES;
    [loader loadFile:file parent:scene.root params:params async:YES listener:listener];
}

- (UIView *)onUiCreate:(UIView *)parent {
    mView = [JWRelativeLayout layout];
    mView.layoutParams.width = JWLayoutMatchParent;
    mView.layoutParams.height = JWLayoutMatchParent;
    
    UIView* gameView = self.engine.frame.view;
    gameView.layoutParams.width = JWLayoutMatchParent;
    gameView.layoutParams.height = JWLayoutMatchParent;
    [mView addSubview:gameView];
    
#pragma mark 拉伸点切换按钮
    btn_stretch_object_switch = [[UIButton alloc] init];
    btn_stretch_object_switch.layoutParams.width = JWLayoutWrapContent;
    btn_stretch_object_switch.layoutParams.height = 30;
    btn_stretch_object_switch.layoutParams.alignment = JWLayoutAlignParentTopRight;
    btn_stretch_object_switch.text = @"切换";
    btn_stretch_object_switch.textColor = [UIColor blueColor];
    [mView addSubview:btn_stretch_object_switch];
    
    [btn_stretch_object_switch addTarget:self action:@selector(onStretchObjectSwitch:) forControlEvents:UIControlEventTouchUpInside];
    
#pragma mark 操作面板
    JWLinearLayout* lo_pane = [JWLinearLayout layout];
    lo_pane.layoutParams.width = JWLayoutMatchParent;
    lo_pane.layoutParams.height = JWLayoutWrapContent;
    lo_pane.orientation = JWLayoutOrientationVertical;
    lo_pane.layoutParams.alignment = JWLayoutAlignParentBottom;
    [mView addSubview:lo_pane];
    
#pragma mark 旋转界面
    JWLinearLayout* lo_rotate = [JWLinearLayout layout];
    lo_rotate.layoutParams.width = JWLayoutMatchParent;
    lo_rotate.layoutParams.height = 30;
    lo_rotate.orientation = JWLayoutOrientationHorizontal;
    [lo_pane addSubview:lo_rotate];
    
    UILabel* tv_rotate = [[UILabel alloc] init];
    tv_rotate.layoutParams.width = JWLayoutWrapContent;
    tv_rotate.layoutParams.height = JWLayoutMatchParent;
    tv_rotate.text = @"旋转：";
    tv_rotate.textColor = [UIColor yellowColor];
    [lo_rotate addSubview:tv_rotate];

    sl_rotate_y = [[UISlider alloc] init];
    sl_rotate_y.layoutParams.width = JWLayoutMatchParent;
    sl_rotate_y.layoutParams.height = JWLayoutMatchParent;
    sl_rotate_y.layoutParams.weight = 1;
    [lo_rotate addSubview:sl_rotate_y];

    sl_rotate_y.minimumValue = 0.0f;
    sl_rotate_y.maximumValue = 180.0f;
    [sl_rotate_y addTarget:self action:@selector(onRotateChanged:) forControlEvents:UIControlEventValueChanged];
    
#pragma mark 缩放界面
    JWLinearLayout* lo_scale = [JWLinearLayout layout];
    lo_scale.layoutParams.width = JWLayoutMatchParent;
    lo_scale.layoutParams.height = 30;
    lo_scale.orientation = JWLayoutOrientationHorizontal;
    lo_scale.backgroundColor = [UIColor clearColor];
    [lo_pane addSubview:lo_scale];
    
    UILabel* tv_scale = [[UILabel alloc] init];
    tv_scale.layoutParams.width = JWLayoutWrapContent;
    tv_scale.layoutParams.height = JWLayoutMatchParent;
    tv_scale.text = @"缩放：";
    tv_scale.textColor = [UIColor yellowColor];
    [lo_scale addSubview:tv_scale];
    
    sl_scale_x = [[UISlider alloc] init];
    sl_scale_x.layoutParams.width = JWLayoutMatchParent;
    sl_scale_x.layoutParams.height = JWLayoutMatchParent;
    sl_scale_x.layoutParams.weight = 1;
    [lo_scale addSubview:sl_scale_x];
    
    sl_scale_y = [[UISlider alloc] init];
    sl_scale_y.layoutParams.width = JWLayoutMatchParent;
    sl_scale_y.layoutParams.height = JWLayoutMatchParent;
    sl_scale_y.layoutParams.weight = 1;
    [lo_scale addSubview:sl_scale_y];
    
    sl_scale_z = [[UISlider alloc] init];
    sl_scale_z.layoutParams.width = JWLayoutMatchParent;
    sl_scale_z.layoutParams.height = JWLayoutMatchParent;
    sl_scale_z.layoutParams.weight = 1;
    [lo_scale addSubview:sl_scale_z];
    
    sl_scale_x.minimumValue = 1.0f;
    sl_scale_x.maximumValue = 10.0f;
    sl_scale_y.minimumValue = 1.0f;
    sl_scale_y.maximumValue = 10.0f;
    sl_scale_z.minimumValue = 1.0f;
    sl_scale_z.maximumValue = 10.0f;
    [sl_scale_x addTarget:self action:@selector(onScaleChanged:) forControlEvents:UIControlEventValueChanged];
    [sl_scale_y addTarget:self action:@selector(onScaleChanged:) forControlEvents:UIControlEventValueChanged];
    [sl_scale_z addTarget:self action:@selector(onScaleChanged:) forControlEvents:UIControlEventValueChanged];
    
#pragma mark 拉伸点界面
    JWLinearLayout* lo_stretch_pivot = [JWLinearLayout layout];
    lo_stretch_pivot.layoutParams.width = JWLayoutMatchParent;
    lo_stretch_pivot.layoutParams.height = 30;
    lo_stretch_pivot.orientation = JWLayoutOrientationHorizontal;
    lo_stretch_pivot.backgroundColor = [UIColor clearColor];
    [lo_pane addSubview:lo_stretch_pivot];
    
    UILabel* tv_stretch_pivot = [[UILabel alloc] init];
    tv_stretch_pivot.layoutParams.width = JWLayoutWrapContent;
    tv_stretch_pivot.layoutParams.height = JWLayoutMatchParent;
    tv_stretch_pivot.text = @"支点：";
    tv_stretch_pivot.textColor = [UIColor yellowColor];
    [lo_stretch_pivot addSubview:tv_stretch_pivot];
    
    sl_stretch_pivot_x = [[UISlider alloc] init];
    sl_stretch_pivot_x.layoutParams.width = JWLayoutMatchParent;
    sl_stretch_pivot_x.layoutParams.height = JWLayoutMatchParent;
    sl_stretch_pivot_x.layoutParams.weight = 1;
    [lo_stretch_pivot addSubview:sl_stretch_pivot_x];
    
    sl_stretch_pivot_y = [[UISlider alloc] init];
    sl_stretch_pivot_y.layoutParams.width = JWLayoutMatchParent;
    sl_stretch_pivot_y.layoutParams.height = JWLayoutMatchParent;
    sl_stretch_pivot_y.layoutParams.weight = 1;
    [lo_stretch_pivot addSubview:sl_stretch_pivot_y];
    
    sl_stretch_pivot_z = [[UISlider alloc] init];
    sl_stretch_pivot_z.layoutParams.width = JWLayoutMatchParent;
    sl_stretch_pivot_z.layoutParams.height = JWLayoutMatchParent;
    sl_stretch_pivot_z.layoutParams.weight = 1;
    [lo_stretch_pivot addSubview:sl_stretch_pivot_z];
    
    sl_stretch_pivot_x.minimumValue = 0.0f;
    sl_stretch_pivot_x.maximumValue = 1.0f;
    sl_stretch_pivot_y.minimumValue = 0.0f;
    sl_stretch_pivot_y.maximumValue = 1.0f;
    sl_stretch_pivot_z.minimumValue = 0.0f;
    sl_stretch_pivot_z.maximumValue = 1.0f;
    [sl_stretch_pivot_x addTarget:self action:@selector(onStretchChanged:) forControlEvents:UIControlEventValueChanged];
    [sl_stretch_pivot_y addTarget:self action:@selector(onStretchChanged:) forControlEvents:UIControlEventValueChanged];
    [sl_stretch_pivot_z addTarget:self action:@selector(onStretchChanged:) forControlEvents:UIControlEventValueChanged];
    
#pragma mark 拉伸数值界面
    JWLinearLayout* lo_stretch = [JWLinearLayout layout];
    lo_stretch.layoutParams.width = JWLayoutMatchParent;
    lo_stretch.layoutParams.height = 50;
    lo_stretch.orientation = JWLayoutOrientationHorizontal;
    lo_stretch.backgroundColor = [UIColor clearColor];
    [lo_pane addSubview:lo_stretch];
    
    UILabel* tv_stretch = [[UILabel alloc] init];
    tv_stretch.layoutParams.width = JWLayoutWrapContent;
    tv_stretch.layoutParams.height = JWLayoutMatchParent;
    tv_stretch.text = @"大小：";
    tv_stretch.textColor = [UIColor yellowColor];
    [lo_stretch addSubview:tv_stretch];
    
#pragma mark 拉伸x界面
    et_stretch_x = [[UITextField alloc] init];
    et_stretch_x.layoutParams.width = 60;
    et_stretch_x.layoutParams.height = JWLayoutMatchParent;
    et_stretch_x.keyboardType = UIKeyboardTypeNumberPad;
    et_stretch_x.returnKeyType = UIReturnKeyDone;
    et_stretch_x.textColor = [UIColor whiteColor];
    [lo_stretch addSubview:et_stretch_x];
    
    sl_stretch_x = [[UISlider alloc] init];
    sl_stretch_x.layoutParams.width = JWLayoutMatchParent;
    sl_stretch_x.layoutParams.height = JWLayoutMatchParent;
    sl_stretch_x.layoutParams.weight = 1;
    [lo_stretch addSubview:sl_stretch_x];
    
#pragma mark 拉伸y界面
    et_stretch_y = [[UITextField alloc] init];
    et_stretch_y.layoutParams.width = 60;
    et_stretch_y.layoutParams.height = JWLayoutMatchParent;
    et_stretch_y.keyboardType = UIKeyboardTypeNumberPad;
    et_stretch_y.returnKeyType = UIReturnKeyDone;
    et_stretch_y.textColor = [UIColor whiteColor];
    [lo_stretch addSubview:et_stretch_y];
    
    sl_stretch_y = [[UISlider alloc] init];
    sl_stretch_y.layoutParams.width = JWLayoutMatchParent;
    sl_stretch_y.layoutParams.height = JWLayoutMatchParent;
    sl_stretch_y.layoutParams.weight = 1;
    [lo_stretch addSubview:sl_stretch_y];
    
#pragma mark 拉伸z界面
    et_stretch_z = [[UITextField alloc] init];
    et_stretch_z.layoutParams.width = 60;
    et_stretch_z.layoutParams.height = JWLayoutMatchParent;
    et_stretch_z.keyboardType = UIKeyboardTypeNumberPad;
    et_stretch_z.returnKeyType = UIReturnKeyDone;
    et_stretch_z.textColor = [UIColor whiteColor];
    [lo_stretch addSubview:et_stretch_z];
    
    sl_stretch_z = [[UISlider alloc] init];
    sl_stretch_z.layoutParams.width = JWLayoutMatchParent;
    sl_stretch_z.layoutParams.height = JWLayoutMatchParent;
    sl_stretch_z.layoutParams.weight = 1;
    [lo_stretch addSubview:sl_stretch_z];
    
    sl_stretch_x.minimumValue = 0.0f;
    sl_stretch_x.maximumValue = 2.0f;
    sl_stretch_y.minimumValue = 0.0f;
    sl_stretch_y.maximumValue = 2.0f;
    sl_stretch_z.minimumValue = 0.0f;
    sl_stretch_z.maximumValue = 2.0f;
    [sl_stretch_x addTarget:self action:@selector(onStretchChanged:) forControlEvents:UIControlEventValueChanged];
    [sl_stretch_y addTarget:self action:@selector(onStretchChanged:) forControlEvents:UIControlEventValueChanged];
    [sl_stretch_z addTarget:self action:@selector(onStretchChanged:) forControlEvents:UIControlEventValueChanged];
    et_stretch_x.text = [NSString stringWithFormat:@"%.2f", sl_stretch_x.minimumValue];
    et_stretch_x.delegate = self;
    et_stretch_y.text = [NSString stringWithFormat:@"%.2f", sl_stretch_y.minimumValue];
    et_stretch_y.delegate = self;
    et_stretch_z.text = [NSString stringWithFormat:@"%.2f", sl_stretch_z.minimumValue];
    et_stretch_z.delegate = self;
    
#pragma mark 纹理平铺调整
    JWLinearLayout* lo_tilling = [JWLinearLayout layout];
    lo_tilling.layoutParams.width = JWLayoutMatchParent;
    lo_tilling.layoutParams.height = 30;
    lo_tilling.orientation = JWLayoutOrientationHorizontal;
    lo_tilling.backgroundColor = [UIColor clearColor];
    [lo_pane addSubview:lo_tilling];
    
    UILabel* tv_tilling = [[UILabel alloc] init];
    tv_tilling.layoutParams.width = JWLayoutWrapContent;
    tv_tilling.layoutParams.height = JWLayoutMatchParent;
    tv_tilling.text = @"平铺：";
    tv_tilling.textColor = [UIColor yellowColor];
    [lo_tilling addSubview:tv_tilling];
    
    sl_tilling_x = [[UISlider alloc] init];
    sl_tilling_x.layoutParams.width = JWLayoutMatchParent;
    sl_tilling_x.layoutParams.height = JWLayoutMatchParent;
    sl_tilling_x.layoutParams.weight = 1;
    [lo_tilling addSubview:sl_tilling_x];
    
    sl_tilling_y = [[UISlider alloc] init];
    sl_tilling_y.layoutParams.width = JWLayoutMatchParent;
    sl_tilling_y.layoutParams.height = JWLayoutMatchParent;
    sl_tilling_y.layoutParams.weight = 1;
    [lo_tilling addSubview:sl_tilling_y];
    
    sl_tilling_x.minimumValue = 1.0f;
    sl_tilling_x.maximumValue = 20.0f;
    sl_tilling_y.minimumValue = 1.0f;
    sl_tilling_y.maximumValue = 20.0f;
    [sl_tilling_x addTarget:self action:@selector(onTillingChanged:) forControlEvents:UIControlEventValueChanged];
    [sl_tilling_y addTarget:self action:@selector(onTillingChanged:) forControlEvents:UIControlEventValueChanged];
    
    return mView;
}

#pragma mark 改变旋转
- (void) onRotateChanged:(UISlider*)slider {
    [mCurrentObject.transform resetOrientation:NO];
    [mCurrentObject.transform yawDegrees:sl_rotate_y.value];
}

#pragma mark 改变缩放
- (void) onScaleChanged:(UISlider*)slider {
    JCVector3 scale = JCVector3Make(sl_scale_x.value, sl_scale_y.value, sl_scale_z.value);
    mCurrentObject.transform.scale = scale;
}

#pragma mark 切换拉伸物件
- (void) onStretchObjectSwitch:(UIButton*)button {
    if (mCurrentObjectIndex + 1 > mObjectParts.count - 1) {
        mCurrentObjectIndex = 0;
    } else {
        mCurrentObjectIndex++;
    }
    mCurrentObject = mObjectParts[mCurrentObjectIndex];
    btn_stretch_object_switch.text = mCurrentObject.Id;
    JCStretch stretch = mCurrentObject.stretch;
    sl_stretch_pivot_x.value = stretch.pivot.x;
    sl_stretch_pivot_y.value = stretch.pivot.y;
    sl_stretch_pivot_z.value = stretch.pivot.z;
    sl_stretch_x.value = stretch.offset.x;
    sl_stretch_y.value = stretch.offset.y;
    sl_stretch_z.value = stretch.offset.z;
    mStretchPivotObject.parent = mCurrentObject;
    mStretchPivotObject.transform.position = stretch.pivot;
}

#pragma mark 改变拉伸
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == et_stretch_x) {
        et_stretch_x.layoutParams.enabled = NO;
        et_stretch_x.frameOrigin = [mView convertPoint:CGPointMake(0, 0) toView:et_stretch_x.superview];
    } else if (textField == et_stretch_y) {
        et_stretch_y.layoutParams.enabled = NO;
        et_stretch_y.frameOrigin = [mView convertPoint:CGPointMake(0, 0) toView:et_stretch_x.superview];
    } else if (textField == et_stretch_z) {
        et_stretch_z.layoutParams.enabled = NO;
        et_stretch_z.frameOrigin = [mView convertPoint:CGPointMake(0, 0) toView:et_stretch_x.superview];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    JCBounds3 bounds = mCurrentObject.scaleBounds;
    JCVector3 size = JCBounds3GetSize(&bounds);
    float stretch = 0.0f;
    UISlider* sl_stretch = nil;
    if (textField == et_stretch_x) {
        stretch = et_stretch_x.text.floatValue - size.x;
        sl_stretch = sl_stretch_x;
    } else if (textField == et_stretch_y) {
        stretch = et_stretch_y.text.floatValue - size.y;
        sl_stretch = sl_stretch_y;
    } else if (textField == et_stretch_z) {
        stretch = et_stretch_z.text.floatValue - size.z;
        sl_stretch = sl_stretch_z;
    }
    
    if (stretch < sl_stretch.minimumValue || stretch > sl_stretch.maximumValue) {
        [textField resignFirstResponder];
        textField.layoutParams.enabled = YES;
        return YES;
    }
    sl_stretch.value = stretch;
    [self updateStretch];
    [textField resignFirstResponder];
    textField.layoutParams.enabled = YES;
    return YES;
}

- (void) onStretchChanged:(UISlider*)slider {
    [self updateStretch];
    JCBounds3 bounds = mCurrentObject.scaleBounds;
    JCVector3 size = JCBounds3GetSize(&bounds);
    et_stretch_x.text = [NSString stringWithFormat:@"%.2f", size.x + sl_stretch_x.value];
    et_stretch_y.text = [NSString stringWithFormat:@"%.2f", size.y + sl_stretch_y.value];
    et_stretch_z.text = [NSString stringWithFormat:@"%.2f", size.z + sl_stretch_z.value];
}

- (void) updateStretch {
    JCVector3 stretchPivot = JCVector3Make(sl_stretch_pivot_x.value, sl_stretch_pivot_y.value, sl_stretch_pivot_z.value);
    JCVector3 stretch = JCVector3Make(sl_stretch_x.value, sl_stretch_y.value, sl_stretch_z.value);
    mCurrentObject.stretch = JCStretchMake(stretchPivot, stretch);
    mStretchPivotObject.transform.position = stretchPivot;
    mStretchPivotObject.stretch = JCStretchZero();
}

#pragma mark 改变纹理平铺
- (void) onTillingChanged:(UISlider*)slider {
    [mCurrentObject enumRenderableUsing:^(id<JIRenderable> renderable, NSUInteger idx, BOOL *stop) {
        if ([renderable.host.name startsWith:@"sd_"]) {
            return;
        }
        id<JIMaterial> material = renderable.material;
        if (material == nil) {
            return;
        }
        id<JITexture> diffuse = material.diffuseTexture;
        if (diffuse == nil) {
            return;
        }
        diffuse.tilingOffset = JCTilingOffsetMake(sl_tilling_x.value, sl_tilling_y.value, 0.0f, 0.0f);
    }];
}

@end

#pragma mark Showcase
@interface Showcase ()

@end

@implementation Showcase

- (void)onPrepare {
    [self toggleFullscreen];
    [super onPrepare];
}

- (void)onGameConfig {
    
#pragma mark 简单内存池设置
    JCBufferSetDefaultAllocator(JCMakeBuddyAllocator(16 * JCMegabytes, 256));
    
#if JW_OPENGL_VERSION == 2
    self.engine.pluginSystem.renderPlugin = [[JWGL20Plugin alloc] init];
    self.engine.pluginSystem.renderPlugin.MSAA = 4;
#elif JW_OPENGL_VERSION == 3
    self.engine.pluginSystem.renderPlugin = [[JWGL30Plugin alloc] init];
    self.engine.pluginSystem.renderPlugin.MSAA = 4;
#endif
    
}

- (void)onGameBuild {
    self.engine.game = [[GameShowcase alloc] init];
}

//- (UIView *)onCreateView:(UIView *)parent {
//    JWRelativeLayout* container = [JWRelativeLayout layout];
//    container.layoutParams.width = JWLayoutMatchParent;
//    container.layoutParams.height = JWLayoutMatchParent;
//    
//    UIView* gameView = self.engine.frame.view;
//    if (gameView != nil) {
//        gameView.layoutParams.width = JWLayoutMatchParent;
//        gameView.layoutParams.height = JWLayoutMatchParent;
//        [container addSubview:gameView];
//    }
//    
//    return container;
//}

@end
