shader_type canvas_item;


// Première couleur
uniform vec4 color1 = vec4(0.0, 0.0, 0.0, 1.0);

// Seconde couleur
uniform vec4 color2 = vec4(1.0, 1.0, 1.0, 1.0);


// Colorise la texture en dégradé de gris
void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	COLOR = (color1 * (1.0 - tex.r) + color2 * tex.r) * tex.a;
}
