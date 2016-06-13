//
//  JWCollada.h
//  June Winter
//
//  Created by GavinLo on 14/11/5.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWGamePredef.h>
#import <jw/JWObject.h>
#import <jw/JWVector3.h>
#import <jw/JWVector4.h>
#import <jw/JCMatrix4.h>
#import <jw/JCTexture.h>

typedef NS_ENUM(NSInteger, JWColladaUpAxis)
{
    JWColladaUpAxisX_UP = 0,
    JWColladaUpAxisY_UP,
    JWColladaUpAxisZ_UP,
};

typedef NS_ENUM(NSInteger, JWColladaParamType)
{
    JWColladaParamType_Unknown = 0,
    JWColladaParamType_float,
    JWColladaParamType_Name,
    JWColladaParamType_float4x4,
};

typedef NS_ENUM(NSInteger, JWColladaSourceArrayType) {
    JWColladaSourceArrayType_Unknown = 0,
    JWColladaSourceArrayType_float,
    JWColladaSourceArrayType_Vector1,
    JWColladaSourceArrayType_Vector2,
    JWColladaSourceArrayType_Vector3,
    JWColladaSourceArrayType_Vector4,
    JWColladaSourceArrayType_ColorRGB,
    JWColladaSourceArrayType_ColorRGBA,
    JWColladaSourceArrayType_Matrix4,
    JWColladaSourceArrayType_JOINT,
};

typedef NS_ENUM(NSInteger, JWColladaSemantic)
{
    JWColladaSemantic_Unknown = 0,
    JWColladaSemantic_POSITION,
    JWColladaSemantic_VERTEX,
    JWColladaSemantic_NORMAL,
    JWColladaSemantic_TANGENT,
    JWColladaSemantic_BINORMAL,
    JWColladaSemantic_COLOR,
    JWColladaSemantic_TEXCOORD,
    JWColladaSemantic_JOINT,
    JWColladaSemantic_INV_BIND_MATRIX,
    JWColladaSemantic_WEIGHT,
    JWColladaSemantic_INPUT,
    JWColladaSemantic_OUTPUT,
    JWColladaSemantic_INTERPOLATION,
    JWColladaSemantic_IN_TANGENT,
    JWColladaSemantic_OUT_TANGENT,
};

typedef NS_ENUM(NSInteger, JWColladaPrimitiveType)
{
    JWColladaPrimitiveType_Unknown = 0,
    JWColladaPrimitiveType_triangles,
    JWColladaPrimitiveType_polylist,
    JWColladaPrimitiveType_polygons,
    JWColladaPrimitiveType_lines,
    JWColladaPrimitiveType_trifans,
    JWColladaPrimitiveType_tristrips,
    JWColladaPrimitiveType_linestrips,
};

typedef NS_ENUM(NSInteger, JWColladaNodeType)
{
    JWColladaNodeType_NODE,
    JWColladaNodeType_JOINT,
};

typedef NS_ENUM(NSInteger, JWColladaProfileType)
{
    JWColladaProfileType_Unknown = -1,
    JWColladaProfileType_COMMON = 0,
    JWColladaProfileType_CG,
    JWColladaProfileType_GLES,
    JWColladaProfileType_GLSL,
};

typedef NS_ENUM(NSInteger, JWColladaSurfaceType)
{
    JWColladaSurfaceType_UNTYPED,
    JWColladaSurfaceType_1D,
    JWColladaSurfaceType_2D,
    JWColladaSurfaceType_3D,
    JWColladaSurfaceType_CUBE,
    JWColladaSurfaceType_DEPTH,
    JWColladaSurfaceType_RECT,
};

typedef NS_ENUM(NSInteger, JWColladaSurfaceFormat)
{
    JWColladaSurfaceFormat_A8R8G8B8,
};

typedef NS_ENUM(NSInteger, JWColladaSamplerType)
{
    JWColladaSamplerType_UNTYPED,
    JWColladaSamplerType_1D,
    JWColladaSamplerType_2D,
    JWColladaSamplerType_3D,
    JWColladaSamplerType_CUBE,
    JWColladaSamplerType_DEPTH,
    JWColladaSamplerType_RECT,
};

