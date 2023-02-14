extends Node
#check out typecasing := 
#precursor onready (make sure stuff is loaded)
#export will run an editable dropdown for real time (good for debugging)

signal clock_tick

export var current_time : int = 12

var isDay : bool = true

onready var timer = $Timer
#look up one shot func _ready()
func _ready():
	#run once when it loads 
	#timer.start()
	pass # Replace with function body.

func _on_Timer_timeout():
	print("tick")
	#our signal
	emit_signal("clock_tick")
	#timer.start()
