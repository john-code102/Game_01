extends CharacterBody2D

@export_category("stats")
@export var acceleration: float = 100.0
@export var max_speed: float = 300.0
@export var drag: float = 100.0
@export var rotation_speed: float = 5.0

var current_force = 0

var body_rotation = 0
var speed =0 

func _ready() -> void:
	Global.Player = self

func _process(delta: float) -> void:
	if Global.controller:
		controller(delta)
	else:
		computer(delta)
	

func controller(delta):

	var aim_vector = Input.get_vector("c_down", "c_up","c_left", "c_right",)
	if aim_vector.length() > 0:
		var target_angle = aim_vector.angle()
		rotation = lerp_angle(rotation, target_angle , rotation_speed * delta)


	if Input.is_action_pressed("thrust"):
		velocity += Vector2.UP.rotated(rotation) * acceleration * delta
		%thrust_effect.emitting = true
	else:
		pass
		
		%thrust_effect.emitting = false
	
	velocity = velocity.move_toward(Vector2.ZERO, drag * delta)
	
	if Input.is_action_pressed("break"):
		%thrust_effect.emitting = false
		velocity = velocity.move_toward(Vector2.ZERO, 5 *drag * delta)
	
	
	

	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
	
	current_force = velocity.length()

	move_and_slide()

func take_damage(damage):
	%health_manager.change_health(damage)


func computer(delta):
	pass