typedef NS_ENUM(NSInteger, JWColladaTechniqueCoreProfile)
{
    JWColladaTechniqueCoreProfile_Unknown,
    JWColladaTechniqueCoreProfile_UCOLLADA,
    JWColladaTechniqueCoreProfile_FCOLLADA,
    JWColladaTechniqueCoreProfile_MAX3D,
    JWColladaTechniqueCoreProfile_MAYA,
};

typedef NS_ENUM(NSInteger, JWColladaTechniqueTypeType)
{
    JWColladaTechniqueTypeType_Unknown,
    JWColladaTechniqueTypeType_constant,
    JWColladaTechniqueTypeType_lambert,
    JWColladaTechniqueTypeType_phong,
    JWColladaTechniqueTypeType_blinn,
};

typedef NS_ENUM(NSInteger, JWColladaTransparentOpaque) {
    JWColladaTransparentOpaque_A_ONE,
    JWColladaTransparentOpaque_RGB_ZERO,
    JWColladaTransparentOpaque_A_ZERO,
    JWColladaTransparentOpaque_RGB_ONE,
};

typedef NS_ENUM(NSInteger, JWColladaTransformType) {
    JWColladaTransformTypeTranslate,
    JWColladaTransformTypeRotate,
    JWColladaTransformTypeScale,
};

typedef NS_ENUM(NSInteger, JWColladaSidAddress) {
    JWColladaSidAddressX = 0,
    JWColladaSidAddressY = 1,
    JWColladaSidAddressZ = 2,
    JWColladaSidAddressANGLE = 3,
    JWColladaSidAddressXYZ = -1,
};

@class JWColladaAsset;
@class JWColladaContributor;
@class JWColladaUnit;
@class JWColladaLibraryCameras;
@class JWColladaLibraryLights;
@class JWColladaLibraryImages;
@class JWColladaImage;
@class JWColladaLibraryMaterials;
@class JWColladaMaterial;
@class JWColladaInstanceEffect;
@class JWColladaLibraryEffects;
@class JWColladaEffect;
@class JWColladaProfile;
@class JWColladaProfileCommon;
@class JWColladaTechniqueFX;
@class JWColladaTechniqueType;
@class JWColladaConstant;
@class JWColladaLambert;
@class JWColladaPhong;
@class JWColladaBlinn;
@class JWColladaCommonColorOrTextureType;
@class JWColladaCommonFloatOrParamType;
@class JWColladaTexture;
@class JWColladaTransparent;
@class JWColladaNewparam;
@class JWColladaSurface;
@class JWColladaSampler;
@class JWColladaLibraryGeometries;
@class JWColladaGeometry;
@class JWColladaMesh;
@class JWColladaSource;
@class JWColladaSourceArray;
@class JWColladaFloatArray;
@class JWColladaNameArray;
@class JWColladaTechniqueCommon;
@class JWColladaAccessor;
@class JWColladaParam;
@class JWColladaVertices;
@class JWColladaInput;
@class JWColladaPrimitives;
@class JWColladaPrimitive;
@class JWColladaTriangles;
@class JWColladaPolygons;
@class JWColladaLibraryVisualScenes;
@class JWColladaVisualScene;
@class JWColladaNode;
@class JWColladaLibraryNodes;
@class JWColladaInstanceNode;
@class JWColladaScene;
@class JWColladaInstanceVisualScene;
@class JWColladaInstanceGeometry;
@class JWColladaBindMaterial;
@class JWColladaInstanceMaterial;
@class JWColladaBindVertexInput;
@class JWColladaExtra;
@class JWColladaTechniqueCore;
@class JWColladaFloat;
@class JWColladaInteger;
@class JWColladaBump;
@class JWColladaAO;
@class JWColladaLibraryControllers;
@class JWColladaController;
@class JWColladaSkin;
@class JWColladaMorph;
@class JWColladaJoints;
@class JWColladaVertexWeights;
@class JWColladaInstanceController;
@class JWColladaLibraryAnimations;
@class JWColladaAnimation;
@class JWColladaAnimationSampler;
@class JWColladaChannel;

// 数据结构
@interface JWColladaMaterialInfo : JWObject

@property (nonatomic, readwrite) NSString* name;
@property (nonatomic, readwrite) short texcoordSet;

@end

// collada文件结构
@interface JWCollada : JWObject

