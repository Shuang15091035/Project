//
//  ArchitureEdit.m
//  project_mesher
//
//  Created by mac zdszkj on 16/1/6.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "ArchitureEdit.h"
#import "WallLayout.h"
#import "MesherModel.h"
#import "WallAdapter.h"
#import "UpdateTextureCommand.h"
#import "Vertex.h"
#import "GamePhotographer.h"
#import "ArchCameraBehaviour.h"
#import "TextureAdapter.h"
#import <ctrlcv/CCVVector3.h>

@interface ArchitureEdit () <ICVOnResourceLoadingListener> {
    CCVRelativeLayout *lo_WallEdit;
    UIImageView *centerImage;
    CCVCollectionView *cv_color;
    WallAdapter *mWallAdapter;
    CCVLinearLayout *lo_camera;
    
    CCVRelativeLayout *lo_ArchitureDetails;
    UIImageView* img_details_image;
    CCVImageOptions* opt_img_details_image;
    CCVRadioViewGroup *rg_option;
    UIButton *btn_change_texture;
    CCVCollectionView *cv_texture;
    CCVRelativeLayout *lo_texture;
    TextureAdapter *mTextureAdapter;
    CCVRelativeLayout *lo_button1_line1;
    
    CCVFrameLayout* lo_object_menu_container; // 物件上的菜单容器
    CCVLinearLayout* lo_object_menu;
    id<ICVViewTag> mArchitureEditMenu;
    
    id<ICVTexture> texture;
    id<ICVMaterial> material;
    id<ICVMaterial> tempMaterial;
    CCVAsyncResult *result; // 异步载入贴图的返回信息 可用于取消异步加载
    
    BOOL isReplace;
    NSMutableArray *architures;
    NSString *tempExtension;
    
    NSMutableArray *angles;
}

@end

@implementation ArchitureEdit

