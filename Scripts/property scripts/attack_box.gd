class_name AttackBox
extends Area2D

@export var Damage : float = 1
@export var Enabled : bool = true

signal Attacked(hurtBox : HurtBox)

func _on_attack_box_entered(area: Area2D) -> void:
	if Enabled == true:
		if area is HurtBox:
			area.Take_Damage(Damage)
			
			Attacked.emit(area)