@property (nonatomic, readwrite) JWColladaAsset* asset;
@property (nonatomic, readwrite) JWColladaLibraryCameras* cameras;
@property (nonatomic, readwrite) JWColladaLibraryLights* lights;
@property (nonatomic, readwrite) JWColladaLibraryImages* images;
@property (nonatomic, readwrite) JWColladaLibraryMaterials* materials;
@property (nonatomic, readwrite) JWColladaLibraryEffects* effects;
@property (nonatomic, readwrite) JWColladaLibraryGeometries* geometries;
@property (nonatomic, readwrite) JWColladaLibraryControllers* controllers;
@property (nonatomic, readwrite) JWColladaLibraryAnimations* animations;
@property (nonatomic, readwrite) JWColladaLibraryVisualScenes* visualScenes;
@property (nonatomic, readwrite) JWColladaLibraryNodes* nodes;

@property (nonatomic, readonly) NSMutableDictionary* sources;
@property (nonatomic, readonly) NSMutableDictionary* sourceArrays;

- (JWColladaNode*) findNodeById:(NSString*)Id;
- (JWColladaNode*) findNodeByPath:(NSString*)path;

@end

@interface JWColladaSid : JWObject

+ (JWColladaSid*) parseSid:(NSString*)sid hasAttribute:(BOOL)hasAttribute;

@property (nonatomic, readwrite) NSString* path;
@property (nonatomic, readwrite) NSString* attribute;
@property (nonatomic, readwrite) NSInteger address0;
@property (nonatomic, readwrite) NSInteger address1;

@end

@interface JWColladaAsset : JWObject

@property (nonatomic, readwrite) JWColladaContributor* contributor;
@property (nonatomic, readwrite) JWColladaUnit* unit;
@property (nonatomic, readwrite) JWColladaUpAxis up_axis;

+ (JWColladaUpAxis) parseUpAxis:(NSString*)upAxis;

@end

@interface JWColladaContributor : JWObject

@property (nonatomic, readwrite) NSString* hashcode;

@end

@interface JWColladaUnit : JWObject

@property (nonatomic, readwrite) float meter;

@end

@interface JWColladaFloat : JWObject

@property (nonatomic, readwrite) NSString* sid;
@property (nonatomic, readwrite) float float_;

@end

@interface JWColladaInteger : JWObject

@property (nonatomic, readwrite) NSString* sid;
@property (nonatomic, readwrite) int int_;

@end

@interface JWColladaLibraryImages : JWObject

@property (nonatomic, readonly) NSMutableDictionary* images;

@end

@interface JWColladaImage : JWObject

@property (nonatomic, readwrite) NSString* Id;
@property (nonatomic, readwrite) NSString* name;
@property (nonatomic, readwrite) NSString* Init_from;

@end

@interface JWColladaLibraryMaterials : JWObject

@property (nonatomic, readonly) NSMutableDictionary* materials;

@end

@interface JWColladaMaterial : JWObject

@property (nonatomic, readwrite) NSString* Id;
@property (nonatomic, readwrite) NSString* name;
@property (nonatomic, readwrite) JWColladaInstanceEffect* instanceEffect;

@end

@interface JWColladaInstanceEffect : JWObject

@property (nonatomic, readwrite) NSString* url;

@end

@interface JWColladaLibraryEffects : JWObject

@property (nonatomic, readonly) NSMutableDictionary* effects;

@end

@interface JWColladaEffect : JWObject

@property (nonatomic, readwrite) NSString* Id;
@property (nonatomic, readwrite) NSString* name;
@property (nonatomic, readonly) NSMutableArray* profiles;
@property (nonatomic, readonly) NSMutableArray* extras;

@end

@interface JWColladaProfile : JWObject
{
    JWColladaProfileType mType;
    NSString* mId;
}

@property (nonatomic, readwrite) JWColladaProfileType type;
@property (nonatomic, readwrite) NSString* Id;

- (id) initWithType:(JWColladaProfileType)type;

@end

@interface JWColladaProfileCommon : JWColladaProfile

@property (nonatomic, readonly) NSMutableArray* newparams;
@property (nonatomic, readwrite) JWColladaTechniqueFX* technique;

- (JWColladaNewparam*) findSurfaceWithSource:(NSString*)source;
- (JWColladaNewparam*) findSamplerWithTexture:(NSString*)texture;

@end

@interface JWColladaTechniqueFX : JWObject

