//
//  InspiratedList.m
//  project_mesher
//
//  Created by mac zdszkj on 16/4/6.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "InspiratedList.h"
#import "MesherModel.h"
#import "InspiratedPlanAdapter.h"
#import "InspiratedImagePickerController.h"
#import "App.h"
#import <jw/CMDeviceMotion+JWCoreCategory.h>
#import <jw/UIDevice+JWCoreCategory.h>

@interface InspiratedList()<UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    JWRelativeLayout *lo_inspiratedList;
    JWCollectionView *cv_inspiratedList;
    InspiratedPlanAdapter *mInspiratedPlanAdapter;
    
    InspiratedPlan *shot;
    NSMutableArray *shotAndPlans;
    
    JCQuaternion mQuater;
    id<JIFile> mInspiratedBackground;
    InspiratedImagePickerController *pickerImage;
    
    UIImageView *test;
    UIButton *btn;
    UIPopoverController *popover;
    
    JWRelativeLayout *lo_shot;
    JWRelativeLayout *lo_photoLibrary;
    
}

@end

@implementation InspiratedList

- (UIView *)onCreateView:(UIView *)parent {
    lo_inspiratedList = [JWRelativeLayout layout];
    lo_inspiratedList.layoutParams.width = JWLayoutMatchParent;
    lo_inspiratedList.layoutParams.height = JWLayoutMatchParent;
    lo_inspiratedList.backgroundColor = [UIColor colorWithARGB:R_color_room_base_background];
    [parent addSubview:lo_inspiratedList];
    
    JWRelativeLayout *line = [JWRelativeLayout layout];
    line.layoutParams.width = [MesherModel uiWidthBy:6.0f];
    line.layoutParams.height = [MesherModel uiHeightBy:1000.0f];
    line.backgroundColor = [UIColor whiteColor];
    line.layoutParams.alignment = JWLayoutAlignCenterInParent;
    [lo_inspiratedList addSubview:line];
    
    lo_shot = [JWRelativeLayout layout];
    lo_shot.tag = R_id_lo_shot;
//    lo_shot.backgroundColor = [UIColor blueColor];
    lo_shot.layoutParams.width = 0.5;
    lo_shot.layoutParams.height = JWLayoutMatchParent;
    lo_shot.layoutParams.alignment = JWLayoutAlignParentLeft;
    [lo_inspiratedList addSubview:lo_shot];
    lo_shot.clickable = YES;
    [self.viewEventBinder bindEventsToView:lo_shot willBindSubviews:NO andFilter:nil];
    UIImage *btn_inspirated_shot = [UIImage imageByResourceDrawable:@"btn_inspirated_shot"];
    UIImageView *bg_shot = [[UIImageView alloc] initWithImage:btn_inspirated_shot];
    bg_shot.layoutParams.width = JWLayoutWrapContent;
    bg_shot.layoutParams.height = JWLayoutWrapContent;
    bg_shot.layoutParams.alignment = JWLayoutAlignCenterInParent;
    [lo_shot addSubview:bg_shot];
    
    lo_photoLibrary = [JWRelativeLayout layout];
    lo_photoLibrary.tag = R_id_lo_photo_library;
//    lo_photoLibrary.backgroundColor = [UIColor redColor];
    lo_photoLibrary.layoutParams.width = 0.5;
    lo_photoLibrary.layoutParams.height = JWLayoutMatchParent;
    lo_photoLibrary.layoutParams.alignment = JWLayoutAlignParentRight;
    [lo_inspiratedList addSubview:lo_photoLibrary];
    lo_photoLibrary.clickable = YES;
    [self.viewEventBinder bindEventsToView:lo_photoLibrary willBindSubviews:NO andFilter:nil];
    UIImage *btn_inspirated_photolibrary = [UIImage imageByResourceDrawable:@"btn_insporated_photolibrary"];
    UIImageView *bg_photolibrary = [[UIImageView alloc] initWithImage:btn_inspirated_photolibrary];
    bg_photolibrary.layoutParams.width = JWLayoutWrapContent;
    bg_photolibrary.layoutParams.height = JWLayoutWrapContent;
    bg_photolibrary.layoutParams.alignment = JWLayoutAlignCenterInParent;
    [lo_photoLibrary addSubview:bg_photolibrary];
    
    UIImage *btn_close_clear = [UIImage imageByResourceDrawable:@"btn_back_white"];
    UIButton *btn_close = [[UIButton alloc] initWithImage:btn_close_clear selectedImage:btn_close_clear];
    btn_close.layoutParams.width = JWLayoutWrapContent;
    btn_close.layoutParams.height = JWLayoutWrapContent;
    btn_close.layoutParams.alignment = JWLayoutAlignParentTopLeft;
//    btn_close.layoutParams.marginTop = [MesherModel uiHeightBy:20.0f];
//    btn_close.layoutParams.marginLeft = [MesherModel uiWidthBy:20.0f];
    btn_close.layoutParams.padding = [MesherModel uiWidthBy:40.0f];
    [lo_inspiratedList addSubview:btn_close];
    [btn_close addTarget:self action:@selector(backToDIY:) forControlEvents:UIControlEventTouchUpInside];
    
//    cv_inspiratedList = [JWCollectionView collectionView];
//    cv_inspiratedList.layoutParams.width = [MesherModel uiWidthBy:1740.0f];;
//    cv_inspiratedList.layoutParams.height = [MesherModel uiHeightBy:1120.0f];
//    cv_inspiratedList.layoutParams.alignment = JWLayoutAlignCenterInParent;
//    cv_inspiratedList.backgroundColor = [UIColor clearColor];
//    [lo_inspiratedList addSubview:cv_inspiratedList];
//    cv_inspiratedList.alwaysBounceVertical = NO;
//    cv_inspiratedList.showsHorizontalScrollIndicator = NO;
//    cv_inspiratedList.showsVerticalScrollIndicator = NO;
//    
//    mInspiratedPlanAdapter = [[InspiratedPlanAdapter alloc] init];
//    cv_inspiratedList.adapter = mInspiratedPlanAdapter;
//    __block typeof (self)weakSelf = self;
//    id<IMesherModel> model = mModel;
//    
//    cv_inspiratedList.onItemSelected = ^(NSUInteger position, id item, BOOL selected){
//        if (position == 0) {
//            //            [model.mainController presentModalViewController:picker animated:YES];
//            [weakSelf.parentMachine changeStateTo:[States InspiratedCamera]];
//        }else {
//            InspiratedPlan *plan = [model.project createInspiratedPlan];
//            [model.project saveInspiratedPlans];
//            plan.inspirateBackground = [model.project getInspiratedBackgroundAtIndex:position-1];
//            model.currentPlan = plan;
//            //            [backgroundSprite.spriteTexture.manager destroyByFile:backgroundSprite.spriteTexture.file];// 先移除旧的图
//            //            [backgroundSprite setSpriteTextureFile:plan.inspirateBackground];// 载入新的图
//            [weakSelf.parentMachine changeStateTo:[States InspiratedEdit] pushState:NO];
//        }
//    };
//    
//    if (shotAndPlans == nil) {
//        shotAndPlans = [NSMutableArray array];
//    }
//    
//    shot = [[InspiratedPlan alloc] init];
//    shot.Id = 0;
//    shot.inspirateBackground = [JWFile fileWithType:JWFileTypeBundle path:[JWResourceBundle nameForDrawable:@"btn_inspirated_camera.png"]]; //这里改成一张照相机的图片
    
    
    //    test = [[UIImageView alloc] init];
    //    test.layoutParams.width = [MesherModel uiWidthBy:200];
    //    test.layoutParams.height = [MesherModel uiHeightBy:200];
    //    test.backgroundColor = [UIColor yellowColor];
    //    [lo_inspiratedList addSubview:test];
    //    btn = [UIButton new];
    //    btn.backgroundColor = [UIColor redColor];
    //    btn.layoutParams.width = [MesherModel uiWidthBy:200];
    //    btn.layoutParams.height = [MesherModel uiHeightBy:200];
    //    btn.layoutParams.marginTop = [MesherModel uiHeightBy:200];
    //    [lo_inspiratedList addSubview:btn];
    //
    //    [btn addTarget:self action:@selector(loadPhotoLibrary) forControlEvents:UIControlEventTouchUpInside];
    
    return lo_inspiratedList;
}

