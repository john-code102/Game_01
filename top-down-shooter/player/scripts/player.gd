extends CharacterBody2D

#Hello liam, ive added some extra export categorys as opposed to string name references for
#easier use proggraming(js type in player and youll have a list of all the important
#children, add any as you need) Ive also changed sm variable names that werent clear. I've 
#avoided changing much of your logic and js foocused on commenting blocks and readability.
#Ive also made the health manager you are using for the player reusable on any body we want
#to use it on. Feel free to remove these comments after youve seen them and change or revert
#any of this. This is js ideas. anything you wanna ask about or want me to do tell me. I was 
#considering you could make the weapon holder more verbose and make it use and weapons within
#a directory. Sorry for this long blurb but those are the changes etc within the player atm.



@export_category("stats")
@export var acceleration: float = 100.0
@export var max_speed: float = 300.0
@export var drag: float = 100.0
@export var rotation_speed: float = 5.0

@export_category("children")
@export var playerSprite : AnimatedSprite2D
@export var particleHolder : GPUParticles2D
@export var playerWeapons : Node2D
@export var playerAbilities : Node2D
@export var playerHealth : Node2D

var current_force = 0

var body_rotation = 0
var speed =0 

var inputThrust : bool

func _ready() -> void:
	Global.Player = self #Reference to self

func _process(delta: float) -> void:
	if Global.controller: controller(delta) #Define input method
	else: computer(delta)
	

func controller(delta):
	
	#Get target angle
	var aim_vector = Input.get_vector("c_down", "c_up","c_left", "c_right",)
	if aim_vector.length() > 0:
		var target_angle = aim_vector.angle()
		rotation = lerp_angle(rotation, target_angle , rotation_speed * delta)
	
	#Movement logic
	if Input.is_action_pressed("thrust"): 
		velocity += Vector2.UP.rotated(rotation) * acceleration * delta
		particleHolder.emitting = true
		inputThrust = true
	else:
		inputThrust = false
		particleHolder.emitting = false
	velocity = velocity.move_toward(Vector2.ZERO, drag * delta)
	
	#Break logic
	if Input.is_action_pressed("break"):
		particleHolder.emitting = false
		velocity = velocity.move_toward(Vector2.ZERO, 5 *drag * delta)
	
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
	
	current_force = velocity.length()

	if inputThrust: #Animations
		var aniSpeed = current_force / 50
		if aniSpeed > 1:
			aniSpeed = 1
		playerSprite.speed_scale = aniSpeed
		playerSprite.play()
	else:
		playerSprite.stop()
		playerSprite.frame = 0
	
	
	move_and_slide()

func take_damage(damage):
	playerHealth.change_health(damage)


func computer(delta):
	pass
