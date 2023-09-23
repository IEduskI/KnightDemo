extends CharacterBody2D

const moveSpeed = 60
const maxSpeed = 90
const jumpHeight = -300
const slide = 150
const up = Vector2(0,-1)
const gravity = 15
var isSlide = false

@onready var sprite = $Sprite2D
@onready var animationPlayer=$AnimationPlayer
var motion = Vector2()

func _physics_process(_delta):
	velocity.y += gravity
	var friction = false
	
	if is_on_floor():
		if Input.is_action_pressed("ui_right") && !isSlide:
			sprite.flip_h= false
			animationPlayer.play("Walk")
			velocity.x = min(velocity.x+moveSpeed,maxSpeed)
		elif Input.is_action_pressed("ui_left") && !isSlide:
			sprite.flip_h= true
			animationPlayer.play("Walk")
			velocity.x = max(velocity.x-moveSpeed,-maxSpeed)
		elif !isSlide:
			animationPlayer.play("Idle")
			friction=true
			
		if Input.is_action_pressed("ui_accept"):
			animationPlayer.play("Jump")
			velocity.y = jumpHeight
		if friction == true:
			velocity.x = lerp(0,0, 0)
			
		if Input.is_action_just_pressed("ui_slide") && sprite.flip_h == true:
			isSlide = true
			animationPlayer.play("Slide")
		elif Input.is_action_just_pressed("ui_slide") && sprite.flip_h == false:
			isSlide = true
			animationPlayer.play("Slide")
	else:
		if friction == true:
			velocity.x = lerp(0,0,1)
	motion = move_and_slide()

func SlideMov(vel):
	if sprite.flip_h == true:
		velocity.x = -150
	elif sprite.flip_h == false:
		velocity.x = 150
	await get_tree().create_timer(.46).timeout
	
	isSlide = false
