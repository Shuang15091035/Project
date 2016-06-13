//
//  MesherModel.m
//  project_mesher
//
//  Created by MacMini on 15/10/12.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "MesherModel.h"
#import <jw/JWGameContext.h>
#import <jw/JWGameEngine.h>
#import <jw/JWGameWorld.h>
#import <jw/JWSceneQuery.h>
#import <jw/JWCommandMachine.h>

@interface MesherModel (){
    id<JIGameWorld> mWorld;
    id<JIGameContext>mCurrentContext;
    id<JIGameScene> mCurrentScene;
    id<JIGameScene> mArScene;
    id<JIGameScene> mInspirateScene;
    id<JIGameObject> mGridsObject;
    id<JIGameObject> mBackgroundSprite;
    id<JIGameObject> mItemSelectAndMoveObject;
    ItemSelectAndMoveBehaviour* mItemSelectAndMoveBehaviour;
    
    id<JIGameObject> mInspiratedObject;
    InspiratedBehaviour *mInspiratedBehaviour;
    id<JICamera> mInspiratedCamera;
    EditorCamera* mInspiratedEditorCamera;
    id<JIGameObject> mInspiratedGridsObject;
    BOOL mFromPhotoLibrary;
    BOOL mFromExchange;
    
    GamePhotographer *mPhotographer;
    JWCameraPrefab *mCurrentCamera;
    id<JICommandMachine> mCommandMachine;
    UIView *mLo_game_view;
    UIView *mGameView;
    
    Area mCurrentArea;
    Product *mCurrentProduct;
    id<JIGameObject> mSelectedObject;
    id<JIGameObject> mPreSelectedObject;
    id<JIGameObject> mArObject;
    id<JIMaterial> mArVideoMaterial;
    Plan* mCurrentPlan;
    Plan* mPrePlan;
//    SuitPlan *mSuitPlan;
    
    Project* mProject;
    
    Item* mRoomItem;
    NSArray *mCurrentRoomShapes;
    
    JCVector3 mCameraPosition;
#ifdef USE_MOJING
    MojingType mMojingType;
#endif
    
    JWRect4CornersDecals *mItemRectFrameDecals;
    JWRect4CornersDecals *mItemOverlapDecals;
    
    NSInteger mLaunchIndex;
    
    NSUInteger mCurrentPlanIndex;
    NSMutableArray* mOnCurrentPlanIndexChangedDelegates;

    CGFloat mGameViewWidth;
    CGFloat mRightMenuWidth;
    id<JIGameObject> mBorderObject;
    BOOL mAutoFPS;
    BOOL mIsFPS;
    BOOL mIsTeach;
    id<JIGameObject> mTeachObject;
    id<JIGameObject> mTeachDeacls;
    CGPoint mTeachTouchUpPoint;
    BOOL mIsTeachMove;
    BOOL mIsInTeachObject;
    BOOL mCompletedMove;
    BOOL mCompletedTeach;
    BOOL mFromTeach;
    
    BOOL mIsTouchBirdCamera;
    BOOL mIsTouchEditCamera;
    BOOL mIsTouchShot;
    BOOL mIsTouchHome;
    BOOL mIsTeachTime;
    BOOL mLoadScene;
    JCVector3 mTeachMoveLastPosition;
    
    UIViewController *mMainController;
    UIImage *mInspiratedImage;
    JWBackgroundSpritePrefab* mInspiratedBackgroundSprite;
    id<JIGameScene> mInspiratedCameraScene;
    BOOL mFromInspiration;
    BOOL mIsInspiratedCreate;
}


@end

@implementation MesherModel

//+ (NSUInteger)CanSelectMask
//{
//    return JWSceneQueryMask_Layer0;
//}
//
//+ (NSUInteger)CanNotSelectMask
//{
//    return JWSceneQueryMask_Layer1;
//}

- (void)onDestroy
{
    mWorld = nil;
    mCurrentContext = nil;
    mCurrentScene = nil;
    mArScene = nil;
    mInspirateScene = nil;
    mPhotographer = nil;
    mCurrentCamera = nil;
    mCommandMachine = nil;
    
    mSelectedObject = nil;
    mPreSelectedObject = nil;
    mArObject = nil;
    mCurrentPlan = nil;
//    mSuitPlan = nil;
    [JWCoreUtils destroyObject:mProject];
    mProject = nil;
    [super onDestroy];
}

