//
//  JWNetUtils.m
//  June Winter
//
//  Created by GavinLo on 14-3-17.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWNetUtils.h"
#import "../apple/Reachability.h"

@implementation JWNetUtils

+ (BOOL)isNetworkConnected
{
    Reachability* r = [Reachability reachabilityForInternetConnection];
    return [r currentReachabilityStatus] != NotReachable;
}

@end
