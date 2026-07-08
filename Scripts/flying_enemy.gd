extends CharacterBody2D


@export var SPEED = 50
@export_range(0,1) var AIRDRAG = 0.96


func _physics_process(delta: float) -> void:
	velocity.x += (randf() -0.5) * SPEED
	velocity.y += (randf() -0.5) * SPEED
	velocity *= 0.96

	move_and_slide()
