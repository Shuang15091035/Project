//
//  TutorialPlanEditAddItem.m
//  project_mesher
//
//  Created by mac zdszkj on 16/5/16.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "TutorialPlanEditAddItem.h"
#import "MesherModel.h"
#import "GamePhotographer.h"
#import <jw/JCMath.h>
#import "ProductListAdapter.h"
#import "Item.h"
#import "ItemCreateCommand.h"

@interface TutorialPlanEditAddItem()<UIGestureRecognizerDelegate> {
    ProductListAdapter *mProductAdapter;
    Product* mCurrentProduct;
    JWRelativeLayout *lo_main;
    
    JWRelativeLayout *lo_moving;
    JWFrameLayout *lo_loading;
    
    JWCollectionView* cv_product_list;
    JWFrameLayout *lo_move;
    UIImageView *img_item_preview;
    JWImageOptions *opt_item_preview;
    
    JWRelativeLayout *lo_progress;
    CGPoint mPoint;
    id<JIGameObject> mTempParentForSetNewPosition;
    
    JWRelativeLayout *lo_teach_move;
    UIImageView *lo_teachMove_animation;
    UIImage *img_move_n;
    UIImage *img_move_p;
//    UIImage *img_tap;
//    UIImage *img_anim;
    NSMutableArray *mTeachMoveImages;
    
    NSMutableArray *teachArray;
    JWRelativeLayout *lo_teachMain;
    
    JWRelativeLayout *btn_living_room;
    UIImageView *img_living_room;
    UILabel *tv_living_room;
    
    UIImageView *lo_cg;
    
    BOOL first;
    
    UIImageView *img_moveAnimation;
    CAKeyframeAnimation *pathAnimation_pause;
    CAKeyframeAnimation *pathAnimation_pause2;
    CAKeyframeAnimation *pathAnimation;
    
    BOOL completedAdd;
    JWRelativeLayout *lo_all;
    UIImage *img_sofa;
}

@end

@implementation TutorialPlanEditAddItem

