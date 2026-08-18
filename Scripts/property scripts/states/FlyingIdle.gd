extends State
class_name FlyingIdle

@export var enemy : Enemy
@export var LOSRay : RayCast2D
@export var Speed : float = 50
@export var DistanceTillAtackState : float = 250

var player : PlayerCharacter

func _ready() -> void:
	player = enemy.GetPlayer()

func Update(delta : float):
	if LOSRay.HasLineOfSight(player) && enemy.position.distance_to(player.position) < DistanceTillAtackState:
		Transitioned.emit(self, "FlyingHostile")

func Physics_Update(delta : float):
	if enemy:
		enemy.velocity.x += (randf() -0.5) * Speed
		enemy.velocity.y += (randf() -0.5) * Speed
