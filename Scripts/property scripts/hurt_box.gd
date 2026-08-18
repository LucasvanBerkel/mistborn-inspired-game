class_name HurtBox
extends Area2D

@export var healthComponent : HealthComponent

func Take_Damage (damage : float) -> void:
	healthComponent.Take_Damage(damage)
