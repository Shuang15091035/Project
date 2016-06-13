//
//  JWGameFramework.h
//  June Winter
//
//  Created by GavinLo on 14-5-4.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWStateController.h>
#import <jw/JWGameEngine.h>

@protocol JIGameFramework <NSObject>

@property (nonatomic, readonly) id<JIGameEngine> engine;
@property (nonatomic, readonly) UIView* gameFrame;

/*
 * 一般是安装插件等配置性的操作
 */
- (void) onGameConfig;

/*
 * 一般是游戏的创建(场景、基础内容等等),就是指定engine中的game对象
 */
- (void) onGameBuild;

@end

@interface JWGameFramework : JWStateController <JIGameFramework>

@end
