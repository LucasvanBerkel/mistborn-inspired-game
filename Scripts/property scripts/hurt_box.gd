class_name HurtBox
extends Area2D

@export var healthComponent : HealthComponent

func Take_Damage (damage : int) -> void:
	healthComponent.Take_Damage(damage)
