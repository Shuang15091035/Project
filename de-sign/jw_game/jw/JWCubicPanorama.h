//
//  JWCubicPanorama.h
//  June Winter_game
//
//  Created by ddeyes on 15/8/2.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGamePredef.h>
#import <jw/JCBase.h>
#import <jw/JWObject.h>

typedef NS_ENUM(NSUInteger, JWCubicPanoramaFace) {
    JWCubicPanoramaFacePosX,
    JWCubicPanoramaFacePosY,
    JWCubicPanoramaFacePosZ,
    JWCubicPanoramaFaceNegX,
    JWCubicPanoramaFaceNegY,
    JWCubicPanoramaFaceNegZ,
    JWCubicPanoramaFaceNums,
};

@protocol JICubicPanorama <JIObject>

@property (nonatomic, readonly) id<JIGameObject> root;
@property (nonatomic, readonly) id<JICamera> camera;
@property (nonatomic, readonly) id<JIGameObject> panorama;
- (id<JITexture>) face:(JWCubicPanoramaFace)face;
- (void) setFace:(JWCubicPanoramaFace)face withTexture:(id<JITexture>)texture;

@property (nonatomic, readwrite) JCFloat edgeLength;
@property (nonatomic, readwrite) JCFloat move1SpeedX;
@property (nonatomic, readwrite) JCFloat move1SpeedY;
- (void) setMove1Speed:(JCFloat)move1Speed;
@property (nonatomic, readwrite) JCFloat scaleSpeed;

@end

@interface JWCubicPanorama : JWObject <JICubicPanorama>

+ (id) panoramaWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent cameraId:(NSString*)cameraId panoramaId:(NSString*)panoramaId;
- (id) initWithContext:(id<JIGameContext>)context parent:(id<JIGameObject>)parent cameraId:(NSString*)cameraId panoramaId:(NSString*)panoramaId;

- (void) move1dx:(JCFloat)dx dy:(JCFloat)dy;
- (void) scaleS:(JCFloat)s;

@end

@protocol JICubicPanoramaCapturer;

@protocol JICubicPanoramaCaptureListener <NSObject>

- (void) onCapture:(id<JICubicPanoramaCapturer>)capturer;

@end

@protocol JICubicPanoramaCapturer <JIObject>

- (void) startCapture:(id<JICubicPanoramaCaptureListener>)listener;
- (id<JITexture>) resultAtFace:(JWCubicPanoramaFace)face;

@end

@interface JWCubicPanoramaCapturer : JWObject <JICubicPanoramaCapturer>

- (id) initWithScene:(id<JIGameScene>)scene center:(id<JIGameObject>)center;

@end
