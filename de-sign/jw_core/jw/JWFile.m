//
//  JWFile.m
//  June Winter
//
//  Created by GavinLo on 14-2-22.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWFile.h"
#import "JWFileUtils.h"
#import "JWFileDataAsyncTask.h"
#import "JWHttp.h"
#import "JWHashcode.h"
#import "NSString+JWCoreCategory.h"
#import "NSArray+JWCoreCategory.h"
#import "NSBundle+JWCoreCategory.h"

@implementation JWFileDataSyncResult

@synthesize data = mData;
@synthesize error = mError;

- (id)initWithData:(NSData *)data andError:(NSError *)error
{
    self = [super init];
    if(self != nil)
    {
        mData = data;
        mError = error;
    }
    return self;
}

+ (id)resultWithData:(NSData *)data andError:(NSError *)error
{
    return [[JWFileDataSyncResult alloc] initWithData:data andError:error];
}

@end

@interface JWFile () {
    JWFileType mType;
    NSBundle* mBundle;
    NSString* mPath;
    NSURL* mUrl;
    id mContent;
    NSMutableArray* mFiles;
    id mExtra;
}

@end

@implementation JWFile

+ (id)file {
    return [[self alloc] init];
}

+ (id)fileWithBundle:(NSBundle *)bundle path:(NSString *)path {
    return [[self alloc] initWithBundle:bundle path:path];
}

+ (id)fileWithType:(JWFileType)type path:(NSString *)path {
    return [[self alloc] initWithType:type path:path];
}

+ (id)fileWithUrl:(NSURL *)url {
    return [[self alloc] initWithUrl:url];
}

+ (id)fileWithName:(NSString *)name content:(id)content {
    return [[self alloc] initWithName:name content:content];
}

+ (id)fileWithName:(NSString *)name files:(NSArray *)files {
    return [[self alloc] initWithName:name files:files];
}

+ (id)fileWithFiles:(NSArray *)files {
    return [[self alloc] initWithFiles:files];
}

- (id)initWithBundle:(NSBundle *)bundle path:(NSString *)path {
    self = [super init];
    if (self != nil) {
        mType = JWFileTypeBundle;
        mBundle = bundle;
        if (mBundle == nil) {
            mBundle = [NSBundle mainBundle];
        }
        mPath = path;
    }
    return self;
}

- (id)initWithMainBundlePath:(NSString *)path {
    return [self initWithBundle:[NSBundle mainBundle] path:path];
}

- (id)initWithType:(JWFileType)type path:(NSString *)path {
    self = [super init];
    if (self != nil) {
        mType = type;
        if (mType == JWFileTypeBundle) {
            mBundle = [NSBundle mainBundle];
        }
        mPath = path;
    }
    return self;
}

- (id)initWithUrl:(NSURL *)url {
    self = [super init];
    if (self != nil) {
        mType = JWFileTypeUrl;
        mUrl = url;
    }
    return self;
}

- (id)initWithName:(NSString *)name content:(id)content {
    self = [super init];
    if (self != nil) {
        mType = JWFileTypeMemory;
        mPath = name;
        mContent = content;
    }
    return self;
}

- (id)initWithName:(NSString *)name files:(NSArray *)files {
    self = [super init];
    if (self != nil) {
        mType = JWFileTypeFiles;
        mPath = name;
        if (files != nil) {
            mFiles = [NSMutableArray arrayWithArray:files];
        }
    }
    return self;
}

- (id)initWithFiles:(NSArray *)files {
    return [self initWithName:nil files:files];
}

@synthesize type = mType;
@synthesize bundle = mBundle;
@synthesize path = mPath;

- (NSString *)realPath {
    NSString* rp = nil;
    switch(mType) {
        case JWFileTypeBundle: {
            rp = [mBundle pathForResource:mPath ofType:nil];
            break;
        }
        case JWFileTypeDocument: {
            rp = [JWFileUtils fullPathForDocument:mPath];
            break;
        }
        case JWFileTypeLibrary: {
            // TODO
            break;
        }
        case JWFileTypeUrl: {
            rp = mUrl.absoluteString;
            break;
        }
        case JWFileTypeMemory: {
            // NO path
            break;
        }
        case JWFileTypeFiles: {
            // NO path
            break;
        }
    }
    return rp;
}

@synthesize url = mUrl;
@synthesize content = mContent;

- (NSString *)name {
    return mPath;
}

- (void)setName:(NSString *)name {
    mPath = name;
}

- (NSMutableArray *)files {
    if (mFiles == nil) {
        mFiles = [NSMutableArray array];
    }
    return mFiles;
}

