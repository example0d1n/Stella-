extends Node

#This should spawn the character in the same place of the
# Marker2D otherwise known as "SpawnPoint" ^_^
const PLAYER_SCENE := preload("res://character.tscn")

func _ready() -> void:
	var player := PLAYER_SCENE.instantiate()
	add_child(player)
	player.global_position = $SpawnPoint.global_position


# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
