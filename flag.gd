extends CharacterBody2D




#When player enters, they will teleport to the next level ^_^
func _on_area_2d_area_entered(area: Area2D) -> void:
	get_tree().change_scene_to_file("res://level_2.tscn")