- (NSString *)filename {
    NSString* fn = nil;
    switch(mType) {
        case JWFileTypeBundle:
        case JWFileTypeDocument: {
            fn = [mPath lastPathComponent];
            break;
        }
        case JWFileTypeLibrary: {
            break;
        }
        case JWFileTypeUrl: {
            fn = [mUrl lastPathComponent];
            break;
        }
        case JWFileTypeMemory: {
            fn = mPath;
            break;
        }
        case JWFileTypeFiles: {
            break;
        }
    }
    return fn;
}

- (NSString *)basename {
    NSString* bn = nil;
    NSString* fn = self.filename;
    if (fn != nil) {
        bn = [fn stringByDeletingPathExtension];
    }
    return bn;
}

- (NSString *)extension {
    NSString* ext = nil;
    NSString* fn = self.filename;
    if (fn != nil) {
        ext = [fn pathExtension];
    }
    return ext;
}

- (void)setExtension:(NSString *)extension {
    switch(mType) {
        case JWFileTypeBundle:
        case JWFileTypeDocument:
        case JWFileTypeMemory: {
            NSString* newPath = [mPath stringByDeletingPathExtension];
            newPath = [newPath stringByAppendingPathExtension:extension];
            mPath = newPath;
            break;
        }
        case JWFileTypeLibrary: {
            break;
        }
        case JWFileTypeUrl: {
            NSURL* newUrl = [mUrl URLByDeletingPathExtension];
            newUrl = [mUrl URLByAppendingPathExtension:extension];
            mUrl = newUrl;
            break;
        }
        case JWFileTypeFiles: {
            break;
        }
    }
}

- (id<JIFile>)dir {
    id<JIFile> d = nil;
    switch(mType) {
        case JWFileTypeBundle: {
            NSString* dirPath = [mPath stringByGettingDirPath];
            d = [JWFile fileWithBundle:mBundle path:dirPath];
            break;
        }
        case JWFileTypeDocument: {
            NSString* dirPath = [mPath stringByGettingDirPath];
            d = [JWFile fileWithType:mType path:dirPath];
            break;
        }
        case JWFileTypeLibrary: {
            // TODO
            break;
        }
        case JWFileTypeUrl: {
            NSURL* dirUrl = [mUrl URLByDeletingLastPathComponent];
            d = [JWFile fileWithUrl:dirUrl];
            break;
        }
        case JWFileTypeMemory:
        case JWFileTypeFiles: {
            // nothing to do
            break;
        }
    }
    return d;
}

- (id<JIFile>)relFileFromPath:(NSString *)relPath {
    id<JIFile> f = nil;
    switch(mType) {
        case JWFileTypeBundle: {
            NSString* filePath = [mPath stringByAppendingPathComponent:relPath];
            f = [JWFile fileWithBundle:mBundle path:filePath];
            break;
        }
        case JWFileTypeDocument: {
            NSString* filePath = [mPath stringByAppendingPathComponent:relPath];
            f = [JWFile fileWithType:mType path:filePath];
            break;
        }
        case JWFileTypeLibrary: {
            // TODO
            break;
        }
        case JWFileTypeUrl: {
            NSURL* fileUrl = [NSURL URLWithString:relPath relativeToURL:mUrl];
            f = [JWFile fileWithUrl:fileUrl];
            break;
        }
        case JWFileTypeMemory:
        case JWFileTypeFiles: {
            // nothing to do
            break;
        }
    }
    return f;
}

- (BOOL)exists {
    BOOL b = NO;
    switch(mType) {
        case JWFileTypeBundle: {
            NSString* fullPath = [mBundle pathForResource:mPath ofType:nil];
            if (fullPath != nil) {
                b = [[NSFileManager defaultManager] fileExistsAtPath:fullPath];
            }
            break;
        }
        case JWFileTypeDocument: {
            NSString* fullPath = [JWFileUtils fullPathForDocument:mPath];
            if (fullPath != nil) {
                b = [[NSFileManager defaultManager] fileExistsAtPath:fullPath];
            }
            break;
        }
        case JWFileTypeLibrary: {
            // TODO
            break;
        }
        case JWFileTypeUrl: {
            // TODO
            break;
        }
        case JWFileTypeMemory:
        case JWFileTypeFiles: {
            // nothing to do
            break;
        }
    }
    return b;
}

