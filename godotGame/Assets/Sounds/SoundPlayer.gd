extends Node

const HURT = preload("res://Assets/Sounds/Hurt.wav")
const JUMP = preload("res://Assets/Sounds/Jump.wav")
const BGM = preload("res://Assets/Sounds/Corm_Sounds/Home_OGG.ogg")

onready var audioPlayers = $AudioPlayers
onready var bgmPlayer = $BGMPlayer/AudioStreamPlayer

func play_sound(sound):
	for audioStreamPlayer in audioPlayers.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			break

func play_BGM(sound = BGM):
	bgmPlayer.stream = BGM
	bgmPlayer.play()
