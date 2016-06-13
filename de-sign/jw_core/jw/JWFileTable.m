//
//  JWFileTable.m
//  June Winter
//
//  Created by GavinLo on 14/12/29.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWFileTable.h"
#import "JWAsyncEventHandler.h"
#import "JWAsyncResultTask.h"
#import "JWAsyncTaskResult.h"
#import "NSMapTable+JWCoreCategory.h"
#import "NSMutableArray+JWArrayList.h"
#import "NSString+JWCoreCategory.h"

@interface JWFileTableEventHandler : JWAsyncEventHandler {
    id<JIOnFileTableLoadListener> mOnFileTableLoadListener;
    id<JIOnFileTableSaveListener> mOnFileTableSaveListener;
}

- (id)initWithAsync:(BOOL)async onFileTableLoadListener:(id<JIOnFileTableLoadListener>)onFileTableLoadListener;
- (id)initWithAsync:(BOOL)async onFileTableSaveListener:(id<JIOnFileTableSaveListener>)onFileTableSaveListener;
- (void) onLoadRecord:(id)record;
- (void) onLoadFileTable:(NSArray*)records;
- (void) onSaveRecord:(id)record;
- (void) onSaveFileTable:(NSException*)e;

@end

@implementation JWFileTableEventHandler

- (id)initWithAsync:(BOOL)async onFileTableLoadListener:(id<JIOnFileTableLoadListener>)onFileTableLoadListener {
    self = [super initWithAsync:async];
    if (self != nil) {
        mOnFileTableLoadListener = onFileTableLoadListener;
    }
    return self;
}

- (id)initWithAsync:(BOOL)async onFileTableSaveListener:(id<JIOnFileTableSaveListener>)onFileTableSaveListener {
    self = [super initWithAsync:async];
    if (self != nil) {
        mOnFileTableSaveListener = onFileTableSaveListener;
    }
    return self;
}

- (void)onLoadRecord:(id)record {
    if (mAsync) {
        if (mOnFileTableLoadListener != nil) {
            [JWAsyncUtils runOnMainQueue:^{
                [mOnFileTableLoadListener onLoadRecord:record];
            }];
        }
    } else {
        if (mOnFileTableLoadListener != nil) {
            [mOnFileTableLoadListener onLoadRecord:record];
        }
    }
}

- (void)onLoadFileTable:(NSArray *)records {
    if (mOnFileTableLoadListener != nil) {
        [mOnFileTableLoadListener onLoadFileTable:records];
    }
}

- (void)onSaveRecord:(id)record {
    if (mAsync) {
        if (mOnFileTableSaveListener != nil) {
            [JWAsyncUtils runOnMainQueue:^{
                [mOnFileTableSaveListener onSaveRecord:record];
            }];
        }
    } else {
        if (mOnFileTableSaveListener != nil) {
            [mOnFileTableSaveListener onSaveRecord:record];
        }
    }
}

- (void)onSaveFileTable:(NSException *)e {
    if (mOnFileTableSaveListener != nil) {
        [mOnFileTableSaveListener onSaveFileTable:e];
    }
}

@end

@interface JWFileTableLoadTask : JWAsyncResultTask {
    id<JIFile> mFile;
    JWFileTableEventHandler* mHandler;
    JWFileTable* mFileTable;
}

- (id) initWithResult:(JWAsyncResult *)result file:(id<JIFile>)file handler:(JWFileTableEventHandler*)handler fileTable:(JWFileTable*)fileTable;

@end

@implementation JWFileTableLoadTask

- (id)initWithResult:(JWAsyncResult *)result file:(id<JIFile>)file handler:(JWFileTableEventHandler *)handler fileTable:(JWFileTable *)fileTable {
    self = [super initWithResult:result];
    if (self != nil) {
        mFile = file;
        mHandler = handler;
        mFileTable = fileTable;
    }
    return self;
}

- (void)onPreExecute {
    [super onPreExecute];
    if (mFile == nil) {
        [self cancel];
    }
}

