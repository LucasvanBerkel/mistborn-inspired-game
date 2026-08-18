extends State
class_name FlyingHostile

@export var enemy : Enemy
@export var LOSRay : RayCast2D
@export var Speed : float = 10
@export var HoverSpeed : float = 4
@export var directionChangeChancePerSec : float = 0.5
@export var DistanceTillIdleState : float = 500
@export var HoverDistance : float = 150

@export var TimeTillIdle : float = 5

var idleTimer = TimeTillIdle
var hoverMovementDirection = 1

var player : PlayerCharacter

func _ready() -> void:
	player = enemy.GetPlayer()

func Update(delta : float):
	if enemy:
		if LOSRay.HasLineOfSight(player):
			idleTimer = TimeTillIdle
		else:
			idleTimer -= delta
			if idleTimer < 0:
				Transitioned.emit(self, "FlyingIdle")

func Physics_Update(delta : float):
	if enemy:
		#hover enemy around player
		if enemy.position.distance_to(player.position) > HoverDistance:
			enemy.velocity += enemy.position.direction_to(player.position) * Speed
		else:
			enemy.velocity -= enemy.position.direction_to(player.position) * Speed
		
		if randf() < directionChangeChancePerSec * delta:
			hoverMovementDirection *= -1
		
		#add some randomization to the movement
		enemy.velocity.x += HoverSpeed * enemy.position.direction_to(player.position).rotated(90).x * hoverMovementDirection
		enemy.velocity.y += HoverSpeed * enemy.position.direction_to(player.position).rotated(90).y * hoverMovementDirection
