class_name AttackBox
extends Area2D

@export var Damage : int = 1
@export var Enabled : bool = true

func _on_attack_box_entered(area: Area2D) -> void:
	if Enabled == true:
		if area is HurtBox:
			area.Take_Damage(Damage)
