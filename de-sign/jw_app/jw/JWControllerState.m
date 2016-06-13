//
//  JWControllerState.m
//  June Winter
//
//  Created by GavinLo on 14-2-14.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWControllerState.h"
#import "JWExceptions.h"
#import "JWStateController.h"

@interface JWControllerState ()
{
    Class mControllerClass;
    UINavigationController* mNavigationController;
    JWStateController* mParent;
    JWStateController* mController;
    NSInteger mContainerId;
}

@end

@implementation JWControllerState

- (void)onDestroy
{
    [super onDestroy];
    
    [mController removeFromParentViewController];
    mController = nil;
    
    mControllerClass = nil;
    mNavigationController = nil;
    mController = nil;
}

- (id)initWithClass:(Class)controllerClass parent:(UIViewController *)parent containerId:(NSInteger)containerId
{
    self = [super init];
    if(self != nil)
    {
        [self initParent:parent];
        mControllerClass = controllerClass;
        mController = nil;
        mContainerId = containerId;
    }
    return self;
}

- (id)initWithController:(JWStateController *)controller parent:(UIViewController *)parent containerId:(NSInteger)containerId
{
    self = [super init];
    if(self != nil)
    {
        [self initParent:parent];
        mControllerClass = [controller class];
        mController = controller;
        mContainerId = containerId;
    }
    return self;
}

+ (id)stateWithClass:(Class)controllerClass parent:(UIViewController *)parent containerId:(NSInteger)containerId
{
    return [[JWControllerState alloc] initWithClass:controllerClass parent:parent containerId:containerId];
}

+ (id)stateWithController:(JWStateController *)controller parent:(UIViewController *)parent containerId:(NSInteger)containerId
{
    return [[JWControllerState alloc] initWithController:controller parent:parent containerId:containerId];
}

- (void) initParent:(UIViewController*)controller
{
    if([controller isKindOfClass:[JWStateController class]])
    {
        JWStateController* sc = (JWStateController*)controller;
        mParent = sc;
        mNavigationController = sc.navigationController;
    }
    else if([controller isKindOfClass:[UINavigationController class]])
    {
        UINavigationController* nc = (UINavigationController*)controller;
        mParent = nil;
        mNavigationController = nc;
    }
    else
    {
        @throw [JWException exceptionWithName:@"Invalid Parameter" reason:@"Can only use a JWStateController or UINavigationController as parent" userInfo:nil];
    }
}

- (Class)controllerClass
{
    return mControllerClass;
}

- (void)onStateEnter:(NSDictionary *)data
{
    if(mNavigationController != nil)
    {
        UIViewController* currentController = mNavigationController.visibleViewController;
        if(currentController == mController)
            return;
        
        if(mController == nil)
        {
            mController = [[mControllerClass alloc] init];
            [mController notifyParent:mParentMachine];
        }
        
        if(mParent == nil)
            [mNavigationController pushViewController:mController animated:YES];
        else
            [mParent showContentController:mController containerId:mContainerId];
        [mController onStateEnter:data];
    }
}

- (void)onStateLeave
{
    if(mNavigationController != nil)
    {
        [mController onStateLeave];
        if(mParent != nil)
            [mParent hideContentController:mController];
    }
}

- (void)onStateMessage:(id<JIStateMessage>)message
{
    [mController onStateMessage:message];
}

@end

@implementation UIViewController (JWAppCategory)

- (void)showContentController:(UIViewController *)content containerId:(NSInteger)containerId
{
    UIView* container = self.view;
    if(containerId != 0)
    {
        container = [self.view viewWithTag:containerId];
        if(container == nil)
            container = self.view;
    }
    
    if(content.parentViewController != self)
    {
        [content removeFromParentViewController];
        [self addChildViewController:content];
    }
    
    if(content.view.superview != container)
    {
        [content.view removeFromSuperview];
        [container addSubview:content.view];
        [content didMoveToParentViewController:self];
    }
}

- (void)hideContentController:(UIViewController *)content
{
    [content willMoveToParentViewController:nil];
    [content.view removeFromSuperview];
    [content removeFromParentViewController];
}

@end
