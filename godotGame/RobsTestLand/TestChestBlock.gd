extends StaticBody2D
class_name CHEST
onready var arrow = $Sprite2
onready var glow = $GlowAnimation

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func show_arrow():
	arrow.visible = true
func hide_arrow():
	arrow.visible = false
func glow():
	print('glow')
	glow.play('glow')
func not_glow():
	print('no glow')
	if glow.is_playing():
		
		glow.stop(true)
		glow.seek(0, true)