@property (nonatomic, readwrite) NSString* sid;
@property (nonatomic, readwrite) JWColladaTechniqueType* type;
@property (nonatomic, readonly) NSMutableArray* extras;

@end

@interface JWColladaTechniqueType : JWObject

@property (nonatomic, readwrite) JWColladaTechniqueTypeType type;
@property (nonatomic, readwrite) JWColladaCommonColorOrTextureType* ambient;
@property (nonatomic, readwrite) JWColladaCommonColorOrTextureType* diffuse;
@property (nonatomic, readwrite) JWColladaCommonColorOrTextureType* emission;
@property (nonatomic, readwrite) JWColladaCommonColorOrTextureType* specular;
@property (nonatomic, readwrite) JWColladaCommonFloatOrParamType* shininess;
@property (nonatomic, readwrite) JWColladaCommonColorOrTextureType* reflective;
@property (nonatomic, readwrite) JWColladaTransparent* transparent;
@property (nonatomic, readwrite) JWColladaCommonFloatOrParamType* transparency;

- (id) initWithType:(JWColladaTechniqueTypeType)type;

@end

@interface JWColladaConstant : JWColladaTechniqueType

@end

@interface JWColladaLambert : JWColladaTechniqueType

@end

@interface JWColladaPhong : JWColladaTechniqueType

@end

@interface JWColladaBlinn : JWColladaTechniqueType

@end

@interface JWColladaCommonColorOrTextureType : JWObject

@property (nonatomic, readwrite) JCColor color;
@property (nonatomic, readwrite) JWColladaTexture* texture;

@end

@interface JWColladaCommonFloatOrParamType : JWObject

@property (nonatomic, readwrite) float float_;

@end

@interface JWColladaTexture : JWObject

@property (nonatomic, readwrite) NSString* texture;
@property (nonatomic, readwrite) NSString* texcoord;
@property (nonatomic, readonly) NSMutableArray* extras;

@end

@interface JWColladaTransparent : JWObject

@property (nonatomic, readwrite) JWColladaTransparentOpaque opaque;
@property (nonatomic, readwrite) JWColladaCommonColorOrTextureType* transparent;

+ (JWColladaTransparentOpaque) parseOpaque:(NSString*)opaque;

@end

@interface JWColladaNewparam : JWObject

@property (nonatomic, readwrite) NSString* sid;
@property (nonatomic, readwrite) JWColladaSurface* surface;
@property (nonatomic, readwrite) JWColladaSampler* sampler;

@end

@interface JWColladaSurface : JWObject

@property (nonatomic, readwrite) JWColladaSurfaceType type;
@property (nonatomic, readwrite) NSString* Init_from;
@property (nonatomic, readwrite) JWColladaSurfaceFormat format;

+ (JWColladaSurfaceType) parseType:(NSString*)type;
+ (JWColladaSurfaceFormat) parseFormat:(NSString*)format;

@end

@interface JWColladaSampler : JWObject

@property (nonatomic, readwrite) JWColladaSamplerType type;
@property (nonatomic, readwrite) NSString* source;
@property (nonatomic, readwrite) JCTextureFilter minFilter;
@property (nonatomic, readwrite) JCTextureFilter magFilter;
@property (nonatomic, readwrite) JCTextureFilter mipFilter;

+ (JWColladaSamplerType) parseType:(NSString*)type;
//+ (JCTextureFilter) parseFilter:(NSString*)filter defaultFilter:(JCTextureFilter)defaultFilter;
- (void) parseMinFilter:(NSString*)filter;
- (void) parseMagFilter:(NSString*)filter;

@end

@interface JWColladaLibraryGeometries : JWObject

@property (nonatomic, readonly) NSMutableDictionary* geometries;

@end

@interface JWColladaGeometry : JWObject

@property (nonatomic, readwrite) NSString* Id;
@property (nonatomic, readwrite) NSString* name;
@property (nonatomic, readwrite) JWColladaMesh* mesh;

@end

@interface JWColladaMesh : JWObject

@property (nonatomic, readonly) NSMutableDictionary* sources;
@property (nonatomic, readwrite) JWColladaVertices* vertices;
@property (nonatomic, readonly) NSMutableArray* primitives;

@end

@interface JWColladaSource : JWObject

