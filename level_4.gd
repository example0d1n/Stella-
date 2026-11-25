extends Node
const PLAYER_SCENE := preload("res://character.tscn")

func _ready() -> void:
	var player := PLAYER_SCENE.instantiate()
	add_child(player)
	player.global_position = $SpawnPoint.global_position