- (id)doInBackground:(NSArray *)params {
    if (self.isCancelled) {
        return nil;
    }
    
    NSMutableArray* records = [NSMutableArray array];
    @try {
        NSString* text = [mFile stringWithEncoding:mFileTable.encoding];
        NSArray* lines = [text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        int row = 0;
        for (NSString* line in lines) {
            if ([line isBlank]) { // NOTE 跳过空行，并且处理操蛋的windows导出的文件，换行符为\r\n而导致出现空行的问题
                continue;
            }
            NSArray* words = [line componentsSeparatedByString:mFileTable.separator];
            if (words.count > 0) {
                int column = 0;
                if (row == 0) { // 处理属性列
                    NSMapTable* columnId2Index = mFileTable.columnId2Index;
                    [columnId2Index clear]; // 清除属性id对应关系,以免重复使用FileTable读取不同类型的文件id对应关系出现问题
                    for(NSString* word in words) {
                        int columnId = [mFileTable getColumnIdByName:word];
                        if (columnId < 0) {
                            columnId = column;
                        }
                        [columnId2Index put:[NSNumber numberWithInt:columnId] value:[NSNumber numberWithInt:column]];
                        column++;
                    }
                } else { // 处理记录数据
                    id record = nil;
                    for(NSString* word in words) {
                        //if ([NSString isNilOrBlank:word]) {
                        if (word == nil) { // NOTE 空白字符串还是有某种意义的®
                            column++;
                            continue;
                        }
                        if (record == nil) {
                            record = [mFileTable newRecord];
                        }
                        [mFileTable setRecord:record word:word columnIndex:column];
                        column++;
                    }
                    if (record != nil) {
                        [records add:record];
                        [mHandler onLoadRecord:record];
                    }
                }
            }
            row++;
        }
    } @catch(NSException* e) {
        NSLog(@"%@", e.description);
    }
    return records;
}

- (void)onPostExecute:(id)result {
    [mHandler onLoadFileTable:result];
    [super onPostExecute:result];
}

@end

@interface JWFileTableSaveTask : JWAsyncResultTask {
    id<JIFile> mFile;
    NSArray* mRecords;
    JWFileTableEventHandler* mHandler;
    JWFileTable* mFileTable;
}

- (id) initWithResult:(JWAsyncResult *)result file:(id<JIFile>)file records:(NSArray*)records handler:(JWFileTableEventHandler*)handler fileTable:(JWFileTable*)fileTable;

@end

@implementation JWFileTableSaveTask

- (id)initWithResult:(JWAsyncResult *)result file:(id<JIFile>)file records:(NSArray*)records handler:(JWFileTableEventHandler *)handler fileTable:(JWFileTable *)fileTable {
    self = [super initWithResult:result];
    if (self != nil) {
        mFile = file;
        mRecords = records;
        mHandler = handler;
        mFileTable = fileTable;
    }
    return self;
}

- (void)onPreExecute {
    [super onPreExecute];
    if (mFile == nil) {
        [self cancel];
    }
}

- (id)doInBackground:(NSArray *)params {
    if (self.isCancelled) {
        return nil;
    }
    
    const int numColumns = [mFileTable getNumColumns];
    if (numColumns <= 0) {
        return nil;
    }
    
    @try {
        NSMutableString* text = [NSMutableString string];
        
        // 写入属性列
        for (int i = 0; i < numColumns; i++) {
            NSString* columnName = [mFileTable getColumnNameByIndex:i];
            if (columnName != nil) {
                if (i == 0) {
                    [text appendString:columnName];
                } else {
                    [text appendString:mFileTable.separator];
                    [text appendString:columnName];
                }
            }
        }
        //[text appendString:[NSString newLine]];
        
        // 写入记录数据
        if (mRecords != nil && mRecords.count > 0) { // NOTE 接受空列表写入
            for (id record in mRecords) {
                [text appendString:[NSString newLine]];
                for (int i = 0; i < numColumns; i++) {
                    NSString* word = [mFileTable getRecord:record columnIndex:i];
                    if (i == 0) {
                        if (word != nil)
                            [text appendString:word];
                    } else {
                        if (word != nil) {
                            [text appendString:mFileTable.separator];
                            [text appendString:word];
                        } else {
                            [text appendString:mFileTable.separator];
                        }
                    }
                }
                //[text appendString:[NSString newLine]];
            }
        }
        
        [mFile setString:text withEncoding:mFileTable.encoding];
    } @catch(NSException* e) {
        NSLog(@"[JWFileTable] %@", e.description);
        return e;
    }
    return nil;
}

- (void)onPostExecute:(id)result {
    [mHandler onSaveFileTable:result];
    [super onPostExecute:result];
}

@end

@interface JWFileTable () {
    NSString* mSeparator;
    JWEncoding mEncoding;
    Class mRecordType;
    
    NSMapTable* mColumnId2Index;
}

@end

@implementation JWFileTable

+ (NSString *)DefaultSeparator {
    /**
     * 默认为读取microsoft office excel导出的unicode txt表格,故使用tab分隔符
     */
    return @"\t";
}

+ (JWEncoding)DefaultEncoding {
    /**
     * 默认为读取microsoft office excel导出的unicode txt表格,故使用{@link Encoding#UTF16}
     */
    return JWEncodingUTF16;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"JWFileTable" reason:@"Cannot use init." userInfo:nil];
}

