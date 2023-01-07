extends Area2D

onready var animatedSprite: = $AnimatedSprite

var active = true

func _on_Checkpoint_body_entered(body):
	if not body is Player: return
	if not active: return
	animatedSprite.play("Checked")
	active = false
	var checkpoint_pos = position
	#offsetting for weird coordinate offsets
	checkpoint_pos.x += 430.3
	checkpoint_pos.y += 254.6
	
	Events.emit_signal("hit_checkpoint", checkpoint_pos)
