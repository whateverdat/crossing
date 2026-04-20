extends Camera2D

@export var tween_duration: float = 2
@export var transition_type: Tween.TransitionType = Tween.TRANS_QUART
@export var ease_type: Tween.EaseType = Tween.EASE_OUT

var _camera_tween: Tween

signal start_game

func move_camera(pos: float) -> void:
	if _camera_tween and _camera_tween.is_running():
		_camera_tween.kill()
	
	_camera_tween = create_tween()
	
	var target_position: Vector2 = Vector2(pos, 0)
	
	_camera_tween.tween_property(self, "position", target_position, tween_duration)\
		.set_trans(transition_type)\
		.set_ease(ease_type)
		
	_camera_tween.finished.connect(func(): 
		_on_camera_settled()
	)
	
func _on_camera_settled() -> void:
	emit_signal("start_game")
