//
//  UIDevice+JWCoreCategory.m
//  June Winter
//
//  Created by GavinLo on 14-3-9.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "UIDevice+JWCoreCategory.h"
#import <sys/types.h>
#import <sys/sysctl.h>

@implementation UIDevice (JWCoreCategory)

- (UIDeviceResolution)resolution
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if([[UIScreen mainScreen] respondsToSelector: @selector(scale)])
        {
            CGSize screenSize = [[UIScreen mainScreen] bounds].size;
            if(screenSize.height <= 480.0f)
                return UIDeviceResolutionPhoneHD;
            return UIDeviceResolutionPhone5HD;
        }
        else
        {
            return UIDeviceResolutionPhoneSD;
        }
    }
    else
    {
        if([[UIScreen mainScreen] respondsToSelector: @selector(scale)])
        {
            return UIDeviceResolutionPadHD;
        }
        else
        {
            return UIDeviceResolutionPadSD;
        }
    }
}

- (NSString *)fileSuffix
{
    return [UIDevice fileSuffixFromResolution:self.resolution];
}

+ (NSString *)fileSuffixFromResolution:(UIDeviceResolution)resolution
{
    NSString* suffix = nil;
    switch(resolution)
    {
        case UIDeviceResolutionPhoneSD:
        {
            suffix = @"";
            break;
        }
        case UIDeviceResolutionPhoneHD:
        {
            suffix = @"@2x";
            break;
        }
        case UIDeviceResolutionPhone5HD:
        {
            suffix = @"-568h@2x";
            break;
        }
        case UIDeviceResolutionPadSD:
        {
            suffix = @"~ipad";
            break;
        }
        case UIDeviceResolutionPadHD:
        {
            suffix = @"2x~ipad";
            break;
        }
        default:
            break;
    }
    return suffix;
}

+ (void)enumResolutions:(UIDeviceOnResolutionBlock)onResolution
{
    if(onResolution == nil)
        return;
    for(NSInteger r = UIDeviceResolutionPhoneSD; r < UIDeviceResolutionCount; r++)
    {
        BOOL stop = NO;
        onResolution((UIDeviceResolution)r, &stop);
        if(stop)
            break;
    }
}

- (UIDeviceType)type {
    NSString* model = self.model;
    NSRange range = [model rangeOfString:@"iPhone"];
    if (range.location != NSNotFound) {
        return UIDeviceTypeIPhone;
    }
    range = [model rangeOfString:@"iPad"];
    if (range.location != NSNotFound) {
        return UIDeviceTypeIPad;
    }
    range = [model rangeOfString:@"iPod"];
    if (range.location != NSNotFound) {
        return UIDeviceTypeIPod;
    }
    return UIDeviceTypeUnknown;
}

- (UIDeviceIPhoneModel)iphoneModel {
    if (self.type != UIDeviceTypeIPhone) {
        return UIDeviceIPhoneModelUnknown;
    }
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char* name = (char*)malloc(size);
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    NSString *iphoneModel = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    free(name);
    if ([iphoneModel isEqualToString:@"iPhone1,1"]) {
        return UIDeviceIPhoneModel1;
    } else if ([iphoneModel isEqualToString:@"iPhone1,2"]) {
        return UIDeviceIPhoneModel3;
    } else if ([iphoneModel isEqualToString:@"iPhone2,1"]) {
        return UIDeviceIPhoneModel3;
    } else if ([iphoneModel isEqualToString:@"iPhone3,1"]) {
        return UIDeviceIPhoneModel4;
    } else if ([iphoneModel isEqualToString:@"iPhone3,3"]) {
        return UIDeviceIPhoneModel4;
    } else if ([iphoneModel isEqualToString:@"iPhone4,1"]) {
        return UIDeviceIPhoneModel4;
    } else if ([iphoneModel isEqualToString:@"iPhone5,1"]) {
        return UIDeviceIPhoneModel5;
    } else if ([iphoneModel isEqualToString:@"iPhone5,2"]) {
        return UIDeviceIPhoneModel5;
    } else if ([iphoneModel isEqualToString:@"iPhone5,3"]) {
        return UIDeviceIPhoneModel5c;
    } else if ([iphoneModel isEqualToString:@"iPhone5,4"]) {
        return UIDeviceIPhoneModel5c;
    } else if ([iphoneModel isEqualToString:@"iPhone6,1"]) {
        return UIDeviceIPhoneModel5s;
    } else if ([iphoneModel isEqualToString:@"iPhone6,2"]) {
        return UIDeviceIPhoneModel5s;
    } else if ([iphoneModel isEqualToString:@"iPhone7,1"]) {
        return UIDeviceIPhoneModel6;
    } else if ([iphoneModel isEqualToString:@"iPhone7,2"]) {
        return UIDeviceIPhoneModel6;
    } else if ([iphoneModel isEqualToString:@"iPhone8,1"]) {
        return UIDeviceIPhoneModel6s;
    } else if ([iphoneModel isEqualToString:@"iPhone8,2"]) {
        return UIDeviceIPhoneModel6s;
    }else {
        return UIDeviceIPhoneModelUnknown;
    }
}

