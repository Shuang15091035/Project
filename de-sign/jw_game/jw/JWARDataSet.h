//
//  JWARDataSet.h
//  June Winter_game
//
//  Created by GavinLo on 15/3/5.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGamePredef.h>
#import <jw/JWResource.h>

@protocol JIARDataSet <JIResource>

/**
 * 是否被激活，设置AR资源是否为激活状态(处于激活状态的资源才会在识别AR目标时产生效果)
 */
@property (nonatomic, readwrite, getter=isActive) BOOL active;

@end

@interface JWARDataSet : JWResource <JIARDataSet> {
    BOOL mActive;
}

@end
