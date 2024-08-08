extends CharacterBody2D
<<<<<<< Updated upstream
@export var move_speed : float = 100
=======
@export var move_speed : float = 120
>>>>>>> Stashed changes
@export var starting_direction : Vector2 = Vector2(0, 1)
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var lootspawn = preload("res://bone_pickup.tscn")
var separate_scene = preload("res://separation.tscn")
var merge_scene = preload("res://merge.tscn")
@onready var equips = 0
@onready var can_alchemy = 1
@onready var charge = 0
@onready var mana = get_node("/root/Base/HUD/Mana")
@onready var health = get_node("/root/Base/HUD/Health")
@onready var max_hp = 3
@onready var current_hp = max_hp
<<<<<<< Updated upstream

#const separationscene = preload("res://separate.tscn")
=======
@onready var playable = 0

var mouse_active

var dead_zone = 0.2  #Dead zone adjustment so the player doesn't automatically move if center isn't exactly 0,0
>>>>>>> Stashed changes
var sound_effect


func _ready():
	animation_tree.set_active(true)
	update_animation_parameters(starting_direction)
	current_hp = max_hp
<<<<<<< Updated upstream
=======
	Dialogic.signal_event.connect(_on_dialogic_signal)
	
func playercinematic():
	set_collision_mask_value(1,0)
	set_collision_mask_value(15,1)
	can_alchemy = 0
	$Reticle.self_modulate.a = 0
	set_process_input(false)
>>>>>>> Stashed changes

const DIRECTIONS = ["move_right", "move_left", "move_down", "move_up"]
func _physics_process(_delta):
	if playable == 1:
		var input_direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		)
		input_direction = input_direction.normalized()
		update_animation_parameters(input_direction)
		velocity = input_direction * move_speed
		move_and_slide()
		#magic_input = (Input.get_action_strength("separate") - Input.get_action_strength("merge"))
		#update_animation_parameters2(magic_input)
		
		# Handle controller input
		#var joystick_input = Vector2(
			#Input.get_joy_axis(0, JOY_AXIS_LEFT_X),
			#Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
		#)
		# Apply dead zone
		#if abs(joystick_input.x) < dead_zone:
			#joystick_input.x = 0
			
		#if abs(joystick_input.y) < dead_zone:
			#joystick_input.y = 0

<<<<<<< Updated upstream
=======
		#input_direction += Vector2(ceil(joystick_input.x), ceil(joystick_input.y))
		
	elif playable == 0:
		velocity = Vector2(0,-1) * 10
		$AnimationPlayer.speed_scale = 0.5
		state_machine.travel("walk")
		$AnimationPlayer.play("walk_up")
		update_animation_parameters(velocity)
		move_and_slide()
		

