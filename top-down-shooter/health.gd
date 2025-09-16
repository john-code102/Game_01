extends Node2D

var health = 100


func change_health(damage):
	health -= damage
	
	if health <= 0:
		get_tree().change_scene_to_file("res://menu.tscn")
