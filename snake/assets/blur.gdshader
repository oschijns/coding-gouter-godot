shader_type canvas_item;

// rendu de l'ecran avant application du shader
// `filter_linear_mipmap` permet d'adoucir l'echantionnage
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;

// facteur de l'effet de flou
uniform float blur_amount: hint_range(0.0, 5.0) = 1.5;

// fonction appelee pour chaque pixel
void fragment()
{
	// pour un pixel aux coordonnees `SCREEN_UV` echantionner `screen_texture` 
	// avec le facteur de flou `blur_amount`
	COLOR.rgb = textureLod(screen_texture, SCREEN_UV, blur_amount).rgb;
}