- (UIView *)onCreateView:(UIView *)parent {
    lo_camera = [parent viewWithTag:R_id_lo_camera];
    
    lo_WallEdit = [CCVRelativeLayout layout];
    lo_WallEdit.tag = R_id_lo_wall_edit;
    lo_WallEdit.layoutParams.width = mModel.gameViewWidth;
    lo_WallEdit.layoutParams.height = CCVLayoutMatchParent;
    lo_WallEdit.backgroundColor = [UIColor clearColor];
    lo_WallEdit.layoutParams.alignment = CCVLayoutAlignParentBottomLeft;
    [parent addSubview:lo_WallEdit];
    
    WallLayout *wallLayout = [[WallLayout alloc] init];
    wallLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat width = mModel.gameViewWidth/2 - [MesherModel uiWidthBy:50.0f];
    wallLayout.headerReferenceSize = CGSizeMake(width, [MesherModel uiHeightBy:150.0f]);
    wallLayout.footerReferenceSize = CGSizeMake(width, [MesherModel uiHeightBy:150.0f]);
    cv_color = [[CCVCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:wallLayout];
    cv_color.backgroundColor = [UIColor whiteColor];
    cv_color.layoutParams.width = mModel.gameViewWidth;
    cv_color.layoutParams.height = [MesherModel uiHeightBy:150.0f];
    cv_color.layoutParams.alignment = CCVLayoutAlignParentBottomLeft;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        cv_color.layoutParams.marginBottom = [MesherModel uiHeightBy:-30.0f];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        cv_color.layoutParams.marginBottom = [MesherModel uiHeightBy:-10.0f];
    }
    [lo_WallEdit addSubview:cv_color];
    mWallAdapter = [[WallAdapter alloc] init];
    cv_color.adapter = mWallAdapter;
    cv_color.alwaysBounceVertical = NO;
    cv_color.showsHorizontalScrollIndicator = NO;
    cv_color.showsVerticalScrollIndicator = NO;
    //cv_color.bounces = NO; // 弹簧效果
    __block typeof(self)weakSelf = self;
    __block CCVCollectionView *cv_color_b = cv_color;
    __block id<IMesherModel> model = mModel;
    __block CCVAsyncResult *result_b = result;
    __block CCVRelativeLayout *lo_WallEdit_b = lo_WallEdit;
    cv_color.onScrolled = ^(id<ICVAdapterView> view, NSUInteger firstVisibleItem, NSUInteger visibleItemCount, NSUInteger totalItemCount) { // 滚动结束后调用
        //    // 将p相对于AV的坐标转成相对于BV的坐标
        //    //                   AV                          p                   BV
        //    CGPoint pInView = [lo_Center convertPoint:lo_Center.center toView:cv_plans];
        CGPoint cv_center = CGPointMake(mModel.gameViewWidth/2, [UIScreen mainScreen].bounds.size.height - [MesherModel uiHeightBy:75.0f]); // 获取屏幕水平中心的某一个点
        CGPoint inView = [lo_WallEdit_b convertPoint:cv_center toView:cv_color_b];
        NSIndexPath* i = [cv_color_b indexPathForItemAtPoint:inView];
        Source *s = [weakSelf getSourceBy:i.row];
        [weakSelf loadPVR:s];
        [weakSelf loadTextureByFile:s.file];
        ItemInfo *info = [Data getItemInfoFromInstance:model.borderObject];
        Item *item = [model.project getItemBySourceId:s.Id];
        Item *it = [Item new];
        it.Id = item.Id;
        info.item = it;
    };
    cv_color.onItemSelected = ^(NSUInteger position, id item, BOOL selected) {
        [cv_color_b selectItemAtPosition:position animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        Source *s = [weakSelf getSourceBy:position];
        [weakSelf loadPVR:s];
        [weakSelf loadTextureByFile:s.file];
        ItemInfo *info = [Data getItemInfoFromInstance:model.borderObject];
        Item *it = [model.project getItemBySourceId:s.Id];
        Item *it2 = [Item new];
        it2.Id = it.Id;
        info.item = it2;
    };
    cv_color.onScroll = ^(id<ICVAdapterView> view) {//滚动中调用
        CGPoint cv_center = CGPointMake(mModel.gameViewWidth/2, [UIScreen mainScreen].bounds.size.height - [MesherModel uiHeightBy:75.0f]); // 获取屏幕水平中心的某一个点
        CGPoint inView = [lo_WallEdit_b convertPoint:cv_center toView:cv_color_b];
//        CGPoint inView = CGPointMake(mModel.gameViewWidth/2, cv_color_b.frame.size.height/2);
        NSIndexPath* i = [cv_color_b indexPathForItemAtPoint:inView];
        Source *s = [weakSelf getSourceBy:i.row];
        [weakSelf updateImageBy:s];
        [result_b cancel];
    };
    
    centerImage = [UIImageView new];
    centerImage.layoutParams.width = [MesherModel uiWidthBy:129.0f];
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        centerImage.layoutParams.height = [MesherModel uiHeightBy:150.0f];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        centerImage.layoutParams.height = [MesherModel uiHeightBy:200.0f];
    }
    centerImage.layoutParams.alignment = CCVLayoutAlignParentBottom | CCVLayoutAlignCenterHorizontal;
    centerImage.layer.borderWidth = 2.0f;
    centerImage.layer.borderColor = [UIColor whiteColor].CGColor;
    [lo_WallEdit addSubview:centerImage];
    
    btn_undo = (UIImageView*)[parent viewWithTag:R_id_btn_undo];
    btn_redo = (UIImageView*)[parent viewWithTag:R_id_btn_redo];
    
#pragma mark item上的按钮
    lo_object_menu_container = [CCVFrameLayout layout];
    lo_object_menu_container.layoutParams.width = CCVLayoutMatchParent;
    lo_object_menu_container.layoutParams.height = CCVLayoutMatchParent;
    lo_object_menu_container.hidden = NO;
    [lo_WallEdit addSubview:lo_object_menu_container];
    lo_object_menu = [CCVLinearLayout layout];
    lo_object_menu.layoutParams.width = CCVLayoutWrapContent;
    lo_object_menu.layoutParams.height = CCVLayoutWrapContent;
    lo_object_menu.orientation = CCVLayoutOrientationHorizontal;
    //lo_object_menu.layoutParams.alignment = CCVLayoutAlignCenterInParent;
    [lo_object_menu_container addSubview:lo_object_menu];
    
    UIImage *btn_brush_n = [UIImage imageByResourceDrawable:@"btn_brush_n"];
    UIImage *btn_brush_p = [UIImage imageByResourceDrawable:@"btn_brush_p"];
    UIButton *btn_brush = [[UIButton alloc] initWithImage:btn_brush_n highlightedImage:btn_brush_p
                           ];
    btn_brush.tag = R_id_btn_brush;
    btn_brush.layoutParams.width = CCVLayoutWrapContent;
    btn_brush.layoutParams.height = CCVLayoutWrapContent;
    [lo_object_menu addSubview:btn_brush];
    
    UIImage *btn_details_n = [UIImage imageByResourceDrawable:@"btn_details_n"];
    UIImage *btn_details_p = [UIImage imageByResourceDrawable:@"btn_details_p"];
    UIButton *btn_details = [[UIButton alloc] initWithImage:btn_details_n highlightedImage:btn_details_p];
    btn_details.tag = R_id_btn_details;
    btn_details.layoutParams.width = CCVLayoutWrapContent;
    btn_details.layoutParams.height = CCVLayoutWrapContent;
    btn_details.layoutParams.marginLeft = 2;
    [lo_object_menu addSubview:btn_details];
    
    btn_brush.userInteractionEnabled = YES;
    [self.viewEventBinder bindEventsToView:btn_brush willBindSubviews:NO andFilter:nil];
    btn_details.userInteractionEnabled = YES;
    [self.viewEventBinder bindEventsToView:btn_details willBindSubviews:NO andFilter:nil];
    
#pragma mark details
    lo_ArchitureDetails = [CCVRelativeLayout layout];
    lo_ArchitureDetails.tag = R_id_lo_architure_details;
    lo_ArchitureDetails.layoutParams.width = [self uiWidthBy:521.0f];
    lo_ArchitureDetails.layoutParams.height = CCVLayoutMatchParent;
    lo_ArchitureDetails.layoutParams.alignment = CCVLayoutAlignParentRight;
    [lo_WallEdit addSubview:lo_ArchitureDetails];
    lo_ArchitureDetails.hidden = YES;
    UIImage *bg_menu_right = [UIImage imageByResourceDrawable:@"bg_list_info"];
    UIImageView *bg_architureDetails = [[UIImageView alloc] initWithImage:bg_menu_right];
    bg_architureDetails.layoutParams.width = [self uiWidthBy:508.0f];
    bg_architureDetails.layoutParams.height = CCVLayoutMatchParent;
    bg_architureDetails.layoutParams.alignment = CCVLayoutAlignParentRight;
    [lo_ArchitureDetails addSubview:bg_architureDetails];
    
    CCVLinearLayout *lo_menu_product_linear = [CCVLinearLayout layout];
    lo_menu_product_linear.layoutParams.width = CCVLayoutMatchParent;
    lo_menu_product_linear.layoutParams.height = CCVLayoutMatchParent;
    lo_menu_product_linear.orientation = CCVLayoutOrientationVertical;
    [lo_ArchitureDetails addSubview:lo_menu_product_linear];
    
    CCVRelativeLayout* lo_item_name = [CCVRelativeLayout layout];
    lo_item_name.layoutParams.width = CCVLayoutMatchParent;
    lo_item_name.layoutParams.height = CCVLayoutWrapContent;
    [lo_menu_product_linear addSubview:lo_item_name];
    
    UIImage *btn_back_n = [UIImage imageByResourceDrawable:@"btn_back_n.png"];
    UIButton *btn_back = [[UIButton alloc] initWithImage:btn_back_n highlightedImage:btn_back_n];
    btn_back.tag = R_id_btn_back;
    btn_back.layoutParams.width = CCVLayoutWrapContent;
    btn_back.layoutParams.height = CCVLayoutWrapContent;
    btn_back.layoutParams.alignment = CCVLayoutAlignParentLeft | CCVLayoutAlignCenterVertical;
    btn_back.layoutParams.marginLeft = [MesherModel uiWidthBy:20.0f];
    [lo_item_name addSubview:btn_back];
    btn_back.userInteractionEnabled = YES;
    [self.viewEventBinder bindEventsToView:btn_back willBindSubviews:NO andFilter:nil];
    
    UIImage *img_divider_dark_520_img = [UIImage imageByResourceDrawable:@"img_divider_dark_520.png"];
    UIImageView *img_divider_dark_520 = [[UIImageView alloc] initWithImage:img_divider_dark_520_img];
    img_divider_dark_520.layoutParams.width = CCVLayoutMatchParent;
    img_divider_dark_520.layoutParams.height = CCVLayoutWrapContent;
    img_divider_dark_520.layoutParams.marginLeft = [self uiWidthBy:20.0f];
    img_divider_dark_520.layoutParams.marginRight = [self uiWidthBy:20.0f];
    [lo_menu_product_linear addSubview:img_divider_dark_520];
    
    img_details_image = [[UIImageView alloc] init];
    CGFloat img_width = [MesherModel uiWidthBy:220.0f];
    CGFloat img_height = [MesherModel uiHeightBy:360.0f];
    CGFloat img_size = img_width > img_height ? img_width : img_height;
    img_details_image.layoutParams.width = img_size;
    img_details_image.layoutParams.height = img_size;
    img_details_image.layoutParams.marginLeft = [MesherModel uiWidthBy:10.0f];
    img_details_image.layoutParams.alignment = CCVLayoutAlignCenterHorizontal;
    img_details_image.layoutParams.marginTop = [self uiWidthBy:20.0f];
    img_details_image.layoutParams.marginLeft = [self uiWidthBy:20.0f];
    [lo_menu_product_linear addSubview:img_details_image];
    opt_img_details_image = nil;
    
    CCVRelativeLayout *lo_option = [CCVRelativeLayout layout];
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        lo_option.layoutParams.height = [MesherModel uiHeightBy:80.0f];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        lo_option.layoutParams.height = [MesherModel uiHeightBy:100.0f];
    }
    lo_option.layoutParams.width = CCVLayoutMatchParent;
    lo_option.layoutParams.marginTop = [MesherModel uiHeightBy:40.0f];
    [lo_menu_product_linear addSubview:lo_option];
    
    CGFloat textsize = 0;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        textsize = 15.0f;
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        textsize = 10.0f;
    }
    
    btn_change_texture = [[UIButton alloc] init];
    btn_change_texture.tag = R_id_btn_change_texture;
    btn_change_texture.layoutParams.width = [MesherModel uiWidthBy:150.0f];
    btn_change_texture.layoutParams.height = CCVLayoutMatchParent;
    btn_change_texture.layoutParams.alignment = CCVLayoutAlignParentLeft;
    btn_change_texture.layoutParams.marginLeft = [MesherModel uiWidthBy:20.0f];
    [btn_change_texture setTitle:@"颜 色" forState:UIControlStateNormal];
    [btn_change_texture setTitle:@"颜 色" forState:UIControlStateSelected];
    [btn_change_texture setTitleColor:[UIColor colorWithARGB:R_color_option_info_n] forState:UIControlStateNormal];
    [btn_change_texture setTitleColor:[UIColor colorWithARGB:R_color_option_info_p] forState:UIControlStateSelected];
    [btn_change_texture setButtonTextSize:textsize];
    [btn_change_texture setBackgroundImage:[UIImage imageByResourceDrawable:@"btn_description_n"] forState:UIControlStateNormal];
    [btn_change_texture setBackgroundImage:[UIImage imageByResourceDrawable:@"btn_description_p"] forState:UIControlStateSelected];
    [lo_option addSubview:btn_change_texture];
    [self.viewEventBinder bindEventsToView:btn_change_texture willBindSubviews:NO andFilter:nil];
    
    rg_option = [CCVRadioViewGroup group];
    [rg_option addView:btn_change_texture];
    rg_option.onChecked = (^(BOOL checked, NSUInteger index, UIView* view){
        UIButton *button = (UIButton*)view; // view是button类型的  强转
        [button setSelected:checked]; // 把button状态设为选中状态
    });
    rg_option.checkedView = btn_change_texture; // 初始角度在颜色按钮上
    
