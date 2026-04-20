extends Node2D

@export var Hitbox : Area2D
@export var PathFollow : PathFollow2D
@export var Sprite : Sprite2D

var outline_shader : ShaderMaterial = load("res://Content/Shaders/outline.tres")
var color_shader : ShaderMaterial = load("res://Content/Shaders/color.tres")
var color_shader_duplicate : ShaderMaterial

var _is_game_over : bool = false


func _ready() -> void:
	var random_color = Color.from_hsv(randf(), 0.7, 0.9) 
	color_shader_duplicate = color_shader.duplicate()
	color_shader_duplicate.set_shader_parameter("tint_color", random_color)
	Sprite.material = color_shader_duplicate
	


func handle_game_over() -> void:
	_is_game_over = true

	
