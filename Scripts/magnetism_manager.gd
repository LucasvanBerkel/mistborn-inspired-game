extends Node

@export var MetalTileMap : TileMapLayer

signal selected_metal_location(Position : Vector2)

var lockedOn : bool = false
var closestPosition : Vector2

@export var metalObjectType : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_pressed("Push") or Input.is_action_pressed("Pull"):
		lockedOn = true
	else:
		lockedOn = false
	
	if lockedOn == false:
		var mousePos : Vector2
		mousePos = get_viewport().get_camera_2d().get_global_mouse_position()
		
		var cellCords : Array
		for cell in MetalTileMap.get_used_cells():
			cellCords.append(MetalTileMap.map_to_local(cell))
		
		var distanceToClosestPosition : float = 100000000
		
		for cell in cellCords:
			if mousePos.distance_to(cell) <= distanceToClosestPosition:
				distanceToClosestPosition = mousePos.distance_to(cell)
				closestPosition = cell
		
		for metal in get_tree().get_nodes_in_group("MetalObject"):
			var metalObjectPos = metal.get_parent().position
			if mousePos.distance_to(metalObjectPos) <= distanceToClosestPosition:
				distanceToClosestPosition = mousePos.distance_to(metalObjectPos)
				closestPosition = metalObjectPos
		
	self.position = closestPosition
	selected_metal_location.emit(closestPosition)
