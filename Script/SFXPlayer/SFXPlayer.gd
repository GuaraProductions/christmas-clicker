extends AudioStreamPlayer
class_name SFXPlayer

@export var audios : Array[AudioStream]

func _ready() -> void:
	print(audios)

func play_bell() -> void:
	stop()
	stream = audios[0]
	play()

func play_dink() -> void:
	stop()
	stream = audios[1]
	play()
