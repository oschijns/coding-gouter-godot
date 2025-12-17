shader_type canvas_item;

/*
	Effet graphique qui permet de coloriser une texture.
*/

// couleur à appliquer
uniform vec4 color: source_color = vec4(0.0);

// colorisation des pixels
void fragment()
{
	COLOR = texture(TEXTURE, UV).rgba * color.rgba;
}
