shader_type canvas_item;

uniform vec2 wave_origin = vec2(0.0);  // Posición inicial de la onda
uniform float wave_time = 10.0;        // Controla la expansión de la onda

void fragment() {

    vec2 uv = SCREEN_UV;  // Usamos la coordenada global de la pantalla (todo el fondo)
    float dist = distance(uv * SCREEN_PIXEL_SIZE, wave_origin);  // Distancia del cursor

    // Onda expansiva con efecto de distorsión
    float wave = sin(dist * 20.0 - wave_time * 5.0) * exp(-dist * 8.0);

    vec3 base_color = vec3(1.0, 1.0, 1.0);  // Color blanco del fondo
    vec3 effect_color = vec3(0.2, 0.6, 1.0) * wave;  // Azul con la onda

    COLOR = vec4(base_color + effect_color, 1.0);
}