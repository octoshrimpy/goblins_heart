extends Area2D

var interactable : bool = false
var has_berries : bool = false

var time_track_for_plant : int = 0
var last_picked : int = 0

onready var small_growth = $SmallGrowth
onready var large_growth = $LargeGrowth

enum GROWTH {
	SMALL,
	LARGE
}

var growth_stage = GROWTH.SMALL

# Called when the node enters the scene tree for the first time.
func _ready():
			if not Chronos.is_connected("clock_tick", self, "_on_timer_tick"):
				Chronos.connect("clock_tick", self, "_on_timer_tick")
			print('connected signal clock tick')
			if not Chronos.is_connected("clock_updated", self, "_on_clock_update"):
				Chronos.connect("clock_updated", self, "_on_clock_update")
			print('connected signal clock updated')

func _on_Plant_body_entered(body):
	if body is Player:
		interactable = true

func _on_Plant_body_exited(body):
	if body is Player:
		interactable = false

func grow_bigger():
	#if time_track_for_plant >= 24:
		update_size(growth_stage)

func update_size(growth_stage_param):
	if growth_stage_param == GROWTH.SMALL:
		growth_stage = GROWTH.LARGE
		small_growth.visible = false
		large_growth.visible = true
		
func _on_timer_tick():
#	if time_track_for_plant >= 24:
	if time_track_for_plant >= 3:
		time_track_for_plant = 0
		grow_bigger()
		print('grow?', time_track_for_plant)
	else:
		time_track_for_plant += 1
		print('tick', time_track_for_plant)
	
func _on_clock_update():
	pass


#func _on_Chronos_clock_tick():
#	grow_bigger()
