extends CanvasLayer

# Path to the next scene to transition to
#export(String, FILE, "*.tscn") var next_scene_path
var main = preload("res://world.tscn")
var test = preload("res://TestRect.tscn")
export(String, FILE, "res://world.tscn") var next_scene_path

# Reference to the _AnimationPlayer_ node
onready var _anim_player := $AnimationPlayer

func _ready() -> void:
	# Plays the animation backward to fade in
	def_fade()

func def_fade():
	_anim_player.play("Fade")
	_anim_player.play_backwards("Fade")
func transit_fade_in():
	_anim_player.play("Fade")
func transit_fade_out():
	_anim_player.play_backwards("Fade")
#func transition_to(_next_scene := next_scene_path) -> void:
func transition_to(_next_scene) -> void:
	# Plays the Fade animation and wait until it finishes
	transit_fade_in()
#	_anim_player.play_backwards("Fade")
	yield(_anim_player, "animation_finished")
	# Changes the scene
#	get_tree().change_scene(_next_scene)
	if _next_scene == 'main':
		get_tree().change_scene_to(main)
	if _next_scene == 'test':
		get_tree().change_scene_to(test)
	else: get_tree().change_scene_to(main)
