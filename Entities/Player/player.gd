extends CharacterBody2D

@export var PLAYER_SPEED: float = 300.0


func _ready() -> void:
	pass
	
func _physics_process(_delta: float) -> void:
	if (!is_multiplayer_authority()):
		return
	
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	print(direction)
	
	velocity = direction * PLAYER_SPEED
	move_and_slide()
