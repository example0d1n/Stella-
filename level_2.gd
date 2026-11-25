extends Node

#This should spawn the character in the same place of the
# Marker2D otherwise known as "SpawnPoint" ^_^

const PLAYER_SCENE := preload("res://character.tscn")

func _ready() -> void:
	print("level script running")
	var player := PLAYER_SCENE.instantiate()
	add_child(player)
	player.global_position = $SpawnPoint.global_position
	print("player spawned at ", player.global_position)
