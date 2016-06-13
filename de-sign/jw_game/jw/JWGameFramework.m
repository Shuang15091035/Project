//
//  JWGameFramework.m
//  June Winter
//
//  Created by GavinLo on 14-5-4.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWGameFramework.h"
#import "JWGame.h"
#import "JWGameFrame.h"
#import "UIScreen+JWCoreCategory.h"
#import "UIDevice+JWCoreCategory.h"
#import "JWFrameLayout.h"
#import <jw/UIView+JWUiCategory.h>
#import <jw/UIView+JWUiLayout.h>

@interface JWGameFramework ()
{
    id<JIGameEngine> mEngine;
}

@end

@implementation JWGameFramework

- (id<JIGameEngine>)engine
{
    return mEngine;
}

- (UIView *)gameFrame
{
    return mEngine.frame.view;
}

- (void)onPrepare
{
    [super onPrepare];
    
    mEngine = [[JWGameEngine alloc] init];
    [self onGameConfig];
    [mEngine onCreate];
    [self onGameBuild];
}

- (UIView *)onCreateView:(UIView *)parent {
    UIView* view = nil;
    id<JIGame> game = self.engine.game;
    if (game != nil) {
        view = [game onUiCreate:parent];
        if (view != nil) {
            UIView* gameView = mEngine.frame.view;
            if (![view hasView:gameView]) {
                @throw [NSException exceptionWithName:@"GameViewNotFound" reason:@"No GameView Found in view create by onUiCreate, please add GameView(engine.frame.view) to view." userInfo:nil];
                return nil;
            }
            return view;
        }
    }
    view = [self createDefaultView:parent];
    return view;
}

- (UIView*) createDefaultView:(UIView*)parent {
    JWFrameLayout* container = [JWFrameLayout layout];
    container.layoutParams.width = JWLayoutMatchParent;
    container.layoutParams.height = JWLayoutMatchParent;
//    container.backgroundColor = [UIColor clearColor];
    
    UIView* gameView = mEngine.frame.view;
    if (gameView != nil) {
        gameView.layoutParams.width = JWLayoutMatchParent;
        gameView.layoutParams.height = JWLayoutMatchParent;
        [container addSubview:gameView];
    }
    
    return container;
}

- (void)onGameConfig
{
    
}

- (void)onGameBuild
{
    
}

- (void)onStateResume
{
    [mEngine onResume];
}

- (void)onStatePause
{
    [mEngine onPause];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [mEngine onFrameReady];
}

@end
