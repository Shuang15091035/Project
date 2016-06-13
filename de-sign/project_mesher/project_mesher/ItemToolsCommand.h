//
//  ItemToolsCommand.h
//  project_mesher
//
//  Created by mac zdszkj on 16/6/2.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Common.h"
#import "Plan.h"
#import "MesherModel.h"

@interface ItemToolsCommand : JWCommand

@property (nonatomic, readwrite) id<JIGameObject> object;
@property (nonatomic, readwrite) JCStretch originStretch;
@property (nonatomic, readwrite) JCStretch destStretch;
@property (nonatomic, readwrite) NSMutableDictionary *materialsDictionary;
@property (nonatomic, readwrite) CGFloat originTx;
@property (nonatomic, readwrite) CGFloat originTy;
@property (nonatomic, readwrite) CGFloat destTx;
@property (nonatomic, readwrite) CGFloat destTy;

@property (nonatomic, readwrite) CGFloat originSx;
@property (nonatomic, readwrite) CGFloat destSx;
@property (nonatomic, readwrite) CGFloat originSy;
@property (nonatomic, readwrite) CGFloat destSy;
@property (nonatomic, readwrite) CGFloat originSz;
@property (nonatomic, readwrite) CGFloat destSz;
@property (nonatomic, readwrite) JCVector3 originScale;

@property (nonatomic, readwrite) id<IMesherModel> model;


@end
