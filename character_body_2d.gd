extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -300.0
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var coin_sound: AudioStreamPlayer = $CoinSound
@onready var jump_sound: AudioStreamPlayer = $JumpSound
@onready var hurt_sound: AudioStreamPlayer = $HurtSound

var coins_left := 0
var message_id := 0
@onready var coins_left_label: Label = $CanvasLayer/CoinsLeftLabel
@onready var message_label: Label = $CanvasLayer/Message
var health := 3
var score := 0

#minimizes delay between when player touches the spring and launches ^_^
var launch_timer := 0.0

func launch(new_velocity: Vector2, lock_time := 0.25) -> void:
	velocity = new_velocity
	# Only lock horizontal control for springs that push sideways
	launch_timer = lock_time if abs(new_velocity.x) > 1.0 else 0.0

@onready var score_label: Label = $CanvasLayer/ScoreLabel
#on screen coin label connecting to when a player collects a coin
func _ready() -> void:
	score_label.text = "Coins: 0"
	coins_left = get_tree().get_nodes_in_group("Coin").size()
	update_coins_left()

func update_coins_left() -> void:
	coins_left_label.text = "Coins left: %d" % coins_left

func show_message(text: String, seconds := 2.0) -> void:
	message_id += 1
	var my_id := message_id
	message_label.text = text
	message_label.visible = true
	await get_tree().create_timer(seconds).timeout
	if my_id == message_id:  # don't hide a newer message early
		message_label.visible = false



func _physics_process(delta: float) -> void:
	#Animations
	if abs(velocity.x) > 1:
		sprite_2d.play("walk")
	else:
		sprite_2d.play("default")
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_sound.play()
		velocity.y = JUMP_VELOCITY

	
	#movement direction & spring launch physics
	launch_timer -= delta
	var direction := Input.get_axis("left", "right")
	if launch_timer > 0:
		pass  # keep launch momentum
	elif direction:
		velocity.x = direction * SPEED
		sprite_2d.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

#Flips character left or right depending on movement direction ^_^
	var isLeft = velocity.x > 0
	sprite_2d.flip_h = isLeft

#Coin collecting function and sound *cha ching* ^_^
func _on_pickup_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Coin"):
		area.get_parent().queue_free()
		coin_sound.play()
		score += 1
		score_label.text = "Coins: %d" % score
		coins_left -= 1
		update_coins_left()
		
		
#Player damage
var invincible := false

func take_damage(amount: int) -> void:
	if invincible:
		return
	hurt_sound.play()
	health -= amount
	invincible = true
	sprite_2d.modulate = Color(1, 0.4, 0.4)  # flash red
	if health <= 0:
		get_tree().reload_current_scene.call_deferred()
		return
	velocity.y = -200
	await get_tree().create_timer(1.0).timeout
	sprite_2d.modulate = Color.WHITE
	invincible = false
		
		
		
