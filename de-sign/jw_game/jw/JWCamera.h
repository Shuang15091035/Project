//
//  JWCamera.h
//  June Winter
//
//  Created by GavinLo on 14-4-30.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <jw/JCCamera.h>
#import <jw/JWFrustum.h>
#import <jw/JCViewport.h>
#import <jw/JCVector2.h>
#import <jw/JCRay3.h>
#import <jw/JCRect.h>
#import <jw/JWAsyncResult.h>

typedef void (^JWOnTakePictureBlock)(UIImage* picture);

@protocol JIOnTakePictureListener <NSObject>

- (void) onTakePicture:(UIImage*)picture;

@end

@interface JWOnTakePictureListener : NSObject <JIOnTakePictureListener>

@property (nonatomic, readwrite) JWOnTakePictureBlock onTakePicture;

@end

@protocol JICamera <JIFrustum>

@property (nonatomic, readwrite) JCViewport viewport;
- (BOOL) preRender;
- (void) render;
- (void) postRender;
- (JCVector2) getCoordinatesFromScreenX:(JCFloat)screenX screenY:(JCFloat)screenY;
- (JCRay3) getRayFromX:(JCFloat)cameraX screenY:(JCFloat)cameraY;

- (UIImage*) takePictureByRect:(JCRect)rect;
- (JWAsyncResult*) takePictureByRect:(JCRect)rect async:(BOOL)async listener:(id<JIOnTakePictureListener>)listener;

@end

@interface JWCamera : JWFrustum <JICamera> {
    JCViewport mViewport;
    BOOL mViewportDirty;
}

- (UIImage*) takePictureToUIImageByRect:(JCRect)rect;
@property (nonatomic, readonly) JCCameraRefC ccamera;

@end
