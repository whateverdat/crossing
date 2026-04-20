extends Camera2D

@export var random_strength: float = 10.0
@export var shake_fade: float = 5.0

var _shake_strength: float = 0.0
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	make_current()
	_rng.randomize()

func apply_shake(strength: float = 10.0) -> void:
	_shake_strength = strength

func _process(delta: float) -> void:
	if _shake_strength > 0:
		_shake_strength = lerp(_shake_strength, 0.0, shake_fade * delta)
		
		offset = _get_random_offset()
	else:
		offset = Vector2.ZERO

func _get_random_offset() -> Vector2:
	return Vector2(
		_rng.randf_range(-_shake_strength, _shake_strength),
		_rng.randf_range(-_shake_strength, _shake_strength)
	)
