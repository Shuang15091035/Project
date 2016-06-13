// 针对像素

//uniform sampler2D u_diffuse_texture; // 纹理
//uniform mediump vec4 u_diffuse_st; // 纹理st
//uniform mediump vec2 u_diffuse_size; // 纹理大小
//
//varying mediump vec2 v_texcoord0; // 纹理坐标
//uniform mediump float u_outline_width; // 描边宽度
//uniform mediump vec4 u_outline_color; // 描边颜色
//
//mediump int getIsStrokeWithAngel(mediump float angel) {
//    mediump int stroke = 0;
//    mediump float rad = angel * 0.01745329252;
//
//    mediump float a = texture2D(u_diffuse_texture, vec2(v_texcoord0.x + u_outline_width * cos(rad) / u_diffuse_size.x, v_texcoord0.y + u_outline_width * sin(rad) / u_diffuse_size.y)).a;
//    
//    if (a = 0.5) {
//        stroke = 1;
//    }
//    
//    return stroke;
//}
//
//void main() {
//    mediump vec4 myC = texture2D(u_diffuse_texture, v_texcoord0);
//    
//    mediump int strokeCount = 0;
//    
//    strokeCount += getIsStrokeWithAngel(0.0);
//    strokeCount += getIsStrokeWithAngel(30.0);
//    strokeCount += getIsStrokeWithAngel(60.0);
//    strokeCount += getIsStrokeWithAngel(90.0);
//    strokeCount += getIsStrokeWithAngel(120.0);
//    strokeCount += getIsStrokeWithAngel(150.0);
//    strokeCount += getIsStrokeWithAngel(180.0);
//    strokeCount += getIsStrokeWithAngel(210.0);
//    strokeCount += getIsStrokeWithAngel(240.0);
//    strokeCount += getIsStrokeWithAngel(270.0);
//    strokeCount += getIsStrokeWithAngel(300.0);
//    strokeCount += getIsStrokeWithAngel(330.0);
//    
//    if (strokeCount > 0) {
//        myC = u_outline_color;
//        myC.a = 1.0;
//    }
//
//    gl_FragColor = myC;
//}



//void main() {
////    if (v_texcoord0.x > 0.5) {
////        gl_FragColor = vec4(1,1,1,1);
////    } else {
////        gl_FragColor = texture2D(u_diffuse_texture, v_texcoord0 * u_diffuse_st   ture, v_texcoord0 * u_diffuse_st.xy + u_diffuse_st.zw);
//    //                               贴图               纹理坐标(坐标*缩放*偏移量)
//    mediump float change = (color.r + color.g + color.b) / 3.0;
//    mediump vec4 c = vec4(change);
//    gl_FragColor = c;
//}



uniform sampler2D u_diffuse_texture; // 纹理
varying mediump vec2 v_texcoord0; // 纹理坐标
uniform mediump vec4 u_diffuse_st; // 纹理st
uniform mediump vec2 u_diffuse_size; // 纹理大小
uniform mediump vec4 u_outline_color; // 描边颜色
uniform mediump float u_outline_width; // 描边宽度

mediump int getIsStrokeWithAngel(mediump float angel) {
    mediump int stroke = 0;
    mediump float rad = angel * 0.01745329252;
    
    mediump float a = texture2D(u_diffuse_texture, vec2(v_texcoord0.x + u_outline_width * cos(rad) / u_diffuse_size.x, v_texcoord0.y + u_outline_width * sin(rad) / u_diffuse_size.y)).a;
    
    if (a >= 0.5) {
        stroke = 1;
    }
    
    return stroke;
}

