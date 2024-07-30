extends CharacterBody2D

@export var move_speed : float = 100
@export var starting_direction : Vector2 = Vector2(0, 1)
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var lootspawn = preload("res://bone_pickup.tscn")
var separate_scene = preload("res://separation.tscn")
var merge_scene = preload("res://merge.tscn")
@onready var can_alchemy = 1
@onready var charge = 0
@onready var equips = 0
@onready var magic_input
@onready var mana = get_node("/root/Base/HUD/Mana")
var sound_effect

var dead_zone = 0.2  #Dead zone adjustment so the player doesn't automatically move if center isn't exactly 0,0

func _ready():
	animation_tree.set_active(true)
	update_animation_parameters(starting_direction)

func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

	# Handle controller input
	var joystick_input = Vector2(
		Input.get_joy_axis(0, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
	)

	# Apply dead zone
	if abs(joystick_input.x) < dead_zone:
		joystick_input.x = 0
	if abs(joystick_input.y) < dead_zone:
		joystick_input.y = 0

	input_direction += joystick_input

	update_animation_parameters(input_direction)
	velocity = input_direction.normalized() * move_speed
	move_and_slide()

func update_animation_parameters(move_input : Vector2):
	if move_input != Vector2.ZERO:
		animation_tree.set("parameters/idle/blend_position", move_input)
		animation_tree.set("parameters/walk/blend_position", move_input)
		animation_tree.set("parameters/idle_separate/blend_position", move_input)
		animation_tree.set("parameters/walk_separate/blend_position", move_input)
		animation_tree.set("parameters/idle_merge/blend_position", move_input)
		animation_tree.set("parameters/walk_merge/blend_position", move_input)
	pick_new_state()

func pick_new_state():
	if velocity != Vector2.ZERO:
		state_machine.travel("walk")
	else:
		state_machine.travel("idle")

func _process(_delta):
	update_reticle_position()

	if can_alchemy == 1:
		mana.frame = 0
	else:
		mana.frame = 1

	if Input.is_action_just_pressed("separate") and can_alchemy == 1:
		$Alchemy_windup.start()
		$Reticle/AnimationPlayer.play("Separation1")
		$Reticle.self_modulate.a = 1

	if Input.is_action_just_released("separate"):
		$Alchemy_windup.stop()
		charge = 0
		if can_alchemy == 1:
			$Reticle/AnimationPlayer.stop()
			$Reticle.self_modulate.a = 0.5

	if Input.is_action_pressed("separate") and can_alchemy == 1 and charge == 1:
		separate()

	if Input.is_action_just_pressed("merge") and can_alchemy == 1:
		$Alchemy_windup.start()
		$Reticle/AnimationPlayer.play("Merge1")
		$Reticle.self_modulate.a = 1

	if Input.is_action_just_released("merge"):
		$Alchemy_windup.stop()
		charge = 0
		if can_alchemy == 1:
			$Reticle/AnimationPlayer.stop()
			$Reticle.self_modulate.a = 0.5

	if Input.is_action_pressed("merge") and can_alchemy == 1 and charge == 1:
		merge()

func update_reticle_position():
	var right_stick_input = Vector2(
		Input.get_joy_axis(0, JOY_AXIS_RIGHT_X),
		Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	)

	#Apply dead zone
	if abs(right_stick_input.x) < dead_zone:
		right_stick_input.x = 0
	if abs(right_stick_input.y) < dead_zone:
		right_stick_input.y = 0

	#Update reticle position based on right stick input
	if right_stick_input != Vector2.ZERO:
		$Reticle.position += right_stick_input * move_speed * get_process_delta_time()

func separate():
	var separate_instance = separate_scene.instantiate()
	separate_instance.position = $Reticle.global_position
	get_parent().add_child(separate_instance)
	can_alchemy = 0
	charge = 0

	$Separate.play()
	$Alchemy_timer.start()
	$Reticle.self_modulate.a = 0.5  #Alpha to help the reticle not disappear

func merge():
	var merge_instance = merge_scene.instantiate()
	merge_instance.position = $Reticle.global_position
	get_parent().add_child(merge_instance)
	can_alchemy = 0
	charge = 0

	$Merge.play()
	$Alchemy_timer.start()
	$Reticle.self_modulate.a = 0.5  #Alpha to help the reticle not disappear

func _on_alchemy_timer_timeout():
	can_alchemy = 1
	$Reticle.self_modulate.a = 0.5

func _on_alchemy_windup_timeout():
	charge = 1
