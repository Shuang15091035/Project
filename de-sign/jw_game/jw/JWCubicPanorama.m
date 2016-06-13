//
//  JWCubicPanorama.m
//  June Winter_game
//
//  Created by ddeyes on 15/8/2.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWCubicPanorama.h"

#import <jw/JWGameEngine.h>
#import <jw/JWGameContext.h>
#import <jw/JWGameScene.h>
#import <jw/JWGameObject.h>
#import <jw/JWGameFrame.h>
#import <jw/JWComponent.h>
#import <jw/JWMeshRenderer.h>
#import <jw/JWMaterial.h>
#import <jw/JWTexture.h>
#import <jw/JWCamera.h>
#import <jw/JWBehaviour.h>
#import <jw/JWMaterial.h>
#import <jw/JWMaterialManager.h>
#import <jw/JWMesh.h>
#import <jw/JWMeshManager.h>
#import <jw/UITouch+JWAppCategory.h>
#import <jw/UIScreen+JWCoreCategory.h>

@interface JWCubicPanoramaCameraBehaviour : JWBehaviour {
    JWCubicPanorama* mPanorama;
}

- (id) initWithContext:(id<JIGameContext>)context panorama:(JWCubicPanorama*)panorama;

@end

@interface JWCubicPanorama () {
    id<JIGameObject> mRoot;
    id<JICamera> mCamera;
    id<JIGameObject> mPanorama;
    id<JIMesh> mPanoramaMeshes[JWCubicPanoramaFaceNums];
    id<JIMaterial> mPanoramaMaterials[JWCubicPanoramaFaceNums];
    
    JCFloat mEdgeLength;
    JCFloat mMove1SpeedX;
    JCFloat mMove1SpeedY;
    JCFloat mScaleSpeed;
}

@end

@implementation JWCubicPanorama

+ (id)panoramaWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent cameraId:(NSString *)cameraId panoramaId:(NSString *)panoramaId {
    return [[self alloc] initWithContext:context parent:parent cameraId:cameraId panoramaId:panoramaId];
}

- (id)initWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent cameraId:(NSString *)cameraId panoramaId:(NSString *)panoramaId {
    self = [super init];
    if (self != nil) {
        mRoot = [context createObject];
        mRoot.parent = parent;
        
        id<JIGameObject> cameraRoot = [context createObject];
        cameraRoot.parent = mRoot;
        id<JIGameObject> cameraObject = [context createObject];
        cameraObject.Id = cameraId;
        cameraObject.name = cameraId;
        cameraObject.parent = cameraRoot;
        mCamera = [context createCamera];
        mCamera.Id = cameraId;
        mCamera.name = cameraId;
        [cameraObject addComponent:mCamera];
        id<JIBehaviour> cameraBehaviour = [[JWCubicPanoramaCameraBehaviour alloc] initWithContext:context panorama:self];
        [cameraObject addComponent:cameraBehaviour];
        
        mPanorama = [context createObject];
        mPanorama.Id = panoramaId;
        mPanorama.name = panoramaId;
        mPanorama.parent = mRoot;
        id<JIComponentSet> panoramaSet = [context createComponentSet];
        for (NSUInteger i = 0; i < JWCubicPanoramaFaceNums; i++) {
            NSString* panoramaFileName = [NSString stringWithFormat:@"%@%@", panoramaId, @(i)];
            id<JIFile> panoramaFile = [JWFile fileWithName:panoramaFileName content:nil];
            id<JIMaterial> panoramaMaterial = (id<JIMaterial>)[context.materialManager createFromFile:panoramaFile];
            id<JIMesh> panoramaMesh = (id<JIMesh>)[context.meshManager createFromFile:panoramaFile];
            
            mEdgeLength = 1.0f;
            [self makeFace:i mesh:panoramaMesh update:NO];
            [panoramaMesh load];
            
            id<JIMeshRenderer> panoramaRenderer = [context createMeshRenderer];
            panoramaRenderer.material = panoramaMaterial;
            panoramaRenderer.mesh = panoramaMesh;
            [panoramaSet addComponent:panoramaRenderer];
            
            mPanoramaMeshes[i] = panoramaMesh;
            mPanoramaMaterials[i] = panoramaMaterial;
        }
        [mPanorama addComponent:panoramaSet];
        
        mMove1SpeedX = 1.0f;
        mMove1SpeedY = 1.0f;
        mScaleSpeed = 1.0f;
    }
    return self;
}

