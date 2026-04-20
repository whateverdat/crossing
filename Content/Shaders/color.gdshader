shader_type canvas_item;

uniform vec4 tint_color : source_color = vec4(1.0);

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    // Multiply the white sprite's color by our random tint
    COLOR = tex_color * tint_color;
}