- (NSData *)data {
    NSData* data = nil;
    switch(mType) {
        case JWFileTypeBundle: {
            NSString* fullPath = [mBundle pathForResource:mPath ofType:nil];
            if (fullPath != nil) {
                data = [NSData dataWithContentsOfFile:fullPath];
            }
            break;
        }
        case JWFileTypeDocument:
        {
            NSString* fullPath = [JWFileUtils fullPathForDocument:mPath];
            if (fullPath != nil) {
                data = [NSData dataWithContentsOfFile:fullPath];
            }
            break;
        }
        case JWFileTypeLibrary: {
            // TODO
            break;
        }
        case JWFileTypeUrl: {
            if (mUrl != nil) {
                if (mUrl.isFileURL) {
                    NSString* fullPath = mUrl.path;
                    if (fullPath != nil) {
                        data = [NSData dataWithContentsOfFile:fullPath];
                    }
                }
                else {
                    __block NSData* urlData = nil;
                    [JWHttpUtils executeWithUrl:mUrl.absoluteString method:JWHttpMethodGet encoding:JWEncodingUTF8 timeout:0 params:nil headers:nil files:nil async:NO completionHandler:^(NSHTTPURLResponse* res, NSData* resData, NSError* err) {
                        urlData = resData;
                    }];
                    data = urlData;
                }
            }
            break;
        }
        case JWFileTypeMemory: {
            data = mContent;
            break;
        }
        case JWFileTypeFiles: {
            break;
        }
    }
    return data;
}

- (void)setData:(NSData *)data {
    switch(mType) {
        case JWFileTypeBundle: {
            // 不可写
            break;
        }
        case JWFileTypeDocument: {
            NSString* filePath = [JWFileUtils fullPathForDocument:mPath];
            if(filePath != nil)
                [data writeToFile:filePath atomically:YES];
            break;
        }
        case JWFileTypeLibrary: {
            // TODO
            break;
        }
        case JWFileTypeUrl: {
            // TODO
            break;
        }
        case JWFileTypeMemory: {
            mContent = data;
            break;
        }
        case JWFileTypeFiles: {
            break;
        }
    }
}

- (JWAsyncResult *)dataWillGet:(BOOL)async onData:(JWFileOnDataBlock)onData {
    JWAsyncResult* result = [JWAsyncResult result];
    JWFileDataAsyncTask* task = [JWFileDataAsyncTask taskWithFile:self onFileData:onData];
    if (!async) {
        [task onPreExecute];
        if (task.isCancelled) {
            result.syncResult = nil;
            return result;
        }
        NSData* data = [task doInBackground:nil];
        [task onPostExecute:data];
        result.syncResult = data;
    }
    else {
        [task execute:nil];
        result.syncResult = nil;
    }
    return result;
}

- (NSString *)stringData {
    if (mType == JWFileTypeMemory && [mContent isKindOfClass:[NSString class]]) {
        return mContent;
    }
    return [self stringWithEncoding:JWEncodingUTF8];
}

- (void)setStringData:(NSString *)stringData {
    if (mType == JWFileTypeMemory && [mContent isKindOfClass:[NSString class]]) {
        mContent = stringData;
        return;
    }
    [self setString:stringData withEncoding:JWEncodingUTF8];
}

- (NSString *)stringWithEncoding:(JWEncoding)encoding {
    NSData* data = self.data;
    if (data == nil) {
        return nil;
    }
    return [[NSString alloc] initWithData:data encoding:[JWEncodingUtils toNSStringEncoding:encoding]];
}

- (void)setString:(NSString *)stringData withEncoding:(JWEncoding)encoding {
    NSData* data = [stringData dataUsingEncoding:[JWEncodingUtils toNSStringEncoding:encoding]];
    self.data = data;
}

- (void)deleteFile {
    switch(mType) {
        case JWFileTypeBundle: {
            // can not delete
            break;
        }
        case JWFileTypeDocument: {
            NSString* fullPath = [JWFileUtils fullPathForDocument:mPath];
            if (fullPath != nil) {
                NSFileManager* fileManager = [NSFileManager defaultManager];
                [fileManager removeItemAtPath:fullPath error:nil];
            }
            break;
        }
        case JWFileTypeLibrary: {
            // TODO
            break;
        }
        case JWFileTypeUrl: {
            // TODO
            break;
        }
        case JWFileTypeMemory: {
            mContent = nil;
            break;
        }
        case JWFileTypeFiles: {
            // TODO
            break;
        }
    }
}

- (BOOL)isMatchPattern:(NSRegularExpression *)pattern {
    if(pattern == nil)
        return NO;
    
    BOOL match = NO;
    switch(mType) {
        case JWFileTypeBundle:
        case JWFileTypeDocument:
        case JWFileTypeLibrary:
        case JWFileTypeMemory: {
            NSRange range = NSMakeRange(0, mPath.length);
            NSTextCheckingResult* result = [pattern firstMatchInString:mPath options:0 range:range];
            match = result != nil;
            break;
        }
        case JWFileTypeUrl: {
            NSString* path = mUrl.absoluteString;
            NSRange range = NSMakeRange(0, path.length);
            NSTextCheckingResult* result = [pattern firstMatchInString:path options:0 range:range];
            match = result != nil;
            break;
        }
        case JWFileTypeFiles: {
            for (id<JIFile> file in self.files) {
                if ([file isMatchPattern:pattern]) {
                    match = YES;
                    break;
                }
            }
            break;
        }
    }
    return match;
}

