shader_type canvas_item;

void fragment() {
    vec4 current_color = texture(TEXTURE, UV);
    // Keeps the sprite's shape/transparency, but forces RGB to white (1.0)
    COLOR = vec4(1.0, 1.0, 1.0, current_color.a);
}
