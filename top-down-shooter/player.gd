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

	var play_squid
	if Input.is_action_pressed("thrust"):
		velocity += Vector2.UP.rotated(rotation) * acceleration * delta
		%thrust_effect.emitting = true
		play_squid = true
	else:
		play_squid = false
		%thrust_effect.emitting = false
	
	velocity = velocity.move_toward(Vector2.ZERO, drag * delta)
	
	if Input.is_action_pressed("break"):
		%thrust_effect.emitting = false
		velocity = velocity.move_toward(Vector2.ZERO, 5 *drag * delta)
	
	
	

	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
	
	current_force = velocity.length()

	if play_squid:
		var temp_speed = current_force / 50
		if temp_speed > 1:
			temp_speed = 1
		%squid_art.speed_scale = temp_speed
		%squid_art.play()
	else:
		%squid_art.stop()
		%squid_art.frame = 0
	
	
	move_and_slide()

func take_damage(damage):
	%health_manager.change_health(damage)


func computer(delta):
	
	var roation_dir = Input.get_axis("rotate_left", "rotate_right")
	
	
	rotation += roation_dir * rotation_speed * delta
	
	
	var play_squid
	if Input.is_action_pressed("thrust"):
		velocity += Vector2.UP.rotated(rotation) * acceleration * delta
		%thrust_effect.emitting = true
		play_squid = true
	else:
		play_squid = false
		%thrust_effect.emitting = false
	
	velocity = velocity.move_toward(Vector2.ZERO, drag * delta)
	
	if Input.is_action_pressed("break"):
		%thrust_effect.emitting = false
		velocity = velocity.move_toward(Vector2.ZERO, 5 *drag * delta)
	
	
	

	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
	
	current_force = velocity.length()
	
	if play_squid:
		var temp_speed = current_force / 50
		if temp_speed > 1:
			temp_speed = 1
		%squid_art.speed_scale = temp_speed
		%squid_art.play()
	else:
		%squid_art.stop()
		%squid_art.frame = 0
	
	
	move_and_slide()
