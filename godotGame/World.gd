extends Node2D

const PlayerScene = preload("res://Player/Player.tscn")

var player_spawn_location = Vector2.ZERO

onready var camera: = $Camera2D
onready var player: = $Player
onready var timer: = $Timer

func _ready():
	VisualServer.set_default_clear_color(Color.lightblue)
	player.connect_camera(camera)
	player_spawn_location = player.global_position
	#player_spawn_location.y -= 10
	Events.connect("player_died", self, "_on_player_died")
	Events.connect("hit_checkpoint", self, "_on_hit_checkpoint")
	print(player_spawn_location)
	#Fade out box from transition 
	SceneTransitionRect.transit_fade_out()
func _on_player_died():
	print(player_spawn_location)
	timer.start(1.0)
	yield(timer, "timeout")
	var player = PlayerScene.instance()
	player.position = player_spawn_location
	add_child(player)
	player.connect_camera(camera)
	
func _on_hit_checkpoint(checkpoint_position):
	player_spawn_location = checkpoint_position
