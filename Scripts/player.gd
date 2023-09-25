extends CharacterBody2D

const moveSpeed = 60
const maxSpeed = 90
const jumpHeight = -300
const slide = 150
const up = Vector2(0,-1)
const gravity = 15

# flags
var blockActions = false
var continueAttack = false

@onready var sprite = $Sprite2D
@onready var animationPlayer=$AnimationPlayer
@onready var collisionShape = $Area2D/CollisionPolygon2D

var motion = Vector2()

func _physics_process(_delta):
	velocity.y += gravity
	var friction = false
	
	if is_on_floor():
		if Input.is_action_pressed("ui_right") && !blockActions:
			sprite.flip_h= false
			collisionShape.scale.x *= -1
			animationPlayer.play("Walk")
			velocity.x = min(velocity.x+moveSpeed,maxSpeed)
		elif Input.is_action_pressed("ui_left") && !blockActions:
			sprite.flip_h= true
			collisionShape.scale.x *= -1
			animationPlayer.play("Walk")
			velocity.x = max(velocity.x-moveSpeed,-maxSpeed)
		elif !blockActions:
			animationPlayer.play("Idle")
			friction=true
		
		if Input.is_action_just_pressed("ui_attack") && !blockActions:
			velocity.x = 0
			blockActions = true
			_attactk1()
			
		if Input.is_action_pressed("ui_accept"):
			animationPlayer.play("Jump")
			velocity.y = jumpHeight
		if friction == true:
			velocity.x = lerp(0,0, 0)
			
		if Input.is_action_just_pressed("ui_slide") && sprite.flip_h == true:
			blockActions = true
			animationPlayer.play("Slide")
		elif Input.is_action_just_pressed("ui_slide") && sprite.flip_h == false:
			blockActions = true
			animationPlayer.play("Slide")
	else:
		if friction == true:
			velocity.x = lerp(0,0,1)
	motion = move_and_slide()

func SlideMov():
	if sprite.flip_h == true:
		velocity.x = -150
	elif sprite.flip_h == false:
		velocity.x = 150
	await get_tree().create_timer(.46).timeout
	blockActions = false


func _attactk1():
	animationPlayer.play("Attack1")
	await get_tree().create_timer(.47).timeout
	if Input.is_action_pressed("ui_attack") && continueAttack:
		await _attactk2()
	continueAttack = false
	blockActions = false
	
func _attactk2():
	animationPlayer.play("Attack2")
	await get_tree().create_timer(.45).timeout
	if Input.is_action_pressed("ui_attack") && continueAttack:
		await _attactk3()
	continueAttack = false

func _attactk3():
	animationPlayer.play("Attack3")
	await get_tree().create_timer(.55).timeout
	continueAttack = false
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("Enemy"):
		print("enemy detected")
		continueAttack = true
