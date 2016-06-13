//
//  JWARCamera.h
//  June Winter_game
//
//  Created by GavinLo on 15/3/11.
//  Copyright (c) 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGamePredef.h>
#import <jw/JWCamera.h>

/**
 * AR系统的camera，与硬件camera挂钩，一般全局只有一个
 * **由于AR的camera跟硬件camera挂钩，所以作为一种特殊的camera来处理，独立出来。
 * **场景中也可以切换回正常的camera，以实现VR和AR的交替
 */
@protocol JIARCamera <JICamera>

@end

@interface JWARCamera : JWCamera <JIARCamera>

@end
