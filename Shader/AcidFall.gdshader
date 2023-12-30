shader_type canvas_item;

void fragment() {
    float speed = 0.7;
    float radius = 20.0;
    
    vec2 uv = vec2(1.0) - FRAGCOORD.xy / SCREEN_PIXEL_SIZE;
    float X = uv.x * 25.0 + TIME;
    float Y = uv.y * 25.0 + TIME;
    uv.x += sin(X - Y) * 0.01 * sin(Y);
    uv.y += cos(X + Y) * 0.03 * cos(Y);
    
    vec2 ps = TEXTURE_PIXEL_SIZE;
    vec4 shadow = texture(TEXTURE, UV + vec2(-radius, 0) * ps);
    shadow += texture(TEXTURE, UV + vec2(radius, 0) * ps);
    shadow /= 2.0;
    shadow *= vec4(0.0, 0.0, 0.0, 0.5);
    
    vec4 col = texture(TEXTURE, vec2(uv.x, uv.y + TIME * speed));
    
    COLOR = mix(shadow, col, col.a);
}
