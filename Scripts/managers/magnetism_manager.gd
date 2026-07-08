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
		
		closestPosition = GetClosestMetalToPoint(mousePos)
	else:
		closestPosition = GetClosestMetalToPoint(closestPosition)
	
	self.position = closestPosition
	selected_metal_location.emit(closestPosition)

func GetClosestMetalToPoint(point : Vector2):
	
	var closestMetal : Vector2
	var distanceToClosestPosition : float = 100000000
	
	var cellCords : Array
	for cell in MetalTileMap.get_used_cells():
		cellCords.append(MetalTileMap.map_to_local(cell))
	
	for cell in cellCords:
		if point.distance_to(cell) <= distanceToClosestPosition:
			distanceToClosestPosition = point.distance_to(cell)
			closestMetal = cell
	
	for metal in get_tree().get_nodes_in_group("MetalObject"):
		var metalObjectPos = metal.get_parent().position
		if point.distance_to(metalObjectPos) <= distanceToClosestPosition:
			distanceToClosestPosition = point.distance_to(metalObjectPos)
			closestMetal = metalObjectPos
	
	return closestMetal
