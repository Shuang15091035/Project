//
//  JWNetMessage.h
//  June Winter
//
//  Created by GavinLo on 14-2-19.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <jw/JWObject.h>
#import <jw/JWStringSerializable.h>
#import <jw/JWNetFormatter.h>

/**
 * 网络消息
 */
@protocol IJWNetMessage <JISerializeObject, JIStringSerializable>

@property (nonatomic, readwrite) JWNetFormatter* formatter;

/**
 * 从对象中获取参数列表
 * @param outParams 参数列表 key(NSString) => value(NSString)
 */
- (void) getParams:(NSMutableDictionary*)outParams;

/**
 * 根据参数列表设置对象
 * @param inParams 参数列表 key(NSString) => value(NSString)
 */
- (void) setParams:(NSDictionary*)inParams;

/**
 * 从对象中获取header列表
 * @param outHeaders header列表 key(NSString) => value(NSString)
 */
- (void) getHeaders:(NSMutableDictionary*)outHeaders;

/**
 * 根据header列表设置对象
 * @param inHeaders header列表 key(NSString) => value(NSString)
 */
- (void) setHeaders:(NSDictionary*)inHeaders;

/**
 * 从对象中获取文件列表
 * @param outFiles 文件列表 key(NSString) => value(IJWFile)
 */
- (void) getFiles:(NSMutableDictionary*)outFiles;

/**
 * 根据文件列表设置对象
 * @param inFiles 文件列表 key(NSString) => value(IJWFile)
 */
- (void) setFiles:(NSDictionary*)inFiles;

@end

/**
 * 网络消息
 */
@interface JWNetMessage : JWSerializeObject <IJWNetMessage>
{
    JWNetFormatter* mFormatter;
}

+ (NSInteger) SerializeParamsMethodId;

/**
 * 指定该如何序列化参数列表
 * @return 参数列表 name(NSString) => info(JWSerializeInfo)
 */
- (NSDictionary*) serializeParams;

/**
 * 指定该如何序列化header
 * @return header列表 name(NSString)
 */
- (NSArray*) serializeHeaders;

/**
 * 指定该如何序列化header中的cookie
 * @return header列表 name(NSString)
 */
- (NSArray*) serializeCookies;

/**
 * 指定该如何序列化文件列表
 * @return header列表 name(NSString)
 */
- (NSArray*) serializeFiles;

@end