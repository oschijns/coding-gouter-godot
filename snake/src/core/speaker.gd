class_name Speaker extends AudioStreamPlayer

# Nombre d'échantillions
const SAMPLE_HERTZ := 22050

# Playback stream
var playback: AudioStreamPlayback = null


func _ready():
	# Le "mix rate" doit être défini avant de jouer le son 
	stream.mix_rate = float(SAMPLE_HERTZ)

	# Nous devons jouer le son pour obtenir un "playback stream"
	play()

	# On obtient le stream
	playback = get_stream_playback()


func play_beep(freq: float = 440.0, duration: float = 0.05):
	var frames := int(float(SAMPLE_HERTZ) * duration)
	var step   := freq / float(SAMPLE_HERTZ)

	for i in frames:
		# Converti le signal en signal rectangulaire
		var sample := 1.0 if fmod(float(i) * step, 1.0) < 0.5 else -1.0

		# Les trames audio sont stéréo, donc nous poussons deux nombres en même temps
		playback.push_frame(Vector2.ONE * sample)
