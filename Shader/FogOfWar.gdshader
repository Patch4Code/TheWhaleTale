shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D NOISE_PATTERN : repeat_enable;

// Amount of detail.
uniform int octaves = 4;

// Opacity of the output fog.
uniform float starting_amplitude: hint_range(0.0, 0.5) = 0.5;

// Rate of pattern within the fog.
uniform float starting_frequency = 1.0;

// Shift towards transparency (clamped) for sparser fog.
uniform float shift: hint_range(-1.0, 0.0) = 0.0;

// White cut off
uniform float white_cutoff: hint_range(0.0, 1.0) = 0.999;

// Direction and speed of travel.
uniform vec2 velocity = vec2(1.0, 1.0);

// Color of the fog.
uniform vec4 fog_color = vec4(0.0, 0.0, 0.0, 1.0);

float rand(vec2 uv) {
	float amplitude = starting_amplitude;
	float frequency = starting_frequency;
	float output = 0.0;
	for (int i = 0; i < octaves; i++) {
		output += texture(NOISE_PATTERN, uv * frequency).x * amplitude;
		amplitude /= 2.0;
		frequency *= 2.0;
	}
	return clamp(output + shift, 0.0, 1.0);
}

void fragment() {
	vec4 mainTexture = texture(TEXTURE, UV);
	vec2 motion = vec2(rand(UV + TIME * starting_frequency * velocity));
	vec4 negative_fog_value = vec4(1.0 - fog_color.rgb, fog_color.a);
	vec4 color = mix(mainTexture, fog_color, rand(UV + motion));
	COLOR = color;
	float real_alfa_cutoff = 1.0 - white_cutoff;
	if(color.r * color.g * color.b > real_alfa_cutoff)
	{
	    COLOR.a = 0.0;
	}
	
}