- (UIView *)onCreateView:(UIView *)parent{
    JWRelativeLayout* lo_product_list = (JWRelativeLayout *)[parent viewWithTag:R_id_lo_product_list];
    lo_teachMain = (JWRelativeLayout *)[parent viewWithTag:R_id_lo_teach_main];
    
    lo_main = (JWRelativeLayout*)[parent viewWithTag:R_id_lo_teach_main];
    
    JWLinearLayout *lo_menu_linear = [JWLinearLayout layout];
    lo_menu_linear.layoutParams.width = JWLayoutMatchParent;
    lo_menu_linear.layoutParams.height = JWLayoutMatchParent;
    lo_menu_linear.orientation = JWLayoutOrientationVertical;
    [lo_product_list addSubview:lo_menu_linear];
    
    UIImage *btn_close_n = [UIImage imageByResourceDrawable:@"btn_close_n"];
    UIImageView *btn_close = [[UIImageView alloc] initWithImage:btn_close_n];
    //    btn_close.tag = R_id_btn_close;
    btn_close.layoutParams.width = JWLayoutWrapContent;
    btn_close.layoutParams.height = JWLayoutWrapContent;
    btn_close.layoutParams.marginLeft = [self uiWidthBy:20.0f];
    [lo_menu_linear addSubview:btn_close];
    btn_close.userInteractionEnabled = YES;
    [self.gestureEventBinder bindEventsWithType:JWGestureTypeSingleTap toView:btn_close willBindSubviews:NO andFilter:nil];
    
    UIImage *img_divider_dark_520_img = [UIImage imageByResourceDrawable:@"img_divider_dark_520.png"];
    UIImageView *img_divider_dark_520 = [[UIImageView alloc] initWithImage:img_divider_dark_520_img];
    img_divider_dark_520.layoutParams.width = JWLayoutMatchParent;
    img_divider_dark_520.layoutParams.height = JWLayoutWrapContent;
    img_divider_dark_520.layoutParams.marginLeft = [self uiWidthBy:20.0f];
    img_divider_dark_520.layoutParams.marginRight = [self uiWidthBy:20.0f];
    [lo_menu_linear addSubview:img_divider_dark_520];
    
    JWRelativeLayout *lo_grid = [JWRelativeLayout layout];
    lo_grid.layoutParams.width = JWLayoutMatchParent;
    lo_grid.layoutParams.height = JWLayoutMatchParent;
    lo_grid.layoutParams.marginLeft = [MesherModel uiWidthBy:30.0f];
    lo_grid.layoutParams.marginRight = [MesherModel uiWidthBy:10.0f];
    lo_grid.layoutParams.below = img_divider_dark_520;
    lo_grid.layoutParams.weight = 1.0f;
    [lo_menu_linear addSubview:lo_grid];
    
    cv_product_list = [JWCollectionView collectionView];
    cv_product_list.tag = R_id_gv_product_list;
    cv_product_list.scrollEnabled = NO;
    cv_product_list.layoutParams.width = JWLayoutMatchParent;
    cv_product_list.layoutParams.height = JWLayoutMatchParent;
    [lo_grid addSubview:cv_product_list];
    cv_product_list.backgroundColor = [UIColor whiteColor];
    mProductAdapter = [[ProductListAdapter alloc] init];
    cv_product_list.adapter = mProductAdapter;
    cv_product_list.alwaysBounceVertical = NO;
    cv_product_list.showsHorizontalScrollIndicator = NO;
    cv_product_list.showsVerticalScrollIndicator = NO;
    
    JWRelativeLayout *lo_vertical_line = [JWRelativeLayout layout];
    lo_vertical_line.layoutParams.width = 1;
    lo_vertical_line.layoutParams.height = JWLayoutMatchParent;
    lo_vertical_line.backgroundColor = [UIColor colorWithARGB:R_color_product_list_line];
    lo_vertical_line.layoutParams.alignment = JWLayoutAlignCenterHorizontal;
    [lo_grid addSubview:lo_vertical_line];
    
#pragma mark 物件拖动
    lo_move = (JWFrameLayout*)[parent viewWithTag:R_id_lo_move];
    lo_move.visible = YES;
    
    lo_moving = [JWRelativeLayout layout];
    lo_moving.layoutParams.width = JWLayoutWrapContent;
    lo_moving.layoutParams.height = JWLayoutWrapContent;
    lo_moving.hidden = YES;
    [lo_move addSubview:lo_moving];
    
    img_item_preview = [[UIImageView alloc] init];
    img_item_preview.layoutParams.width = [MesherModel uiWidthBy:500.0f];
    img_item_preview.layoutParams.height = img_item_preview.layoutParams.width;
    [lo_moving addSubview:img_item_preview];
    opt_item_preview = [JWImageOptions options];
    opt_item_preview.requestWidth = [MesherModel uiWidthBy:500.0f];
    opt_item_preview.requestHeight = opt_item_preview.requestWidth;
    
#pragma mark 物件载入loading
    lo_loading = (JWFrameLayout*)[parent viewWithTag:R_id_lo_loading];
    lo_loading.hidden = YES;
//    [self createLoadingAnimationView:lo_loading];
    UITapGestureRecognizer* singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.delegate = self;
    [cv_product_list addGestureRecognizer:singleTapGestureRecognizer];
    UILongPressGestureRecognizer* longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    longPressGestureRecognizer.minimumPressDuration = 0.1f;
    longPressGestureRecognizer.delegate = self;
    [cv_product_list addGestureRecognizer:longPressGestureRecognizer];
    [singleTapGestureRecognizer requireGestureRecognizerToFail:longPressGestureRecognizer];
    
#pragma mark Teach动画
    lo_teach_move = [parent viewWithTag:R_id_lo_teach_move];
    lo_teach_move.hidden = NO;
    
#pragma mark moveAnimation
    lo_all = [JWRelativeLayout layout];
    lo_all.layoutParams.width = JWLayoutWrapContent;
    lo_all.layoutParams.height = JWLayoutWrapContent;
    [lo_teach_move addSubview:lo_all];
        
    img_moveAnimation = [UIImageView new];
    img_moveAnimation.layoutParams.width = [MesherModel uiWidthBy:500.0f];
    img_moveAnimation.layoutParams.height = opt_item_preview.requestWidth;
    [lo_all addSubview:img_moveAnimation];
    
    btn_living_room = (JWRelativeLayout*)[parent viewWithTag:R_id_btn_living_room_t];
    img_living_room = (UIImageView*)[parent viewWithTag:R_id_img_living_room_t];
    tv_living_room = (UILabel*)[parent viewWithTag:R_id_tv_living_room_t];
    
    lo_teachMove_animation = [UIImageView new];
    lo_teachMove_animation.layoutParams.width = JWLayoutWrapContent;
    lo_teachMove_animation.layoutParams.height = JWLayoutWrapContent;
    img_move_n = [UIImage imageByResourceDrawable:@"teach_move_n"];
    img_move_p = [UIImage imageByResourceDrawable:@"teach_move_p"];
    lo_teachMove_animation.image = img_move_p;
    
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        lo_teachMove_animation.layoutParams.alignment = JWLayoutAlignParentBottom | JWLayoutAlignCenterHorizontal;
        lo_teachMove_animation.layoutParams.marginBottom = img_move_p.size.height/1.5;
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        lo_teachMove_animation.layoutParams.alignment = JWLayoutAlignParentBottom | JWLayoutAlignCenterHorizontal;
        lo_teachMove_animation.layoutParams.marginBottom = img_move_p.size.height/3;
    }

    
    [lo_all addSubview:lo_teachMove_animation];
    