//    lo_button1_line1 = [CCVRelativeLayout layout];
//    lo_button1_line1.layoutParams.width = [MesherModel uiWidthBy:355.0f];
//    lo_button1_line1.layoutParams.height = 1;
//    lo_button1_line1.layoutParams.alignment = CCVLayoutAlignParentBottomRight;
//    lo_button1_line1.backgroundColor = [UIColor colorWithARGB:R_color_option_line];
//    [lo_option addSubview:lo_button1_line1];
    
#pragma mark 贴图替换
    lo_texture = [CCVRelativeLayout layout];
    lo_texture.layoutParams.width = CCVLayoutMatchParent;
    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
        lo_texture.layoutParams.height = [MesherModel uiHeightBy:800.0f];
        lo_texture.layoutParams.marginBottom = [MesherModel uiHeightBy:130.0f];
    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
        lo_texture.layoutParams.height = [MesherModel uiHeightBy:700.0f];
        lo_texture.layoutParams.marginBottom = [MesherModel uiHeightBy:110.0f];
    }
    lo_texture.layoutParams.alignment = CCVLayoutAlignParentBottom | CCVLayoutAlignCenterHorizontal;
    [lo_ArchitureDetails addSubview:lo_texture];
    
    cv_texture = [CCVCollectionView collectionView];
    cv_texture.layoutParams.width = [MesherModel uiWidthBy:480.0f];
    cv_texture.layoutParams.height = CCVLayoutMatchParent;
    cv_texture.layoutParams.marginLeft = [MesherModel uiWidthBy:30.0f];
    cv_texture.numColumns = 3;
    cv_texture.backgroundColor = [UIColor clearColor];
    [lo_texture addSubview:cv_texture];
    mTextureAdapter = [[TextureAdapter alloc] init];
    cv_texture.adapter = mTextureAdapter;
    cv_texture.alwaysBounceVertical = NO;
    cv_texture.showsHorizontalScrollIndicator = NO; // 取消水平滚动条
    cv_texture.showsVerticalScrollIndicator = NO; // 取消垂直滚动条
    cv_texture.allowsMultipleSelection = NO; // 取消多选模式
    cv_texture.onItemSelected = ^(NSUInteger position, id item, BOOL selected) {
        Source *s = [weakSelf getSourceBy:position];
        [weakSelf loadPVR:s];
        [weakSelf loadTextureByFile:s.file];
        ItemInfo *info = [Data getItemInfoFromInstance:model.borderObject];
        Item *it = [model.project getItemBySourceId:s.Id];
        Item *it2 = [Item new];
        it2.Id = it.Id;
        info.item = it2;
        [weakSelf updateDetailsImageBy:s];
    };
    
    return lo_WallEdit;
}

