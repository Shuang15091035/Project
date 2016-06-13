//
//  InspiratedProductList.m
//  project_mesher
//
//  Created by mac zdszkj on 16/4/7.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "InspiratedProductList.h"
#import "MesherModel.h"
#import <jw/JCMath.h>
#import "Item.h"
#import "ItemCreateCommand.h"
#import "ProductListAdapter.h"

@interface InspiratedProductList () <UIGestureRecognizerDelegate> {
    ProductListAdapter *mProductAdapter;
    Product* mCurrentProduct;
    
    JWRelativeLayout *lo_moving;
    JWFrameLayout *lo_loading;
    
    JWCollectionView* cv_product_list;
    JWFrameLayout *lo_move;
    UIImageView *img_item_preview;
    JWImageOptions *opt_item_preview;
    
    JWRelativeLayout *lo_progress;
    CGPoint mPoint;
    id<JIGameObject> mTempParentForSetNewPosition;
}
@end

@implementation InspiratedProductList

- (UIView *)onCreateView:(UIView *)parent {
    JWRelativeLayout *lo_inspiratedProductList = (JWRelativeLayout*)[parent viewWithTag:R_id_lo_inspirate_product_list];
    
    JWLinearLayout *lo_menu_linear = [JWLinearLayout layout];
    lo_menu_linear.layoutParams.width = JWLayoutMatchParent;
    lo_menu_linear.layoutParams.height = JWLayoutMatchParent;
    lo_menu_linear.orientation = JWLayoutOrientationVertical;
    [lo_inspiratedProductList addSubview:lo_menu_linear];
    
    UIImage *btn_close_n = [UIImage imageByResourceDrawable:@"btn_close_n"];
    UIImageView *btn_close = [[UIImageView alloc] initWithImage:btn_close_n];
    btn_close.tag = R_id_btn_close;
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
    
//    cv_product_list.control.tag = R_id_gv_product_list;
    
    UITapGestureRecognizer* singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.delegate = self;
    [cv_product_list addGestureRecognizer:singleTapGestureRecognizer];
    UILongPressGestureRecognizer* longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    longPressGestureRecognizer.minimumPressDuration = 0.3f;
    longPressGestureRecognizer.delegate = self;
    [cv_product_list addGestureRecognizer:longPressGestureRecognizer];
    [singleTapGestureRecognizer requireGestureRecognizerToFail:longPressGestureRecognizer];

#pragma mark undo redo
    btn_undo = (UIImageView*)[parent viewWithTag:R_id_btn_undo];
    btn_redo = (UIImageView*)[parent viewWithTag:R_id_btn_redo];

    return lo_inspiratedProductList;
}

- (void)onStateEnter:(NSDictionary *)data {
    [super onStateEnter:data];
    [self updateUndoRedoState];
    
#pragma mark 载入本地数据
    mProductAdapter.data = [mModel.project getProductsByArea:mModel.currentArea];
    [mProductAdapter notifyDataSetChanged];//必写
    
    InspiratedProductList* weakSelf = self;
//    __block id<IMesherModel> model = mModel;
    mModel.inspiratedBehaviour.selectedMask = SelectedMaskAllArchs | SelectedMaskAllItems;
    mModel.inspiratedBehaviour.onSelect = (^(id<JIGameObject> object) {
        if (object == nil) {
            return;
        }
        [weakSelf.parentMachine changeStateTo:[States InspiratedItemEdit]];
    });
    
    mModel.inspiratedBehaviour.canMove = NO;
}

- (void)onStateLeave {
    mModel.inspiratedBehaviour.onSelect = nil;
    [super onStateLeave];
}

