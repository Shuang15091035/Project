//
//  JWResponseStatus.m
//  June Winter
//
//  Created by GavinLo on 14-2-20.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWResponseStatus.h"

@implementation JWResponseStatusUtils

+ (NSString *)getLocalDescription:(JWResponseStatus)status
{
    NSString* desc = nil;
    switch(status)
    {
        case JWResponseStatusTimeout:
        {
            desc = @"网络超时";
            break;
        }
        case JWResponseStatusNoNetWorkConnection:
        {
            desc = @"无网络连接";
            break;
        }
        case JWResponseStatusCannotConnectToHost:
        {
            desc = @"无法连接服务器";
            break;
        }
        case JWResponseStatusClientError:
        {
            desc = @"客户端错误";
            break;
        }
        case JWResponseStatusOk:
        {
            desc = @"请求成功";
            break;
        }
        case JWResponseStatusBadRequest:
        {
            desc = @"服务器无法理解该请求";
            break;
        }
        case JWResponseStatusForbidden:
        {
            desc = @"请求被拒绝";
            break;
        }
        case JWResponseStatusNotFound:
        {
            desc = @"请求失败";
            break;
        }
        case JWResponseStatusInternalError:
        {
            desc = @"服务器内部错误";
            break;
        }
    }
    return desc;
}

@end