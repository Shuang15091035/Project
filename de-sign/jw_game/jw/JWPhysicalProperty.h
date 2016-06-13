//
//  JWPhysicalProperty.h
//  June Winter_game
//
//  Created by ddeyes on 16/3/2.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWComponent.h>
#import <jw/JCVector3.h>

@protocol JIPhysicalProperty <JIComponent>

/**
 * 速度
 */
@property (nonatomic, readwrite) JCVector3 velocity;

/**
 * 角速度
 */
@property (nonatomic, readwrite) JCVector3 angularSpeed;

/**
 * 线性加速度
 */
@property (nonatomic, readwrite) JCVector3 acceleration;

- (void) reset;

@end

@interface JWPhysicalProperty : JWComponent <JIPhysicalProperty>

@end
