//
//  JWStateController.m
//  June Winter
//
//  Created by GavinLo on 14-2-13.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWStateController.h"
#import "JWAppStateMachine.h"
#import "JWAppDelegate.h"
#import "JWCoreUtils.h"
#import "JWIOS.h"
#import "JWCorePluginSystem.h"

@interface JWStateController ()
{
    BOOL mIsFullscreen;
    JWViewEventBinder* mViewEventBinder;
    JWGestureEventBinder* mGestureEventBinder;
}

@property (nonatomic, readonly) JWStateController* parent;

@end

@implementation JWStateController

- (void)onPrepare
{
    
}

- (void)onCreate
{
    
}

- (void)onDestroy
{
    [JWCoreUtils destroyObject:mViewEventBinder];
    mViewEventBinder = nil;
    [JWCoreUtils destroyObject:mGestureEventBinder];
    mGestureEventBinder = nil;
}

- (JWViewEventBinder *)viewEventBinder
{
    if(mViewEventBinder == nil)
        mViewEventBinder = [[JWViewEventBinder alloc] initWithEvents:self];
    return mViewEventBinder;
}

- (JWGestureEventBinder *)gestureEventBinder
{
    if(mGestureEventBinder == nil)
        mGestureEventBinder = [[JWGestureEventBinder alloc] initWithEvents:self];
    return mGestureEventBinder;
}

- (BOOL)onPreCondition
{
    return YES;
}

- (void)onStateEnter:(NSDictionary *)data
{
    
}

- (void)onStateLeave
{
    
}

- (void)onStateResume
{
    // 唤醒子状态机中的当前状态
//    if(mSubMachine != nil)
//    {
//        id<JIState> state = mSubMachine.currentState;
//        [state onStateResume];
//    }
}

- (void)onStatePause
{
    // TODO 暂时只处理主子状态机
    // 暂停子状态机中的当前状态
//    if(mSubMachine != nil)
//    {
//        id<JIState> state = mSubMachine.currentState;
//        [state onStatePause];
//    }
}

- (void)onStateMessage:(id<JIStateMessage>)message
{
    
}

- (id<JIStateMachine>)parentMachine
{
    return mParentMachine;
}

- (id<JIState>)parentState
{
    if(mParentMachine == nil)
        return nil;
    return mParentMachine.state;
}

- (id<JIStateMachine>)subMachine
{
    if(mSubMachine == nil)
    {
        JWAppStateMachine* subMachine = [JWAppStateMachine machineWithName:nil andState:self];
        mSubMachine = subMachine;
    }
    return mSubMachine;
}

- (void)sendMessage:(id<JIStateMessage>)message
{
    if(mParentMachine.state != nil)
        [mParentMachine.state onStateMessage:message];
}

- (JWStateController *)parentController
{
    JWStateController* parent = nil;
    UIViewController* pvc = self.parentViewController;
    if([pvc isKindOfClass:[JWStateController class]])
        parent = (JWStateController*)pvc;
    return parent;
}

- (UIView *)onCreateView:(UIView *)parent
{
    return nil;
}

- (void)onCreated
{
    
}

- (BOOL)onTouchDown:(NSSet *)touches withEvent:(UIEvent *)event
{
    return NO;
}

- (BOOL)onTouchMove:(NSSet *)touches withEvent:(UIEvent *)event
{
    return NO;
}

- (BOOL)onTouchUp:(NSSet *)touches withEvent:(UIEvent *)event
{
    return NO;
}

- (BOOL)onTouchCancel:(NSSet *)touches withEvent:(UIEvent *)event
{
    return NO;
}

- (void)onPinch:(UIPinchGestureRecognizer *)pinch
{
    
}

- (void)onSingleTap:(UITapGestureRecognizer *)singleTap
{
    
}

- (void)onDoubleTap:(UITapGestureRecognizer *)doubleTap
{
    
}

- (void)onDoubleDrag:(UIPanGestureRecognizer *)doubleDrag {
    
}

- (void)onLongPress:(UILongPressGestureRecognizer *)longPress {
    
}

- (void)onLowMemory
{
    //[[[[JWCorePluginSystem instance].log withType:JWLogTypeUi] withLevel:JWLogLevelCritical] log:@"内存不足"];
    static int i = 0;
    NSLog(@"LowMemory (count:%d) ", ++i);
}

- (id<JIStateMachine>)appMachine
{
    if(mAppMachine == nil)
        mAppMachine = ((JWAppDelegate*)[[UIApplication sharedApplication] delegate]).appMachine;
    return mAppMachine;
}

- (void)notifyParent:(id<JIStateMachine>)parentMachine
{
    mParentMachine = parentMachine;
}

- (void)toggleFullscreen
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setToolbarHidden:YES];
    mIsFullscreen = YES;
    [self setNeedsStatusBarAppearanceUpdate];
}

// api ios7
#if JW_IOS_API(7, 0)
- (BOOL)prefersStatusBarHidden
{
    return mIsFullscreen;
}
#endif

- (id)init
{
    self = [super init];
    if(self != nil)
        [self onCreate];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self != nil)
        [self onCreate];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self != nil)
        [self onCreate];
    return self;
}

- (void)dealloc
{
    [self onDestroy];
}

- (void)loadView
{
    [self onPrepare];
    
    UIView* parentView = nil;
    JWStateController* parent = self.parent;
    if(parent != nil)
        parentView = parent.view;
    UIView* view = [self onCreateView:parentView];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self onCreated];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self onStateResume];
//}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self onStateResume];
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    if([self.navigationController.viewControllers indexOfObject:self] == NSNotFound)
//    {
//        //! hack back按钮按下
//        [self.appMachine revertState:NO];
//    }
//    [self onStatePause];
//    [super viewWillDisappear:animated];
//}

- (void)viewDidDisappear:(BOOL)animated
{
    if([self.navigationController.viewControllers indexOfObject:self] == NSNotFound)
    {
        //! hack back按钮按下
        [self.appMachine revertState:NO];
    }
    [self onStatePause];
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self onLowMemory];
}

@end
