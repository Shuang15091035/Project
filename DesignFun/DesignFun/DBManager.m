//
//  LBDBManager.m
//  LBBSmileCheerful
//
//  Created by qianfeng007 on 15/10/6.
//  Copyright (c) 2015年 刘备备. All rights reserved.
//

#import "DBManager.h"
#import <FMDB/FMDatabase.h>

#import "DFPictureModel.h"

@implementation DBManager {
    
    FMDatabase *_database;
}

+ (instancetype)shareInstance {
    
    static DBManager *shareInstance = nil;
    
    @synchronized(self) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (shareInstance == nil) {
                
                shareInstance = [[self alloc] init];
            }
        });
        
    }

    return shareInstance;
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        [self createDatabase];
    }
    return self;
}



- (void)createDatabase {
    
    NSString *dbPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/image_List"];
    
//    NSLog(@"%@", dbPath);
    
    _database = [[FMDatabase alloc] initWithPath:dbPath];
    
    NSString *xlSql = @"create table if not exists image_List (xlid INTEGER PRIMARY KEY AUTOINCREMENT, id TEXT, title TEXT, imgurls1 TEXT,imgurls2 TEXT,imgurls3 TEXT, imgSum TEXT, commentNum TEXT, imageType TEXT)";
    
    if ([_database open]) {
        
        [_database executeUpdate:xlSql];
        
    } else {
        
        NSLog(@"Open database error:%@", _database.lastErrorMessage);
    }
}

- (BOOL)isExistModel:(DFImage *)model {
    
    BOOL isExist = NO;
    
   NSString *sql = @"select * from image_List where id = ?";
    
  FMResultSet *resultSet = [_database executeQuery:sql, model.id];
    
    if (resultSet.next) {
        
        isExist = YES;
    }
    
    [resultSet close];
    
    return isExist;
    
}

- (BOOL)insertDataWithModel:(DFImage *)model {
    
    BOOL isInsert = YES;
    
    NSString *sql = nil;

    if ([self isExistModel:model]) {
        return isInsert;
    }
    if (model.imgurls.count == 1) {
        
        sql = @"insert into image_List (id, title, imgurls1, imgSum,commentNum,imageType) values (?, ?, ?, ?, ?, ?)";
        isInsert = [_database executeUpdate:sql,model.id,model.title,model.imgurls,model.imgSum,model.commentNum,model.imageType];
    }else{
        
        sql = @"insert into image_List (id, title, imgurls1, imgurls2, imgurls3, imgSum,commentNum,imageType) values (?, ?, ?, ?, ?, ?,?,?)";
    
        isInsert = [_database executeUpdate:sql,model.id,model.title,model.imgurls[0],model.imgurls[1],model.imgurls[2],model.imgSum,model.commentNum,model.imageType];
    }
    

    return isInsert;

}

- (BOOL)deleteDataWithModel:(DFImage *)model {
    
    BOOL isDelete = YES;
    
    NSString *sql = @"delete from image_List where id = ?";
    
    if ([self isExistModel:model]) {
        
        isDelete = [_database executeUpdate:sql, model.id];
    }
    
    return isDelete;

}

- (NSMutableArray *)quaryAllData {
    
    NSMutableArray *mArray = [NSMutableArray array];
    
    NSString *sql = @"select * from image_List";
        
    FMResultSet *resultSet = [_database executeQuery:sql];
    
    while (resultSet.next) {
        
        DFImage *image = [[DFImage alloc] init];
        
        image.id = [resultSet stringForColumn:@"id"];
            
        image.title = [resultSet stringForColumn:@"title"];
        
        image.imgSum = [resultSet stringForColumn:@"imgSum"];
        
        image.commentNum = [resultSet stringForColumn:@"commentNum"];
        
        image.imageType = [resultSet stringForColumn:@"imageType"];
        
        NSString *img1 = [resultSet stringForColumn:@"imgurls1"];
        NSString *img2 = [resultSet stringForColumn:@"imgurls2"];
        NSString *img3 = [resultSet stringForColumn:@"imgurls3"];
        
        
        if ((img1 != nil) && (img2 == nil) && (img3 == nil)) {
            
            image.imgurls = [NSMutableArray arrayWithObject:img1];
            
        } else {
            
            image.imgurls = [NSMutableArray arrayWithArray:@[img1, img2, img3]];
        }
        
        [mArray addObject:image];
    }
    
    [resultSet close];
            
    return mArray;
}

@end