- (void) makeFace:(JWCubicPanoramaFace)face mesh:(id<JIMesh>)panoramaMesh update:(BOOL)update {
    JCFloat minX = -mEdgeLength * 0.5f;
    JCFloat minY = minX;
    JCFloat minZ = minX;
    JCFloat maxX = -minX;
    JCFloat maxY = maxX;
    JCFloat maxZ = maxX;
    JCVector3 v0 = JCVector3Make(minX, maxY, maxZ);
    JCVector3 v1 = JCVector3Make(minX, minY, maxZ);
    JCVector3 v2 = JCVector3Make(maxX, minY, maxZ);
    JCVector3 v3 = JCVector3Make(maxX, maxY, maxZ);
    JCVector3 v4 = JCVector3Make(minX, maxY, minZ);
    JCVector3 v5 = JCVector3Make(minX, minY, minZ);
    JCVector3 v6 = JCVector3Make(maxX, minY, minZ);
    JCVector3 v7 = JCVector3Make(maxX, maxY, minZ);
    if (!update) {
        [panoramaMesh makeWithNumVertices:4 numIndices:6];
    }
    [panoramaMesh beginOperation:JCRenderOperationTriangles update:update];
    switch (face) {
        case JWCubicPanoramaFacePosX: {
            [panoramaMesh position:v7];
            [panoramaMesh texCoordU:0.0f v:0.0f];
            [panoramaMesh position:v6];
            [panoramaMesh texCoordU:0.0f v:1.0f];
            [panoramaMesh position:v2];
            [panoramaMesh texCoordU:1.0f v:1.0f];
            [panoramaMesh position:v3];
            [panoramaMesh texCoordU:1.0f v:0.0f];
            break;
        }
        case JWCubicPanoramaFacePosY: {
            [panoramaMesh position:v0];
            [panoramaMesh texCoordU:0.0f v:0.0f];
            [panoramaMesh position:v4];
            [panoramaMesh texCoordU:0.0f v:1.0f];
            [panoramaMesh position:v7];
            [panoramaMesh texCoordU:1.0f v:1.0f];
            [panoramaMesh position:v3];
            [panoramaMesh texCoordU:1.0f v:0.0f];
            break;
        }
        case JWCubicPanoramaFacePosZ: {
            [panoramaMesh position:v3];
            [panoramaMesh texCoordU:0.0f v:0.0f];
            [panoramaMesh position:v2];
            [panoramaMesh texCoordU:0.0f v:1.0f];
            [panoramaMesh position:v1];
            [panoramaMesh texCoordU:1.0f v:1.0f];
            [panoramaMesh position:v0];
            [panoramaMesh texCoordU:1.0f v:0.0f];
            break;
        }
        case JWCubicPanoramaFaceNegX: {
            [panoramaMesh position:v0];
            [panoramaMesh texCoordU:0.0f v:0.0f];
            [panoramaMesh position:v1];
            [panoramaMesh texCoordU:0.0f v:1.0f];
            [panoramaMesh position:v5];
            [panoramaMesh texCoordU:1.0f v:1.0f];
            [panoramaMesh position:v4];
            [panoramaMesh texCoordU:1.0f v:0.0f];
            break;
        }
        case JWCubicPanoramaFaceNegY: {
            [panoramaMesh position:v5];
            [panoramaMesh texCoordU:0.0f v:0.0f];
            [panoramaMesh position:v1];
            [panoramaMesh texCoordU:0.0f v:1.0f];
            [panoramaMesh position:v2];
            [panoramaMesh texCoordU:1.0f v:1.0f];
            [panoramaMesh position:v6];
            [panoramaMesh texCoordU:1.0f v:0.0f];
            break;
        }
        case JWCubicPanoramaFaceNegZ: {
            [panoramaMesh position:v4];
            [panoramaMesh texCoordU:0.0f v:0.0f];
            [panoramaMesh position:v5];
            [panoramaMesh texCoordU:0.0f v:1.0f];
            [panoramaMesh position:v6];
            [panoramaMesh texCoordU:1.0f v:1.0f];
            [panoramaMesh position:v7];
            [panoramaMesh texCoordU:1.0f v:0.0f];
            break;
        }
        default:
            break;
    }
    [panoramaMesh quadWithP1:0 P2:1 P3:2 P4:3];
    [panoramaMesh end];
}

- (id<JIGameObject>)root {
    return mRoot;
}

- (id<JICamera>)camera {
    return mCamera;
}

- (id<JIGameObject>)panorama {
    return mPanorama;
}

- (id<JITexture>)face:(JWCubicPanoramaFace)face {
    return mPanoramaMaterials[face].diffuseTexture;
}

- (void)setFace:(JWCubicPanoramaFace)face withTexture:(id<JITexture>)texture {
    mPanoramaMaterials[face].diffuseTexture = texture;
}

- (JCFloat)edgeLength {
    return mEdgeLength;
}

- (void)setEdgeLength:(JCFloat)edgeLength {
    mEdgeLength = edgeLength;
    for (NSUInteger i = 0; i < JWCubicPanoramaFaceNums; i++) {
        [self makeFace:i mesh:mPanoramaMeshes[i] update:YES];
    }
}