- (void)onStateEnter:(NSDictionary *)data {
    [super onStateEnter:data];
    [mModel.project loadInspiratedPlans];
    if (shotAndPlans != nil) {
        [shotAndPlans clear];
        [shotAndPlans add:shot];
        for (int i = 0; i < mModel.project.inspiratedPlans.count; i++) {
            InspiratedPlan *p = mModel.project.inspiratedPlans[i];
            [shotAndPlans add:p];
        }
    }
    
    mInspiratedPlanAdapter.data = shotAndPlans;
    [mInspiratedPlanAdapter notifyDataSetChanged];
    
}

- (BOOL)onTouchUp:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    switch (touch.view.tag) {
        case R_id_lo_shot: {
            [self.parentMachine changeStateTo:[States InspiratedCamera]];
            break;
        }
        case R_id_lo_photo_library: {
            [self loadPhotoLibrary];
            break;
        }
        default:
            break;
    }
    return YES;
}

- (void)onStateLeave {
    [super onStateLeave];
}

- (void)backToDIY:(id)sender {
    [self.parentMachine revertState];
}

- (void)loadPhotoLibrary {
    App *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.orientationMask = UIInterfaceOrientationMaskAll;
    
    if (pickerImage == nil) {
        pickerImage = [[InspiratedImagePickerController alloc] init];
    }
    [pickerImage shouldAutorotate];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = YES;
    [mModel.mainController presentViewController:pickerImage animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    JWImageOptions *option = [JWImageOptions options];
    option.fixedWidth = [UIScreen mainScreen].boundsInPixels.size.width;
    option.fixedHeight = [UIScreen mainScreen].boundsInPixels.size.height;
    option.keepRatioPolicy = JWKeepRatioPolicyHeightPriority;
    
    UIImage *im = [image imageByOptions:option];
    test.image = im;
    NSLog(@"%f,%f",image.size.width,image.size.height);
    NSLog(@"%f,%f",im.size.width,im.size.height);
    
    App *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.orientationMask = UIInterfaceOrientationMaskLandscapeRight;
    [mModel.mainController dismissViewControllerAnimated:YES completion:nil];
    
    
    mModel.inspiratedImage = im;
    NSLog(@"%f,%f",mModel.inspiratedImage.size.width,mModel.inspiratedImage.size.height);
    InspiratedPlan *p = [mModel.project createInspiratedPlan];
    p.qw = 0;
    p.qx = 0;
    p.qy = 0;
    p.qz = 0;
    [UIImagePNGRepresentation(im) writeToFile:p.inspirateBackground.realPath atomically:YES];
    [mModel.project saveInspiratedPlans];
    mModel.currentPlan = p;
    mModel.isInspiratedCreate = YES;
    mModel.fromPhotoLibrary = YES;
    [self.parentMachine changeStateTo:[States InspiratedEdit] pushState:NO];
    
    //    JWFile *f = [JWFile fileWithType:JWFileTypeDocument path:[NSString stringWithFormat:@"233.png"]];
    //    JWFile *a = [JWFile fileWithType:JWFileTypeDocument path:[NSString stringWithFormat:@"122.png"]];
    //    [UIImagePNGRepresentation(image) writeToFile:f.realPath atomically:YES];
    //    [UIImagePNGRepresentation(im) writeToFile:a.realPath atomically:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"cancel");
    App *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.orientationMask = UIInterfaceOrientationMaskLandscapeRight;
    [mModel.mainController dismissViewControllerAnimated:YES completion:nil];
}

@end
