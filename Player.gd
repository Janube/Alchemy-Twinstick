extends CharacterBody2D
signal hit
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
#const separationscene = preload("res://separate.tscn")
var sound_effect


func _ready():
	animation_tree.set_active(true)
	update_animation_parameters(starting_direction)
	

	
func _physics_process(_delta):
	var input_direction = Vector2(
	Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
	Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	#var magic_input = (Input.get_action_strength("separate") - Input.get_action_strength("merge"))
	
	update_animation_parameters(input_direction)
	#update_animation_parameters(magic_input)
	velocity = input_direction * move_speed
	move_and_slide()

func update_animation_parameters(move_input : Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/idle/blend_position", move_input)
		animation_tree.set("parameters/walk/blend_position", move_input)
		animation_tree.set("parameters/idle_separate/blend_position", move_input)
		animation_tree.set("parameters/walk_separate/blend_position", move_input)
		animation_tree.set("parameters/idle_merge/blend_position", move_input)
		animation_tree.set("parameters/walk_merge/blend_position", move_input)
	pick_new_state()

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
	if (velocity != Vector2.ZERO) and magic_input == 0:
		state_machine.travel("walk")
	#elif (velocity == Vector2.ZERO) and magic_input == 1:
		#state_machine.travel("idle_separate")
	#elif (velocity == Vector2.ZERO) and magic_input == -1:
		#state_machine.travel("idle_merge")
	elif (velocity == Vector2.ZERO) and magic_input == 0:
		state_machine.travel("idle")



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
	separate_instance.position = get_global_mouse_position()
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
	merge_instance.position = get_global_mouse_position()
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

func _on_hitbox_body_entered(body):
	if body.is_in_group("enemy"):
		hit.emit()

	
#Make alchemyarea tie to global mouse position only when var == 1 and have that var go to 0 during func casts
#slow player speed while alchemy
 
