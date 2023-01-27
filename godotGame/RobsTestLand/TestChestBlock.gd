extends StaticBody2D
class_name CHEST
onready var arrow = $Sprite2
onready var glow = $GlowAnimation
onready var interact = $InteractAnimation
onready var interactSprite = $Interact

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
#Near prompt for arrows
func show_arrow():
	arrow.visible = true
func hide_arrow():
	arrow.visible = false

#far prompt for glow
func glow():
	glow.play('glow')
func not_glow():
	if glow.is_playing():
		glow.stop(true)
		glow.seek(0, true)

#proximity prompt for interact
func show_interact():
	interactSprite.visible = true
	interact.play('Interact')
func hide_interact():
	if interact.is_playing():
		interactSprite.visible = false
		interact.stop()
		interact.seek(0, true)
	
