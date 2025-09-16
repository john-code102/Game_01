extends Node

var controller = false

var Player

var gun : PackedScene


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("return home"):
		get_tree().change_scene_to_file("res://menu.tscn")
