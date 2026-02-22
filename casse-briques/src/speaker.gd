class_name GameSpeaker extends AudioStreamPlayer

#region PROPERTIES

# Défini le tempo de la musique (en secondes)
@export_range(0.01, 10.0, 0.1)
var tempo := 0.1

# Playback stream
var _playback: AudioStreamPlayback = null

# Mélodie à jouer avec son curseur
var _melody: Array[Vector2] = []
var _note_index := 0

#endregion


#region GODOT'S METHODS

# Initialize le speaker
func _ready() -> void:
	# Le "mix rate" doit être défini avant de jouer le son 
	stream.mix_rate = float(SAMPLE_HERTZ)
	# Nous devons jouer le son pour obtenir un "playback stream"
	play()
	# On obtient le stream
	_playback = get_stream_playback()

#endregion


#region PUBLIC METHODS

# Joue un simple bip sonore avec la note sélectionnée et la durée choisie en secondes
func play_beep(freq: float = 440.0, duration: float = 0.075) -> void:
	var frames := int(float(SAMPLE_HERTZ) * duration)
	var step   := freq / float(SAMPLE_HERTZ)

	for i in frames:
		# Génère un signal rectangulaire
		var sample := 1.0 if fmod(float(i) * step, 1.0) < 0.5 else -1.0

		# Les trames audio sont stéréo, donc nous poussons deux nombres en même temps
		_playback.push_frame(Vector2.ONE * sample)


# Joue une mélodie où pour chaque note, 
# - la première valeur correspond à la fréquence
# - la seconde  valeur correspond à la durée
func play_melody(melody: Array[Vector2]) -> void:
	_melody = melody
	_note_index = 0
	_on_note_timeout()


#endregion


#region CALLBACKS

# Appelé lorsque la balle rebondi sur un objet
func _on_ball_bounce() -> void:
	self.play_beep(A)


# Appelé lorsque qu'une note vien de s'achever, pour jouer la suivante
func _on_note_timeout() -> void:
	if _note_index < _melody.size():

		# On récupère les données de la note à jouer
		var note     := _melody[_note_index]
		var duration := note.y * tempo

		# Si ce n'est pas un silence, on joue la note
		if note.x > SILENCE:
			const CUTOFF := 0.99
			play_beep(note.x, duration * CUTOFF)

		# Instantie un timer et relie son signal "timeout" à la méthode 
		# "_on_note_timeout" de notre speaker.
		var delay := get_tree().create_timer(duration)
		delay.timeout.connect(_on_note_timeout)

		_note_index += 1

#endregion


#region CONSTANTS

# Fréquences des notes
const C  := 261.6 # note Do
const Cs := 277.2 # note Do#
const D  := 293.7 # note Re
const Ds := 311.1 # note Re#
const E  := 329.6 # note Mi
const F  := 349.2 # note Fa
const Fs := 370.0 # note Fa#
const G  := 392.0 # note Sol
const Gs := 415.3 # note Sol#
const A  := 440.0 # note La
const As := 466.2 # note La#
const B  := 493.9 # note Si

# Indique que aucun son ne devrait être joué
const SILENCE := 0.0

# Nombre d'échantillions
const SAMPLE_HERTZ := 22050

#endregion
