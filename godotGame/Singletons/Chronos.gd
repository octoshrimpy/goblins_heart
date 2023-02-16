extends Node

signal clock_tick
signal clock_updated
signal day_cycle_update

export var current_time : int = 12
var is_day : bool = true
var rng = RandomNumberGenerator.new()
func _ready():
		if not is_connected("clock_tick", self, "_on_timer_tick"):
			connect("clock_tick", self, "_on_timer_tick")
			print('connected signal')
	
func _on_Timer_timeout():
	print('tick')
	Chronos.emit_signal("clock_tick")
	
func _on_timer_tick():
	update_clock()
	update_is_day()

func update_clock():
	if current_time < 24:
		current_time += 1
		emit_signal("clock_updated")
	elif current_time >= 24:
		current_time = 0
		emit_signal("clock_updated")
	else: 
		pass
func rng_0_to_10():
	return rng.randi_range(0, 10)
#May cause bug of too many signals
func update_is_day():
	if current_time > 10:
		is_day = false
		emit_signal("day_cycle_update")
	else:
		is_day = true
		emit_signal("day_cycle_update")
	