- (UIDeviceIPadModel)ipadModel {
    if (self.type != UIDeviceTypeIPad) {
        return UIDeviceIPadModelUnknown;
    }
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char* name = (char*)malloc(size);
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    NSString *ipadModel = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    free(name);
    if ([ipadModel isEqualToString:@"iPad1,1"]) {
        return UIDeviceIPadModel1;
    } else if ([ipadModel isEqualToString:@"iPad2,1"]) {
        return UIDeviceIPadModel2;
    } else if ([ipadModel isEqualToString:@"iPad2,2"]) {
        return UIDeviceIPadModel2;
    } else if ([ipadModel isEqualToString:@"iPad2,3"]) {
        return UIDeviceIPadModel2;
    } else if ([ipadModel isEqualToString:@"iPad2,4"]) {
        return UIDeviceIPadModel2;
    } else if ([ipadModel isEqualToString:@"iPad2,5"]) {
        return UIDeviceIPadModelMini;
    } else if ([ipadModel isEqualToString:@"iPad2,6"]) {
        return UIDeviceIPadModelMini;
    } else if ([ipadModel isEqualToString:@"iPad2,7"]) {
        return UIDeviceIPadModelMini;
    } else if ([ipadModel isEqualToString:@"iPad3,1"]) {
        return UIDeviceIPadModel3;
    } else if ([ipadModel isEqualToString:@"iPad3,2"]) {
        return UIDeviceIPadModel3;
    } else if ([ipadModel isEqualToString:@"iPad3,3"]) {
        return UIDeviceIPadModel3;
    } else if ([ipadModel isEqualToString:@"iPad3,4"]) {
        return UIDeviceIPadModel4;
    } else if ([ipadModel isEqualToString:@"iPad3,5"]) {
        return UIDeviceIPadModel4;
    } else if ([ipadModel isEqualToString:@"iPad3,6"]) {
        return UIDeviceIPadModel4;
    } else if ([ipadModel isEqualToString:@"iPad4,1"]) {
        return UIDeviceIPadModelAir;
    } else if ([ipadModel isEqualToString:@"iPad4,2"]) {
        return UIDeviceIPadModelAir;
    } else if ([ipadModel isEqualToString:@"iPad4,4"]) {
        return UIDeviceIPadModelMini2G;
    } else if ([ipadModel isEqualToString:@"iPad4,5"]) {
        return UIDeviceIPadModelMini2G;
    } else if ([ipadModel isEqualToString:@"iPad4,7"]) {
        return UIDeviceIPadModelMini3;
    } else if ([ipadModel isEqualToString:@"iPad4,8"]) {
        return UIDeviceIPadModelMini3;
    } else if ([ipadModel isEqualToString:@"iPad4,9"]) {
        return UIDeviceIPadModelMini3;
    } else if ([ipadModel isEqualToString:@"iPad5,3"]) {
        return UIDeviceIPadModelAir2;
    } else if ([ipadModel isEqualToString:@"iPad5,4"]) {
        return UIDeviceIPadModelAir2;
    } else {
        return UIDeviceIPadModelUnknown;
    }
}

@end
