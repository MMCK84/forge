shader_type canvas_item;
// Färbt ein graustufiges Werkstück-Sprite nach seiner Temperatur ein (Lastenheft 6.5).
// Die Verlaufstextur enthält die Glutfarben-Stützpunkte; x = Temperatur / t_scale.

uniform sampler2D glow_gradient : filter_linear, repeat_disable;
uniform float temperature = 20.0;
uniform float t_scale = 1450.0;
// 0 = keine sichtbare Glut, 1 = volle Glut
uniform float glow_strength : hint_range(0.0, 1.0) = 0.0;
uniform float flicker = 0.0;

void fragment() {
	vec4 base = COLOR;
	float lum = base.r;
	vec3 glow = texture(glow_gradient, vec2(clamp(temperature / t_scale, 0.0, 1.0), 0.5)).rgb;
	vec3 cold_metal = vec3(0.30, 0.31, 0.34) + vec3(0.55, 0.55, 0.58) * lum;
	float pulse = 1.0 + flicker * 0.06 * sin(TIME * 9.0 + UV.x * 6.0);
	vec3 hot = glow * (0.55 + 0.65 * lum) * pulse + glow * glow_strength * 0.25;
	COLOR = vec4(mix(cold_metal, hot, glow_strength), base.a);
}
