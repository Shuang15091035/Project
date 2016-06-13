//
//  JWFileTable.h
//  June Winter
//
//  Created by GavinLo on 14/12/29.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWObject.h>
#import <jw/JWFile.h>
#import <jw/JWAsyncResult.h>

@protocol JIOnFileTableLoadListener <NSObject>

- (void) onLoadRecord:(id)record;
- (void) onLoadFileTable:(NSArray*)records;

@end

@protocol JIOnFileTableSaveListener <NSObject>

- (void) onSaveRecord:(id)record;
- (void) onSaveFileTable:(NSException*)e;

@end

@protocol JIFileTable <JIObject>

@property (nonatomic, readwrite) NSString* separator;
@property (nonatomic, readwrite) JWEncoding encoding;
@property (nonatomic, readonly) Class recordType;

- (NSArray*) loadFile:(id<JIFile>)file;
- (JWAsyncResult*) loadFile:(id<JIFile>)file async:(BOOL)async listener:(id<JIOnFileTableLoadListener>)listener;
- (NSException*) saveFile:(id<JIFile>)file records:(NSArray*)records;
- (JWAsyncResult*) saveFile:(id<JIFile>)file records:(NSArray*)records async:(BOOL)async listener:(id<JIOnFileTableSaveListener>)listener;

@end

@interface JWFileTable : JWObject <JIFileTable>

+ (NSString*) DefaultSeparator;
+ (JWEncoding) DefaultEncoding;

- (id) initWithRecordType:(Class)recordType;

/**
 * 读取表格时,用于创建记录实例
 * @return
 */
- (id) newRecord;

/**
 * 读取表格时,用于设置读取到的字符串到记录数据中
 * @param record
 * @param word
 * @param columnIndex
 */
- (void) setRecord:(id)record word:(NSString*)word columnIndex:(int)columnIndex;

/**
 * 读取表格时,用于获取列名对应的id(必须>=0),以便使用{@link #getColumnIndex(int)}来快速查找列id所对应的列索引
 * @param columnName
 * @return
 */
- (int) getColumnIdByName:(NSString*)columnName;

/**
 * 写入表格时,用于获取列数目
 * @return
 */
- (int) getNumColumns;

/**
 * 写入表格时,用于获取记录中每个属性对应的字符串
 * @param record
 * @param columnIndex
 * @return
 */
- (NSString*) getRecord:(id)record columnIndex:(int)columnIndex;

/**
 * 写入表格时,用于获取列索引所对应的列名
 * @param columnIndex
 * @return
 */
- (NSString*) getColumnNameByIndex:(int)columnIndex;

/**
 * 使用列id来获取列索引
 * @param columnId
 * @return
 */
- (int) getColumnIndexById:(int)columnId;

@property (nonatomic, readonly) NSMapTable* columnId2Index;

@end
