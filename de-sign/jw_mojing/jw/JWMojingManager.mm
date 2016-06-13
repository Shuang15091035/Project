//
//  JWMojingManager.m
//  June Winter
//
//  Created by ddeyes on 16/3/17.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWMojingManager.h"
#import <MojingSDK/MojingIOSAPI.h>
#import <MojingSDK/MojingGamepad.h>
#import "Glass.h"
#import "Manufacturer.h"
#import "ManufacturerList.h"
#import "Product.h"

static JWMojingManager* s_JWMojingManager = nil;

@interface JWMojingManager () {
    MojingType mType;
    NSUInteger mMSAALevel;
}

@end

@implementation JWMojingManager

+ (JWMojingManager*)instance {
    if (s_JWMojingManager == nil) {
        s_JWMojingManager = [[self alloc] init];
    }
    return s_JWMojingManager;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        mType = MojingTypeUnknown;
        mMSAALevel = 4; // NOTE 默认开启抗锯齿
    }
    return self;
}

- (void)setupMojingWithController:(UIViewController *)controller {
    // TODO 暂写死，之后改为info.plist取值
    MojingSDK_API_Init(@"P3954066002858824", @"3954392437152824", @"5b08a58fd48366a9515a2b5f3a53176c", @"jw_mojing");
     [[MojingGamepad sharedGamepad] registerGamepad:controller];
}

//@synthesize MSAALevel = mMSAALevel;

- (MojingType)mojingType {
    return mType;
}

- (BOOL)changeMojingType:(MojingType)type {
    if (mType == type) {
        return YES;
    }
    // NOTE 在ipad上面调用畸变API的话会崩溃，估计是暴风魔镜只做了手机的适配引起的
    //
    // 图例：
    // |- # manufacturer
    // |  |- # product
    // |  |  |- # glass
    //
    // 镜片列表如下：
    // |- 0 暴风魔镜
    // |  |- 0 暴风魔镜II
    // |  |- 1 暴风魔镜III
    // |  |  |- 0 标准片
    // |  |  |- 1 Plus B镜片
    // |  |  |- 2 Plus A镜片
    // |  |- 2 暴风魔镜IV
    // |  |- 3 观影镜
    // |  |- 4 魔镜小D
    // |- 1 深圳聚众创科技有限公司
    // |- 2 奇酷互联网络科技（深圳）有限公司
    // |- 3 深圳市悉达多经贸有限公司
    NSInteger manufacturerIndex = -1;
    NSInteger productIndex = -1;
    NSInteger glassIndex = -1;
    switch (type) {
        case MojingType2: {
//            manufacturerIndex = 0;
//            productIndex = 0;
//            glassIndex = 0;
            // NOTE 暴风魔镜II没有畸变，采用直接分屏显示
            mType = type;
            break;
        }
        case MojingType3Standard: {
            manufacturerIndex = 0;
            productIndex = 1;
            glassIndex = 0;
            break;
        }
        case MojingType3PlusB: {
            manufacturerIndex = 0;
            productIndex = 1;
            glassIndex = 1;
            break;
        }
        case MojingType3PlusA: {
            manufacturerIndex = 0;
            productIndex = 1;
            glassIndex = 2;
            break;
        }
        case MojingType4: {
            manufacturerIndex = 0;
            productIndex = 2;
            glassIndex = 0;
            break;
        }
        case MojingTypeGuanYingJing: {
            manufacturerIndex = 0;
            productIndex = 3;
            glassIndex = 0;
            break;
        }
        case MojingTypeXiaoD: {
//            manufacturerIndex = 0;
//            productIndex = 4;
//            glassIndex = 0;
            // NOTE 魔镜小D没有畸变，采用直接分屏显示
            mType = type;
            break;
        }
        case MojingTypeUnknown: {
            mType = type;
            break;
        }
    }
    if (manufacturerIndex < 0 || productIndex < 0 || glassIndex < 0) {
        MojingSDK_API_LeaveMojingWorld();
        return false;
    }
    BOOL b = false;
    MojingManufacturerList* manufacturerList = [MojingManufacturerList getInstance];
    if (manufacturerList.mManufacturerList == nil || manufacturerList.mManufacturerList.count <= manufacturerIndex) {
        return b;
    }
    MojingManufacturer* manufacturer = manufacturerList.mManufacturerList[manufacturerIndex];
    if (manufacturer.mProductList == nil || manufacturer.mProductList.count <= productIndex) {
        return b;
    }
    MojingProduct* product = manufacturer.mProductList[productIndex];
    if (product.mGlassList == nil || product.mGlassList.count <= glassIndex) {
        return b;
    }
    MojingGlass* glass = product.mGlassList[glassIndex];
    NSString* key = glass.mKey;
    if (mType == MojingTypeUnknown) {
        b = MojingSDK_API_EnterMojingWorld(key, true) ? YES : NO;
    } else {
        b = MojingSDK_API_ChangeMojingWorld(key) ? YES : NO;
    }
    if (b) {
        mType = type;
    }
    return b;
}

@end
