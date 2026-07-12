extends State
class_name FlyingIdle

@export var enemy : CharacterBody2D
@export var Speed : float = 50

func Physics_Update(delta : float):
	if enemy:
		enemy.velocity.x += (randf() -0.5) * Speed
		enemy.velocity.y += (randf() -0.5) * Speed
