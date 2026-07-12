extends Node

@export var InitialState : State

var currentState : State
var states : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transitioned)
	if InitialState:
		InitialState.Enter()
		currentState = InitialState

func _process(delta: float) -> void:
	if currentState:
		currentState.Update(delta)

func _physics_process(delta: float) -> void:
	if currentState:
		currentState.Physics_Update(delta)


func on_child_transitioned(state, newStateName):
	print_debug(state,newStateName)
	if state != currentState:
		return
	
	var newState = states.get(newStateName.to_lower())
	if !newState:
		return
	
	if currentState:
		currentState.Exit()
	newState.Enter()
	
	currentState = newState
