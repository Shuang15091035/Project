//
//  TutorialPlanEditFinish.m
//  project_mesher
//
//  Created by mac zdszkj on 16/5/16.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "TutorialPlanEditFinish.h"
#import "MesherModel.h"
#import "Plan.h"
#import "PlanLoader.h"
#import "LocalPlanTable.h"

@interface TutorialPlanEditFinish() {
    UIImageView *btn_homepage;
    UIImageView *lo_teach_tap_static;
    UIImageView *lo_teachTap_animation;
}

@end

@implementation TutorialPlanEditFinish

- (UIView *)onCreateView:(UIView *)parent {
    btn_homepage = (UIImageView*)[parent viewWithTag:R_id_btn_homepage];
    btn_homepage.userInteractionEnabled = YES;
    [self.gestureEventBinder bindEventsWithType:JWGestureTypeSingleTap toView:btn_homepage willBindSubviews:NO andFilter:nil];
    
    lo_teach_tap_static = (UIImageView*)[parent viewWithTag:R_id_lo_teach_tap_static];
    lo_teachTap_animation = (UIImageView*)[parent viewWithTag:R_id_lo_teach_tap];
    
    return nil;
}

- (void)onStateEnter:(NSDictionary *)data {
    [super onStateEnter:data];
    btn_homepage.userInteractionEnabled = YES;
}

- (void)onStateLeave {
    btn_homepage.userInteractionEnabled = NO;
    [super onStateLeave];
}

- (void)onSingleTap:(UITapGestureRecognizer *)singleTap {
    switch (singleTap.view.tag) {
        case R_id_btn_homepage: {
            mModel.isTeach = NO;
            mModel.isTeachMove = NO;
            id<JIGameEngine> engine = mModel.currentContext.engine;
            id<JIRenderTimer> renderTimer = engine.renderTimer;
            JWOnSnapshotListener* listener = [[JWOnSnapshotListener alloc] init];
            listener.onSnapshot = (^(UIImage* screenshot) {
                Plan* plan = nil;
                if (mModel.currentPlan.sceneDirty) {
                    JCVector3 position = [mModel.currentCamera.camera.transform positionInSpace:JWTransformSpaceWorld];
                    JCQuaternion q = [mModel.currentCamera.camera.transform orientationInSpace:JWTransformSpaceWorld];
                    PlanCamera *p = [[PlanCamera alloc] init];
                    p.px = position.x;
                    p.py = position.y;
                    p.pz = position.z;
                    p.rw = q.w;
                    p.rx = q.x;
                    p.ry = q.y;
                    p.rz = q.z;
                    mModel.currentPlan.camera = p;
                    if (mModel.currentPlan.isSuit) {
                        plan = [mModel.project addSuitPlanToLocal:mModel.currentPlan];
                        plan.isSuit = NO;
                        [plan saveScene];
                        id<JIFile> file = [JWFile fileWithType:JWFileTypeDocument path:@"plans.fit"];
                        LocalPlanTable* pt = [[LocalPlanTable alloc] initWithFileType:LocalPlanTableFileTypeDocument model:mModel bundle:nil]; // 保存的路径在沙盒中
                        [pt saveFile:file records:mModel.project.plans];
                        [plan destroyAllObjects];
                    } else {
                        plan = mModel.currentPlan;
                        [plan saveScene];
                    }
                } else {
                    plan = mModel.currentPlan;
                }
                [UIImagePNGRepresentation(screenshot) writeToFile:plan.preview.realPath atomically:YES];
                [[JWCorePluginSystem instance].imageCache removeBy:plan.preview];
                [mModel.commandMachine clear];
                mModel.currentPlan.isCreatedPlan = YES;
                [self.parentState.parentMachine changeStateTo:[States DIY] pushState:NO];
            });
            CGRect frame = engine.frame.view.frameInPixels;
            JCRect rect = JCRectMake(0.0f, 0.0f, frame.size.width, frame.size.height);
            [renderTimer snapshotByRect:rect async:YES listener:listener];
            break;
        }
        default:
            break;
    }
}

@end
