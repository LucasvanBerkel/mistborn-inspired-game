extends Node2D
class_name HealthComponent

@export var MaxHealth : float = 1
@export var Health : float = MaxHealth
@export var Invulnerable : bool = false
@export var InvulnerabilityAfterHit : float = 1

var InvulnerabilityTimer = 0

func _ready() -> void:
	if Health > MaxHealth:
		Health = MaxHealth
	if Health <= 0:
		Health = MaxHealth

func _process(delta: float) -> void:
	if InvulnerabilityTimer > 0:
		InvulnerabilityTimer -= delta
	
	if Health <= 0:
		self.get_parent().queue_free()

func Take_Damage(damage : float) -> void:
	if InvulnerabilityTimer <= 0:
		InvulnerabilityTimer = InvulnerabilityAfterHit
		
		if Invulnerable == false:
			Health -= damage