>>>>>>> Stashed changes
func update_animation_parameters(move_input : Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/idle/blend_position", move_input)
		animation_tree.set("parameters/walk/blend_position", move_input)
	pick_new_state()
	
#func update_animation_parameters2(magic_input : int):
	#animation_tree.set("parameters/idle/blend_position", magic_input)
	#animation_tree.set("parameters/walk/blend_position", magic_input)
	#animation_tree.set("parameters/idle_separate/blend_position", magic_input)
	#animation_tree.set("parameters/walk_separate/blend_position", magic_input)
	#animation_tree.set("parameters/idle_merge/blend_position", magic_input)
	#animation_tree.set("parameters/walk_merge/blend_position", magic_input)
	#pick_new_state()

func pick_new_state():
	if (velocity != Vector2.ZERO):
		state_machine.travel("walk")
	else:
		state_machine.travel("idle")

#func pick_new_state():
	#if (velocity != Vector2.ZERO) and magic_input == 1:
		#state_machine.travel("walk_separate")
	#elif (velocity != Vector2.ZERO) and magic_input == -1:
		#state_machine.travel("walk_merge")
	#elif (velocity != Vector2.ZERO) and magic_input == 0:
		#state_machine.travel("walk")
	#elif (velocity == Vector2.ZERO) and magic_input == 1:
		#state_machine.travel("idle_separate")
	#elif (velocity == Vector2.ZERO) and magic_input == -1:
		#state_machine.travel("idle_merge")
	#elif (velocity == Vector2.ZERO) and magic_input == 0:
		#state_machine.travel("idle")

<<<<<<< Updated upstream

=======
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
		mouse_active = false
		$Reticle.position += right_stick_input * move_speed * 2 * get_process_delta_time()
		$Reticle.position.x = clamp($Reticle.position.x, -160, 160)
		$Reticle.position.y = clamp($Reticle.position.y, -90, 90)
		
	if mouse_active == true:
		$Reticle.position = get_local_mouse_position()
		
func _input(event):
	if event is InputEventMouseMotion:
		mouse_active = true
>>>>>>> Stashed changes

func _process(_delta):
	if can_alchemy == 1:
		$Reticle.position = get_local_mouse_position()
		mana.frame = 0
	if can_alchemy == 0:
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

func separate():
	var separate_instance = separate_scene.instantiate()
	separate_instance.position = $Reticle.global_position
	get_parent().add_child(separate_instance)
	can_alchemy = 0
	charge = 0

	$Separate.play()
	$Alchemy_timer.start()
	#await $AlchemyArea/AlchemyHitbox/Separate/AnimationPlayer.animation_finished
	$Reticle.self_modulate.a = 0
	$Reticle/AnimationPlayer.play("idle")

func merge():
	var merge_instance = merge_scene.instantiate()
	merge_instance.position = $Reticle.global_position
	get_parent().add_child(merge_instance)
	can_alchemy = 0
	charge = 0
	#$Reticle/AnimationPlayer.play("Merge2")
	#var reagents = $AlchemyArea.get_overlapping_bodies()
	#for reagent in reagents:
		#if reagent.is_in_group("mergeable") and equips <= 3:
			#reagent.equip()
			#var loot = lootspawn.instantiate()
			#get_parent().add_child(loot)
			#loot.position = global_position + Vector2.RIGHT.rotated(randi_range(0,360))*3
			#position
			#equips += 1
	$Merge.play()
	$Alchemy_timer.start()
	$Reticle.self_modulate.a = 0
	$Reticle/AnimationPlayer.play("idle")


func _on_alchemy_timer_timeout():
	can_alchemy = 1
	$Reticle.self_modulate.a = 0.5

func _on_alchemy_windup_timeout():
	charge = 1

<<<<<<< Updated upstream
=======
		
func OnHit(damage):
	$Ow.pitch_scale = randf_range(.95,1.05)
	$Ow.play()
	current_hp -= damage
<<<<<<< Updated upstream
	health.frame += 1
=======
	if health.frame < 2:
		health.frame += 1
>>>>>>> Stashed changes
	if current_hp <= 0:
		death()
	
func death():
<<<<<<< Updated upstream
	print("Game Over")
>>>>>>> Stashed changes

=======
	$PlayerCollision.set_deferred("disabled", true)
	HUD_scene.hide()
	Dialogic.start("Player Death")
	$BuffNode._remove_orbs(4)
	%Enemy_timer.stop()
	var enemies = get_tree().get_nodes_in_group("enemy")
	for n in enemies:
		n.set_physics_process(false)
	playable = 2
>>>>>>> Stashed changes
	
	
	


func _on_nav_region_area_body_entered(body):
	if body.is_in_group("player") and playable == 0:
		await get_tree().create_timer(3.0).timeout
		speech1()
		Input.mouse_mode = 0
		await get_tree().create_timer(5.0).timeout
		playable = 2
		$AnimationPlayer.speed_scale = 1
		
		
func speech1():
	Dialogic.start("Player")
	
func _on_dialogic_signal(argument:String):
	if argument == "begin":
		playable = 1
		can_alchemy = 1
		$Reticle.self_modulate.a = 0.5
		set_process_input(true)
		set_collision_mask_value(1,1)
		set_collision_mask_value(15,0)
		HUD_scene.show()
		update_animation_parameters(starting_direction)
		get_parent()._on_enemy_timer_timeout()
		%BGM_Open.stop()
		%BGM_Boss.play()
		Input.mouse_mode = 4
		
	if argument == "boss":
		playable = 1
		
	if argument == "death":
		get_tree().change_scene_to_file("res://start.tscn")
		var enemies = get_tree().get_nodes_in_group("enemy")
		for n in enemies:
			n.queue_free()
		
	if argument == "credits":
		%DeathScreen.play("death")
		playable = 2
		await %DeathScreen.animation_finished
		get_tree().change_scene_to_file("res://Credits/GodotCredits.tscn")
		get_parent().free()
