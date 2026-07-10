class_name HealthComponent
extends Node2D

@export var MaxHealth : int = 1
@export var Health : int = MaxHealth
@export var CanTakeDamage : bool = true

func _ready() -> void:
	if Health > MaxHealth:
		Health = MaxHealth

func _process(delta: float) -> void:
	if Health <= 0:
		self.get_parent().queue_free()

func Take_Damage(damage : int) -> void:
	Health -= damage