@synthesize world = mWorld;
@synthesize currentContext = mCurrentContext;
@synthesize lo_game_view = mLo_game_view;
@synthesize gameView = mGameView;

- (id<JIGameScene>)currentScene
{
    return mCurrentScene;
}

- (void)setCurrentScene:(id<JIGameScene>)currentScene
{
    if(mCurrentScene == currentScene)
        return;
    [mCurrentContext.engine.game.world changeSceneById:currentScene.Id];
    mCurrentScene = currentScene;
}

- (id<JIGameScene>)arScene {
    return mArScene;
}

- (void)setArScene:(id<JIGameScene>)arScene {
    if (mArScene == arScene) {
        return;
    }
    [mCurrentContext.engine.game.world changeSceneById:arScene.Id];
    mArScene = arScene;
}

- (id<JIGameScene>)inspirateScene {
    return mInspirateScene;
}

- (void)setInspirateScene:(id<JIGameScene>)inspirateScene {
    if (mInspirateScene == inspirateScene) {
        return;
    }
    [mCurrentContext.engine.game.world changeSceneById:inspirateScene.Id];
    mInspirateScene = inspirateScene;
}

@synthesize gridsObject = mGridsObject;
@synthesize backgroundSprite = mBackgroundSprite;
@synthesize itemSelectAndMoveObject = mItemSelectAndMoveObject;
@synthesize itemSelectAndMoveBehaviour = mItemSelectAndMoveBehaviour;
@synthesize inspiratedCamera = mInspiratedCamera;
@synthesize inspiratedEditorCamera = mInspiratedEditorCamera;
@synthesize inspiratedGridsObject = mInspiratedGridsObject;
@synthesize fromPhotoLibrary = mFromPhotoLibrary;
@synthesize fromExchange = mFromExchange;

@synthesize inspiratedObject = mInspiratedObject;
@synthesize inspiratedBehaviour = mInspiratedBehaviour;

@synthesize photographer = mPhotographer;
@synthesize currentCamera = mCurrentCamera;

- (id<JICommandMachine>)commandMachine {
    if (mCommandMachine == nil) {
        mCommandMachine = [JWCommandMachine machine];
    }
    return mCommandMachine;
}

@synthesize currentArea = mCurrentArea;
@synthesize currentProduct = mCurrentProduct;

- (id<JIGameObject>)selectedObject  {
    return mSelectedObject;
}

- (void)setSelectedObject:(id<JIGameObject>)selectedObject {
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
#ifdef USE_MOJING
@synthesize mojingType = mMojingType;
#endif

@synthesize itemRectFrameDecals = mItemRectFrameDecals;
@synthesize itemOverlapDecals = mItemOverlapDecals;
@synthesize launchIndex = mLaunchIndex;
@synthesize currentPlanIndex = mCurrentPlanIndex;

@synthesize gameViewWidth = mGameViewWidth;
@synthesize rightMenuWidth = mRightMenuWidth;
@synthesize borderObject = mBorderObject;

@synthesize autoFPS = mAutoFPS;
@synthesize isFPS = mIsFPS;
@synthesize isTeach = mIsTeach;
@synthesize teachObject = mTeachObject;
@synthesize teachDeacls = mTeachDeacls;
@synthesize teachTouchUpPoint = mTeachTouchUpPoint;
@synthesize isTeachMove = mIsTeachMove;
@synthesize isInTeachObject = mIsInTeachObject;
@synthesize completedMove = mCompletedMove;
@synthesize completedTeach = mCompletedTeach;
@synthesize fromTeach = mFromTeach;

@synthesize isTouchBirdCamera = mIsTouchBirdCamera;
@synthesize isTouchEditCamera = mIsTouchEditCamera;
@synthesize isTouchShot = mIsTouchShot;
@synthesize isTouchHome = mIsTouchHome;
@synthesize isTeachTime = mIsTeachTime;
@synthesize loadScene = mLoadScene;
@synthesize teachMoveLastPosition = mTeachMoveLastPosition;

@synthesize mainController = mMainController;
@synthesize inspiratedImage = mInspiratedImage;
@synthesize inspiratedBackgroundSprite = mInspiratedBackgroundSprite;
@synthesize inspiratedCameraScene = mInspiratedCameraScene;
@synthesize fromInspiration = mFromInspiration;
@synthesize isInspiratedCreate = mIsInspiratedCreate;

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
