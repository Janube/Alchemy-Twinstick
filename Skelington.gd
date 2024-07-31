extends CharacterBody2D
@onready var root = get_tree().get_current_scene()
@onready var enemyspeed = randf_range(60,100)
@onready var navigation_agent = $NavigationAgent2D
@onready var playerlocation = get_node("/root/Base/Player")
@onready var loot = preload("bone_pickup.tscn")
@onready var move = 0
@onready var scalesize

func _ready():
	scalesize = randf_range(0.9,1.1)
	self.scale.x = scalesize
	self.scale.y = scalesize
	$Sprite2D/AnimationPlayer.play("Spawn")
	await $Sprite2D/AnimationPlayer.animation_finished
	movement()
	add_to_group("enemy")

func _physics_process(delta):
	if move == 1:
		navigation_agent.target_position = playerlocation.global_position
		velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * enemyspeed
		if velocity.x <= 0:
			$Sprite2D.scale.x = -1 * scalesize

		else:
			$Sprite2D.scale.x = 1 * scalesize
	move_and_slide()
	
func movement():
	$Sprite2D/AnimationPlayer.play("Walk")
	move = 1
	

func alchemydeath():
	enemyspeed = 0
	$Sprite2D/AnimationPlayer.play("Break")
	var lootdrop = loot.instantiate()
	get_parent().add_child(lootdrop)
	lootdrop.position = global_position
	$Explode.play()
	await $Sprite2D/AnimationPlayer.animation_finished
	root.on_target_death()
	queue_free()

func death():
	enemyspeed = 0
	$Sprite2D/AnimationPlayer.play("Break")
	$Explode.play()
	await $Sprite2D/AnimationPlayer.animation_finished
	root.on_target_death()
	queue_free()

func _on_hitbox_body_entered(body):
	#if body.is_in_group("weapon"): - NEEDS FIXED - BODY IS DETECTED, BUT IT'S NOT REGISTERING AS WEAPON
	death()
