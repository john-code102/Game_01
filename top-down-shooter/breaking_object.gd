extends StaticBody2D

@export var strength : float

func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body.name)
	if body.name == "player":
		if strength > body.current_force:
			body.take_damage(strength - body.current_force) 
			strength -= body.current_force
		else:
			queue_free()
