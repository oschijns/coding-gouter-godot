shader_type canvas_item;

// couleur a appliquer
uniform vec4 color: source_color = vec4(0.0);

// aucunes transformations des vertexes
void vertex()
{}

// colorisation des pixels
void fragment()
{
	COLOR = texture(TEXTURE, UV).rgba * color.rgba;
}
