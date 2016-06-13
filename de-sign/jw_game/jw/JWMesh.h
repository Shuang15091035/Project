//
//  JWMesh.h
//  June Winter
//
//  Created by GavinLo on 14-5-5.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWResource.h>
#import <jw/JCBounds3.h>
#import <jw/JWMaterial.h>
#import <jw/JCMesh.h>

@protocol JIMesh <JIResource>

@property (nonatomic, readonly) JCBounds3 bounds;

- (void) makeWithNumVertices:(NSUInteger)numVertices numIndices:(NSUInteger)numIndices;
- (void) beginOperation:(JCRenderOperation)operation update:(BOOL)update;
- (void) position:(JCVector3)position;
- (void) positionX:(JCFloat)x y:(JCFloat)y z:(JCFloat)z;
- (void) normalX:(JCFloat)x y:(JCFloat)y z:(JCFloat)z;
- (void) texCoordU:(JCFloat)u v:(JCFloat)v;
- (void) texCoordS:(JCFloat)s t:(JCFloat)t p:(JCFloat)p;
- (void) color:(JCColor)color;
- (void) colorR:(JCFloat)r G:(JCFloat)g B:(JCFloat)b A:(JCFloat)a;
- (void) index:(JCUShort)i;
- (void) lineStart:(JCUShort)i1 end:(JCUShort)i2;
- (void) triangleWithP1:(JCUShort)i1 P2:(JCUShort)i2 P3:(JCUShort)i3;
- (void) quadWithP1:(JCUShort)i1 P2:(JCUShort)i2 P3:(JCUShort)i3 P4:(JCUShort)i4;
- (void) end;

- (void) cube:(float)edgeLength color:(JCColor)color;
- (void) wireCube:(float)edgeLength color:(JCColor)color;
- (void) gridsStartRow:(NSInteger)startRow startColumn:(NSInteger)startColumn numRows:(NSUInteger)numRows numColumns:(NSUInteger)numColumns gridWidth:(float)gridWidth gridHeight:(float)gridHeight color:(JCColor)color;
- (void) spriteRect:(JCRectF)rect color:(JCColor)color;
- (void) decalsRectFrameInnerWidth:(float)innerWidth innerHeight:(float)innerHeight thickness:(float)thickness uvThickness:(float)uvThickness;
- (void) decalsRectFrameUpdateInnerWidth:(float)innerWidth innerHeight:(float)innerHeight thickness:(float)thickness uvThickness:(float)uvThickness;
- (void) decalsRect4CornersInnerWidth:(float)innerWidth innerHeight:(float)innerHeight cornerOffsetX:(float)cornerOffsetX cornerOffsetY:(float)cornerOffsetY thickness:(float)thickness cornerOffsetU:(float)cornerOffsetU cornerOffsetV:(float)cornerOffsetV uvThickness:(float)uvThickness;
- (void) decalsRect4CornersUpdateInnerWidth:(float)innerWidth innerHeight:(float)innerHeight cornerOffsetX:(float)cornerOffsetX cornerOffsetY:(float)cornerOffsetY thickness:(float)thickness cornerOffsetU:(float)cornerOffsetU cornerOffsetV:(float)cornerOffsetV uvThickness:(float)uvThickness;

- (void) customByOperation:(JCRenderOperation)operation vertexData:(const JCVertexData*)vertexData indexData:(const JCIndexData*)indexData;
@property (nonatomic, readwrite) JCRenderOperation renderOperation;
@property (nonatomic, readwrite) JCVertexData vertexData;
@property (nonatomic, readwrite) JCIndexData indexData;

@end

@interface JWMesh : JWResource <JIMesh> {
    JCMesh mMesh;
}

@property (nonatomic, readonly) JCMeshRefC cmesh;

@end
