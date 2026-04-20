extends Node2D

@export var Camera : Camera2D
@export var CarContainer : Node2D
@export var PedestrianContainer : Node2D
@export var ScoreTriggerContainer : Node2D
@export var ScoreText : Label
@export var HitSound : AudioStreamPlayer

var score : int = 0
var is_game_over : bool = false

const SPAWN_INTERVAL : int = 1
var spawn_elapsed : float = 0

var level_type : int = 0

var pedestrian_array : Array[PackedScene] = [
	preload("res://Scenes/pedestrian_lr.tscn"),
	preload("res://Scenes/pedestrian_rl.tscn"),
]

var roundabout_cars_array : Array[PackedScene] = [
	preload("res://Entities/Cars/Roundabout/l_south_car_north.tscn"),
	preload("res://Entities/Cars/Roundabout/l_south_car_west.tscn"),
	preload("res://Entities/Cars/Roundabout/r_south_car_east.tscn"),
	preload("res://Entities/Cars/Roundabout/r_south_car_north.tscn"),
]

var intersection_cars_array : Array[PackedScene] = [
	preload("res://Entities/Cars/Intersection/l_south_car_north.tscn"),
	preload("res://Entities/Cars/Intersection/l_south_car_west.tscn"),
	preload("res://Entities/Cars/Intersection/r_south_car_east.tscn"),
	preload("res://Entities/Cars/Intersection/r_south_car_north.tscn"),
]

func _ready() -> void:
	for area : Area2D in ScoreTriggerContainer.get_children():
		area.area_entered.connect(_score)

func _handle_game_over() -> void:
	HitSound.play()
	if (is_game_over): return
	Camera.apply_shake()
	is_game_over = true
	ScoreText.text = "You've scored %s. RIGHT CLICK to go back." % str(score)
	for car : Path2D in CarContainer.get_children():
		car.PathFollow.state = car.PathFollow.CarState.STOPPED
		car.handle_game_over()
	

func _score(entering : Area2D) -> void:
	if (entering.name == "Hitbox"):
		entering.owner.queue_free()
		if (is_game_over): return
		score += 1
		ScoreText.text = str(score)


func _process(delta: float) -> void:
	if (is_game_over): return
	spawn_elapsed += delta
	if (spawn_elapsed >= SPAWN_INTERVAL):
		spawn_elapsed = 0
		_spawn_car()


func _spawn_car() -> void:
	var pedestrian_spawn : bool = false
	if (randi_range(0, 4) == 0):
		pedestrian_spawn = true
	
	var random_pedestrian : PackedScene
	var instantiated_pedestrian : Node
	if (pedestrian_spawn):
		random_pedestrian = pedestrian_array.pick_random()
		instantiated_pedestrian = random_pedestrian.instantiate()
	
	var random : PackedScene
	if (level_type == 0):
		random = roundabout_cars_array.pick_random()
	else: random = intersection_cars_array.pick_random()
	
	var instantiated : Node = random.instantiate()
	var random_start_direction : int = randi_range(0, 3)
	match random_start_direction:
		## South
		0:
			pass
			
		## East
		1:
			instantiated.rotation_degrees = 90
			instantiated.position.x = 250
			instantiated.position.y = -70
			if (pedestrian_spawn):
				instantiated_pedestrian.rotation_degrees = 90
				instantiated_pedestrian.position.x = 250
				instantiated_pedestrian.position.y = -70
				
			
		## North
		2: 
			instantiated.rotation_degrees = 180
			instantiated.position.x = 320
			instantiated.position.y = 180
			if (pedestrian_spawn):
				instantiated_pedestrian.rotation_degrees = 180
				instantiated_pedestrian.position.x = 320
				instantiated_pedestrian.position.y = 180
			
		## West
		3: 
			instantiated.rotation_degrees = -90
			instantiated.position.x = 70
			instantiated.position.y = 250
			if (pedestrian_spawn):
				instantiated_pedestrian.rotation_degrees = -90
				instantiated_pedestrian.position.x = 70
				instantiated_pedestrian.position.y = 250
			
	
		
	instantiated.collision.connect(_handle_game_over)
	CarContainer.add_child(instantiated)
	if (pedestrian_spawn):
		PedestrianContainer.add_child(instantiated_pedestrian)