#pragma mark undo redo
    btn_undo = (UIImageView*)[parent viewWithTag:R_id_btn_undo];
    btn_redo = (UIImageView*)[parent viewWithTag:R_id_btn_redo];
    
    lo_cg = (UIImageView*)[parent viewWithTag:R_id_lo_cg];
    
    return lo_product_list;
}

- (void)onStateEnter:(NSDictionary *)data {
    [super onStateEnter:data];
    [self updateUndoRedoState];
    
    lo_all.alpha = 1.0f;
    completedAdd = NO;
    first = YES;
    lo_teach_move.hidden = NO;
    lo_teachMove_animation.alpha = 1.0f;
    img_moveAnimation.hidden = YES;
    
#pragma mark 载入本地数据
    if (teachArray == nil) {
        teachArray = [NSMutableArray array];
    }
    [teachArray arrayByAddingObjectsFromArray:[mModel.project getProductsByArea:mModel.currentArea]];
    for (Product* product in [mModel.project getProductsByArea:mModel.currentArea]) {
        Item *it = product.items[0];
        if (it.Id == 21) {
            [teachArray add:product];
            [[JWCorePluginSystem instance].imageCache getBy:it.preview options:opt_item_preview async:NO onGet:^(UIImage *image) {
                img_sofa = image;
            }];
        }
    }
    for (Product* product in [mModel.project getProductsByArea:mModel.currentArea]) {
        Item *it = product.items[0];
        if (it.Id == 21) {
            continue;
        }
        [teachArray add:product];
    }
    
    mProductAdapter.data = teachArray;
    [mProductAdapter notifyDataSetChanged];//必写
    
    TutorialPlanEditAddItem* weakSelf = self;
    __block id<IMesherModel> model = mModel;
    mModel.itemSelectAndMoveBehaviour.selectedMask = SelectedMaskAllArchsExceptCeil | SelectedMaskAllItemsExceptTop;
    mModel.itemSelectAndMoveBehaviour.onSelect = (^(id<JIGameObject> object) {
        if (object == nil) {
            return;
        }
        ItemInfo *it = [Data getItemInfoFromInstance:object];
        if (it.type == ItemTypeItem) {
            [weakSelf.parentMachine changeStateTo:[States TeachItemEdit]];
        } else if (it.type != ItemTypeItem && it.type != ItemTypeCeil) {
            model.borderObject = object;
            [weakSelf.parentMachine changeStateTo:[States TeachArchitureEdit] pushState:NO];
        }
    });
    
    mModel.itemSelectAndMoveBehaviour.canMove = NO;
    mModel.photographer.cameraEnabled = YES;

    img_moveAnimation.image = img_sofa;

    CGPoint firstCellCenter = CGPointMake([self uiWidthBy:120.0f] + lo_teachMove_animation.image.size.width/2, [self uiHeightBy:164.0f] + lo_teachMove_animation.image.size.height);
    CGPoint pointInScreen = [cv_product_list convertPoint:firstCellCenter toView:lo_teachMove_animation.superview];
    
    pathAnimation_pause = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation_pause.calculationMode = kCAAnimationLinear;
    pathAnimation_pause.fillMode = kCAFillModeForwards;
    pathAnimation_pause.removedOnCompletion = NO;
    pathAnimation_pause.duration = 1.5f;
    pathAnimation_pause.repeatCount = 1; // 循环次数
    CGMutablePathRef path_s = CGPathCreateMutable();
    CGPathMoveToPoint(path_s, NULL, pointInScreen.x ,pointInScreen.y);
    CGPathAddLineToPoint(path_s, NULL, pointInScreen.x+1, pointInScreen.y+1);
    // 最后2个值为初始点位置
    pathAnimation_pause.path = path_s;
    CGPathRelease(path_s);
    pathAnimation_pause.delegate = self;
    [pathAnimation_pause setValue:@"pause" forKey:@"pause"];
    
    pathAnimation_pause2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation_pause2.calculationMode = kCAAnimationLinear;
    pathAnimation_pause2.fillMode = kCAFillModeForwards;
    pathAnimation_pause2.removedOnCompletion = NO;
    pathAnimation_pause2.duration = 1.0f;
    pathAnimation_pause2.repeatCount = 1; // 循环次数
    CGMutablePathRef path_s2 = CGPathCreateMutable();
    CGPathMoveToPoint(path_s2, NULL, pointInScreen.x ,pointInScreen.y);
    CGPathAddLineToPoint(path_s2, NULL, pointInScreen.x-1, pointInScreen.y-1);
    pathAnimation_pause2.path = path_s2;
    CGPathRelease(path_s2);
    pathAnimation_pause2.delegate = self;
    [pathAnimation_pause2 setValue:@"pause2" forKey:@"pause2"];
    
    pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationLinear;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = 2.0f;
    pathAnimation.repeatCount = 1; // 循环次数
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, pointInScreen.x ,pointInScreen.y);
    // 最后2个值为初始点位置
    CGPathAddQuadCurveToPoint(path, NULL, pointInScreen.x - [self uiWidthBy:10.0f], [UIScreen mainScreen].bounds.size.height/2 - [self uiHeightBy:10.0f], [UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
//    CGPathAddLineToPoint(path, NULL, [UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    // 第三个值开始 切线点的位置 结束点的位置
    pathAnimation.delegate = self;
    [pathAnimation setValue:@"move" forKey:@"move"];
    
    //    CGPathMoveToPoint(path, NULL, 300 , 0);
    //    CGPathAddQuadCurveToPoint(path, NULL, 0, 0, 0, 300);
    pathAnimation.path = path;
    CGPathRelease(path);
    
    [lo_all.layer addAnimation:pathAnimation_pause forKey:@"Animation"];
}

- (void)onStateLeave {
    [lo_teachMove_animation.layer removeAllAnimations];
    pathAnimation_pause = nil;
    pathAnimation_pause2 = nil;
    pathAnimation = nil;
    mModel.itemSelectAndMoveBehaviour.onSelect = nil;
    [lo_teachMove_animation stopAnimating];
    lo_teach_move.hidden = YES;
    [super onStateLeave];
}

- (void)onLongPress:(UILongPressGestureRecognizer *)longPress {
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            mModel.isTeach = NO;
            CGPoint p = [longPress locationInView:cv_product_list];
            NSIndexPath* i = [cv_product_list indexPathForItemAtPoint:p];
            if (i == nil || i.row != 0) {
                break;
            }
            img_item_preview.visible = YES;
            mCurrentProduct = [mProductAdapter getItemAt:i.row];
            if (mCurrentProduct.preview != nil){
                [[JWCorePluginSystem instance].imageCache getBy:mCurrentProduct.preview options:opt_item_preview async:YES onGet:^(UIImage *image) {
                    img_item_preview.image = image;
                }];
            }
            lo_moving.visible = YES;
            CGPoint point = [longPress locationInView:lo_move];
            lo_moving.layoutParams.marginLeft = point.x - img_item_preview.frame.size.width * 0.5f;
            lo_moving.layoutParams.marginTop = point.y - img_item_preview.frame.size.height * 0.5f;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (mCurrentProduct == nil) {
                break;
            }
            CGPoint point = [longPress locationInView:lo_move];
            lo_moving.layoutParams.marginLeft = point.x - img_item_preview.frame.size.width * 0.5f;
            lo_moving.layoutParams.marginTop = point.y - img_item_preview.frame.size.height * 0.5f;
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if (mCurrentProduct == nil) {
                break;
            }
            CGPoint p = [longPress locationInView:cv_product_list];
            mModel.teachTouchUpPoint = [cv_product_list convertPoint:p toView:lo_teachMain];
            NSIndexPath* i = [cv_product_list indexPathForItemAtPoint:p];
            img_item_preview.visible = NO;
            if (i == nil) {
                CGPoint point = [longPress positionInPixelsInView:lo_move];
                mPoint = point;
                if(mCurrentProduct.area == AreaArchitecture && mModel.currentPlan.architectureObject != nil) {  // 新建户型，并让用户选择是否要删除现有场景
                    [JWAppUtils showDialogWithTitle:@"新建户型" message:@"是否清除场景？" onButtonChecked:^(NSInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            [mModel.currentPlan destroyAllObjects];// 移除原先的户型
                            mModel.selectedObject = nil;
                            mModel.preSelectedObject = nil;
                            [mModel.commandMachine clear];// 场景清空后把commandMachine命令清除
                            mModel.currentPlan.fileDirty = YES;
                            mModel.currentPlan.sceneDirty = YES;
                            [self loadProduct:mCurrentProduct atPoint:mPoint];
                            mModel.borderObject = nil;
                        }
                    } cancelButton:@"取消" otherButtons:@"确认", nil];
                } else { // 直接加载产品
                    if (mCurrentProduct.position == PositionOnWall) {
                        id<JIGameScene> scene = mModel.currentScene; // 获取场景
                        scene.rayQuery.willSortByDistance = YES; // 射线查询 按照距离排序 为了找到射线的第一个目标对象
                        scene.rayQuery.mask = SelectedMaskAllArchsExceptCeil | SelectedMaskAllItemsExceptTop;// 可以优化
                        id<JIRayQueryResult> result = [scene getCameraRayQueryResultFromScreenX:point.x screenY:point.y]; // 通过点 来获取射线
                        if (result.numEntries > 0) { // result 是个列表(包含了距离 和 物件) 是射线穿过的物件
                            id<JIGameObject> wall;
                            for (int i = 0; i < result.numEntries; i++) {
                                JWRayQueryResultEntry* e = [result entryAt:i];
                                ItemInfo *itemInfo = [Data getItemInfoFromInstance:e.object];
                                if (itemInfo.type == ItemTypeWall) {
                                    wall = e.object;
                                    break;
                                }
                            }
                            if (wall == nil) {
                                lo_moving.visible = YES;
                            }else {
                                ItemInfo *itemInfo = [Data getItemInfoFromInstance:wall];
                                JCVector2 cameraXY = [mModel.currentCamera.camera getCoordinatesFromScreenX:point.x screenY:point.y];
                                JCRay3 ray = [mModel.currentCamera.camera getRayFromX:cameraXY.x screenY:cameraXY.y];
                                JCVector3 normal = JCVector3Make([itemInfo.dx floatValue], [itemInfo.dy floatValue], [itemInfo.dz floatValue]);
                                
                                JCFloat distance = fabsf([itemInfo.dx floatValue] * wall.transformBounds.min.x + [itemInfo.dy floatValue] * wall.transformBounds.min.y + [itemInfo.dz floatValue] * wall.transformBounds.min.z);//原点到平面的距离
                                JCPlane ground = JCPlaneMake(normal, distance);//平面的位置
                                JCRayPlaneIntersectResult result = JCRayPlaneIntersect(&ray, &ground);
                                result.point = JCRayPlaneIntersectResultGetHitPoint(&result, &ray);
                                JCVector3 newPosition = JCVector3Zero();
                                if (result.hit) {
                                    newPosition = result.point;// 点击到的墙的点
                                }
                                //为了不和墙体重叠 离墙0.01
                                if([itemInfo.dx intValue] != 0) {
                                    if ([itemInfo.dx intValue] > 0){
                                        newPosition.x += 0.01f;
                                    }else {
                                        newPosition.x -= 0.01f;
                                    }
                                }else if ([itemInfo.dz intValue] != 0){
                                    if ([itemInfo.dz intValue] > 0){
                                        newPosition.z += 0.01f;
                                    }else {
                                        newPosition.z -= 0.01f;
                                    }
                                }
                                
                                Item* item = [mCurrentProduct.items at:0];
                                //异步加载 创建监听
                                JWSceneLoaderOnLoadingListener* listener = [[JWSceneLoaderOnLoadingListener alloc] init];
                                listener.onFinish = (^(id<JIFile> file, id<JIGameObject> parent, id<JIGameObject> object){
                                    mModel.selectedObject = object;
                                    mCurrentProduct = nil;
//                                    [self stopLoadingAnimation];
                                    lo_loading.hidden = YES;
                                    lo_moving.hidden = YES;
                                    lo_move.clickable = NO;
                                    ItemInfo *info = [ItemInfo new];
                                    info.type = ItemTypeItem;
                                    [Data bindInstance:object toItemInfo:info];
                                    [self.parentMachine changeStateTo:[States TeachItemEdit] pushState:NO];
                                });
                                listener.onFailed = (^(id<JIFile> file, id<JIGameObject> parent, NSError* error){
                                    NSLog(@"加载失败");
//                                    [self stopLoadingAnimation];
                                    lo_loading.hidden = YES;
                                    lo_moving.hidden = YES;
                                    lo_move.clickable = NO;
                                });
                                lo_move.clickable = YES;
                                lo_moving.hidden = NO;
//                                [self startLoadingAnimation];
                                lo_loading.hidden = NO;
                                [mModel.currentPlan loadItem:item position:newPosition orientation:JCQuaternionIdentity() async:NO listener:listener];
                                JCVector3 selectObjZ = [mModel.selectedObject.transform zAxisInSpace:JWTransformSpaceWorld];
                                float d = JCVector3DotProductv(&normal, &selectObjZ);
                                float radians = acosf(d);
                                float degrees = JCRad2Deg(radians); // 旋转的角度
                                if ([itemInfo.dx intValue] < 0) {
                                    degrees =  -degrees;//比较特殊的面
                                }
                                [mModel.selectedObject.transform rotateUpDegrees:degrees];
                                ItemCreateCommand *command = [[ItemCreateCommand alloc] init];
                                command.object = mModel.selectedObject;
                                command.plan = mModel.currentPlan;
                                command.gridsObject = mModel.gridsObject;
                                [mModel.commandMachine doneCommand:command];
                                [self updateUndoRedoState];
                            }
                        }else {
                            lo_moving.visible = YES;
                        }
                    }else if (mCurrentProduct.position == PositionInWall) {
                        id<JIGameScene> scene = mModel.currentScene; // 获取场景
                        scene.rayQuery.willSortByDistance = YES; // 射线查询 按照距离排序 为了找到射线的第一个目标对象
                        scene.rayQuery.mask = SelectedMaskAllArchsExceptCeil;// 可以优化
                        id<JIRayQueryResult> result = [scene getCameraRayQueryResultFromScreenX:point.x screenY:point.y]; // 通过点 来获取射线
                        id<JIGameObject> wall;
                        for (int i = 0; i < result.numEntries; i++) {
                            JWRayQueryResultEntry* e = [result entryAt:i];
                            ItemInfo *itemInfo = [Data getItemInfoFromInstance:e.object];
                            if (itemInfo.type == ItemTypeWall) {
                                wall = e.object;
                                break;
                            }
                        }
                        if (wall == nil) {
                            [self loadProduct:mCurrentProduct atPoint:point];
                        }else {
                            ItemInfo *itemInfo = [Data getItemInfoFromInstance:wall];
                            JCVector2 cameraXY = [mModel.currentCamera.camera getCoordinatesFromScreenX:point.x screenY:point.y];
                            JCRay3 ray = [mModel.currentCamera.camera getRayFromX:cameraXY.x screenY:cameraXY.y];
                            JCVector3 normal = JCVector3Make([itemInfo.dx floatValue], [itemInfo.dy floatValue], [itemInfo.dz floatValue]);
                            
                            JCFloat distance = fabsf([itemInfo.dx floatValue] * wall.transformBounds.min.x + [itemInfo.dy floatValue] * wall.transformBounds.min.y + [itemInfo.dz floatValue] * wall.transformBounds.min.z);//原点到平面的距离
                            JCPlane ground = JCPlaneMake(normal, distance);//平面的位置
                            JCRayPlaneIntersectResult result = JCRayPlaneIntersect(&ray, &ground);
                            result.point = JCRayPlaneIntersectResultGetHitPoint(&result, &ray);
                            JCVector3 newPosition = JCVector3Zero();
                            if (result.hit) {
                                newPosition = result.point;// 点击到的墙的点
                            }
                            //为了不和墙体重叠 离墙0.01
                            if([itemInfo.dx intValue] != 0) {
                                if ([itemInfo.dx intValue] > 0){
                                    newPosition.x += 0.01f;
                                }else {
                                    newPosition.x -= 0.01f;
                                }
                            }else if ([itemInfo.dz intValue] != 0){
                                if ([itemInfo.dz intValue] > 0){
                                    newPosition.z += 0.01f;
                                }else {
                                    newPosition.z -= 0.01f;
                                }
                            }
                            newPosition.y = 0.01;
                            Item* item = [mCurrentProduct.items at:0];
                            //异步加载 创建监听
                            JWSceneLoaderOnLoadingListener* listener = [[JWSceneLoaderOnLoadingListener alloc] init];
                            listener.onFinish = (^(id<JIFile> file, id<JIGameObject> parent, id<JIGameObject> object){
                                mModel.selectedObject = object;
                                mCurrentProduct = nil;
//                                [self stopLoadingAnimation];
                                lo_loading.hidden = YES;
                                lo_moving.hidden = YES;
                                lo_move.clickable = NO;
                                ItemInfo *info = [ItemInfo new];
                                info.type = ItemTypeItem;
                                [Data bindInstance:object toItemInfo:info];
                                [self.parentMachine changeStateTo:[States TeachItemEdit] pushState:NO];
                            });
                            listener.onFailed = (^(id<JIFile> file, id<JIGameObject> parent, NSError* error){
                                NSLog(@"加载失败");
//                                [self stopLoadingAnimation];
                                lo_loading.hidden = YES;
                                lo_moving.hidden = YES;
                                lo_move.clickable = NO;
                            });
                            lo_move.clickable = YES;
                            lo_moving.hidden = NO;
//                            [self startLoadingAnimation];
                            lo_loading.hidden = NO;
                            [mModel.currentPlan loadItem:item position:newPosition orientation:JCQuaternionIdentity() async:NO listener:listener];
                            JCVector3 selectObjZ = [mModel.selectedObject.transform zAxisInSpace:JWTransformSpaceWorld];
                            float d = JCVector3DotProductv(&normal, &selectObjZ);
                            float radians = acosf(d);
                            float degrees = JCRad2Deg(radians); // 旋转的角度
                            if ([itemInfo.dx intValue] < 0) {
                                degrees =  -degrees;//比较特殊的面
                            }
                            [mModel.selectedObject.transform rotateUpDegrees:degrees];
                            ItemCreateCommand *command = [[ItemCreateCommand alloc] init];
                            command.object = mModel.selectedObject;
                            command.plan = mModel.currentPlan;
                            command.gridsObject = mModel.gridsObject;
                            [mModel.commandMachine doneCommand:command];
                            [self updateUndoRedoState];
                        }
                    }else {
                        [self loadProduct:mCurrentProduct atPoint:point];
                    }
                }
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            if (mCurrentProduct == nil) {
                break;
            }
            lo_moving.visible = NO;
            break;
        }
        default: {
            break;
        }
    }
}

