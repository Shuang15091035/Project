//
//  InspiratedImagePickerController.m
//  project_mesher
//
//  Created by mac zdszkj on 16/4/8.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "InspiratedImagePickerController.h"
#import <jw/CMDeviceMotion+JWCoreCategory.h>
#import <jw/UIDevice+JWCoreCategory.h>
#import "App.h"

@interface InspiratedImagePickerController()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    id<IMesherModel> mModel;
    JCQuaternion quater;
    id<InspiratedImagePickerDelegate> mPickerDelegate;
}

@end

@implementation InspiratedImagePickerController

@synthesize pickerDelegate = mPickerDelegate;

- (instancetype)initWithModel:(id<IMesherModel>)model {
    self = [super init];
    if (self) {
        mModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.delegate = self;
//    self.showsCameraControls = NO;
//    JWRelativeLayout *lo_background = [JWRelativeLayout layout];
//    
//    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
//        lo_background.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone) {
//        lo_background.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
//    }
//    lo_background.backgroundColor = [UIColor clearColor];
//    self.cameraViewTransform = CGAffineTransformScale(self.cameraViewTransform,1,1.5);
//    self.cameraOverlayView = lo_background;
//    JWRelativeLayout *lo_shot = [JWRelativeLayout layout];
//    JWRelativeLayout *bg_shot = [JWRelativeLayout layout];
//    UIImage *img_shot = [UIImage imageByResourceDrawable:@"btn_shot_n"];
//    UIButton *btn_shot = [[UIButton alloc] initWithImage:img_shot selectedImage:img_shot];
//    UIImage *img_back = [UIImage imageByResourceDrawable:@"btn_close_white"];
//    UIButton *btn_back = [[UIButton alloc] initWithImage:img_back selectedImage:img_back];
//    
//    if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
//        lo_shot.layoutParams.width = JWLayoutMatchParent;
//        lo_shot.layoutParams.height = [MesherModel uiHeightBy:136.0f];
//        lo_shot.backgroundColor = [UIColor clearColor];
//        lo_shot.layoutParams.alignment = JWLayoutAlignParentBottom;
//        [lo_background addSubview:lo_shot];
//        
//        bg_shot.layoutParams.width = JWLayoutMatchParent;
//        bg_shot.layoutParams.height = JWLayoutMatchParent;
//        bg_shot.backgroundColor = [UIColor blackColor];
//        bg_shot.alpha = 0.3f;
//        [lo_shot addSubview:bg_shot];
//        
//        btn_shot.layoutParams.width = JWLayoutWrapContent;
//        btn_shot.layoutParams.height = JWLayoutWrapContent;
//        btn_shot.layoutParams.alignment = JWLayoutAlignCenterInParent;
//        [lo_shot addSubview:btn_shot];
//        
//        btn_back.layoutParams.width = JWLayoutWrapContent;
//        btn_back.layoutParams.height = JWLayoutWrapContent;
//        btn_back.layoutParams.alignment = JWLayoutAlignCenterVertical | JWLayoutAlignParentLeft;
//        btn_back.layoutParams.marginLeft = [MesherModel uiWidthBy:20.0f];
//        [lo_shot addSubview:btn_back];
//        
//    }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone) {
//        lo_shot.layoutParams.width = [MesherModel uiWidthBy:136.0f];
//        lo_shot.layoutParams.height = JWLayoutMatchParent;
//        lo_shot.backgroundColor = [UIColor clearColor];
//        lo_shot.layoutParams.alignment = JWLayoutAlignParentLeft;
//        [lo_background addSubview:lo_shot];
//        
//        bg_shot.layoutParams.width = JWLayoutMatchParent;
//        bg_shot.layoutParams.height = JWLayoutMatchParent;
//        bg_shot.backgroundColor = [UIColor blackColor];
//        bg_shot.alpha = 0.3f;
//        [lo_shot addSubview:bg_shot];
//        
//        btn_shot.layoutParams.width = JWLayoutWrapContent;
//        btn_shot.layoutParams.height = JWLayoutWrapContent;
//        btn_shot.layoutParams.alignment = JWLayoutAlignCenterInParent;
//        [lo_shot addSubview:btn_shot];
//        
//        btn_back.layoutParams.width = JWLayoutWrapContent;
//        btn_back.layoutParams.height = JWLayoutWrapContent;
//        btn_back.layoutParams.alignment = JWLayoutAlignCenterHorizontal | JWLayoutAlignParentTop;
//        btn_back.layoutParams.marginTop = [MesherModel uiHeightBy:20.0f];
//        [lo_shot addSubview:btn_back];
//    }
//    
//    [btn_shot addTarget:self action:@selector(shot) forControlEvents:UIControlEventTouchUpInside];
//    [btn_back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (void)start {
    CMMotionManager* motionManager = mModel.currentContext.motionManager;
    if (motionManager.deviceMotionAvailable) {
        if ([UIDevice currentDevice].type == UIDeviceTypeIPad) {
            if ([UIDevice currentDevice].ipadModel <= UIDeviceIPadModel4) {
                motionManager.deviceMotionUpdateInterval = 1.0f / 30.0f;
            } else {
                motionManager.deviceMotionUpdateInterval = 1.0f / 60.0f;
            }
        } else if ([UIDevice currentDevice].type == UIDeviceTypeIPhone) {
            if ([UIDevice currentDevice].iphoneModel <= UIDeviceIPhoneModel4) {
                motionManager.deviceMotionUpdateInterval = 1.0f / 15.0f;
            } else if ([UIDevice currentDevice].iphoneModel > UIDeviceIPhoneModel4 && [UIDevice currentDevice].iphoneModel < UIDeviceIPhoneModel5s) {
                motionManager.deviceMotionUpdateInterval = 1.0f / 30.0f;
            } else {
                motionManager.deviceMotionUpdateInterval = 1.0f / 60.0f;
            }
        }
        [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical toQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            quater = [motion orientationByInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
        }];
    }
}

- (void)stop {
    CMMotionManager* motionManager = mModel.currentContext.motionManager;
    [motionManager stopDeviceMotionUpdates];
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self stop];
    NSLog(@"%f,%f,%f,%f",quater.w,quater.x,quater.y,quater.z);
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSLog(@"image size: %f, %f", image.size.width, image.size.height);
//        NSData *data;
//        if (UIImagePNGRepresentation(image) == nil) {
//            data = UIImageJPEGRepresentation(image, 1.0);
//        }else {
//            data = UIImagePNGRepresentation(image);
//        }
        
        //        //图片保存的路径
        //        //这里将图片放在沙盒的documents文件夹中
        //        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        //
        //        //文件管理器
        //        NSFileManager *fileManager = [NSFileManager defaultManager];
        //
        //        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        //        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        //        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        //
        //        //得到选择后沙盒中图片的完整路径
        //        NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        //
        //        //关闭相册界面
        //        [picker dismissModalViewControllerAnimated:YES];
        //
        //        //创建一个选择后图片的小图标放在下方
        //        //类似微薄选择图后的效果
        //        //        UIImageView *smallimage = [[UIImageView alloc] initWithFrame:
        //        //                                    CGRectMake(50, 120, 40, 40)];
        //        //
        //        //        smallimage.image = image;
        //        //        //加在视图中
        //        //        [self.view addSubview:smallimage];
        //
        //        //img.image = image;
        
        
//        id<JIFile> file = [JWFile fileWithName:@"image.png" content:image];
        //id<JIFile> file = [JWFile fileWithType:JWFileTypeDocument path:@"image.png"];
        //        [JWPrefabUtils createSpriteWithContext:mModel.currentContext parent:mModel.world.currentScene.root rect:JCRectFMake(0, 0, bounds.size.width, bounds.size.height) textureFile:file];
        
//        [backgroundSprite.spriteTexture.manager destroyByFile:backgroundSprite.spriteTexture.file];// 先移除旧的图
//        [backgroundSprite setSpriteTextureFile:file];// 载入新的图
        
        App *appDelegate = [UIApplication sharedApplication].delegate;
        appDelegate.orientationMask = UIInterfaceOrientationMaskLandscapeRight;
        if (mPickerDelegate) {
            [mPickerDelegate getImage:image AndQuaternion:quater];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"您取消了选择图片");
    [self stop];
//    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)shot{
    [self start];
    [self takePicture];
}



@end
