shader_type canvas_item;

// Vitesse et direction du défilement
uniform vec2 velocity = vec2(0.0, 0.0);

// Coloration
uniform vec4 color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

// Motif
uniform sampler2D albedo : source_color;

// Taille du motif
uniform vec2 scaling = vec2(1.0, 1.0);


// Colorise la texture en dégradé de gris
void fragment() {
	vec4 tex = texture(albedo, mod(UV * scaling + velocity * TIME, 1.0));
	COLOR = tex * color;
}