- (void)onSingleTap:(UITapGestureRecognizer *)singleTap{
    switch (singleTap.view.tag) {
        case R_id_btn_close:{
            [self.parentMachine revertState];
            break;
        }
        case R_id_gv_product_list: {
            switch (singleTap.state) {
                case UIGestureRecognizerStateEnded:{
                    CGPoint p = [singleTap locationInView:cv_product_list];
                    NSIndexPath* i = [cv_product_list indexPathForItemAtPoint:p];
                    if (i == nil) {
                        break;
                    }
                    mCurrentProduct = [mProductAdapter getItemAt:i.row];
                    if (mCurrentProduct.preview != nil){
                        [[JWCorePluginSystem instance].imageCache getBy:mCurrentProduct.preview options:opt_item_preview async:YES onGet:^(UIImage *image) {
                            img_item_preview.image = image;
                        }];
                    }
                    mModel.currentProduct = mCurrentProduct;
                    [self.parentMachine changeStateTo:[States InspiratedProductInfo]];
                    break;
                }
                case UIGestureRecognizerStateCancelled:
                case UIGestureRecognizerStateFailed: {
                    if (mCurrentProduct == nil) {
                        break;
                    }
                    break;
                }
                default:
                    break;
            }
        }
        default:
            break;
    }
}

- (void)onLongPress:(UILongPressGestureRecognizer *)longPress {
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            CGPoint p = [longPress locationInView:cv_product_list];
            NSIndexPath* i = [cv_product_list indexPathForItemAtPoint:p];
            if (i == nil) {
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
            NSIndexPath* i = [cv_product_list indexPathForItemAtPoint:p];
            img_item_preview.visible = NO;
            if (i == nil) {
                CGPoint point = [longPress positionInPixelsInView:lo_move];
                mPoint = point;
                if(mCurrentProduct.area == AreaArchitecture && mModel.currentPlan.architectureObject != nil) {  // 新建场景，并让用户选择是否要删除现有场景
                    [JWAppUtils showDialogWithTitle:@"新建场景" message:@"是否清除场景？" onButtonChecked:^(NSInteger buttonIndex) {
//                        if (buttonIndex == 1) {
//                            [mModel.currentPlan destroyAllObjects];// 移除原先的户型
//                            mModel.selectedObject = nil;
//                            mModel.preSelectedObject = nil;
//                            [mModel.commandMachine clear];// 场景清空后把commandMachine命令清除
//                            mModel.currentPlan.fileDirty = YES;
//                            mModel.currentPlan.sceneDirty = YES;
//                            [self loadProduct:mCurrentProduct atPoint:mPoint];
//                            mModel.borderObject = nil;
//                        }
                        //逻辑重写 改为替换背景 删除物件
                    } cancelButton:@"取消" otherButtons:@"确认", nil];
                } else { // 直接加载产品
                    [self loadProduct:mCurrentProduct atPoint:point];
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
        [self.parentMachine revertState];
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
        newPosition.y = 0.01f; // 放到地上
    }
    //异步加载 创建监听
    JWSceneLoaderOnLoadingListener* listener = [[JWSceneLoaderOnLoadingListener alloc] init];
    listener.onFinish = (^(id<JIFile> file, id<JIGameObject> parent, id<JIGameObject> object){
        mModel.selectedObject = object;
        mCurrentProduct = nil;
        
        ItemCreateCommand *command = [[ItemCreateCommand alloc] init];
        command.object = object;
        command.plan = mModel.currentPlan;
        command.gridsObject = mModel.gridsObject;
        [mModel.commandMachine doneCommand:command];
        [self updateUndoRedoState];
        if (item.product.area == AreaArchitecture) { // NOTE 户型不能点击或编辑
            [self.parentMachine revertState];
        } else {
            // 直接进入编辑状态
            ItemInfo *info = [ItemInfo new];
            info.type = ItemTypeItem;
            [Data bindInstance:object toItemInfo:info];
            [self.parentMachine changeStateTo:[States InspiratedItemEdit] pushState:NO];//不压栈
        }
//        [self stopLoadingAnimation];
        lo_loading.hidden = YES;
        lo_moving.hidden = YES;
        lo_move.clickable = NO;
    });
    listener.onFailed = (^(id<JIFile> file, id<JIGameObject> parent, NSError* error){
        NSLog(@"加载失败");
//        [self stopLoadingAnimation];
        lo_loading.hidden = YES;
        lo_moving.hidden = YES;
        lo_move.clickable = NO;
    });
    lo_move.clickable = YES;
    lo_moving.hidden = NO;
//    [self startLoadingAnimation];
    lo_loading.hidden = NO;
    [mModel.currentPlan loadItem:item position:newPosition orientation:JCQuaternionIdentity() async:YES listener:listener];
}

@end
