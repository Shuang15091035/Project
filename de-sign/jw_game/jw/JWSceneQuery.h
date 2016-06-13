//
//  JWSceneQuery.h
//  June Winter
//
//  Created by GavinLo on 14/12/10.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGamePredef.h>
#import <jw/JWObject.h>

typedef NS_OPTIONS(NSUInteger, JWSceneQueryMask)
{
    JWSceneQueryMask_Layer0 = 0x1 << 0,
    JWSceneQueryMask_Layer1 = 0x1 << 1,
    JWSceneQueryMask_Layer2 = 0x1 << 2,
    JWSceneQueryMask_Layer3 = 0x1 << 3,
    JWSceneQueryMask_Layer4 = 0x1 << 4,
    JWSceneQueryMask_Layer5 = 0x1 << 5,
    JWSceneQueryMask_Layer6 = 0x1 << 6,
    JWSceneQueryMask_Layer7 = 0x1 << 7,
    JWSceneQueryMask_Layer8 = 0x1 << 8,
    JWSceneQueryMask_Layer9 = 0x1 << 9,
    JWSceneQueryMask_All = NSUIntegerMax,
};

@protocol JISceneQuery <NSObject>

@property (nonatomic, readwrite) NSUInteger mask;

@end

@interface JWSceneQuery : JWObject <JISceneQuery>
{
    NSUInteger mMask;
}

@end
