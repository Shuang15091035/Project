//
//  JWColladaParser.h
//  June Winter
//
//  Created by GavinLo on 14/11/5.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWXmlParser.h>
#import <jw/JWSceneLoader.h>

typedef NS_ENUM(NSInteger, JWColladaTags)
{
    JWColladaTags_Unknown = -1,
    JWColladaTags_COLLADA = 0,
    JWColladaTags_asset,
    JWColladaTags_contributor,
    JWColladaTags_hashcode,
    JWColladaTags_unit,
    JWColladaTags_up_axis,
    JWColladaTags_library_geometries,
    JWColladaTags_geometry,
    JWColladaTags_mesh,
    JWColladaTags_source,
    JWColladaTags_float_array,
    JWColladaTags_Name_array,
    JWColladaTags_vertices,
    JWColladaTags_input,
    JWColladaTags_triangles,
    JWColladaTags_polygons,
    JWColladaTags_p,
    JWColladaTags_init_from,
    JWColladaTags_format,
    JWColladaTags_minfilter,
    JWColladaTags_magfilter,
    JWColladaTags_color,
    JWColladaTags_float,
    JWColladaTags_technique_common,
    JWColladaTags_accessor,
    JWColladaTags_param,
    JWColladaTags_library_visual_scenes,
    JWColladaTags_visual_scene,
    JWColladaTags_scene,
    JWColladaTags_instance_visual_scene,
    JWColladaTags_node,
    JWColladaTags_library_nodes,
    JWColladaTags_instance_node,
    JWColladaTags_instance_geometry,
    JWColladaTags_bind_material,
    JWColladaTags_instance_material,
    JWColladaTags_bind_vertex_input,
    JWColladaTags_translate,
    JWColladaTags_rotate,
    JWColladaTags_scale,
    JWColladaTags_matrix,
    JWColladaTags_library_images,
    JWColladaTags_image,
    JWColladaTags_library_materials,
    JWColladaTags_material,
    JWColladaTags_instance_effect,
    JWColladaTags_library_effects,
    JWColladaTags_effect,
    JWColladaTags_profile_COMMON,
    JWColladaTags_newparam,
    JWColladaTags_surface,
    JWColladaTags_sampler2D,
    JWColladaTags_technique,
    JWColladaTags_constant,
    JWColladaTags_lambert,
    JWColladaTags_phong,
    JWColladaTags_blinn,
    JWColladaTags_emission,
    JWColladaTags_ambient,
    JWColladaTags_diffuse,
    JWColladaTags_specular,
    JWColladaTags_shininess,
    JWColladaTags_reflective,
    JWColladaTags_transparent,
    JWColladaTags_transparency,
    JWColladaTags_texture,
    JWColladaTags_constant_attenuation,
    JWColladaTags_linear_attenuation,
    JWColladaTags_quadratic_attenuation,
    JWColladaTags_decay_type,
    JWColladaTags_decay_start,
    JWColladaTags_use_near_attenuation,
    JWColladaTags_near_attenuation_start,
    JWColladaTags_near_attenuation_end,
    JWColladaTags_use_far_attenuation,
    JWColladaTags_far_attenuation_start,
    JWColladaTags_far_attenuation_end,
    JWColladaTags_intensity,
    JWColladaTags_falloff_angle,
    JWColladaTags_falloff_exponent,
    JWColladaTags_extra,
    JWColladaTags_amount,
    JWColladaTags_double_sided,
    JWColladaTags_spec_level,
    JWColladaTags_emission_level,
    JWColladaTags_bump,
    JWColladaTags_ao,
    JWColladaTags_diffuse_st,
    JWColladaTags_transparent_st,
    JWColladaTags_bump_st,
    JWColladaTags_ao_st,
    JWColladaTags_diffuse_color,
    JWColladaTags_refl_amount,
    JWColladaTags_rim_color,
    JWColladaTags_rim_power,
    JWColladaTags_library_controllers,
    JWColladaTags_controller,
    JWColladaTags_skin,
    JWColladaTags_morph,
    JWColladaTags_bind_shape_matrix,
    JWColladaTags_joints,
    JWColladaTags_vertex_weights,
    JWColladaTags_vcount,
    JWColladaTags_v,
    JWColladaTags_instance_controller,
    JWColladaTags_skeleton,
    JWColladaTags_library_animations,
    JWColladaTags_animation,
    JWColladaTags_sampler,
    JWColladaTags_channel,
};

@interface JWColladaParser : JWXmlParser

@property (nonatomic, readwrite) id<JIGameContext> context;
@property (nonatomic, readwrite) id<JIGameObject> parent;
@property (nonatomic, readonly) id<JIGameObject> object;
@property (nonatomic, readwrite) id<JIFile> file;
@property (nonatomic, readwrite) id<JIFile> originFile;
@property (nonatomic, readwrite) JWSceneLoadParams* params;
@property (nonatomic, readwrite) BOOL obfuscated;
@property (nonatomic, readwrite) JWSceneLoaderEventHandler* handler;

@end

@interface JWColladaAttributeNames : JWObject

+ (NSString*) Id;
+ (NSString*) sid;
+ (NSString*) name;
+ (NSString*) type;
+ (NSString*) meter;
+ (NSString*) count;
+ (NSString*) semantic;
+ (NSString*) source;
+ (NSString*) offset;
+ (NSString*) stride;
+ (NSString*) set;
+ (NSString*) material;
+ (NSString*) profile;
+ (NSString*) texture;
+ (NSString*) texcoord;
+ (NSString*) opaque;
+ (NSString*) url;
+ (NSString*) symbol;
+ (NSString*) target;
+ (NSString*) input_semantic;
+ (NSString*) input_set;

@end