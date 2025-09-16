extends Node2D

@export var shoot_points : Array[Node]

@export var cooldown : float

@export var bullet : PackedScene

@export var bullet_speed : float

func shot():
	if Global.Player != null:
		for i in shoot_points.size():
			var new_bullet = bullet.instantiate()
			Global.Player.add_sibling(new_bullet)
			new_bullet.global_rotation = shoot_points[i].global_rotation
			new_bullet.global_position = shoot_points[i].global_position
			new_bullet.velocity = Vector2.UP.rotated(new_bullet.global_rotation) * bullet_speed
