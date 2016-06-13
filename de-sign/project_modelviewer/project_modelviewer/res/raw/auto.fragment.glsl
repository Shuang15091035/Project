
#if defined(f_color_diffuse)
uniform mediump vec4 u_diffuse_color;
#endif

#if defined(f_texture_diffuse)
uniform sampler2D u_diffuse_texture;
#endif

#if defined(f_texture_alpha)
uniform sampler2D u_alpha_texture;
#endif

#if defined(f_texture_reflective)
uniform sampler2D u_reflective_texture;
//varying highp vec3 v_normal;
//varying highp vec3 v_eye_dir;
varying highp vec2 v_reflective_uv;
#endif

varying highp vec2 v_texcoord0;

void main()
{
#if defined(f_texture_alpha)
    mediump vec4 alpha = texture2D(u_alpha_texture, v_texcoord0);
    if(alpha.a < 1.0)
        discard;
#endif
    
    mediump vec4 diffuse = vec4(0.0, 0.0, 0.0, 1.0);
    mediump vec4 reflective = vec4(0.0, 0.0, 0.0, 0.0);

#if defined(f_color_diffuse)
    diffuse = u_diffuse_color;
#endif
#if defined(f_texture_diffuse)
    diffuse = texture2D(u_diffuse_texture, v_texcoord0);
#endif

#if defined(f_texture_reflective)
//    mediump vec3 reflected = reflect(v_eye_dir, v_normal);
//    reflected.z += 1.0;
//    mediump float m = inversesqrt(dot(reflected, reflected));
//    m *= -0.5;
//    reflective = texture2D(u_reflective_texture, reflected.xy * m + vec2(0.5));
    reflective = texture2D(u_reflective_texture, v_reflective_uv) * 0.4;
#endif
    
    gl_FragColor = diffuse + reflective;
}