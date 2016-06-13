//
//  ItemToolsCommand.m
//  project_mesher
//
//  Created by mac zdszkj on 16/6/2.
//  Copyright © 2016年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "ItemToolsCommand.h"

@interface ItemToolsCommand() {
    id<JIGameObject> mObject;
    JCStretch mOriginStretch;
    JCStretch mDestStretch;
    NSMutableDictionary *mMaterialsDictionary;
    CGFloat mOriginTx;
    CGFloat mOriginTy;
    CGFloat mDestTx;
    CGFloat mDestTy;
    CGFloat mOriginSx;
    CGFloat mDestSx;
    CGFloat mOriginSy;
    CGFloat mDestSy;
    CGFloat mOriginSz;
    CGFloat mDestSz;
    JCVector3 mOriginScale;
    id<IMesherModel> mModel;
}

@end

@implementation ItemToolsCommand

@synthesize object = mObject;
@synthesize originStretch = mOriginStretch;
@synthesize destStretch = mDestStretch;
@synthesize materialsDictionary = mMaterialsDictionary;
@synthesize originTx = mOriginTx;
@synthesize originTy = mOriginTy;
@synthesize destTx = mDestTx;
@synthesize destTy = mDestTy;
@synthesize originSx = mOriginSx;
@synthesize destSx = mDestSx;
@synthesize originSy = mOriginSy;
@synthesize destSy = mDestSy;
@synthesize originSz = mOriginSz;
@synthesize destSz = mDestSz;
@synthesize originScale = mOriginScale;

@synthesize model = mModel;

- (void)todo {
    JCVector3 scale = JCVector3Make(mDestSx, mDestSy, mDestSz);
    mObject.transform.scale = JCVector3Mulv(&mOriginScale, &scale);
    [mObject enumRenderableUsing:^(id<JIRenderable> renderable, NSUInteger idx, BOOL *stop) {
        if ([renderable.host.name startsWith:@"sd_"]) {
            return;
        }
        if (renderable.host == mModel.itemRectFrameDecals.decalsObject) {
            return;
        }
        if (renderable.host == mModel.itemOverlapDecals.decalsObject) {
            return;
        }
        id<JIMaterial> mat = [mMaterialsDictionary valueForKey:[NSString stringWithFormat:@"%@",@(renderable.hash)]];
        if (mat == nil) {
            return;
        }
        id<JITexture> diffuse = mat.diffuseTexture;
        diffuse.tilingOffset = JCTilingOffsetMake(mDestTx, mDestTy, 0.0f, 0.0f);
        renderable.material = mat;
    }];
    
    ItemInfo *info = [Data getItemInfoFromInstance:mObject];
    Stretch *destS = [Stretch new];
    destS.px = [NSNumber numberWithFloat:mDestStretch.pivot.x];
    destS.py = [NSNumber numberWithFloat:mDestStretch.pivot.y];
    destS.pz = [NSNumber numberWithFloat:mDestStretch.pivot.z];
    destS.ox = [NSNumber numberWithFloat:mDestStretch.offset.x];
    destS.oy = [NSNumber numberWithFloat:mDestStretch.offset.y];
    destS.oz = [NSNumber numberWithFloat:mDestStretch.offset.z];
    info.st = destS;
    TilingOffset *destT = [TilingOffset new];
    destT.tx = [NSNumber numberWithFloat:mDestTx];
    destT.ty = [NSNumber numberWithFloat:mDestTy];
    info.ts = destT;
    Scale *destSc = [Scale new];
    destSc.sx = [NSNumber numberWithFloat:mDestSx];
    destSc.sy = [NSNumber numberWithFloat:mDestSy];
    destSc.sz = [NSNumber numberWithFloat:mDestSz];
    info.sc = destSc;
    [mModel.currentPlan showOverlap];
}

- (void)undo {
    JCVector3 scale = JCVector3Make(mOriginSx, mOriginSy, mOriginSz);
    mObject.transform.scale = JCVector3Mulv(&mOriginScale, &scale);
    mObject.stretch = mOriginStretch;
    [mObject enumRenderableUsing:^(id<JIRenderable> renderable, NSUInteger idx, BOOL *stop) {
        if ([renderable.host.name startsWith:@"sd_"]) {
            return;
        }
        if (renderable.host == mModel.itemRectFrameDecals.decalsObject) {
            return;
        }
        if (renderable.host == mModel.itemOverlapDecals.decalsObject) {
            return;
        }
        id<JIMaterial> mat = [mMaterialsDictionary valueForKey:[NSString stringWithFormat:@"%@",@(renderable.hash)]];
        if (mat == nil) {
            return;
        }
        id<JITexture> diffuse = mat.diffuseTexture;
        diffuse.tilingOffset = JCTilingOffsetMake(mOriginTx, mOriginTy, 0.0f, 0.0f);
        renderable.material = mat;
    }];
    
    ItemInfo *info = [Data getItemInfoFromInstance:mObject];
    Stretch *originS = [Stretch new];
    originS.px = [NSNumber numberWithFloat:mOriginStretch.pivot.x];
    originS.py = [NSNumber numberWithFloat:mOriginStretch.pivot.y];
    originS.pz = [NSNumber numberWithFloat:mOriginStretch.pivot.z];
    originS.ox = [NSNumber numberWithFloat:mOriginStretch.offset.x];
    originS.oy = [NSNumber numberWithFloat:mOriginStretch.offset.y];
    originS.oz = [NSNumber numberWithFloat:mOriginStretch.offset.z];
    info.st = originS;
    TilingOffset *originT = [TilingOffset new];
    originT.tx = [NSNumber numberWithFloat:mOriginTx];
    originT.ty = [NSNumber numberWithFloat:mOriginTy];
    info.ts = originT;
    Scale *originSc = [Scale new];
    originSc.sx = [NSNumber numberWithFloat:mOriginSx];
    originSc.sy = [NSNumber numberWithFloat:mOriginSy];
    originSc.sz = [NSNumber numberWithFloat:mOriginSz];
    info.sc = originSc;
    [mModel.currentPlan showOverlap];
}

@end
