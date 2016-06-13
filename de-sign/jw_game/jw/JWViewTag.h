//
//  JWViewTag.h
//  June Winter_game
//
//  Created by ddeyes on 15/10/21.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWRenderable.h>

typedef CGPoint (^JWViewTagOnChangeBlock)(CGPoint position);
typedef void (^JWViewTagOnObjectDestroyBlock)(id<JIViewTag> tagView);

@protocol JIViewTag <JIRenderable>

/**
 * 绑定的view，这个view会跟随GameObject移动
 */
@property (nonatomic, readwrite) UIView* view;

/**
 * 绑定的view相对于跟随位置的偏移量，单位是点（pt）
 */
@property (nonatomic, readwrite) CGPoint viewOffset;

/**
 * 强制更新，使view与GameObject同步，一般用于绑定的view有变化时
 */
- (void) notifyViewUpdate;

@property (nonatomic, readwrite) JWViewTagOnChangeBlock onChange;

/**
 * GameObject被释放时调用
 */
@property (nonatomic, readwrite) JWViewTagOnObjectDestroyBlock onObjectDestroy;

@end

@interface JWViewTag : JWRenderable <JIViewTag> {
    UIView* mView;
    CGPoint mViewOffset;
    JWViewTagOnChangeBlock mOnChange;
    JWViewTagOnObjectDestroyBlock mOnObjectDestroy;
}

@end
