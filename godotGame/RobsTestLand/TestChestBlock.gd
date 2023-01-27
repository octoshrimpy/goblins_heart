extends StaticBody2D
class_name CHEST
onready var arrow = $Sprite2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func show_arrow():
	arrow.visible = true
func hide_arrow():
	arrow.visible = false
func glow():
	pass
func no_glow():
	pass
