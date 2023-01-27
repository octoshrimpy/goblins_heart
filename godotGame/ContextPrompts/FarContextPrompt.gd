extends Area2D
#get parent node, will be node type/name unless class_name is declared
onready var parent_context = get_parent()

func _on_FarContextPrompt_body_entered(body):
		#Match context of parent node name, and run whatever you put for it
	if parent_context is NPC: 
		print('NPC far context')
	elif parent_context is CHEST:
		print('Chest far Context')
		parent_context.glow()
#	elif parent_context is PLAYER_OBSERVATION:
#		print('Player makes a remark about what they observed')
	else: pass
#	if body is Player:
##		body.player_interact()
#		pass

func _on_FarContextPrompt_body_exited(body):
				#Match context of parent node name, and run whatever you put for it
	if parent_context is NPC: 
		print('NPC far context')
	elif parent_context is CHEST:
		print('Chest far Context')
		parent_context.not_glow()
#	elif parent_context is PLAYER_OBSERVATION:
#		print('Player makes a remark about what they observed')
	else: pass
#	if body is Player:
##		body.player_interact()
#		pass