void main(void) {
    
    mediump vec2 s0 = vec2(v_texcoord0.x - 2.0/u_diffuse_size.x, v_texcoord0.y - 2.0/u_diffuse_size.y);
    mediump vec2 s1 = vec2(v_texcoord0.x - 1.0/u_diffuse_size.x, v_texcoord0.y - 2.0/u_diffuse_size.y);
    mediump vec2 s2 = vec2(v_texcoord0.x, v_texcoord0.y - 2.0/u_diffuse_size.y);
    mediump vec2 s3 = vec2(v_texcoord0.x + 1.0/u_diffuse_size.x, v_texcoord0.y - 2.0/u_diffuse_size.y);
    mediump vec2 s4 = vec2(v_texcoord0.x + 2.0/u_diffuse_size.x, v_texcoord0.y - 2.0/u_diffuse_size.y);
    
    mediump vec2 s5 = vec2(v_texcoord0.x - 2.0/u_diffuse_size.x, v_texcoord0.y - 1.0/u_diffuse_size.y);
    mediump vec2 s6 = vec2(v_texcoord0.x - 1.0/u_diffuse_size.x, v_texcoord0.y - 1.0/u_diffuse_size.y);
    mediump vec2 s7 = vec2(v_texcoord0.x, v_texcoord0.y - 1.0/u_diffuse_size.y);
    mediump vec2 s8 = vec2(v_texcoord0.x + 1.0/u_diffuse_size.x, v_texcoord0.y - 1.0/u_diffuse_size.y);
    mediump vec2 s9 = vec2(v_texcoord0.x + 2.0/u_diffuse_size.x, v_texcoord0.y - 1.0/u_diffuse_size.y);
    
    mediump vec2 s10 = vec2(v_texcoord0.x - 2.0/u_diffuse_size.x, v_texcoord0.y);
    mediump vec2 s11 = vec2(v_texcoord0.x - 1.0/u_diffuse_size.x, v_texcoord0.y);
    mediump vec2 s12 = v_texcoord0;
    mediump vec2 s13 = vec2(v_texcoord0.x + 1.0/u_diffuse_size.x, v_texcoord0.y);
    mediump vec2 s14 = vec2(v_texcoord0.x + 2.0/u_diffuse_size.x, v_texcoord0.y);
    
    mediump vec2 s15 = vec2(v_texcoord0.x - 2.0/u_diffuse_size.x, v_texcoord0.y + 1.0/u_diffuse_size.y);
    mediump vec2 s16 = vec2(v_texcoord0.x - 1.0/u_diffuse_size.x, v_texcoord0.y + 1.0/u_diffuse_size.y);
    mediump vec2 s17 = vec2(v_texcoord0.x, v_texcoord0.y + 1.0/u_diffuse_size.y);
    mediump vec2 s18 = vec2(v_texcoord0.x + 1.0/u_diffuse_size.x, v_texcoord0.y + 1.0/u_diffuse_size.y);
    mediump vec2 s19 = vec2(v_texcoord0.x + 2.0/u_diffuse_size.x, v_texcoord0.y + 1.0/u_diffuse_size.y);
    
    mediump vec2 s20 = vec2(v_texcoord0.x - 2.0/u_diffuse_size.x, v_texcoord0.y + 2.0/u_diffuse_size.y);
    mediump vec2 s21 = vec2(v_texcoord0.x - 1.0/u_diffuse_size.x, v_texcoord0.y + 2.0/u_diffuse_size.y);
    mediump vec2 s22 = vec2(v_texcoord0.x, v_texcoord0.y + 2.0/u_diffuse_size.y);
    mediump vec2 s23 = vec2(v_texcoord0.x + 1.0/u_diffuse_size.x, v_texcoord0.y + 2.0/u_diffuse_size.y);
    mediump vec2 s24 = vec2(v_texcoord0.x + 2.0/u_diffuse_size.x, v_texcoord0.y + 2.0/u_diffuse_size.y);
    
//    mediump vec4 sf0 = texture2D(u_diffuse_texture,s0 + v_texcoord0.xy);
//    mediump vec4 sf1 = texture2D(u_diffuse_texture,s1 + v_texcoord0.xy);
//    mediump vec4 sf2 = texture2D(u_diffuse_texture,s2 + v_texcoord0.xy);
//    mediump vec4 sf3 = texture2D(u_diffuse_texture,s3 + v_texcoord0.xy);
//    mediump vec4 sf4 = texture2D(u_diffuse_texture,s4 + v_texcoord0.xy);
//    mediump vec4 sf5 = texture2D(u_diffuse_texture,s5 + v_texcoord0.xy);
//    mediump vec4 sf6 = texture2D(u_diffuse_texture,s6 + v_texcoord0.xy);
//    mediump vec4 sf7 = texture2D(u_diffuse_texture,s7 + v_texcoord0.xy);
//    mediump vec4 sf8 = texture2D(u_diffuse_texture,s8 + v_texcoord0.xy);
//    mediump vec4 sf9 = texture2D(u_diffuse_texture,s9 + v_texcoord0.xy);
//    mediump vec4 sf10 = texture2D(u_diffuse_texture,s10 + v_texcoord0.xy);
//    mediump vec4 sf11 = texture2D(u_diffuse_texture,s11 + v_texcoord0.xy);
//    mediump vec4 sf12 = texture2D(u_diffuse_texture,s12 + v_texcoord0.xy);
//    mediump vec4 sf13 = texture2D(u_diffuse_texture,s13 + v_texcoord0.xy);
//    mediump vec4 sf14 = texture2D(u_diffuse_texture,s14 + v_texcoord0.xy);
//    mediump vec4 sf15 = texture2D(u_diffuse_texture,s15 + v_texcoord0.xy);
//    mediump vec4 sf16 = texture2D(u_diffuse_texture,s16 + v_texcoord0.xy);
//    mediump vec4 sf17 = texture2D(u_diffuse_texture,s17 + v_texcoord0.xy);
//    mediump vec4 sf18 = texture2D(u_diffuse_texture,s18 + v_texcoord0.xy);
//    mediump vec4 sf19 = texture2D(u_diffuse_texture,s19 + v_texcoord0.xy);
//    mediump vec4 sf20 = texture2D(u_diffuse_texture,s20 + v_texcoord0.xy);
//    mediump vec4 sf21 = texture2D(u_diffuse_texture,s21 + v_texcoord0.xy);
//    mediump vec4 sf22 = texture2D(u_diffuse_texture,s22 + v_texcoord0.xy);
//    mediump vec4 sf23 = texture2D(u_diffuse_texture,s23 + v_texcoord0.xy);
//    mediump vec4 sf24 = texture2D(u_diffuse_texture,s24 + v_texcoord0.xy);
    
    mediump vec4 sf0 = texture2D(u_diffuse_texture,s0);
    mediump vec4 sf1 = texture2D(u_diffuse_texture,s1);
    mediump vec4 sf2 = texture2D(u_diffuse_texture,s2);
    mediump vec4 sf3 = texture2D(u_diffuse_texture,s3);
    mediump vec4 sf4 = texture2D(u_diffuse_texture,s4);
    mediump vec4 sf5 = texture2D(u_diffuse_texture,s5);
    mediump vec4 sf6 = texture2D(u_diffuse_texture,s6);
    mediump vec4 sf7 = texture2D(u_diffuse_texture,s7);
    mediump vec4 sf8 = texture2D(u_diffuse_texture,s8);
    mediump vec4 sf9 = texture2D(u_diffuse_texture,s9);
    mediump vec4 sf10 = texture2D(u_diffuse_texture,s10);
    mediump vec4 sf11 = texture2D(u_diffuse_texture,s11);
    mediump vec4 sf12 = texture2D(u_diffuse_texture,s12);
    mediump vec4 sf13 = texture2D(u_diffuse_texture,s13);
    mediump vec4 sf14 = texture2D(u_diffuse_texture,s14);
    mediump vec4 sf15 = texture2D(u_diffuse_texture,s15);
    mediump vec4 sf16 = texture2D(u_diffuse_texture,s16);
    mediump vec4 sf17 = texture2D(u_diffuse_texture,s17);
    mediump vec4 sf18 = texture2D(u_diffuse_texture,s18);
    mediump vec4 sf19 = texture2D(u_diffuse_texture,s19);
    mediump vec4 sf20 = texture2D(u_diffuse_texture,s20);
    mediump vec4 sf21 = texture2D(u_diffuse_texture,s21);
    mediump vec4 sf22 = texture2D(u_diffuse_texture,s22);
    mediump vec4 sf23 = texture2D(u_diffuse_texture,s23);
    mediump vec4 sf24 = texture2D(u_diffuse_texture,s24);
    
//    gl_FragColor = 24.0 * sf12;
//    gl_FragColor -= sf0;
//    gl_FragColor -= sf1;
//    gl_FragColor -= sf2;
//    gl_FragColor -= sf3;
//    gl_FragColor -= sf4;
//    gl_FragColor -= sf5;
//    gl_FragColor -= sf6;
//    gl_FragColor -= sf7;
//    gl_FragColor -= sf8;
//    gl_FragColor -= sf9;
//    gl_FragColor -= sf10;
//    gl_FragColor -= sf11;
//    gl_FragColor -= sf13;
//    gl_FragColor -= sf14;
//    gl_FragColor -= sf15;
//    gl_FragColor -= sf16;
//    gl_FragColor -= sf17;
//    gl_FragColor -= sf18;
//    gl_FragColor -= sf19;
//    gl_FragColor -= sf20;
//    gl_FragColor -= sf21;
//    gl_FragColor -= sf22;
//    gl_FragColor -= sf23;
//    gl_FragColor -= sf24;

    mediump vec4 vertEdge = sf0 + 4.0 * sf1 +
    6.0 * sf2 + 4.0 * sf3 + sf4 +
    2.0 * sf5 + 8.0 * sf6 + 12.0 * sf7 +
    8.0 * sf8 + 2.0 * sf9 - 2.0 * sf15 -
    8.0 * sf16 - 12.0 * sf17 - 8.0 * sf18 -
    2.0 * sf19 - sf20 - 4.0 * sf21 -
    6.0 * sf22 - 4.0 * sf23 - sf24;
    
    mediump vec4 horizEdge = - sf0 - 2.0 * sf1 +
    2.0 * sf3 + sf4 - 4.0 * sf5 -
    8.0 * sf6 + 8.0 * sf8 + 4.0 * sf9 -
    6.0 * sf10 - 12.0 * sf11 + 12.0 * sf13 +
    6.0 * sf14 - 4.0 * sf15 - 8.0 * sf16 +
    8.0 * sf18 + 4.0 * sf19 - sf20 -
    2.0 * sf21 + 2.0 * sf23 + sf24;

//    gl_FragColor.rgb = sf12.rgb + (sqrt((horizEdge.rgb * horizEdge.rgb) +
//                            (vertEdge.rgb * vertEdge.rgb)) / 12.0) * u_outline_color.rgb;
    
//    gl_FragColor.rgb = sqrt((horizEdge.rgb * horizEdge.rgb) + (vertEdge.rgb * vertEdge.rgb)) / 12.0;
    
    mediump float n = 2.0;
    if (horizEdge.r < n && horizEdge.g < n && horizEdge.b < n && vertEdge.r < n && vertEdge.g < n && vertEdge.b < n) {
        gl_FragColor = sf12;
    }else {
        gl_FragColor = u_outline_color;
    }
}