@property (nonatomic, readwrite) NSString* Id;
@property (nonatomic, readwrite) JWColladaSourceArray* sourceArray;
@property (nonatomic, readwrite) JWColladaTechniqueCommon* techniqueCommon;

@end

@interface JWColladaSourceArray : JWObject

@property (nonatomic, readwrite) JWColladaSource* source;
@property (nonatomic, readwrite) NSString* Id;
@property (nonatomic, readwrite) NSString* name;
@property (nonatomic, readwrite) NSUInteger count;
@property (nonatomic, readonly) NSArray* values;
@property (nonatomic, readonly) JWColladaSourceArrayType type;

//- (BOOL) parseText:(NSString*)text count:(NSUInteger)count;
//- (BOOL) parseText:(NSString*)text count:(NSUInteger)count colladaInstanceController:(JWColladaInstanceController*)colladaInstanceController;

// 延时解析
- (void) setupText:(NSString*)text count:(NSUInteger)count;
- (BOOL) parse;
- (BOOL) parse:(JWColladaInstanceController*)colladaInstanceController;

@end

@interface JWColladaTechniqueCommon : JWObject

@property (nonatomic, readwrite) JWColladaAccessor* accessor;
@property (nonatomic, readonly) NSMutableArray* instanceMaterials;

@end

@interface JWColladaAccessor : JWObject

@property (nonatomic, readwrite) NSString* source;
@property (nonatomic, readwrite) int count;
@property (nonatomic, readwrite) int offset;
@property (nonatomic, readwrite) int stride;
@property (nonatomic, readonly) NSMutableArray* params;

@end

@interface JWColladaParam : JWObject

@property (nonatomic, readwrite) NSString* name;
@property (nonatomic, readwrite) JWColladaParamType type;

+ (JWColladaParamType) parseType:(NSString*)type;

@end

@interface JWColladaVertices : JWObject

@property (nonatomic, readwrite) NSString* Id;
@property (nonatomic, readonly) NSMutableArray* inputs;

@end

@interface JWColladaInput : JWObject

@property (nonatomic, readwrite) JWColladaSemantic semantic;
@property (nonatomic, readwrite) NSString* source;
@property (nonatomic, readwrite) int offset;
@property (nonatomic, readwrite) int set; // 对semantic="TEXCOORD"有效

+ (JWColladaSemantic) parseSemantic:(NSString*)semantic;

@end

// <triangles> <polygons> ...
@interface JWColladaPrimitives : JWObject
{
    NSUInteger mCount;
    NSMutableArray* mPrimitives;
    NSUInteger mCurrentPIndex;
}

@property (nonatomic, readwrite) JWColladaPrimitiveType type;
@property (nonatomic, readwrite) NSString* materialName;
@property (nonatomic, readwrite) NSUInteger count;
@property (nonatomic, readonly) NSMutableArray* inputs;
@property (nonatomic, readonly) NSMutableArray* primitives;
@property (nonatomic, readwrite) NSUInteger currentPIndex;

- (id) initWithCount:(NSUInteger)count;

+ (JWColladaPrimitiveType) parseType:(NSString*)type;

- (NSMutableArray*) createPrimitives;
- (void) preBuild;
- (NSUInteger) getVertexComponentCount;

@end

// <p>
@interface JWColladaPrimitive : JWObject

@property (nonatomic, readwrite) JWColladaPrimitives* primitives;
@property (nonatomic, readonly) NSArray* indices;
@property (nonatomic, readonly) NSUInteger indexCount;

- (void) parseText:(NSString*)text;

@end

@interface JWColladaTriangles : JWColladaPrimitives

@end

@interface JWColladaPolygons : JWColladaPrimitives

@end

@interface JWColladaLibraryVisualScenes : JWObject

@property (nonatomic, readonly) NSMutableDictionary* visualScenes;
- (JWColladaNode*) findNodeById:(NSString*)Id;

@end

@interface JWColladaVisualScene : JWObject

@property (nonatomic, readwrite) NSString* Id;
@property (nonatomic, readwrite) NSString* name;
@property (nonatomic, readonly) NSMutableArray* nodes;

- (JWColladaNode*) findNodeById:(NSString*)Id;

@end

@interface JWColladaTransform : JWObject

@property (nonatomic, readwrite) JWColladaTransformType type;
@property (nonatomic, readwrite) NSString* sid;
@property (nonatomic, readwrite) JCVector4 value;

