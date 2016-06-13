//
//  NSBundle+JWUiCategory.m
//  June Winter
//
//  Created by GavinLo on 14-3-4.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "NSBundle+JWUiCategory.h"
#import "UIDevice+JWCoreCategory.h"
#import "NSBundle+JWCoreCategory.h"
#import "JWFileUtils.h"
#import "JWExceptions.h"

@implementation NSBundle (JWUiCategory)

- (UIView *)loadXibNamed:(NSString *)name owner:(id)owner options:(NSDictionary *)options
{
    NSString* xibName = [NSBundle findXibNameByBase:name];
    if(xibName == nil)
    {
        @throw [JWException exceptionWithName:@"xib" reason:[NSString stringWithFormat:@"cannot find match xib file for name %@.", name] userInfo:nil];
    }
    
    NSArray* res = [self loadNibNamed:xibName owner:owner options:options];
    if(res == nil || res.count == 0)
        return nil;
    UIView* view = [res objectAtIndex:0];
    return view;
}

+ (NSString*) findXibNameByBase:(NSString*)base
{
    __block NSString* xibName = [NSString stringWithFormat:@"%@%@", base, [UIDevice currentDevice].fileSuffix];
    NSString* xibPath = [[NSBundle mainBundle] pathForResource:xibName ofType:@"nib"];
    
    // 直接找对应配置的xib文件
    if([[NSFileManager defaultManager] fileExistsAtPath:xibPath])
        return xibName;
    
    xibName = nil;
    [UIDevice enumResolutions:^(UIDeviceResolution resolution, BOOL *stop) {
        if(resolution != [UIDevice currentDevice].resolution)
        {
            NSString* xn = [NSString stringWithFormat:@"%@%@", base, [UIDevice fileSuffixFromResolution:resolution]];
            NSString* xp = [[NSBundle mainBundle] pathForResource:xn ofType:@"nib"];
            if([[NSFileManager defaultManager] fileExistsAtPath:xp])
            {
                xibName = xn;
                *stop = YES;
            }
        }
    }];
    NSLog(@"cannot find direct xib file, use %@ instead.", xibName);
    return xibName;
}

@end
