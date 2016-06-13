//
//  Source.h
//  project_mesher
//
//  Created by MacMini on 15/10/13.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"

typedef NS_ENUM(NSInteger, SourceType) {
    SourceTypeUnknown = 0,
    SourceTypeModel = 1,
    SourceTypeTexture = 2,
};

// 素材
@interface Source : JWObject

@property (nonatomic, readwrite) NSInteger Id;
@property (nonatomic, readwrite) NSString* name; // 名字
@property (nonatomic, readwrite) SourceType type; // 类型
@property (nonatomic, readwrite) id<JIFile> file; // 文件
@property (nonatomic, readwrite) id<JIFile> preview; // 缩略图

//// 渲染相关
//- (void) addObject:(id<JIGameObject>)object;
//- (void) destroyObject:(id<JIGameObject>)object;
//@property (nonatomic, readonly) NSArray* objects;

@end


