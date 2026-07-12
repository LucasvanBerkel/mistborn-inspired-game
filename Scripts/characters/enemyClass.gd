extends CharacterBody2D
class_name Enemy

@export_range(0,1) var AIRDRAG = 0.98

func _physics_process(delta: float) -> void:
	velocity *= AIRDRAG
	
	move_and_slide()
