shader_type spatial;

void fragment() {
	vec3 color = vec3(1.0, 0.0, 0.0);

	if (distance(world_position, player_position) < R){
        ALBEDO = color + texture(SCREEN_TEXTURE, SCREEN_UV).xyz;
        ALPHA = 1.;
    }
    else
        ALPHA = 0.;
}
