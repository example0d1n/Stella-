extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -300.0
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var coin_sound: AudioStreamPlayer = $CoinSound
@onready var jump_sound: AudioStreamPlayer = $JumpSound
@onready var hurt_sound: AudioStreamPlayer = $HurtSound



var health := 3

var score := 0
@onready var score_label: Label = $CanvasLayer/ScoreLabel

func _ready() -> void:
	score_label.text = "Coins: 0"


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
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump_sound.play()
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


	var isLeft = velocity.x > 0
	sprite_2d.flip_h = isLeft

func _on_pickup_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Coin"):
		area.get_parent().queue_free()
		coin_sound.play()
		score += 1
		score_label.text = "Coins: %d" % score
		
		
		
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
		
		
		