@synthesize move1SpeedX = mMove1SpeedX;
@synthesize move1SpeedY = mMove1SpeedY;

- (void)setMove1Speed:(JCFloat)move1Speed {
    mMove1SpeedX = move1Speed;
    mMove1SpeedY = move1Speed;
}

@synthesize scaleSpeed = mScaleSpeed;

- (void)move1dx:(JCFloat)dx dy:(JCFloat)dy {
    const JCFloat deltaYaw = dx * mMove1SpeedX;
    // TODO constraint
    {
        [mCamera.host.parent.transform yawDegrees:deltaYaw];
    }
    
    const JCFloat deltaPicth = dy * mMove1SpeedY;
    // TODO constraint
    {
        [mCamera.transform picthDegrees:deltaPicth];
    }
}

- (void)scaleS:(JCFloat)s {
    // TODO 完善
//    const JCFloat deltaZoom = s * mScaleSpeed;
    //[mRoot.transform translateX:0.0f Y:0.0f Z:deltaZoom inSpace:JWTransformSpaceLocal];
    // TODO constraint
}

@end

@implementation JWCubicPanoramaCameraBehaviour

- (id)initWithContext:(id<JIGameContext>)context panorama:(JWCubicPanorama *)panorama {
    self = [super initWithContext:context];
    if (self != nil) {
        mPanorama = panorama;
    }
    return self;
}

- (BOOL)onScreenTouchUp:(NSSet *)touches withEvent:(UIEvent *)event {
    return YES;
}

- (BOOL)onScreenTouchMove:(NSSet *)touches withEvent:(UIEvent *)event {
    if (touches.count > 1) {
        return NO;
    }
    UITouch* touch = [touches anyObject];
    CGPoint dp = touch.deltaPositionInPixels;
    [mPanorama move1dx:-dp.x dy:-dp.y];
    return YES;
}

- (void)onPinch:(UIPinchGestureRecognizer *)pinch {
    [mPanorama scaleS:-(pinch.scale - 1.0f)];
    pinch.scale = 1.0f;
}

@end

@interface JWCubicPanoramaCapturer () {
    id<JIGameScene> mScene;
    id<JICamera> mCaptureCamera;
    id<JICamera> mOriginCamera;
    id<JITexture> mResultTextures[JWCubicPanoramaFaceNums];
}

@end

@implementation JWCubicPanoramaCapturer

- (id)initWithScene:(id<JIGameScene>)scene center:(id<JIGameObject>)center {
    self = [super init];
    if (self != nil) {
        mScene = scene;
        id<JIGameContext> context = scene.context;
        id<JIGameObject> captureCameraObject = [context createObject];
        captureCameraObject.parent = center;
        mCaptureCamera = [context createCamera];
        mCaptureCamera.Id = [NSString stringWithFormat:@"%@ \'s capture camera", @(center.hash)];
        [captureCameraObject addComponent:mCaptureCamera];
        mCaptureCamera.willAutoAdjustAspect = NO;
        mCaptureCamera.aspect = 1.0f;
        mCaptureCamera.fovy = 90.0f;
    }
    return self;
}

- (void)startCapture:(id<JICubicPanoramaCaptureListener>)listener {
    id<JIGameFrame> frame = mScene.context.engine.frame;
    CGFloat width = frame.width;
    CGFloat height = frame.height;
    
    // 调整capture camera
    if (width > height) {
        mCaptureCamera.viewport = JCViewportMake(0.0f, 0.0f, height / width, 1.0f);
    } else {
        mCaptureCamera.viewport = JCViewportMake(0.0f, 0.0f, 1.0f, width / height);
    }
    
    // 切换为capture camera
    [mScene changeCameraById:mCaptureCamera.Id];
    
    // 开始截图
    JCInt r = (JCInt)(width > height ? height : width);
    JCRect rect = JCRectMake(0, 0, r, r);
    JWOnTakePictureListener* posx = [[JWOnTakePictureListener alloc] init];
    posx.onTakePicture = (^(UIImage* picture) {
        if (picture == nil) {
            return;
        }
        UIImageWriteToSavedPhotosAlbum(picture, self, nil, nil);
        
    });
    JWOnTakePictureListener* negz = [[JWOnTakePictureListener alloc] init];
    negz.onTakePicture = (^(UIImage* picture) {
        if (picture == nil) {
            return;
        }
        UIImageWriteToSavedPhotosAlbum(picture, self, nil, nil);
        [mCaptureCamera.transform yawDegrees:90.0f];
        [mCaptureCamera takePictureByRect:rect async:YES listener:posx];
    });
    [mCaptureCamera takePictureByRect:rect async:YES listener:negz];
}

- (id<JITexture>)resultAtFace:(JWCubicPanoramaFace)face {
    return mResultTextures[face];
}

@end
