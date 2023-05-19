shader_type canvas_item;

uniform vec4 glow_color = vec4(0.0);
uniform float glow_amount = 0.75;

void fragment() {
	vec4 tex_contrib = texture(TEXTURE, UV);

	vec3 glow_contrib = vec3(1.0) - tex_contrib.rgb;
	glow_contrib *= abs(sin(PI * TIME)) * glow_color.rgb * glow_amount;

	COLOR = vec4(glow_contrib, tex_contrib.a) + tex_contrib;
}