@end

#pragma mark JWColladaNode
@interface JWColladaNode : JWObject

@property (nonatomic, readwrite) NSString* Id;
@property (nonatomic, readwrite) NSString* name;
@property (nonatomic, readwrite) NSString* sid;
@property (nonatomic, readwrite) JWColladaNodeType type;

//@property (nonatomic, readwrite) JCVector3 translate;
//@property (nonatomic, readwrite) JCVector4 rotate;
//@property (nonatomic, readwrite) JCVector3 scale;
- (JWColladaTransform*) addTransformType:(JWColladaTransformType)type bySid:(NSString*)sid;
- (JWColladaTransform*) getTransformBySid:(NSString*)sid;
- (NSArray<JWColladaTransform*>*) getTransformsBySid:(NSString*)sid;
@property (nonatomic, readonly) NSArray<JWColladaTransform*>* transforms;

@property (nonatomic, readwrite) JCMatrix4 matrix;
@property (nonatomic, readwrite) BOOL transformOrMatrix;

@property (nonatomic, readonly) NSMutableArray* instanceGeometries;
@property (nonatomic, readonly) NSMutableArray* instanceControllers;

@property (nonatomic, readwrite) JWColladaNode* parent;
@property (nonatomic, readonly) NSMutableArray* children;
@property (nonatomic, readonly) NSMutableArray* instanceChildren;

+ (JWColladaNodeType) parseType:(NSString*)type;

- (void) addChild:(JWColladaNode*)child;
- (void) addChildInstance:(JWColladaInstanceNode*)child;
- (JWColladaNode*) findChildById:(NSString*)Id;
- (JWColladaNode*) getChildBySid:(NSString*)sid;

@property (nonatomic, readwrite) id<JIGameObject> object;

@end

@interface JWColladaLibraryNodes : JWObject

@property (nonatomic, readonly) NSMutableDictionary* nodes;
- (JWColladaNode*) getNodeBySid:(NSString*)sid;

@end

@interface JWColladaInstanceNode : JWObject

@property (nonatomic, readwrite) NSString* url;

@end

@interface JWColladaScene : JWObject

@property (nonatomic, readwrite) JWColladaInstanceVisualScene* instanceVisualScene;

@end

@interface JWColladaInstanceVisualScene : JWObject

@property (nonatomic, readwrite) NSString* url;

@end

@interface JWColladaInstanceGeometry : JWObject

@property (nonatomic, readwrite) NSString* url;
@property (nonatomic, readwrite) JWColladaBindMaterial* bindMaterial;

@end

@interface JWColladaBindMaterial : JWObject

@property (nonatomic, readwrite) JWColladaTechniqueCommon* techniqueCommon;
- (JWColladaMaterialInfo *)getMaterialInfo:(JWColladaPrimitives *)colladaPrimitives;

@end

@interface JWColladaInstanceMaterial : JWObject

@property (nonatomic, readwrite) NSString* symbol;
@property (nonatomic, readwrite) NSString* target;
@property (nonatomic, readonly) NSMutableArray* bindVertexInputs;

@end

@interface JWColladaBindVertexInput : JWObject

@property (nonatomic, readwrite) NSString* semantic;
@property (nonatomic, readwrite) JWColladaSemantic input_semantic;
@property (nonatomic, readwrite) short input_set;

@end

@interface JWColladaExtra : JWObject

@property (nonatomic, readonly) NSMutableArray* techniques;

@end

@interface JWColladaTechniqueCore : JWObject

@property (nonatomic, readwrite) JWColladaTechniqueCoreProfile profile;

@property (nonatomic, readwrite) float target_default_dist;
@property (nonatomic, readwrite) float intensity;

@property (nonatomic, readwrite) int decay_type;
@property (nonatomic, readwrite) float decay_start;
@property (nonatomic, readwrite) BOOL use_near_attenuation;
@property (nonatomic, readwrite) float near_attenuation_start;
@property (nonatomic, readwrite) float near_attenuation_end;
@property (nonatomic, readwrite) BOOL use_far_attenuation;
@property (nonatomic, readwrite) float far_attenuation_start;
@property (nonatomic, readwrite) float far_attenuation_end;
@property (nonatomic, readwrite) JWColladaFloat* amount;

