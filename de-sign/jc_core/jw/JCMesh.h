//
//  JCMesh.h
//  June Winter
//
//  Created by GavinLo on 14-10-15.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCMesh__
#define __jw__JCMesh__

#include <jw/JCFlags.h>
#include <jw/JCVertexData.h>
#include <jw/JCIndexData.h>
#include <jw/JCVector2.h>
#include <jw/JCVertex3.h>
#include <jw/JCQuadrangle.h>
#include <jw/JCBounds3.h>
#include <jw/JCRect.h>
#include <jw/JCSkeleton.h>

JC_BEGIN

typedef enum {
    
    JCRenderOperationUnknown = -1,
    JCRenderOperationPoints = 0,
    JCRenderOperationLines,
    JCRenderOperationLineStrip,
    JCRenderOperationLineLoop,
    JCRenderOperationTriangles,
    JCRenderOperationTriangleStrip,
    JCRenderOperationTriangleFan,
    
}JCRenderOperation;

typedef struct {
    
    JCRenderOperation renderOperation;
    JCVertexData vertexData;
    JCIndexData indexData;
    JCULong numVertices;
    JCULong numIndices;
    JCBool isStatic;

// private
    JCBool _isUpdate;
    JCBool _firstVertex;
    JCBool _firstIndex;
    JCVertex3 _tempVertex;
    JCBool _tempVertexPending;
    JCULong _currentVertexIndex;
    JCULong _currentIndexIndex;
    
}JCMesh;

typedef JCMesh* JCMeshRef;
typedef const JCMesh* JCMeshRefC;

JCMesh JCMeshMake(JCULong numVertices, JCULong numIndices);
void JCMeshFree(JCMeshRef mesh);
void JCMeshFreeData(JCMeshRef mesh);

void JCMeshBegin(JCMeshRef mesh, JCRenderOperation operation, JCBool update);
void JCMeshPosition3(JCMeshRef mesh, JCVector3 position);
void JCMeshPosition2(JCMeshRef mesh, JCVector2 position);
void JCMeshNormal3(JCMeshRef mesh, JCVector3 normal);
void JCMeshTexCoord2(JCMeshRef mesh, JCVector2 texCoord, JCUInt set);
void JCMeshColor(JCMeshRef mesh, JCColor color);
void JCMeshIndex(JCMeshRef mesh, JCUShort i);
void JCMeshLine(JCMeshRef mesh, JCUShort i1, JCUShort i2);
void JCMeshTriangle(JCMeshRef mesh, JCUShort i1, JCUShort i2, JCUShort i3);
void JCMeshQuad(JCMeshRef mesh, JCUShort i1, JCUShort i2, JCUShort i3, JCUShort i4);
void JCMeshEnd(JCMeshRef mesh);

// utils
JCBounds3 JCMeshCalcBounds3(JCMeshRefC mesh);
JCMesh JCMeshMakeQuad(JCQuadrangle quad, JCColor color, JCBool uv);
JCMesh JCMeshMakeBox3(JCBounds3 bounds, JCColor color);
JCMesh JCMeshMakeCube(JCFloat edgeLength, JCColor color);
JCMesh JCMeshMakeWireBox3(JCBounds3 bounds, JCColor color);
JCMesh JCMeshMakeWireCube(JCFloat edgeLength, JCColor color);
JCMesh JCMeshMakeGrids(JCInt startRow, JCInt startColumn, JCUInt numRows, JCUInt numColumns, JCFloat gridWidth, JCFloat gridHeight, JCColor color);
JCMesh JCMeshMakeRect(JCRectF rect, JCColor color);

/**
 * 九宫格形式的矩形框
 */
JCMesh JCMeshMakeDecalsRectFrame(JCFloat innerWidth, JCFloat innerHeight, JCFloat thickness, JCFloat uvThickness);
void JCMeshDecalsRectFrameUpdate(JCMeshRef mesh, JCFloat innerWidth, JCFloat innerHeight, JCFloat thickness, JCFloat uvThickness);

/**
 * 矩形四角，边断开的贴花贴花效果
 * @innerWidth 矩形内框宽度
 * @innerHeight 矩形内框高度
 * @cornerOffsetX 宽度方向上角外延出边部分的长度（相对于内宽的百分比）
 * @cornerOffsetY 高度方向上角外延出边部分的长度（相对于内高的百分比）
 * @thickness 矩形边的厚度
 * @cornerOffsetU 宽度方向上角外延出边部分对应的uv偏移
 * @cornerOffsetV 高度方向上角外延出边部分对应的uv偏移
 * @uvThickness 矩形边的厚度对应uv的厚度
 */
JCMesh JCMeshMakeDecalsRect4Corners(JCFloat innerWidth, JCFloat innerHeight, JCFloat cornerOffsetX, JCFloat cornerOffsetY, JCFloat thickness, JCFloat cornerOffsetU, JCFloat cornerOffsetV, JCFloat uvThickness);
void JCMeshDecalsRect4CornersUpdate(JCMeshRef mesh, JCFloat innerWidth, JCFloat innerHeight, JCFloat cornerOffsetX, JCFloat cornerOffsetY, JCFloat thickness, JCFloat cornerOffsetU, JCFloat cornerOffsetV, JCFloat uvThickness);

//--------------------------------------------------------------------------------------------------------------------------
// JCMeshFeatures

typedef enum {
    
    JCMeshFlagOffsetPosition = 0,
    JCMeshFlagOffsetNormal,
    JCMeshFlagOffsetTangent,
    JCMeshFlagOffsetBinormal,
    JCMeshFlagOffsetTexCoord,
    JCMeshFlagOffsetColor,
    JCMeshFlagOffsetBoneWeight,
    
}JCMeshFlagOffsets;

typedef enum {
    
    JCMeshFlagPosition     = 0x1 << JCMeshFlagOffsetPosition,
    JCMeshFlagNormal       = 0x1 << JCMeshFlagOffsetNormal,
    JCMeshFlagTangent      = 0x1 << JCMeshFlagOffsetTangent,
    JCMeshFlagBinormal      = 0x1 << JCMeshFlagOffsetBinormal,
    JCMeshFlagTexCoord    = 0x1 << JCMeshFlagOffsetTexCoord,
    JCMeshFlagColor            = 0x1 << JCMeshFlagOffsetColor,
    JCMeshFlagBoneWeight = 0x1 << JCMeshFlagOffsetBoneWeight,
    
}JCMeshFlags;

typedef struct {
    JCFlag vertexFlags;
}JCMeshFeatures;

JCMeshFeatures JCMeshFeaturesMake();
JCMeshFeatures JCMeshFeaturesMakeByMesh(JCMeshRefC mesh);
bool JCMeshFeaturesEquals(JCMeshFeatures* l, JCMeshFeatures* r);

JC_END

#endif /* defined(__jw__JCMesh__) */
