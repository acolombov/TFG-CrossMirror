shader_type canvas_item;
// https://www.shadertoy.com/view/tlVGDt

//uniform float time;
//const float REPEAT = 5.0;
//
//// Rotación en 2D
//
//mat2 rot(float a) {
	//
	//return mat2(cos(a), sin(a), -sin(a), cos(a));
//
//}
//
//// Signed Distance Function (SDF) para una caja
//float sdBox(vec3 p, vec3 b) {
    //vec3 q = abs(p) - b;
    //return length(max(q, vec3(0.0))) + min(max(q.x, max(q.y, q.z)), 0.0);
//}
//
//// Función que genera las cajas
//float box(vec3 pos, float scale) {
    //pos *= scale;
    //float base = sdBox(pos, vec3(0.4, 0.4, 0.1)) / 1.5;
    //pos.xy *= 5.0;
    //pos.y -= 3.5;
    //pos.xy *= rot(0.75);
    //return -base;
//}
//
//// Genera una estructura de cajas animadas
//float box_set(vec3 pos) {
    //vec3 pos_origin = pos;
    //pos.y += sin(time * 0.4) * 2.5;
    //pos.xy *= rot(0.8);
    //float box1 = box(pos, 2.0 - abs(sin(time * 0.4)) * 1.5);
//
    //pos = pos_origin;
    //pos.y -= sin(time * 0.4) * 2.5;
    //pos.xy *= rot(0.8);
    //float box2 = box(pos, 2.0 - abs(sin(time * 0.4)) * 1.5);
//
    //pos = pos_origin;
    //pos.x += sin(time * 0.4) * 2.5;
    //pos.xy *= rot(0.8);
    //float box3 = box(pos, 2.0 - abs(sin(time * 0.4)) * 1.5);
//
    //pos = pos_origin;
    //pos.x -= sin(time * 0.4) * 2.5;
    //pos.xy *= rot(0.8);
    //float box4 = box(pos, 2.0 - abs(sin(time * 0.4)) * 1.5);
//
    //pos = pos_origin;
    //pos.xy *= rot(0.8);
    //float box5 = box(pos, 0.5) * 6.0;
//
    //pos = pos_origin;
    //float box6 = box(pos, 0.5) * 6.0;
//
    //return max(max(max(max(max(box1, box2), box3), box4), box5), box6);
//}
//
//// Mapea la escena en 3D
//float map(vec3 pos) {
    //return box_set(pos);
//}
//
//// Shader principal
//void fragment() {
    //vec2 p = (FRAGCOORD.xy * 2.0 - vec2(SCREEN_PIXEL_SIZE.x, SCREEN_PIXEL_SIZE.y)) / min(SCREEN_PIXEL_SIZE.x, SCREEN_PIXEL_SIZE.y);
    //vec3 ro = vec3(0.0, -0.2, time * 4.0);
    //vec3 ray = normalize(vec3(p, 1.5));
    //ray.xy = ray.xy * rot(sin(time * 0.03) * 5.0);
    //ray.yz = ray.yz * rot(sin(time * 0.05) * 0.2);
    //float t = 0.1;
    //vec3 col = vec3(0.0);
    //float ac = 0.0;
//
    //for (int i = 0; i < 99; i++) {
        //vec3 pos = ro + ray * t;
        //pos = mod(pos - 2.0, 4.0) - 2.0;
        //float d = map(pos);
        //d = max(abs(d), 0.01);
        //ac += exp(-d * 23.0);
        //t += d * 0.55;
    //}
//
    //col = vec3(ac * 0.02);
    //col += vec3(0.0, 0.2 * abs(sin(time)), 0.5 + sin(time) * 0.2);
//
    //COLOR = vec4(col, 1.0 - t * (0.02 + 0.02 * sin(time)));
//}
