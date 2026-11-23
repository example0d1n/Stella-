extends CharacterBody2D
@export var bounce_strength := -500.0
@onready var spring_sound: AudioStreamPlayer = $SpringSound


func _on_bounce_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and body.velocity.y >= 0 and body.global_position.y < global_position.y:
		spring_sound.play()
		body.velocity.y = bounce_strength
