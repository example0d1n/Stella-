extends CharacterBody2D
@export var bounce_strength := 500.0
@onready var spring_sound: AudioStreamPlayer = $SpringSound


func _on_bounce_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	var direction := Vector2.UP.rotated(global_rotation)
	var to_player := body.global_position - global_position
	# Only trigger when the player hits the front of the spring
	if to_player.dot(direction) > 0 and body.velocity.dot(direction) <= 0:
		spring_sound.play()
		body.launch(direction * bounce_strength)