- (Source*)getSourceBy:(NSInteger)index {
    return [architures at:index];
}

- (void)updateImageBy:(Source*)source {
    centerImage.image = nil;
    [[CCVCorePluginSystem instance].imageCache getBy:source.preview options:nil async:YES onGet:^(UIImage *image) {
        centerImage.image = image;
    }];
}

- (void)updateDetailsImageBy:(Source*)source {
    img_details_image.image = nil;
    [[CCVCorePluginSystem instance].imageCache getBy:source.preview options:nil async:YES onGet:^(UIImage *image) {
        img_details_image.image = image;
    }];
}

- (void)loadPVR:(Source*)source{
    tempExtension = source.file.extension;
    source.file.extension = @"pvr";
    if(!source.file.exists) {
        source.file.extension = tempExtension;
    }
}

- (void)updateInterface {
    centerImage.hidden = YES;
    cv_color.hidden = YES;
    lo_ArchitureDetails.hidden = YES;
}

- (void)onStateEnter:(NSDictionary *)data {
    [super onStateEnter:data];
    ItemInfo *info = [Data getItemInfoFromInstance:mModel.borderObject];
    
    centerImage.hidden = YES;
    cv_color.hidden = YES;
    
    mModel.photographer.cameraEnabled = YES;
    ArchitureEdit *weakSelf = self;
    mModel.itemSelectAndMoveBehaviour.onSelect = (^(id<ICVGameObject> object) {
        [weakSelf updateInterface];
        [weakSelf.parentMachine revertState];
    });
    mModel.itemSelectAndMoveBehaviour.canMove = NO;
    
    lo_WallEdit.hidden = NO;
    [self updateUndoRedoState];
    isReplace = NO;
    
    tempMaterial = mModel.borderObject.renderable.material;

    if (info.type == ItemTypeWall) {
        architures = mModel.project.wallTextures;
        mWallAdapter.data = mModel.project.wallTextures;
        mTextureAdapter.data = mModel.project.wallTextures;
    } else if (info.type == ItemTypeFloor) {
        architures = mModel.project.floorTextures;
        mWallAdapter.data = mModel.project.floorTextures;
        mTextureAdapter.data = mModel.project.floorTextures;
    } else if (info.type == ItemTypeCeil) {
        architures = mModel.project.ceilTextures;
        mWallAdapter.data = mModel.project.ceilTextures;
        mTextureAdapter.data = mModel.project.ceilTextures;
    }
    [mWallAdapter notifyDataSetChanged];
    [mTextureAdapter notifyDataSetChanged];
    
    [cv_color selectItemAtPosition:0 animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];

    centerImage.image = nil;
    id<ICVFile> tempImage = [architures[0] preview];
    [[CCVCorePluginSystem instance].imageCache getBy:tempImage options:nil async:NO onGet:^(UIImage *image) {
        centerImage.image = image;
    }];
    
    img_details_image.image = nil;
    [[CCVCorePluginSystem instance].imageCache getBy:tempImage options:nil async:NO onGet:^(UIImage *image) {
        img_details_image.image = image;
    }];
    
#pragma mark viewTag的设置
    if (mArchitureEditMenu == nil) {
        mArchitureEditMenu = [mModel.currentContext createViewTag];
        mArchitureEditMenu.view = lo_object_menu;
        mArchitureEditMenu.viewOffset = CGPointMake(0, -200);
        mArchitureEditMenu.onChange = (^CGPoint (CGPoint position) {
            float minX = lo_WallEdit.frame.size.width/5;
            float maxX = lo_WallEdit.frame.size.width/5*4;
            float minY = lo_WallEdit.frame.size.height/4;
            float maxY = lo_WallEdit.frame.size.height/4*3;
            if (position.x < minX) {
                position.x = minX;
            }
            if (position.x > maxX) {
                position.x = maxX;
            }
            if (position.y < minY) {
                position.y = minY;
            }
            if (position.y > maxY) {
                position.y = maxY;
            }
            return position;
        });
    }
    [mModel.borderObject addComponent:mArchitureEditMenu];
    
}

