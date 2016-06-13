
attribute highp vec3 a_position;
attribute highp vec2 a_texcoord0;
uniform highp mat4 u_modelview;
uniform highp mat4 u_projection;

varying highp vec2 v_texcoord0;

#if defined(f_texture_reflective)
attribute highp vec3 a_normal;
uniform highp mat3 u_normal; // normal matrix
//varying highp vec3 v_normal;
//varying highp vec3 v_eye_dir;
varying highp vec2 v_reflective_uv;
#endif

void main()
{
    vec4 pos = vec4(a_position, 1.0);
    pos = u_modelview * pos;
    
#if defined(f_texture_reflective)
//    v_normal = normalize(u_normal * a_normal);
//    v_eye_dir = pos.xyz;
    vec3 u = normalize( vec3(pos) );
    vec3 n = normalize( u_normal * a_normal );
    vec3 r = reflect( u, n );
    float m = 2.0 * sqrt( r.x*r.x + r.y*r.y + (r.z+1.0)*(r.z+1.0) );
    v_reflective_uv.s = r.x/m + 0.5;
    v_reflective_uv.t = r.y/m + 0.5;
#endif
    
    v_texcoord0 = a_texcoord0;
    gl_Position = u_projection * pos;
}