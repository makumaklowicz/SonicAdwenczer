extends KinematicBody2D

#Jump setup
export var fall_gravity_scale := 150.0
export var low_jump_gravity_scale := 1000.0
export var jump_power := 1500.0
var jump_released = false

#Physics setup
var velocity = Vector2()
var earth_gravity = 9.807 # m/s^2
export var gravity_scale := 400.0
var on_floor = false

#Movement speed setup
export (int) var movement_speed = 700

#Reference to animation node
onready var _animated_sprite = $AnimatedSprite

#Using animations
func _process(_delta):
	if Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left") :
		_animated_sprite.play("Run")
	else:
		_animated_sprite.play("Idle")


#Left/Right Movement
func get_input():
	velocity.x = 0;
	if Input.is_action_pressed("ui_right"):
		self.scale.x = self.scale.y * 1
		velocity.x += 1

	if Input.is_action_pressed("ui_left"):
		self.scale.x = self.scale.y * -1
		velocity.x -= 1

	velocity.x = velocity.x * movement_speed

#Physics and jumping
func _physics_process(delta):
	get_input()
	if Input.is_action_just_released("ui_accept"):
		jump_released = true

	#Applying gravity to player
	velocity += Vector2.DOWN * earth_gravity * gravity_scale * delta

	#Jump Physics
	if velocity.y > 0: 
		velocity += Vector2.DOWN * earth_gravity * fall_gravity_scale * delta 

	elif velocity.y < 0 && jump_released: 
		velocity += Vector2.DOWN * earth_gravity * low_jump_gravity_scale * delta

	if on_floor:
		if Input.is_action_just_pressed("ui_accept"): 
			velocity = Vector2.UP * jump_power 
			jump_released = false

	velocity = move_and_slide(velocity, Vector2(0,-1)) 
	
	if is_on_floor(): on_floor = true
	else: on_floor = false