#pragma mark 画边框逻辑 暂时不用
//- (void)drawBorder {
//    ObjectExtra *extra = mModel.borderObject.extra;
//    if (extra.borderObject != nil) {
//        id<ICVGameObject> borderObj = extra.borderObject;
//        borderObj.visible = YES;
//    } else {
//        ItemInfo *info = extra.itemInfo;
//        NSMutableArray *path = info.path;
//        NSMutableArray *allPoints = [NSMutableArray array];
//        for (int i = 0; i < path.count; i += 3) {
//            CCCFloat x = [path[i] floatValue];
//            CCCFloat y = [path[i+1] floatValue];
//            CCCFloat z = [path[i+2] floatValue];
//            CCVVector3 *p = [[CCVVector3 alloc] initWithX:x Y:y Z:z];
//            [allPoints add:p];
//        }
//        BOOL isX = NO;
//        BOOL isY = NO;
//        BOOL isZ = NO;
//        
//        CCVVector3 *p1 = allPoints[0];
//        CCVVector3 *p2 = allPoints[1];
//        CCVVector3 *p3 = allPoints[2];
//        
//        if (p1.vector.x == p2.vector.x &&  p1.vector.x == p3.vector.x) {
//            isX = YES;
//        }else if (p1.vector.y == p2.vector.y && p1.vector.y == p3.vector.y) {
//            isY = YES;
//        }else if (p1.vector.z == p2.vector.z && p1.vector.z == p3.vector.z) {
//            isZ = YES;
//        }
//        
//        if (angles == nil) {
//            angles = [NSMutableArray array];
//        }
//        
//
//        CCVVector3 *min = allPoints[0];
//        for (int i = 1; i < allPoints.count; i++) {
//            CCVVector3 *p = allPoints[i];
//            if (min.vector.x >= p.vector.x && min.vector.y >= p.vector.y && min.vector.z >= p.vector.z) {
//                min = p;
//            }
//        }
//        for (int i = 0; i < allPoints.count; i++ ) {
//            if ([allPoints[i] isEqual:min]) {
//                [allPoints exchangeObjectAtIndex:0 withObjectAtIndex:i];
//            }
//        }
//        
//        if(isX) {
//            for (int i = 1; i < allPoints.count; i++) {
//                CCVVector3 *p0 = allPoints[0];
//                CCVVector3 *p = allPoints[i];
//                float angle = atan2(p.vector.y - p0.vector.y, p.vector.z - p0.vector.z)*180/3.2;
//                Vertex *v = [Vertex new];
//                v.angle = angle;
//                [angles add:v];
//            }
//            for (int i = 0; i < angles.count; i++) {
//                for (int j = 0; j < angles.count - 1 - i; j++) {
//                    Vertex *v1 = angles[j];
//                    Vertex *v2 = angles[j+1];
//                    if (v1.angle > v2.angle) {
//                        Vertex *temp = angles[j];
//                        angles[j] = angles[j+1];
//                        angles[j+1] = temp;
//                        [allPoints exchangeObjectAtIndex:j+1 withObjectAtIndex:j+2];
//                    }
//                }
//            }
//        }else if (isY) {
//            for (int i = 1; i < allPoints.count; i++) {
//                CCVVector3 *p0 = allPoints[0];
//                CCVVector3 *p = allPoints[i];
//                float angle = atan2(p.vector.z - p0.vector.z, p.vector.x - p0.vector.x)*180/3.2;
//                Vertex *v = [Vertex new];
//                v.angle = angle;
//                [angles add:v];
//            }
//            for (int i = 0; i < angles.count; i++) {
//                for (int j = 0; j < angles.count - 1 - i; j++) {
//                    Vertex *v1 = angles[j];
//                    Vertex *v2 = angles[j+1];
//                    if (v1.angle > v2.angle) {
//                        Vertex *temp = angles[j];
//                        angles[j] = angles[j+1];
//                        angles[j+1] = temp;
//                        [allPoints exchangeObjectAtIndex:j+1 withObjectAtIndex:j+2];
//                    }
//                }
//            }
//        }else if (isZ) {
//            for (int i = 1; i < allPoints.count; i++) {
//                CCVVector3 *p0 = allPoints[0];
//                CCVVector3 *p = allPoints[i];
//                float angle = atan2(p.vector.y - p0.vector.y, p.vector.x - p0.vector.x)*180/3.2;
//                Vertex *v = [Vertex new];
//                v.angle = angle;
//                [angles add:v];
//            }
//            for (int i = 0; i < angles.count; i++) {
//                for (int j = 0; j < angles.count - 1 - i; j++) {
//                    Vertex *v1 = angles[j];
//                    Vertex *v2 = angles[j+1];
//                    if (v1.angle > v2.angle) {
//                        Vertex *temp = angles[j];
//                        angles[j] = angles[j+1];
//                        angles[j+1] = temp;
//                        [allPoints exchangeObjectAtIndex:j+1 withObjectAtIndex:j+2];
//                    }
//                }
//            }
//        }
//        [angles removeAllObjects];
//        
//        NSString *objName = [NSString stringWithFormat:@"side_%@",@(mModel.borderObject.hash)];
//        id<ICVFile> file = [CCVFile fileWithName:objName content:nil];
//        id<ICVMesh> mesh = (id<ICVMesh>)[mModel.currentContext.meshManager createFromFile:file];
//        [mesh makeWithNumVertices:allPoints.count numIndices:0];
//        [mesh beginOperation:CCCRenderOperationLineLoop update:NO];
//        // CCCUShort i = 0;
//        for (CCVVector3* pos in allPoints) {
//            [mesh position:pos.vector];
//            //        [mesh lineStart:i end:(i + 1)];
//            //        i++;
//        }
//        [mesh colorR:1 G:0 B:0 A:1];
//        [mesh end];
//        [mesh load];
//        id<ICVMeshRenderer> meshRenderer = [mModel.currentContext createMeshRenderer];
//        meshRenderer.mesh = mesh;
//        id<ICVGameObject> borderObj = [mModel.currentContext createObject];
//        borderObj.Id = objName;
//        [borderObj addComponent:meshRenderer];
//        borderObj.parent = mModel.borderObject;
//        borderObj.visible = YES;
//        borderObj.queryMask = [MesherModel CanNotSelectMask];
//        extra.borderObject = borderObj;
//        mModel.borderObject.extra = extra;
//    }
//}

