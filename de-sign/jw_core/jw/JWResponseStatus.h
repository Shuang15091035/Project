//
//  JWResponseStatus.h
//  June Winter
//
//  Created by GavinLo on 14-2-20.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 网络状态
 */
typedef NS_ENUM(NSInteger, JWResponseStatus)
{
    // 本地错误 -----------------------------------------------
    JWResponseStatusTimeout                = -1,
    JWResponseStatusNoNetWorkConnection    = -2,
    JWResponseStatusCannotConnectToHost    = -3,
    JWResponseStatusClientError            = -4,
    
    // 网络状态 -----------------------------------------------
    JWResponseStatusOk                     = 200,
    JWResponseStatusBadRequest             = 400,
    JWResponseStatusForbidden              = 403,
    JWResponseStatusNotFound               = 404,
    JWResponseStatusInternalError          = 500,
};

@interface JWResponseStatusUtils : NSObject

+ (NSString*) getLocalDescription:(JWResponseStatus)status;

@end