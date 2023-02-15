extends Area2D

#var interactable : bool = false
#var has_berries : bool = false

var time_track_for_plant : int = 0
var last_picked : int = 0

onready var plant_sprite = $Plant6StageGrowth
#--------------#RNG#-------------------------------------------------#
var rng = RandomNumberGenerator.new()
#--------------------------------------------------------------------#
enum GROWTH {
	JUST_PLANTED,
	GROWTH_1,
	GROWTH_2,
	GROWTH_3,
	FRUIT_GROWTH_1,
	FRUIT_GROWTH_2,
	FRUIT_GROWTH_3
}
enum GROWTH_SPEED {
	SLOW,
	FAST
}
enum GROWTH_STAGES {
	SIX_STAGE,
	THREE_STAGE
}

export var this_plant = {
	stage_type = GROWTH_STAGES.SIX_STAGE,
	growth_speed_modifer = GROWTH_SPEED.FAST,
	growth_stage = GROWTH.JUST_PLANTED,
	interactable = false,
	has_berries = false,
}

func _ready():
	randomize()
	#connects to Chronos singleton signals, with a saftey check to avoid memory leaks
	if not Chronos.is_connected("clock_tick", self, "_on_timer_tick"):
		Chronos.connect("clock_tick", self, "_on_timer_tick")
		print('connected signal clock tick')
	if not Chronos.is_connected("clock_updated", self, "_on_clock_update"):
		Chronos.connect("clock_updated", self, "_on_clock_update")
		print('connected signal clock updated')

func rng_0_to_10() -> int:
	var choice : int = rng.randi_range(0, 10)
	print(choice)
	return choice

func randomized_growth_success_roll() -> bool:
	var choice : int = rng.randi_range(0, 10)
	print('random growth roll', choice)
	return (choice > 3)
	
func slow_grow_speed_success_check() -> bool:
	var choice : int = rng.randi_range(0, 10)
	print(choice)
	return choice > 3

func try_grow(speed : int) -> void:
	var growTick = (rng.randi_range(0, 10) > 5)
	if growTick:
		if randomized_growth_success_roll():
			if (this_plant.stage_type == GROWTH_STAGES.SIX_STAGE and speed == GROWTH_SPEED.FAST):
				grow_bigger_6_stage()
				update_size_6_stage()
			elif (this_plant.stage_type == GROWTH_STAGES.SIX_STAGE and speed == GROWTH_SPEED.SLOW):
				if (slow_grow_speed_success_check()):
					grow_bigger_6_stage()
					update_size_6_stage()
				else: 
					print('failed slow grow second check')
			else:
				print('Invalid Enum value for plant_stage_type / GROWTH_SPEED')
	else: 
		print('no luck this time, tick')
	
func _on_Plant_body_entered(body):
	if body is Player:
		this_plant.interactable = true

func _on_Plant_body_exited(body):
	if body is Player:
		this_plant.interactable = false
		
func set_plant_harvestable():
	this_plant.has_berries = true
	
func set_plant_not_harvestable():
	this_plant.has_berries = false
	
func grow_bigger_6_stage():
		match this_plant.growth_stage:
			GROWTH.JUST_PLANTED:
				this_plant.growth_stage = GROWTH.GROWTH_1
			GROWTH.GROWTH_1:
				this_plant.growth_stage = GROWTH.GROWTH_2
			GROWTH.GROWTH_2:
				this_plant.growth_stage = GROWTH.GROWTH_3
			GROWTH.GROWTH_3:
				this_plant.growth_stage = GROWTH.FRUIT_GROWTH_1
			GROWTH.FRUIT_GROWTH_1:
				this_plant.growth_stage = GROWTH.FRUIT_GROWTH_2
			GROWTH.FRUIT_GROWTH_2:
				this_plant.growth_stage = GROWTH.FRUIT_GROWTH_3
			GROWTH.FRUIT_GROWTH_3:
				print('can"t grow bigger; fully grown')

func update_size_6_stage():
	match this_plant.growth_stage:
			GROWTH.JUST_PLANTED:
				print('just planted')
				set_plant_not_harvestable()
				plant_sprite.animation = 'JustPlanted'
			GROWTH.GROWTH_1:
				print('growth1')
				set_plant_not_harvestable()
				plant_sprite.animation = 'Growth1'
			GROWTH.GROWTH_2:
				print('growth2')
				set_plant_not_harvestable()
				plant_sprite.animation = 'Growth2'
			GROWTH.GROWTH_3:
				print('growth3')
				set_plant_not_harvestable()
				plant_sprite.animation = 'Growth3'
			GROWTH.FRUIT_GROWTH_1:
				print('fruit1')
				set_plant_not_harvestable()
				plant_sprite.animation = 'FruitGrowth1'
			GROWTH.FRUIT_GROWTH_2:
				print('fruit2')
				set_plant_not_harvestable()
				plant_sprite.animation = 'FruitGrowth2'
			GROWTH.FRUIT_GROWTH_3:
				print('fruit3')
				set_plant_harvestable()
				plant_sprite.animation = 'FruitGrowth3'
		
func _on_timer_tick():
	try_grow(this_plant.growth_speed_modifer)
	
func _on_clock_update():
	pass
