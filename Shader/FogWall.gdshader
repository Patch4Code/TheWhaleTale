// Original by @ENDESGA at https://www.shadertoy.com/view/dlKyWw
// splat-field forked from https://www.shadertoy.com/view/clGyWm

shader_type canvas_item;

uniform uint colorMode = 0; 

uniform vec4 color : source_color;
uniform float timescale = 0.2; 
uniform float hScrollSpeedFactor = 1.; 
uniform float vScrollSpeedFactor = 1.;
uniform float entropyFactor = 1.; 
uniform float sharpness = 10.; 

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

vec3 hash(vec3 p)
{
    p = vec3(dot(p, vec3(127.1, 311.7, 74.7)), dot(p, vec3(269.5,183.3,246.1)), dot(p, vec3(113.5, 271.9, 124.6)));
    p = fract(sin(p) * 43758.5453123);
    return p;
}

float shard_noise(in vec3 p, in float _sharpness) {
    vec3 ip = floor(p);
    vec3 fp = fract(p);

    float v = 0., t = 0.;
    for (int z = -1; z <= 1; z++) {
        for (int y = -1; y <= 1; y++) {
            for (int x = -1; x <= 1; x++) {
                vec3 o = vec3(float(x), float(y), float(z));
                vec3 io = ip + o;
                vec3 h = hash(io);
                vec3 r = fp - (o + h);

                float w = exp2(-TAU*dot(r, r));
                // tanh deconstruction and optimization by @Xor
                float s = _sharpness * dot(r, hash(io + vec3(11, 31, 47)) - 0.5);
                v += w * s*inversesqrt(1.0+s*s);
                t += w;
            }
        }
    }
	return ((v / t) * 0.5) + 0.5;
}

vec4 mainImage( in vec2 _uv )
{
    vec3 uv = vec3(_uv.x + TIME*timescale*hScrollSpeedFactor, _uv.y + TIME*timescale*vScrollSpeedFactor, TIME*timescale * .5 * entropyFactor);

    vec4 C = vec4(vec3(
            (shard_noise(128.0*uv,sharpness) * .03125) +
            (shard_noise(32.0*uv,sharpness) * .0625) +
            (shard_noise(16.0*uv,sharpness) * .125) +
            (shard_noise(8.0*uv,sharpness) * .25) +
            (shard_noise(4.0*uv,sharpness) * .5)
        ),1.);
    
    return C;
}

void fragment() 
{
    vec4 noise = mainImage(UV);
    
    switch (colorMode)
    {
        case 0:
            // Greyscale noise
            COLOR = noise;
            break;
        case 1:
            // Subtract noise from color
            COLOR = vec4(color.r - noise.r, color.g - noise.g, color.b - noise.b, noise.a);
            break;
        case 2:
            // Add noise to clolor
            COLOR = vec4(color.r + noise.r, color.g + noise.g, color.b + noise.b, noise.a);
            break;
        default:
            COLOR = noise;
            break;
    }
}
