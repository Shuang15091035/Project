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
@interface Source : CCVObject

@property (nonatomic, readwrite) NSInteger Id;
@property (nonatomic, readwrite) NSString* name; // 名字
@property (nonatomic, readwrite) SourceType type; // 类型
@property (nonatomic, readwrite) id<ICVFile> file; // 文件
@property (nonatomic, readwrite) id<ICVFile> preview; // 缩略图

//// 渲染相关
//- (void) addObject:(id<ICVGameObject>)object;
//- (void) destroyObject:(id<ICVGameObject>)object;
//@property (nonatomic, readonly) NSArray* objects;

@end


