extends KinematicBody2D



onready var _animated_sprite = $AnimatedSprite
func _process(_delta):
	if Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left") :
		_animated_sprite.play("Run")
	else:
		_animated_sprite.play("Idle")


export (int) var speed = 500
var velocity = Vector2()
export var fallMultiplier = 2 
export var lowJumpMultiplier = 10 
export var jumpVelocity = 400 #Jump height
export var gravity = 8

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		self.scale.x = self.scale.y * 1
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		self.scale.x = self.scale.y * -1
		velocity.x -= 1
	

	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	velocity.y += gravity 

	#Jump Physics
	if velocity.y > 0: #Player is falling
		velocity += Vector2.UP * (-9.81) * (fallMultiplier) #Falling action is faster than jumping action | Like in mario

	elif velocity.y < 0 && Input.is_action_just_released("ui_up"): #Player is jumping 
		velocity += Vector2.UP * (-9.81) * (lowJumpMultiplier) #Jump Height depends on how long you will hold key

	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"): 
			velocity = Vector2.UP * jumpVelocity #Normal Jump action
	velocity = move_and_slide(velocity, Vector2(0,-1))  
	




 
	