- (void)loadTextureByFile:(id<ICVFile>)file {
    if (file != nil) {
        texture = (id<ICVTexture>)[mModel.currentContext.textureManager createFromFile:file];
        if (texture.isValid) {
            NSString *name = [NSString stringWithFormat:@"mat%@",@(texture.hash)];
            id<ICVFile> materialFile = [CCVFile fileWithType:CCVFileTypeMemory path:name];
            material = (id<ICVMaterial>)[mModel.currentContext.materialManager createFromFile:materialFile];
            material.diffuseTexture = texture;
            [material load]; // 重载material 刷新材质
            mModel.borderObject.renderable.material = material;
            isReplace = YES;
        }else {
            texture.onLoad = self; // 设置代理
            result = [texture loadAsync:YES];
        }
        mModel.currentPlan.sceneDirty = YES;
    }
}

// 异步载入成功调用
- (void) onLoadResource:(id<ICVResource>)resource {
    texture = (id<ICVTexture>)resource;
    NSString *name = [NSString stringWithFormat:@"mat%@",@(texture.hash)];
    id<ICVFile> file = [CCVFile fileWithType:CCVFileTypeMemory path:name];
    material = (id<ICVMaterial>)[mModel.currentContext.materialManager createFromFile:file];
    material.diffuseTexture = texture;
    [material load]; // 重载material 刷新材质
    mModel.borderObject.renderable.material = material;
    NSLog(@"载入成功");
    isReplace = YES;
}

