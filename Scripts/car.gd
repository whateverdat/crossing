extends Node2D

@export var Clickbox : Area2D
@export var Hitbox : Area2D
@export var PathFollow : PathFollow2D
@export var CarSprite : AnimatedSprite2D

var outline_shader : ShaderMaterial = load("res://Content/Shaders/outline.tres")
var color_shader : ShaderMaterial = load("res://Content/Shaders/color.tres")
var color_shader_duplicate : ShaderMaterial

var _is_game_over : bool = false

signal collision

func _ready() -> void:
	var random_color = Color.from_hsv(randf(), 0.7, 0.9) 
	color_shader_duplicate = color_shader.duplicate()
	color_shader_duplicate.set_shader_parameter("tint_color", random_color)
	CarSprite.material = color_shader_duplicate
	
	Clickbox.input_pickable = true
	
	Clickbox.input_event.connect(_on_clickbox_input_event)
	Clickbox.mouse_entered.connect(_handle_mouse_enter)
	Clickbox.mouse_exited.connect(_handle_mouse_exit)
	
	Hitbox.area_entered.connect(_handle_collision)


func handle_game_over() -> void:
	_is_game_over = true

func _handle_collision(area: Area2D) -> void:
	if (area.name == "Hitbox"):
		emit_signal("collision")
		PathFollow.acceleration = 0
		PathFollow.speed = 0


func _on_clickbox_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_handle_car_clicked()


func _handle_car_clicked() -> void:
	if (_is_game_over): return
	PathFollow.handle_clicked()
	
	
func _handle_mouse_enter() -> void: 
	if (_is_game_over): return
	CarSprite.material = outline_shader
	
	
func _handle_mouse_exit() -> void:
	if (_is_game_over): return
	CarSprite.material = color_shader_duplicate
	
