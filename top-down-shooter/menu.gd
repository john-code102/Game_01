extends Control


func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")


func _on_controller_pressed() -> void:
	Global.controller = %controller.button_pressed