@synthesize extra = mExtra;

- (NSURL *)toUrl {
    NSURL* url = nil;
    switch(mType) {
        case JWFileTypeBundle: {
            NSString* fullPath = [mBundle pathForResource:mPath ofType:nil];
            if (fullPath != nil) {
                url = [NSURL fileURLWithPath:fullPath];
            }
            break;
        }
        case JWFileTypeDocument: {
            NSString* fullPath = [JWFileUtils fullPathForDocument:mPath];
            if (fullPath != nil) {
                url = [NSURL fileURLWithPath:fullPath];
            }
            break;
        }
        case JWFileTypeLibrary: {
            // TODO
            break;
        }
        case JWFileTypeUrl: {
            url = mUrl;
            break;
        }
        case JWFileTypeMemory: {
            break;
        }
        case JWFileTypeFiles: {
            break;
        }
    }
    return url;
}

- (NSString *)fileExtension {
    NSURL* url = [self toUrl];
    if (url == nil) {
        return nil;
    }
    return [url pathExtension];
}

- (NSString *)mimeType {
    NSString* fileExtension = [self fileExtension];
    return [JWFileUtils mimeTypeForFileExtension:fileExtension];
}

- (BOOL)isEqual:(id)object {
    JWFile* file = (JWFile*)object;
    if(mType != file.type)
        return NO;
    
    BOOL b = NO;
    switch(mType) {
        case JWFileTypeBundle:
        case JWFileTypeDocument:
        case JWFileTypeLibrary: {
            b = (mBundle == file.bundle) && [NSString is:mPath equalsTo:file.path];
            break;
        }
        case JWFileTypeUrl: {
            b = [JWObject is:mUrl equalsTo:file.url];
            break;
        }
        case JWFileTypeMemory: {
            b = [NSString is:mPath equalsTo:file.name];
            b = b && [JWObject is:mContent equalsTo:file.content];
            break;
        }
        case JWFileTypeFiles: {
            b = [NSString is:mPath equalsTo:file.name];
            b = b && [NSArray is:mFiles equalsTo:file.files];
            break;
        }
    }
    b = b && [JWObject is:mExtra equalsTo:file.extra];
    return b;
}

- (NSUInteger)hash {
    NSUInteger hc = 0;
    switch(mType) {
        case JWFileTypeBundle: {
            hc = [[[[[[JWHashcode begin] atObject:[NSNumber numberWithLong:mType]] atObject:mBundle] atObject:mPath] atObject:mExtra] end];
            break;
        }
        case JWFileTypeDocument:
        case JWFileTypeLibrary: {
            hc = [[[[[JWHashcode begin] atObject:[NSNumber numberWithLong:mType]] atObject:mPath] atObject:mExtra] end];
            break;
        }
        case JWFileTypeUrl: {
            hc = [[[[[JWHashcode begin] atObject:[NSNumber numberWithLong:mType]] atObject:mUrl] atObject:mExtra] end];
            break;
        }
        case JWFileTypeMemory: {
            hc = [[[[[[JWHashcode begin] atObject:[NSNumber numberWithLong:mType]] atObject:mPath] atObject:mContent] atObject:mExtra] end];
            break;
        }
        case JWFileTypeFiles: {
            hc = self.files.hash;
            break;
        }
    }
    //NSLog(@"file hc:%lu path:%@ url:%@", (unsigned long)hc, mPath, mUrl);
    return hc;
}

- (NSString *)description {
    NSString* string = nil;
    switch(mType) {
        case JWFileTypeBundle: {
            string = [NSString stringWithFormat:@"[File(Bundle)](bundle=%@, path=%@)", mBundle, mPath];
            break;
        }
        case JWFileTypeDocument: {
            string = [NSString stringWithFormat:@"[File(Document)](path=%@)", mPath];
            break;
        }
        case JWFileTypeLibrary: {
            string = [NSString stringWithFormat:@"[File(Library)](path=%@)", mPath];
            break;
        }
        case JWFileTypeUrl: {
            string = [NSString stringWithFormat:@"[File(Url)](url=%@)", mUrl];
            break;
        }
        case JWFileTypeMemory: {
            string = [NSString stringWithFormat:@"[File(Memory)](name=%@, content=%@)", mPath, mContent];
            break;
        }
        case JWFileTypeFiles: {
            NSMutableString* filesString = [NSMutableString stringWithString:@"[Files]"];
            if (mFiles == nil) {
                [filesString appendString:@"(no files)"];
            } else {
                [filesString appendString:@"[\n"];
                for (id<JIFile> file in mFiles) {
                    [filesString appendFormat:@"\t%@\n", file];
                }
                [filesString appendString:@"]"];
            }
            string = filesString;
            break;
        }
    }
    return string;
}

@end
