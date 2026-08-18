extends Node2D
class_name HealthComponent

@export var MaxHealth : float = 1
@export var Health : float = MaxHealth
@export var CanTakeDamage : bool = true

func _ready() -> void:
	if Health > MaxHealth:
		Health = MaxHealth

func _process(delta: float) -> void:
	if Health <= 0:
		self.get_parent().queue_free()

func Take_Damage(damage : float) -> void:
	if CanTakeDamage == true:
		Health -= damage