@property (nonatomic, readwrite) JWColladaInteger* double_sided;
@property (nonatomic, readwrite) JWColladaCommonFloatOrParamType* spec_level;
@property (nonatomic, readwrite) JWColladaCommonFloatOrParamType* emission_level;
@property (nonatomic, readwrite) JWColladaBump* bump;
@property (nonatomic, readwrite) JWColladaAO* ao;
@property (nonatomic, readwrite) JCVector4 diffuse_st;
@property (nonatomic, readwrite) JCVector4 transparent_st;
@property (nonatomic, readwrite) JCVector4 bump_st;
@property (nonatomic, readwrite) JCVector4 ao_st;
@property (nonatomic, readwrite) JCColor diffuseColor;
@property (nonatomic, readwrite) float reflAmount;
@property (nonatomic, readwrite) JCColor rimColor;
@property (nonatomic, readwrite) float rimPower;

+ (JWColladaTechniqueCoreProfile) parseProfile:(NSString*)profile;

@end

@interface JWColladaBump : JWObject

@property (nonatomic, readwrite) JWColladaTexture* texture;

@end

@interface JWColladaAO : JWObject

@property (nonatomic, readwrite) JWColladaTexture* texture;

@end

@interface JWColladaLibraryControllers : JWObject

@property (nonatomic, readonly) NSMutableDictionary* controllers;

@end

@interface JWColladaController : JWObject

@property (nonatomic, readwrite) NSString* Id;
@property (nonatomic, readwrite) NSString* name;
@property (nonatomic, readwrite) JWColladaAsset* asset;
@property (nonatomic, readwrite) JWColladaSkin* skin;
@property (nonatomic, readwrite) JWColladaMorph* morph;

@end

@interface JWColladaSkin : JWObject

@property (nonatomic, readwrite) NSString* source;
@property (nonatomic, readwrite) JCMatrix4 bindShapeMatrix;
@property (nonatomic, readonly) NSMutableArray* sources;
@property (nonatomic, readwrite) JWColladaJoints* joints;
@property (nonatomic, readwrite) JWColladaVertexWeights* vertexWeights;

@end

@interface JWColladaJoints : JWObject

@property (nonatomic, readonly) NSMutableArray* inputs;

@end

@interface JWColladaVertexWeights : JWObject

@property (nonatomic, readwrite) NSUInteger count;
@property (nonatomic, readonly) NSMutableArray* inputs;
@property (nonatomic, readonly) NSArray* vcount;
@property (nonatomic, readonly) NSArray* v;
@property (nonatomic, readonly) NSUInteger maxBonesPreVertex;

- (void) parseVcount:(NSString*)text;
- (void) parseV:(NSString*)text collada:(JWCollada*)collada;

@end

@interface JWColladaMorph : JWObject

@end

@interface JWColladaInstanceController : JWObject

@property (nonatomic, readwrite) NSString* sid;
@property (nonatomic, readwrite) NSString* name;
@property (nonatomic, readwrite) NSString* url;
@property (nonatomic, readonly) NSMutableArray* skeletons;
@property (nonatomic, readonly) NSMutableArray* skeletonNodes;
@property (nonatomic, readwrite) JWColladaBindMaterial* bindMaterial;

- (JWColladaNode*) getJointFromSkeletonsBySid:(NSString*)sid;

@end

@interface JWColladaLibraryAnimations : JWObject

@property (nonatomic, readonly) NSMutableDictionary* animations;

@end

@interface JWColladaAnimation : JWObject

@property (nonatomic, readwrite) NSString* Id;
@property (nonatomic, readwrite) NSString* name;
@property (nonatomic, readwrite) JWColladaAsset* asset;
@property (nonatomic, readonly) NSMutableArray* animations;
@property (nonatomic, readonly) NSMutableArray* sources;
@property (nonatomic, readonly) NSMutableArray* samplers;
@property (nonatomic, readonly) NSMutableArray* channels;

- (JWColladaAnimationSampler*) getSamplerById:(NSString*)sampleId;

@end

@interface JWColladaAnimationSampler : JWObject

@property (nonatomic, readwrite) NSString* Id;
@property (nonatomic, readonly) NSMutableArray* inputs;

@end

@interface JWColladaChannel : JWObject

@property (nonatomic, readwrite) NSString* source;
@property (nonatomic, readwrite) NSString* target;

@end
