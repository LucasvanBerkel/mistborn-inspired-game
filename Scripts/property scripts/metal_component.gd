class_name MetalComponent
extends Node2D

@export var IsAtackable : bool = false
#@export var ReceivesMetalicForce : bool = false

func Is_Atackable() -> bool:
	return IsAtackable
