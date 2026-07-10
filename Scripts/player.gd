extends CharacterBody2D

@export var magnetism_Manager : MagnetismManager
@export var SPEED : float = 320.0
@export var SPEED_INCREASE : float = 60.0
@export var JUMP_VELOCITY : float = 500.0
@export_range(0, 1) var AIR_FRICTION : float = 0.972
@export_range(0, 1) var GROUND_FRICTION : float = 0.87

@export_category("Push")
@export var PUSH_STRENGTH : float = 28
@export var PUSH_DEGRATION : float = 3
@export var PUSH_MAX_SPEED: float = 10000
@export_range(0,1) var PUSH_GRAVITY_PERCENTAGE: float = 0.6

@export_category("Pull")
@export var PULL_STRENGTH : float = 38
@export var PULL_DEGRATION : float = 1.3
@export var PULL_MAX_SPEED: float = 10000
@export_range(0,3.14) var PULL_MOMENTUM_ROTATION : float = 1.12


var loonyTime : bool = false
var loonyTimer

var selectedMetalNode : Node
var selectedMetalPos : Vector2
var metalPropertyNode : MetalComponent

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	
	#calculate friction
	if is_on_floor():
		velocity.x *= GROUND_FRICTION
	
	velocity *= AIR_FRICTION
	
	#handle loony time(ability to jump when just leaving a platform)
	if is_on_floor():
		loonyTime = true
	else:
		loonyTimer = get_node("LoonyTime")
		if loonyTime == true and loonyTimer.time_left == 0:
			loonyTimer.start()
	
	if Input.is_action_pressed("jump") and loonyTime == true: #jump handler
		velocity.y -= JUMP_VELOCITY
		loonyTime = false
	
	if Input.is_action_pressed("move_right"): #move right action handler
		if velocity.x <= SPEED - SPEED_INCREASE*delta:
			velocity.x += SPEED_INCREASE*delta
		elif velocity.x <= SPEED:
			velocity.x = SPEED
	
	if Input.is_action_pressed("move_left"): #move left action handler
		if velocity.x >= -SPEED + SPEED_INCREASE*delta:
			velocity.x -= SPEED_INCREASE*delta
		elif velocity.x >= SPEED:
			velocity.x = -SPEED
	
	var PushorPull : int = 0
	

	if Input.is_action_pressed("Push"): #push action handler
		PushorPull = 1
	
	if Input.is_action_pressed("Pull"): #pull action handler
		if PushorPull == 0:
			PushorPull = -1
		else:
			PushorPull = 0
	
	if PushorPull != 0: #checking if the player is pushing or pulling before doing the math for it
		var magnetismForce : Vector2 = position - selectedMetalPos #getting the normalized direction vector
		magnetismForce = magnetismForce.normalized()
		
		var angleToMetal = velocity.angle_to(magnetismForce) #get angle between velocity and metal object
		
		if PushorPull == 1: #pushing
			if velocity.length() < PUSH_MAX_SPEED:
				var speedPercentage = abs(velocity.length()/PUSH_MAX_SPEED)
				var forceDegration = 10*speedPercentage
				forceDegration = forceDegration**PUSH_DEGRATION
				forceDegration = 2**-forceDegration
				
				var angleDegration = abs(angleToMetal/PI)
				
				var angleDegrationToAdd = 1 - forceDegration
				angleDegrationToAdd *= angleDegration
				forceDegration += angleDegrationToAdd
				
				velocity += magnetismForce * PUSH_STRENGTH * forceDegration * delta
				
		elif PushorPull == -1: #pulling
			if angleToMetal < -0.8 and angleToMetal > -2.2:
				velocity = velocity.rotated(PULL_MOMENTUM_ROTATION * delta)
			elif angleToMetal > 0.8 and angleToMetal < 2.2:
				velocity = velocity.rotated(-PULL_MOMENTUM_ROTATION * delta)
			
			if velocity.length() < PULL_MAX_SPEED:
				
				var speedPercentage = abs(velocity.length()/PULL_MAX_SPEED)
				var forceDegration = 10*speedPercentage
				forceDegration = forceDegration**PULL_DEGRATION
				forceDegration = 2**-forceDegration
				
				var angleDegration = abs(angleToMetal/PI)
				angleDegration = 1-angleDegration
				
				var angleDegrationToAdd = 1 - forceDegration
				angleDegrationToAdd *= angleDegration
				forceDegration += angleDegrationToAdd
				
				velocity -= magnetismForce * PULL_STRENGTH * forceDegration * delta
	
	# Add the gravity.(or reduced gravity when "pushing")
	if not is_on_floor():
		if is_instance_valid(metalPropertyNode) && metalPropertyNode.IsAtackable == true && PushorPull != 0:
			pass
		elif PushorPull == 1:
			velocity += get_gravity() * PUSH_GRAVITY_PERCENTAGE * delta
		else:
			velocity += get_gravity() * delta
	
	move_and_slide()


func _on_loony_time_timeout() -> void: #handles what happens when the loony time timer runs out
	loonyTime = false

func _on_magnetism_manager_selected_metal_location(selectedNode : Node, metalComponent : MetalComponent) -> void: #signal that gives location of closest metal to mouse
	selectedMetalNode = selectedNode
	selectedMetalPos = selectedNode.position
	metalPropertyNode = metalComponent
