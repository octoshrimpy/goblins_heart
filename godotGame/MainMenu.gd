extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
		SoundPlayer.play_BGM()

##Use this to keep menu music looping, or add more music to change up menu music
#func _process(delta):
#	for audioStreamPlayer in SoundPlayer.bgm.get_children():
#		if not audioStreamPlayer.playing:
#			SoundPlayer.play_bgm(SoundPlayer.BGM_MENU)



func _on_StartButton_pressed():
	 SceneTransitionRect.transition_to("main")



func _on_QuitButton_pressed():
	get_tree().quit()
