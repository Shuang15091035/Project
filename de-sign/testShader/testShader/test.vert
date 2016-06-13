
uniform mediump mat4 u_model;
uniform mediump mat4 u_view;
uniform mediump mat4 u_projection;

attribute mediump vec3 a_position;
attribute mediump vec2 a_texcoord0;

varying mediump vec2 v_texcoord0;

void main() {
    mediump vec4 pos = vec4(a_position, 1.0);
    v_texcoord0 = a_texcoord0;
    gl_Position = u_projection * u_model * u_view * pos;
}