// 异步载入失败调用
- (void) onFailedToLoadResource:(id<ICVResource>)resource {
    NSLog(@"加载失败");
}

- (void)onStateLeave{
    [mModel.borderObject removeComponent:mArchitureEditMenu];
    lo_WallEdit.hidden = YES;
    if (isReplace) {
        UpdateTextureCommand *command = [[UpdateTextureCommand alloc] init];
        command.archtureObject = mModel.borderObject;
        command.originMaterial = tempMaterial;
        command.destMaterial = material;
        [mModel.commandMachine doneCommand:command];
    }
    [mModel.photographer changeToEditorCamera:1000];
    [self updateUndoRedoState];
    material = nil;
    tempMaterial = nil;
    architures = nil;
    [result cancel]; // 取消异步加载
    [super onStateLeave];
}

- (BOOL)onTouchUp:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    switch (touch.view.tag) {
        case R_id_btn_brush: {
            ItemInfo *info = [Data getItemInfoFromInstance:mModel.borderObject];
            CCCVector3 normal = CCCVector3Make(info.dx.floatValue, 0.0f, info.dz.floatValue);
            normal = CCCVector3Normalize(&normal);
            
            CCCVector3 min = mModel.borderObject.transformBounds.min;
            CCCVector3 max = mModel.borderObject.transformBounds.max;
            CCCVector3 position = CCCVector3Make(min.x + (max.x-min.x)/2, min.y + (max.y-min.y)/2, min.z + (max.z-min.z)/2);
            //先设置摄像机
            CCVEditorCameraPrefab* archCamera = mModel.photographer.archEditCamera;
            
            if (info.type == ItemTypeWall) {
                [archCamera.root.transform setPositionV:position inSpace:CCVTransformSpaceWorld];
                CCCVector3 camera_Z = [archCamera.root.transform zAxisInSpace:CCVTransformSpaceParent];
                camera_Z.y = 0.0f;
                camera_Z = CCCVector3Normalize(&camera_Z);
                float d = CCCVector3DotProductv(&normal, &camera_Z);
                float radians = acosf(d);
                float degrees = CCCRad2Deg(radians); // 旋转的角度
                CCCVector3 cn = CCCVector3CrossProductv(&camera_Z, &normal);
                if (cn.y < 0.0f) {
                    degrees = -degrees;
                }
                [archCamera.root.transform yawDegrees:degrees];
                [archCamera.camera.host removeComponent:archCamera.camera.host.behaviour];
                ArchCameraBehaviour *behaviour = [[ArchCameraBehaviour alloc] initWithContext:mModel.currentContext cameraPrefab:archCamera];
                behaviour.machine = self.parentMachine;
                [archCamera.camera.host addComponent:behaviour];
            } else if (info.type == ItemTypeFloor) {
                [archCamera.root.transform setPositionV:position inSpace:CCVTransformSpaceWorld];
            }
            
            mModel.photographer.cameraEnabled = YES;
            [archCamera.camera.host removeComponent:archCamera.camera.host.behaviour];
            ArchCameraBehaviour *behaviour = [[ArchCameraBehaviour alloc] initWithContext:mModel.currentContext cameraPrefab:archCamera];
            behaviour.machine = self.parentMachine;
            [archCamera.camera.host addComponent:behaviour];
            
            // 再切换
            [mModel.photographer changeToArchEditCamera:1000];
            
            centerImage.hidden = NO;
            cv_color.hidden = NO;
            lo_ArchitureDetails.hidden = YES;
            break;
        }
        case R_id_btn_details: {
            centerImage.hidden = YES;
            cv_color.hidden = YES;
            lo_ArchitureDetails.hidden = NO;
            break;
        }
        case R_id_btn_change_color: {
            rg_option.checkedView = touch.view;
            if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
                [btn_change_texture setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
                [btn_change_texture setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            }
            lo_button1_line1.hidden = NO;
            lo_texture.hidden = NO;
            break;
        }
        case R_id_btn_back: {
            lo_ArchitureDetails.hidden = YES;
            break;
        }
        default:
            break;
    }
    return YES;
}

@end
