//
//  JWFile.h
//  June Winter
//
//  Created by GavinLo on 14-2-22.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWObject.h>
#import <jw/JWTransmitable.h>
#import <jw/JWAsyncResult.h>
#import <jw/JWEncoding.h>
#import <jw/JWResourceBundle.h>
#import <jw/JWAssetsBundle.h>

/**
 * 文件类型
 */
typedef NS_ENUM(NSInteger, JWFileType)
{
    JWFileTypeBundle,
    JWFileTypeDocument,
    JWFileTypeLibrary,
    JWFileTypeUrl,
    JWFileTypeMemory,
    JWFileTypeFiles,
};

typedef void (^JWFileOnDataBlock)(NSData* data, NSError* error);

@interface JWFileDataSyncResult : NSObject

@property (nonatomic, readwrite) NSData* data;
@property (nonatomic, readwrite) NSError* error;

- (id) initWithData:(NSData*)data andError:(NSError*)error;
+ (id) resultWithData:(NSData*)data andError:(NSError*)error;

@end

/**
 * 文件接口
 */
@protocol JIFile <JITransmitable>

/**
 * 文件类型
 */
@property (nonatomic, readwrite) JWFileType type;

/**
 * bundle,对于JWFileTypeBundle有效
 */
@property (nonatomic, readwrite) NSBundle* bundle;

/**
 * 文件路径,对于JWFileTypeBundle,JWFileTypeDocument有效
 */
@property (nonatomic, readwrite) NSString* path;

/**
 * 文件真实路径（也就是说，全路径）,对于JWFileTypeBundle,JWFileTypeDocument有效
 */
@property (nonatomic, readonly) NSString* realPath;

/**
 * 文件URL,设置时对于JWFileTypeUrl有效
 */
@property (nonatomic, readwrite) NSURL* url;

/**
 * 文件名字,设置时对于JWFileTypeMemory,JWFileTypeFiles有效
 */
@property (nonatomic, readwrite) NSString* name;

/**
 * 文件内容,对于JWFileTypeMemory类型有效
 */
@property (nonatomic, readwrite) id content;

/**
 * 文件集合,对于JWFileTypeFiles类型有效
 */
@property (nonatomic, readonly) NSMutableArray* files;

/**
 * 返回路径中的filename部分,即:"scheme://password@host:port/dir1/dir2/basename.extension"中的"basename.extension"
 * @return
 */
@property (nonatomic, readonly) NSString* filename;

/**
 * 返回路径中的basename部分,即:"scheme://password@host:port/dir1/dir2/basename.extension"中的"basename"
 * @return
 */
@property (nonatomic, readonly) NSString* basename;

/**
 * 返回路径中的extension部分,即:"scheme://password@host:port/dir1/dir2/basename.extension"中的"extension"
 * 同时支持修改extension
 * @return
 */
@property (nonatomic, readwrite) NSString* extension;

/**
 * 获取父目录{@link IFile}对象
 * @return
 */
@property (nonatomic, readonly) id<JIFile> dir;

/**
 * 根据相对路径生成{@link IFile}对象
 * @param relPath
 * @return
 */
- (id<JIFile>) relFileFromPath:(NSString*)relPath;

/**
 * 文件是否存在
 * @return
 */
@property (nonatomic, readonly) BOOL exists;

/**
 * 文件数据(同步)
 */
@property (nonatomic, readwrite) NSData* data;

/**
 * 获取文件数据(同步/异步)
 * @see data
 */
- (JWAsyncResult*) dataWillGet:(BOOL)async onData:(JWFileOnDataBlock)onData;

/**
 * 文件数据转换为字符串(同步,UTF8)
 */
@property (nonatomic, readwrite) NSString* stringData;

/**
 * 文件数据转换为字符串(同步)
 */
- (NSString*) stringWithEncoding:(JWEncoding)encoding;

/**
 * 字符串转换为文件数据(同步)
 */
- (void) setString:(NSString*)stringData withEncoding:(JWEncoding)encoding;

- (void) deleteFile;

/**
 * 检查文件名是否匹配正则表达式
 */
- (BOOL) isMatchPattern:(NSRegularExpression*)pattern;

/**
 * 附加数据(一般用于附件额外的绑定数据和一些比较特殊的场景,如在缓存中希望同一个图片文件以不同配置缓存起来,不过要注意hashcode有可能产生冲突(相同)的情况)
 */
@property (nonatomic, readwrite) id extra;

@end

/**
 * 文件对象
 */
@interface JWFile : JWTransmitable <JIFile>

+ (id) file;
+ (id) fileWithBundle:(NSBundle*)bundle path:(NSString*)path;
+ (id) fileWithType:(JWFileType)type path:(NSString*)path;
+ (id) fileWithUrl:(NSURL*)url;
+ (id) fileWithName:(NSString*)name content:(id)content;
+ (id) fileWithName:(NSString *)name files:(NSArray*)files;
+ (id) fileWithFiles:(NSArray*)files;
- (id) initWithBundle:(NSBundle*)bundle path:(NSString*)path;
- (id) initWithMainBundlePath:(NSString*)path;
- (id) initWithType:(JWFileType)type path:(NSString*)path;
- (id) initWithUrl:(NSURL*)url;
- (id) initWithName:(NSString*)name content:(id)content;
- (id) initWithName:(NSString *)name files:(NSArray*)files;
- (id) initWithFiles:(NSArray*)files;
 
@end
