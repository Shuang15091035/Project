//
//  JWAnalogStick.h
//  jw_app
//
//  Created by ddeyes on 16/1/6.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWRelativeLayout.h>

typedef NS_ENUM(NSInteger, JWAnalogStickDirection) {
    /**
     * 只允许水平移动
     */
    JWAnalogStickDirectionHorizontal = 0x1 << 0,
    
    /**
     * 只允许垂直移动
     */
    JWAnalogStickDirectionVertical = 0x1 << 1,
    
    /**
     * 允许所有方向的移动
     */
    JWAnalogStickDirectionAll = JWAnalogStickDirectionHorizontal | JWAnalogStickDirectionVertical,
};

@class JWAnalogStick;

@protocol JWOnAnalogStickEventListener <NSObject>

/**
 * 操纵杆的位移，基于以下坐标系
 * y
 * ^
 * |
 * |-------> x
 * 其中坐标原点为控件中心点
 */
- (void) analogStick:(JWAnalogStick*)analogStick didOffset:(CGPoint)offset;
- (void) analogStickDidReset:(JWAnalogStick*)analogStick;

@end

@interface JWAnalogStick : JWRelativeLayout

+ (id) analogStick;
@property (nonatomic, readonly) UIImageView* backgroundView;
@property (nonatomic, readonly) UIImageView* stickView;
@property (nonatomic, readwrite) JWAnalogStickDirection direction;
- (void) resetStick;

@property (nonatomic, readwrite) id<JWOnAnalogStickEventListener> listener;

@end