- (id)initWithRecordType:(Class)recordType {
    self = [super init];
    if (self != nil) {
        if (recordType == nil) {
            @throw [NSException exceptionWithName:@"JWFileTable" reason:@"recordType cannot be nil." userInfo:nil];
        }
        mRecordType = recordType;
    }
    return self;
}

- (NSString *)separator {
    if (mSeparator == nil) {
        return [JWFileTable DefaultSeparator];
    }
    return mSeparator;
}

- (void)setSeparator:(NSString *)separator {
    mSeparator = separator;
}

- (JWEncoding)encoding {
    if (mEncoding == JWEncodingUnknown) {
        return [JWFileTable DefaultEncoding];
    }
    return mEncoding;
}

- (void)setEncoding:(JWEncoding)encoding {
    mEncoding = encoding;
}

@synthesize recordType = mRecordType;

- (NSMapTable *)columnId2Index {
    if (mColumnId2Index == nil) {
        mColumnId2Index = [[NSMapTable alloc] init];
    }
    return mColumnId2Index;
}

- (NSArray *)loadFile:(id<JIFile>)file {
    return [self loadFile:file async:NO listener:nil].syncResult;
}

- (JWAsyncResult *)loadFile:(id<JIFile>)file async:(BOOL)async listener:(id<JIOnFileTableLoadListener>)listener {
    JWAsyncTaskResult* result = [JWAsyncTaskResult result];
    JWFileTableEventHandler* handler = [[JWFileTableEventHandler alloc] initWithAsync:async onFileTableLoadListener:listener];
    JWFileTableLoadTask* task = [[JWFileTableLoadTask alloc] initWithResult:result file:file handler:handler fileTable:self];
    result.asyncTask = task;
    if (!async) {
        [task onPreExecute];
        if (task.isCancelled) {
            result.syncResult = nil;
            return result;
        }
        NSArray* records = [task doInBackground:nil];
        [task onPostExecute:records];
        result.syncResult = records;
    } else {
        [task execute:nil];
        result.syncResult = nil;
    }
    return result;
}

- (NSException *)saveFile:(id<JIFile>)file records:(NSArray*)records {
    return [self saveFile:file records:records async:NO listener:nil].syncResult;
}

- (JWAsyncResult *)saveFile:(id<JIFile>)file records:(NSArray*)records async:(BOOL)async listener:(id<JIOnFileTableSaveListener>)listener {
    JWAsyncTaskResult* result = [JWAsyncTaskResult result];
    JWFileTableEventHandler* handler = [[JWFileTableEventHandler alloc] initWithAsync:async onFileTableSaveListener:listener];
    JWFileTableSaveTask* task = [[JWFileTableSaveTask alloc] initWithResult:result file:file records:records handler:handler fileTable:self];
    result.asyncTask = task;
    if (!async) {
        [task onPreExecute];
        if (task.isCancelled) {
            result.syncResult = nil;
            return result;
        }
        NSException* e = [task doInBackground:nil];
        [task onPostExecute:e];
        result.syncResult = e;
    } else {
        [task execute:nil];
        result.syncResult = nil;
    }
    return result;
}

- (id)newRecord {
    return [[mRecordType alloc] init];
}

- (void)setRecord:(id)record word:(NSString *)word columnIndex:(int)columnIndex {
    
}

- (int)getColumnIdByName:(NSString *)columnName {
    return -1;
}

- (int)getNumColumns {
    return 0;
}

- (NSString *)getRecord:(id)record columnIndex:(int)columnIndex {
    return nil;
}

- (NSString *)getColumnNameByIndex:(int)columnIndex {
    return nil;
}

- (int)getColumnIndexById:(int)columnId {
    if (mColumnId2Index == nil) {
        return -1;
    }
    NSNumber* columnIndex = [mColumnId2Index get:[NSNumber numberWithInt:columnId]];
    if (columnIndex == nil) {
        return -1;
    }
    return columnIndex.intValue;
}

@end
