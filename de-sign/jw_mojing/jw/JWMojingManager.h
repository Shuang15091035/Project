//
//  JWMojingManager.h
//  June Winter
//
//  Created by ddeyes on 16/3/17.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <jw/JWObject.h>

typedef NS_ENUM(NSInteger, MojingType){
    MojingTypeUnknown = 0,
    MojingType2,
    MojingType3Standard,
    MojingType3PlusB,
    MojingType3PlusA,
    MojingType4,
    MojingTypeGuanYingJing,
    MojingTypeXiaoD,
};

@interface JWMojingManager : JWObject

+ (JWMojingManager*) instance;
- (void) setupMojingWithController:(UIViewController*)controller;
@property (nonatomic, readwrite) NSUInteger MSAALevel;
@property (nonatomic, readonly) MojingType mojingType;
- (BOOL) changeMojingType:(MojingType)type;

@end
