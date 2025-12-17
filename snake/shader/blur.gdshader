shader_type canvas_item;

/*
	Effet graphique qui permet de floutter une texture.
*/

// rendu de l'écran avant application du shader
// `filter_linear_mipmap` permet d'adoucir l'échantionnage
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;

// facteur de l'effet de flou
uniform float blur_amount: hint_range(0.0, 5.0) = 1.5;

// fonction appelée pour chaque pixel
void fragment()
{
	// pour un pixel aux coordonnées `SCREEN_UV` échantionner `screen_texture` 
	// avec le facteur de flou `blur_amount`
	COLOR.rgb = textureLod(screen_texture, SCREEN_UV, blur_amount).rgb;
}
