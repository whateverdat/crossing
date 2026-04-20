extends Node2D

@export var camera : Camera2D
@export var btn_right : Button
@export var btn_left : Button 
@export var game_scene_container : Node2D
@export var song : AudioStreamPlayer

var game_scene : PackedScene = preload("res://Scenes/GameScene.tscn")
var game_scene2 : PackedScene = preload("res://Scenes/GameScene2.tscn")


func _ready() -> void:
	btn_right.pressed.connect(func(): camera.move_camera(320.0))
	btn_left.pressed.connect(func(): camera.move_camera(-320.0))
	
	camera.start_game.connect(_handle_start_game)
	
func _handle_start_game() -> void:
	var scene : Node2D
	if (camera.position.x == 320):
		scene = game_scene.instantiate()
	elif (camera.position.x == -320):
		scene = game_scene2.instantiate()
		scene.level_type = 1
	else:
		game_scene_container.get_children().map(func(child): child.queue_free())
		
	if (scene == null): return
	
	game_scene_container.get_children().map(func(child): child.queue_free())
	game_scene_container.position.x = camera.position.x
	game_scene_container.add_child(scene)
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_M and event.pressed:
			_toggle_mute()
	elif event is InputEventMouseButton and event.pressed:
		if (event.button_index == 2):
			_restart()
			


func _toggle_mute() -> void:
	if (song.volume_db == -80):
		song.volume_db = -10
	else: song.volume_db = -80
	
	
func _restart() -> void:
	for child in game_scene_container.get_children():
		if (child.is_game_over):
			camera.make_current()
			camera.move_camera(0)
