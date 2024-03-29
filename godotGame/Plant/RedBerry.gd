extends Area2D

#onready var Item = preload("res://Item/Item.tscn")
#var interactable : bool = false
#var has_berries : bool = false

var time_track_for_plant : int = 0
var last_picked : int = 0

#texture for berries or whatever harvestable it will have
onready var harvestable_texture = preload("res://Assets/Sprites/PlaceholderInteract.png")

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

var this_plant = {
	stage_type = GROWTH_STAGES.SIX_STAGE,
	growth_speed_modifer = GROWTH_SPEED.FAST,
	growth_stage = GROWTH.JUST_PLANTED,
	interactable = false,
	has_berries = false,
	harvestable_texture = harvestable_texture,
	player_proximity = false
}
func _process(delta):
	try_harvest()
	
func _ready():
	randomize()
	#connects to Chronos singleton signals, with a saftey check to avoid memory leaks
	if not Chronos.is_connected("clock_tick", self, "_on_timer_tick"):
		Chronos.connect("clock_tick", self, "_on_timer_tick")
		print('connected signal clock tick')
	if not Chronos.is_connected("clock_updated", self, "_on_clock_update"):
		Chronos.connect("clock_updated", self, "_on_clock_update")
		print('connected signal clock updated')
		

func test():
	var choice = rng.randi_range(0, 10)
	print("TEST", 'var:', choice, 'raw:', Chronos.rng_0_to_10())
	
func rng_0_to_10() -> int:
	var choice : int = Chronos.rng_0_to_10()
	print('first roll: ', choice)
	return choice

func randomized_growth_success_roll() -> bool:
	var choice : int = Chronos.rng_0_to_10()
	print('random growth roll: ', choice)
	return (choice > 3)
	
func slow_grow_speed_success_check() -> bool:
	var choice : int = Chronos.rng_0_to_10()
	print('slow grow check: ', choice)
	return choice > 3

func try_grow(speed : int) -> void:
	var growTick = (Chronos.rng_0_to_10() > 5)
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
#NEW STUFF-------------------------------------------------------------------------#
#change per plant
enum ITEM_TYPE {CONSUMABLE, WEAPON, ARMOR, TECH, OTHER}
var harvest_item_harvestable = false
var harvest_item_name = 'red_berry'
func make_harvest_item():
#	var new_item = Item.instance()
#	new_item.init_item('blue_berry', 5, 5, 5, 0, 0, 0, 0, 0, true, ITEM_TYPE.CONSUMABLE)
	var harvest_item = Thoth.make_item(harvest_item_name, 5, 5, 5, 0, 0, 0, 0, 0, true, ITEM_TYPE.CONSUMABLE, harvestable_texture)
	return harvest_item
	
func try_harvest():
	if not this_plant.interactable == true: return
	if not this_plant.has_berries == true: return
	if not harvest_item_harvestable == true: return
	if not this_plant.player_proximity == true: return
	
	if Input.is_action_just_pressed("ui_accept"):
		harvest_harvest_item()
#		set_plant_not_harvestable()
#		this_plant.has_berries = false
		this_plant.growth_stage = GROWTH.GROWTH_3
		update_size_6_stage()
		
func harvest_harvest_item():
	var harvest_item = make_harvest_item()
	Thoth.add_to_player_inventory(harvest_item, 'consumable')
#--------------------------------------------------------------------------------#
func _on_Plant_body_entered(body):
	if body is Player:
		this_plant.interactable = true
		this_plant.player_proximity = true

func _on_Plant_body_exited(body):
	if body is Player:
		this_plant.interactable = false
		this_plant.player_proximity = false

		#change per plant
func set_plant_harvestable():
	this_plant.has_berries = true
	harvest_item_harvestable = true
	#change per plant
func set_plant_not_harvestable():
	this_plant.has_berries = false
	harvest_item_harvestable = false
	
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
				pass
#				print('can"t grow bigger; fully grown')

func update_size_6_stage():
	match this_plant.growth_stage:
			GROWTH.JUST_PLANTED:
#				print('just planted')
				set_plant_not_harvestable()
				plant_sprite.animation = 'JustPlanted'
				this_plant.interactable = false
			GROWTH.GROWTH_1:
#				print('growth1')
				set_plant_not_harvestable()
				plant_sprite.animation = 'Growth1'
				this_plant.interactable = false
			GROWTH.GROWTH_2:
#				print('growth2')
				set_plant_not_harvestable()
				plant_sprite.animation = 'Growth2'
				this_plant.interactable = false
			GROWTH.GROWTH_3:
#				print('growth3')
				set_plant_not_harvestable()
				plant_sprite.animation = 'Growth3'
				this_plant.interactable = false
			GROWTH.FRUIT_GROWTH_1:
#				print('fruit1')
				set_plant_not_harvestable()
				plant_sprite.animation = 'FruitGrowth1'
				this_plant.interactable = false
			GROWTH.FRUIT_GROWTH_2:
#				print('fruit2')
				set_plant_not_harvestable()
				plant_sprite.animation = 'FruitGrowth2'
				this_plant.interactable = false
			GROWTH.FRUIT_GROWTH_3:
#				print('fruit3')
				set_plant_harvestable()
				plant_sprite.animation = 'FruitGrowth3'
				this_plant.interactable = true
		
func _on_timer_tick():
	try_grow(this_plant.growth_speed_modifer)
#	print(Chronos.rng_0_to_10())
#	test()
	
func _on_clock_update():
	pass


func _on_RedBerry_body_entered(body):
	if body is Player:
#		this_plant.interactable = true
		print('redberry enter')
		this_plant.player_proximity = true


func _on_RedBerry_body_exited(body):
	if body is Player:
#		this_plant.interactable = false
		print('redberry exit')
		this_plant.player_proximity = false