- (void) loadProduct:(Product*)product atPoint:(CGPoint)point {
    if (product.items == nil || product.items.count == 0) {
        return;
    }
    Item* item = [product.items at:0];
    [self loadItem:item atPoint:point];
}

- (void) loadItem:(Item*)item atPoint:(CGPoint)point {
    // 计算出生位置
    JCVector3 newPosition = JCVector3Zero();
    if (item.product.area != AreaArchitecture) {
        JCRayPlaneIntersectResult result = [mModel.currentScene getCameraRayToUnitYZeroPlaneResultFromScreenX:point.x screenY:point.y];
        if (result.hit) {
            newPosition = result.point;
        }
        newPosition.y = 0.02f; // 放到地上
    }
    mModel.teachMoveLastPosition = newPosition;
    //异步加载 创建监听
    JWSceneLoaderOnLoadingListener* listener = [[JWSceneLoaderOnLoadingListener alloc] init];
    listener.onFinish = (^(id<JIFile> file, id<JIGameObject> parent, id<JIGameObject> object){
        mModel.selectedObject = object;
        mCurrentProduct = nil;
        lo_all.alpha = 0.0f;
        ItemCreateCommand *command = [[ItemCreateCommand alloc] init];
        command.object = object;
        command.plan = mModel.currentPlan;
        command.gridsObject = mModel.gridsObject;
        //[mModel.commandMachine todoCommand:command];
        [mModel.commandMachine doneCommand:command];
        [self updateUndoRedoState];
        if (item.product.area == AreaArchitecture) { // NOTE 户型不能点击或编辑
            [self.parentMachine revertState];
        } else {
            [lo_teachMove_animation.layer removeAllAnimations];
            lo_teachMove_animation.alpha = 0.0f;
            completedAdd = YES;
            img_moveAnimation.hidden = YES;
            [UIView animateWithDuration:2.5 animations:^{
                lo_cg.alpha = 1.0f;
                [lo_cg startAnimating];
            } completion:^(BOOL finished) {
                lo_cg.alpha = 1.0f;
                [UIView animateWithDuration:1.0f animations:^{
                    lo_cg.alpha = 0.0f;
                } completion:^(BOOL finished) {
                    [lo_cg stopAnimating];
                    // 直接进入编辑状态
                    UIImage *btn_living_room_n = [UIImage imageByResourceDrawable:@"btn_living_room_n.png"];
                    img_living_room.image = btn_living_room_n;
                    btn_living_room.backgroundColor = [UIColor clearColor];
                    tv_living_room.textColor = [UIColor whiteColor];
                    ItemInfo *info = [ItemInfo new];
                    info.type = ItemTypeItem;
                    [Data bindInstance:object toItemInfo:info];
                    [self.parentMachine changeStateTo:[States EducationItemEdit] pushState:NO];//不压栈
                }];
            }];
        }
        lo_loading.hidden = YES;
        lo_moving.hidden = YES;
        lo_move.clickable = NO;
    });
    listener.onFailed = (^(id<JIFile> file, id<JIGameObject> parent, NSError* error){
        NSLog(@"加载失败");
        lo_loading.hidden = YES;
        lo_moving.hidden = YES;
        lo_move.clickable = NO;
    });
    lo_move.clickable = YES;
    lo_moving.hidden = NO;
    lo_loading.hidden = NO;
    completedAdd = YES;
    img_moveAnimation.hidden = YES;
    [mModel.currentPlan loadItem:item position:newPosition orientation:JCQuaternionIdentity() async:YES listener:listener];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString *an = [anim valueForKey:@"move"];
    if ([an isEqual:@"move"]) {
        [lo_all.layer removeAllAnimations];
        [lo_all.layer addAnimation:pathAnimation_pause forKey:@"pause"];
        lo_teachMove_animation.image = img_move_p;
        img_moveAnimation.hidden = YES;
    }
    NSString *an_p = [anim valueForKey:@"pause"];
    if ([an_p isEqual:@"pause"]) {
        [lo_all.layer removeAllAnimations];
        [lo_all.layer addAnimation:pathAnimation_pause2 forKey:@"pause2"];
        lo_teachMove_animation.image = img_move_n;
        img_moveAnimation.hidden = NO;
    }
    NSString *an_p2 = [anim valueForKey:@"pause2"];
    if ([an_p2 isEqual:@"pause2"]) {
        [lo_all.layer removeAllAnimations];
        [lo_all.layer addAnimation:pathAnimation forKey:@"move"];
        lo_teachMove_animation.image = img_move_n;
        img_moveAnimation.hidden = NO;
    }
}

@end
