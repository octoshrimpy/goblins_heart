extends Area2D

#get parent node, will be node type/name unless class_name is declared
onready var parent_context = get_parent()

func _on_ContextPrompt_body_entered(body):
	print(parent_context is NPC)
	#Match context of parent node name, and run whatever you put for it
	if parent_context is NPC: 
		print('NPC context')
	elif parent_context is CHEST:
		print('Chest Context')
#	elif parent_context is PLAYER_OBSERVATION:
#		print('Player makes a remark about what they observed')
	else: pass
#	if body is Player:
##		body.player_interact()
#		pass
