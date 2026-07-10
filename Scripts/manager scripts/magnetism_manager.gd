extends Node
class_name MagnetismManager

@export var MetalTileMap : TileMapLayer

signal selected_metal_location(Position : Vector2)
var staticMetalObject : PackedScene = load("res://Scenes/Objects/static_metal_object.tscn")

var lockedOn : bool = false
var closestPosition : Vector2

@export var metalObjectType : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for cell in MetalTileMap.get_used_cells():
		var metalForCell = staticMetalObject.instantiate()
		metalForCell.position = MetalTileMap.map_to_local(cell)
		add_child(metalForCell)

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
	var metalFound : bool = false
	
	for metal in get_tree().get_nodes_in_group("MetalObject"):
		var metalObjectPos = metal.get_parent().position
		if point.distance_to(metalObjectPos) <= distanceToClosestPosition:
			distanceToClosestPosition = point.distance_to(metalObjectPos)
			closestMetal = metalObjectPos
			metalFound = true
	if metalFound == false:
		pass
	return closestMetal
