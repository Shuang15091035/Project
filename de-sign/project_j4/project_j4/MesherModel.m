//
//  MesherModel.m
//  project_mesher
//
//  Created by MacMini on 15/10/12.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "MesherModel.h"
#import <ctrlcv/CCVGameContext.h>
#import <ctrlcv/CCVGameEngine.h>
#import <ctrlcv/CCVGameWorld.h>
#import <ctrlcv/CCVSceneQuery.h>
#import <ctrlcv/CCVCommandMachine.h>

@interface MesherModel (){
    id<ICVGameWorld> mWorld;
    id<ICVGameContext>mCurrentContext;
    id<ICVGameScene> mCurrentScene;
    id<ICVGameScene> mArScene;
    id<ICVGameObject> mGridsObject;
    id<ICVGameObject> mBackgroundSprite;
    ItemSelectAndMoveBehaviour* mItemSelectAndMoveBehaviour;
    GamePhotographer *mPhotographer;
    id<ICVCommandMachine> mCommandMachine;
    UIView *mLo_game_view;
    UIView *mGameView;
    
    Area mCurrentArea;
    Product *mCurrentProduct;
    id<ICVGameObject> mSelectedObject;
    id<ICVGameObject> mPreSelectedObject;
    id<ICVGameObject> mArObject;
    id<ICVMaterial> mArVideoMaterial;
    Plan* mCurrentPlan;
    Plan* mPrePlan;
//    SuitPlan *mSuitPlan;
    
    Project* mProject;
    
    Item* mRoomItem;
    NSArray *mCurrentRoomShapes;
    
    CCCVector3 mCameraPosition;
    
    CCVRect4CornersDecals *mItemRectFrameDecals;
    
    NSInteger mLaunchIndex;
    
    NSUInteger mCurrentPlanIndex;
    NSMutableArray* mOnCurrentPlanIndexChangedDelegates;

    CGFloat mGameViewWidth;
    CGFloat mRightMenuWidth;
    id<ICVGameObject> mBorderObject;
}


@end

@implementation MesherModel

+ (NSUInteger)CanSelectMask
{
    return CCVSceneQueryMask_Layer0;
}

+ (NSUInteger)CanNotSelectMask
{
    return CCVSceneQueryMask_Layer1;
}

- (void)onDestroy
{
    mWorld = nil;
    mCurrentContext = nil;
    mCurrentScene = nil;
    mArScene = nil;
    mPhotographer = nil;
    mCommandMachine = nil;
    
    mSelectedObject = nil;
    mPreSelectedObject = nil;
    mArObject = nil;
    mCurrentPlan = nil;
//    mSuitPlan = nil;
    [CCVCoreUtils destroyObject:mProject];
    mProject = nil;
    [super onDestroy];
}

@synthesize world = mWorld;
@synthesize currentContext = mCurrentContext;
@synthesize lo_game_view = mLo_game_view;
@synthesize gameView = mGameView;

- (id<ICVGameScene>)currentScene
{
    return mCurrentScene;
}

- (void)setCurrentScene:(id<ICVGameScene>)currentScene
{
    if(mCurrentScene == currentScene)
        return;
    [mCurrentContext.engine.game.world changeSceneById:currentScene.Id];
    mCurrentScene = currentScene;
}

- (id<ICVGameScene>)arScene {
    return mArScene;
}

- (void)setArScene:(id<ICVGameScene>)arScene {
    if (mArScene == arScene) {
        return;
    }
    [mCurrentContext.engine.game.world changeSceneById:arScene.Id];
    mArScene = arScene;
}

@synthesize gridsObject = mGridsObject;
@synthesize backgroundSprite = mBackgroundSprite;
@synthesize itemSelectAndMoveBehaviour = mItemSelectAndMoveBehaviour;

@synthesize photographer = mPhotographer;

- (id<ICVCommandMachine>)commandMachine {
    if (mCommandMachine == nil) {
        mCommandMachine = [CCVCommandMachine machine];
    }
    return mCommandMachine;
}

@synthesize currentArea = mCurrentArea;
@synthesize currentProduct = mCurrentProduct;

- (id<ICVGameObject>)selectedObject  {
    return mSelectedObject;
}

- (void)setSelectedObject:(id<ICVGameObject>)selectedObject {
    mPreSelectedObject = mSelectedObject;
    mSelectedObject = selectedObject;
}

@synthesize arObject = mArObject;
@synthesize arVideoMaterial = mArVideoMaterial;

@synthesize preSelectedObject = mPreSelectedObject;
//@synthesize currentPlan = mCurrentPlan;

- (Plan *)currentPlan {
    return mCurrentPlan;
}

- (void)setCurrentPlan:(Plan *)currentPlan {
//    if (mCurrentPlan != currentPlan) {
//        [mCurrentPlan destroyAllObjects];
//    }
    mPrePlan = mCurrentPlan;
    mCurrentPlan = currentPlan;
}

- (Plan *)prePlan {
    return mPrePlan;
}

- (void)setPrePlan:(Plan *)prePlan {
    mPrePlan = prePlan;
}

//@synthesize suitPlan = mSuitPlan;

- (Project *)project {
    if (mProject == nil) {
        mProject = [[Project alloc] init];
        mProject.model = self;
    }
    return mProject;
}

@synthesize roomItem = mRoomItem;
@synthesize currentRoomShapes = mCurrentRoomShapes;

@synthesize cameraPosition = mCameraPosition;

@synthesize itemRectFrameDecals = mItemRectFrameDecals;
@synthesize launchIndex = mLaunchIndex;
@synthesize currentPlanIndex = mCurrentPlanIndex;

@synthesize gameViewWidth = mGameViewWidth;
@synthesize rightMenuWidth = mRightMenuWidth;
@synthesize borderObject = mBorderObject;

- (void)setCurrentPlanIndex:(NSInteger)currentPlanIndex byTarget:(id)target {
    mCurrentPlanIndex = currentPlanIndex;
    if (mOnCurrentPlanIndexChangedDelegates != nil) {
        for (id<OnCurrentPlanIndexChangedDelegate> delegate in mOnCurrentPlanIndexChangedDelegates) {
            if (delegate == target) {
                continue;
            }
            [delegate onCurrentPlanIndexChanged:currentPlanIndex];
        }
    }
}

- (void)registerOnCurrentPlanIndexChangedDelegate:(id<OnCurrentPlanIndexChangedDelegate>)delegate {
    if (mOnCurrentPlanIndexChangedDelegates == nil) {
        mOnCurrentPlanIndexChangedDelegates = [NSMutableArray array];
    }
    [mOnCurrentPlanIndexChangedDelegates addObject:delegate];
}

- (void)unregisterOnCurrentPlanIndexChangedDelegate:(id<OnCurrentPlanIndexChangedDelegate>)delegate {
    if (mOnCurrentPlanIndexChangedDelegates == nil) {
        return;
    }
    [mOnCurrentPlanIndexChangedDelegates removeObject:delegate];
}

+ (CGFloat)uiWidthBy:(CGFloat)width {
    return [[UIScreen mainScreen] widthByScale:(width / 2048.0f)];
}

+ (CGFloat)uiHeightBy:(CGFloat)height {
    return [[UIScreen mainScreen] heightByScale:(height / 1536.0f)];
}

@end
