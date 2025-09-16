extends CharacterBody2D


var SPEED = 300.0
var JUMP_VELOCITY = -400.0
@export var player : Node2D
var direction : Vector2




func _physics_process(_delta: float) -> void:

	if player == null and Global.Player != null:
		player = Global.Player

	#direction is the direction towards player
	if global_position.distance_to(player.global_position) < 15 :
		direction = global_position.direction_to(player.global_position)
	if direction: #if direction is not null move towards player
		velocity = direction * SPEED
	else: #if player isnt detected stand still
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		

	move_and_slide()
