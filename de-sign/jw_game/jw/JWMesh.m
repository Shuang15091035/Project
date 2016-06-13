//
//  JWMesh.m
//  June Winter
//
//  Created by GavinLo on 14-5-5.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWMesh.h"
#import "JWMaterialManager.h"
#import "JWSkeleton.h"
#import <jw/JWCoreUtils.h>

@interface JWMesh () {
    JCBounds3 mBounds;
    BOOL mBoundsDirty;
}

@end

@implementation JWMesh

- (id)initWithFile:(id<JIFile>)file context:(id<JIGameContext>)context manager:(id<JIResourceManager>)manager {
    self = [super initWithFile:file context:context manager:manager];
    if (self != nil) {
        mMesh = JCMeshMake(0, 0);
    }
    return self;
}

- (void)onDestroy {
    JCMeshFree(&mMesh);
    [super onDestroy];
}

- (JCBounds3)bounds {
    [self updateBounds];
    return mBounds;
}

- (void) updateBounds {
    //@synchronized(self)
    {
        if(!mBoundsDirty)
            return;
        mBounds = JCMeshCalcBounds3(&mMesh);
        mBoundsDirty = NO;
    }
}

- (void)makeWithNumVertices:(NSUInteger)numVertices numIndices:(NSUInteger)numIndices {
    mMesh = JCMeshMake(numVertices, numIndices);
}

- (void)beginOperation:(JCRenderOperation)operation update:(BOOL)update {
    JCMeshBegin(&mMesh, operation, update == YES ? true : false);
}

- (void)position:(JCVector3)position {
    JCMeshPosition3(&mMesh, position);
    mBoundsDirty = YES;
}

- (void)positionX:(JCFloat)x y:(JCFloat)y z:(JCFloat)z {
    JCMeshPosition3(&mMesh, JCVector3Make(x, y, z));
    mBoundsDirty = YES;
}

- (void)normalX:(JCFloat)x y:(JCFloat)y z:(JCFloat)z {
    JCMeshNormal3(&mMesh, JCVector3Make(x, y, z));
}

- (void)texCoordU:(JCFloat)u v:(JCFloat)v {
    JCMeshTexCoord2(&mMesh, JCVector2Make(u, v), 0);
}

- (void)texCoordS:(JCFloat)s t:(JCFloat)t p:(JCFloat)p {
    // TODO
}

- (void)color:(JCColor)color {
    JCMeshColor(&mMesh, color);
}

- (void)colorR:(JCFloat)r G:(JCFloat)g B:(JCFloat)b A:(JCFloat)a {
    JCMeshColor(&mMesh, JCColorMake(r, g, b, a));
}

- (void)index:(JCUShort)i {
    JCMeshIndex(&mMesh, i);
}

- (void)lineStart:(JCUShort)i1 end:(JCUShort)i2 {
    JCMeshLine(&mMesh, i1, i2);
}

- (void)triangleWithP1:(JCUShort)i1 P2:(JCUShort)i2 P3:(JCUShort)i3 {
    JCMeshTriangle(&mMesh, i1, i2, i3);
}

- (void)quadWithP1:(JCUShort)i1 P2:(JCUShort)i2 P3:(JCUShort)i3 P4:(JCUShort)i4 {
    JCMeshQuad(&mMesh, i1, i2, i3, i4);
}

- (void)end {
    JCMeshEnd(&mMesh);
}

- (void)cube:(float)edgeLength color:(JCColor)color {
    mMesh = JCMeshMakeCube(edgeLength, color);
}

- (void)wireCube:(float)edgeLength color:(JCColor)color {
    mMesh = JCMeshMakeWireCube(edgeLength, color);
}

- (void)gridsStartRow:(NSInteger)startRow startColumn:(NSInteger)startColumn numRows:(NSUInteger)numRows numColumns:(NSUInteger)numColumns gridWidth:(float)gridWidth gridHeight:(float)gridHeight color:(JCColor)color {
    mMesh = JCMeshMakeGrids((JCInt)startRow, (JCInt)startColumn, (JCUInt)numRows, (JCUInt)numColumns, gridWidth, gridHeight, color);
}

