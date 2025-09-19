extends Control


func _process(_delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	Global.gun = guns[current_gun]
	get_tree().change_scene_to_file("res://game.tscn")


func _on_controller_pressed() -> void:
	Global.controller = %controller.button_pressed


@export var guns : Array[PackedScene]

var current_gun = 0

func _on_button_pressed() -> void:
	if current_gun  + 1 < guns.size():
		current_gun += 1 
	else:
		current_gun = 0

	var path = guns[current_gun].get_path()
	%gun_name.text = path.right(-path.rfind("/") - 1).left(-5)
