extends CharacterBody2D


var speed = 600000
var JUMP_VELOCITY = -400.0
@export var player : Node2D
var direction : Vector2
var can_move : bool 
var stop_dist = 25
var stop_speed = 300


func _physics_process(delta: float) -> void:

	if player == null and Global.Player != null:
		player = Global.Player
		print("found player")

	#direction is the direction towards player
	direction = global_position.direction_to(player.global_position)
	if direction and can_move: #if direction is not null move towards player unless its too close
		velocity += velocity.move_toward(direction, speed)
		print("moving towards ", direction)
	else: #if player isnt detected stand still
		velocity = velocity.move_toward(Vector2.ZERO, stop_speed * delta)
		
	if global_position.distance_to(player.global_position) < stop_dist:
		can_move = false
	else:
		can_move = true
	move_and_slide()
	


func _on_damage_area_body_entered(_body: Node2D) -> void:
	if player.has_method("take_damage"):
		player.take_damage(1)