- (void)spriteRect:(JCRectF)rect color:(JCColor)color {
    mMesh = JCMeshMakeRect(rect, color);
}

- (void)decalsRectFrameInnerWidth:(float)innerWidth innerHeight:(float)innerHeight thickness:(float)thickness uvThickness:(float)uvThickness {
    mMesh = JCMeshMakeDecalsRectFrame(innerWidth, innerHeight, thickness, uvThickness);
    mMesh.isStatic = false;
}

- (void)decalsRectFrameUpdateInnerWidth:(float)innerWidth innerHeight:(float)innerHeight thickness:(float)thickness uvThickness:(float)uvThickness {
    JCMeshDecalsRectFrameUpdate(&mMesh, innerWidth, innerHeight, thickness, uvThickness);
}

- (void)decalsRect4CornersInnerWidth:(float)innerWidth innerHeight:(float)innerHeight cornerOffsetX:(float)cornerOffsetX cornerOffsetY:(float)cornerOffsetY thickness:(float)thickness cornerOffsetU:(float)cornerOffsetU cornerOffsetV:(float)cornerOffsetV uvThickness:(float)uvThickness {
    mMesh = JCMeshMakeDecalsRect4Corners(innerWidth, innerHeight, cornerOffsetX, cornerOffsetY, thickness, cornerOffsetU, cornerOffsetV, uvThickness);
    mMesh.isStatic = false;
}

- (void)decalsRect4CornersUpdateInnerWidth:(float)innerWidth innerHeight:(float)innerHeight cornerOffsetX:(float)cornerOffsetX cornerOffsetY:(float)cornerOffsetY thickness:(float)thickness cornerOffsetU:(float)cornerOffsetU cornerOffsetV:(float)cornerOffsetV uvThickness:(float)uvThickness {
    JCMeshDecalsRect4CornersUpdate(&mMesh, innerWidth, innerHeight, cornerOffsetX, cornerOffsetY, thickness, cornerOffsetU, cornerOffsetV, uvThickness);
}

- (JCRenderOperation)renderOperation {
    return mMesh.renderOperation;
}

- (void)setRenderOperation:(JCRenderOperation)renderOperation {
    mMesh.renderOperation = renderOperation;
}

- (JCVertexData)vertexData {
    return mMesh.vertexData;
}

- (void)setVertexData:(JCVertexData)vertexData {
    mMesh.vertexData = vertexData;
}

- (JCIndexData)indexData {
    return mMesh.indexData;
}

- (void)setIndexData:(JCIndexData)indexData {
    mMesh.indexData = indexData;
}

- (BOOL)loadFile:(id<JIFile>)file {
    // 内存中构建的mesh默认为加载成功
    if (file.type == JWFileTypeMemory) {
        return YES;
    }
    // TODO 其他方式加载
    return NO;
}

- (void)customByOperation:(JCRenderOperation)operation vertexData:(const JCVertexData *)vertexData indexData:(const JCIndexData *)indexData {
    //@synchronized(self)
    {
        mMesh.renderOperation = operation;
        JCVertexDataShallowCopy(&mMesh.vertexData, vertexData);
        JCIndexDataShallowCopy(&mMesh.indexData, indexData);
        
        mBoundsDirty = YES;
        // 立刻更新bounds,以避免模型数据可能传输到显存后被释放
        [self updateBounds];
        
        // 作为内存mesh加载
        NSString* meshName = [NSString stringWithFormat:@"mesh_%@", @(self.hash)];
        mFile = [JWFile fileWithName:meshName content:nil];
        mState = JWResourceStateUnloaded;
    }
}

- (JCMeshRefC)cmesh {
    //@synchronized(self)
    {
        return &mMesh;
    }
}

@end
