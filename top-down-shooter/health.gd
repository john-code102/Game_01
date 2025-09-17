extends Node2D

var health = 100


func change_health(damage):
	health -= damage
	Global.health = health
	if health <= 0:
		get_tree().change_scene_to_file("res://menu.tscn")


func _on_area_2d_body_entered(body: Node2D) -> void:
	var parent = get_parent()
	if body.is_breakable:
		var collided_strength = body.strength
		if parent.current_force >= body.strenght:
			body.queue_free()
		else:
			change_health(parent.current_force / 2)
	else:
		change_health(parent.current_force / 2)
