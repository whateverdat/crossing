extends PathFollow2D

var speed : float = 5

func _ready() -> void:
	pass
	
func _process(delta) -> void:
	progress += delta * speed
	if (progress_ratio >= 1):
		get_parent().queue_free()
	
	
	
