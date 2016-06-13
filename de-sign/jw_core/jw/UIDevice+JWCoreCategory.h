//
//  UIDevice+JWCoreCategory.h
//  June Winter
//
//  Created by GavinLo on 14-3-9.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIDeviceResolution)
{
    // (320x480) iPhone 1g-3GS;iPod Touch 1g-3g
    UIDeviceResolutionPhoneSD,
    // (640x960) iPhone 4,4S;iPod Touch 4g
    UIDeviceResolutionPhoneHD,
    // (640x1136) iPhone 5,5C,5S;iPod Touch 5g
    UIDeviceResolutionPhone5HD,
    // (1024x768) iPad;iPad 2;iPad Mini
    UIDeviceResolutionPadSD,
    // (2048x1536) iPad Air;iPad Mini Retina
    UIDeviceResolutionPadHD,
    
    // count
    UIDeviceResolutionCount,
};

typedef NS_ENUM(NSInteger, UIDeviceType) {
    UIDeviceTypeUnknown,
    UIDeviceTypeIPhone,
    UIDeviceTypeIPad,
    UIDeviceTypeIPod,
};

typedef NS_ENUM(NSInteger, UIDeviceIPhoneModel) {
    UIDeviceIPhoneModelUnknown,
    UIDeviceIPhoneModel1,
    UIDeviceIPhoneModel3,
    UIDeviceIPhoneModel4,
    UIDeviceIPhoneModel5,
    UIDeviceIPhoneModel5c,
    UIDeviceIPhoneModel5s,
    UIDeviceIPhoneModel6,
    UIDeviceIPhoneModel6s,
};

typedef NS_ENUM(NSInteger, UIDeviceIPadModel) {
    UIDeviceIPadModelUnknown,
    UIDeviceIPadModel1,
    UIDeviceIPadModel2,
    UIDeviceIPadModelMini,
    UIDeviceIPadModel3,
    UIDeviceIPadModel4,
    UIDeviceIPadModelAir,
    UIDeviceIPadModelMini2G,
    UIDeviceIPadModelMini3,
    UIDeviceIPadModelAir2,
};

typedef void (^UIDeviceOnResolutionBlock)(UIDeviceResolution resolution, BOOL* stop);

@interface UIDevice (JWCoreCategory)

@property (nonatomic, readonly) UIDeviceResolution resolution;
@property (nonatomic, readonly) NSString* fileSuffix;
+ (NSString*) fileSuffixFromResolution:(UIDeviceResolution)resolution;
+ (void) enumResolutions:(UIDeviceOnResolutionBlock)onResolution;

@property (nonatomic, readonly) UIDeviceType type;
@property (nonatomic, readonly) UIDeviceIPhoneModel iphoneModel;
@property (nonatomic, readonly) UIDeviceIPadModel ipadModel;

@end
