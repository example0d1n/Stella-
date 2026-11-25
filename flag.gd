extends CharacterBody2D
#Only checks for coin.tcsn so the player wont be flagged as a coin ^_^
@export_file("*.tscn") var next_level: String

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	var coins_left := get_tree().get_nodes_in_group("Coin").size()
	if coins_left > 0:
		body.show_message("Collect all the coins first! (%d left)" % coins_left)
		return
	get_tree().change_scene_to_file.call_deferred(next_level)

func coins_remaining() -> int:
	var count := 0
	for c in get_tree().get_nodes_in_group("Coin"):
		if c is Area2D and not c.get_parent().is_queued_for_deletion():
			count += 1
	return count
