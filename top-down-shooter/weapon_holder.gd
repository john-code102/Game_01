extends Node2D 

var target_angle_global := 0.0
var smooth_angle_global := 0.0
@export var aim_smoothness: float = 10.0 

var gun_scene
var gun_set = false

var gun
var gun_cooldown = 0 

var grapple_point: Vector2
var is_grappling: bool = false

@export var grapple_length: float = 300.0



func _process(delta: float) -> void:
	
	gun_scene = Global.gun
	
	if Global.controller:
		aim_controler(delta)
	else:
		aim_computer(delta)
	
	if Input.is_action_pressed("grapple") and !is_grappling:
		try_grapple()
	elif Input.is_action_just_released("grapple"):
		release_grapple()
	
	if gun_scene != null and gun_set:
		gun_code(delta)
	elif gun_scene != null and !gun_set:
		gun_set = true
		gun = gun_scene.instantiate()
		add_child(gun)
		
	
	if is_grappling:
		%grapple_line.set_point_position(0, position)
		%grapple_line.set_point_position(1, self.to_local(grapple_point))
		%grapple_line.rotation = %weapon_holder.rotation
		%grapple_line.visible = true
	else:
		%grapple_line.visible = false
	
	

func aim_computer(delta):
	var temp = get_parent().get_angle_to(get_global_mouse_position())
	var holder = rad_to_deg(temp) + 90
	target_angle_global = deg_to_rad(holder)
	smooth_angle_global = lerp_angle(smooth_angle_global, target_angle_global, delta * aim_smoothness)
	var parent = get_parent()
	rotation = smooth_angle_global

func aim_controler(delta):
	var aim_vector = Input.get_vector("cr_down", "cr_up", "cr_left", "cr_right")
	if aim_vector.length() > 0:

		target_angle_global = aim_vector.angle()


	smooth_angle_global = lerp_angle(smooth_angle_global, target_angle_global, delta * aim_smoothness)


	var parent = get_parent()
	rotation = smooth_angle_global - parent.global_rotation

func gun_code(delta):
	if gun_cooldown > 0:
		gun_cooldown -= delta
	
	if Input.is_action_pressed("shoot") and gun_cooldown <= 0:
		gun_cooldown = gun.cooldown
		gun.shot()

	

func _physics_process(delta):
	if is_grappling:
		apply_grapple_force(delta)

var rope_length: float = 0.0  
func try_grapple():
	var parent = get_parent()
	var ray_from = parent.global_position
	var ray_to = ray_from + Vector2.UP.rotated(global_rotation) * grapple_length

	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(ray_from, ray_to)
	query.exclude = [parent]
	query.collision_mask = 1 << 2
	var result = space_state.intersect_ray(query)

	if result:
		grapple_point = result.position
		rope_length = grapple_point.distance_to(parent.global_position) 
		is_grappling = true

func release_grapple():
	is_grappling = false

func apply_grapple_force(delta):
	var parent = get_parent()
	var to_point = grapple_point - parent.global_position
	var distance = to_point.length()
	if distance < 10.0:
		release_grapple()
		return

	var dir = to_point.normalized()
	var tangent = Vector2(-dir.y, dir.x)


	var tangential_velocity = tangent * parent.velocity.dot(tangent)


	if distance > rope_length:
		var correction = (distance - rope_length) * dir * 15.0 * delta
		parent.velocity += correction


	var radial_velocity = parent.velocity.dot(dir) * dir


	parent.velocity = tangential_velocity + radial_velocity


	var target_angle = tangent.angle()
	parent.rotation = lerp_angle(parent.rotation, target_angle, 5.0 * delta)
