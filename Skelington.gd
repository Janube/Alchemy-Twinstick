extends CharacterBody2D
@onready var root = get_node("/root/Base")
@onready var enemyspeed = randf_range(60,100)
@onready var navigation_agent = $NavigationAgent2D
@onready var playerlocation = get_node("/root/Base/Player")
@onready var loot = preload("bone_pickup.tscn")
@onready var move = 0
@onready var scalesize
<<<<<<< Updated upstream
=======
@onready var damage = 1
var max_hp = 400
var current_hp
>>>>>>> Stashed changes

func _ready():
	scalesize = randf_range(0.9,1.1)
	self.scale.x = scalesize
	self.scale.y = scalesize
	$Sprite2D/AnimationPlayer.play("Spawn")
	await $Sprite2D/AnimationPlayer.animation_finished
	movement()
<<<<<<< Updated upstream
=======
	can_attack = 1
>>>>>>> Stashed changes
	add_to_group("enemy")

func _physics_process(delta):
	if move == 1:
		navigation_agent.target_position = playerlocation.global_position
		velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * enemyspeed
		if velocity.x <= 0:
			$Sprite2D.scale.x = -1 * scalesize

		else:
			$Sprite2D.scale.x = 1 * scalesize
	if position.distance_squared_to(navigation_agent.target_position) <= 550:
		attack()
	move_and_slide()
	
func attack():
	move = 0
	velocity = Vector2.ZERO
	$Sprite2D/AnimationPlayer.play("Attack")
	await $Sprite2D/AnimationPlayer.animation_finished
	movement()
	
	
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
<<<<<<< Updated upstream
=======

func OnHit(damage):
	$Impact.pitch_scale = randf_range(.95,1.05)
	$Impact.play()
	current_hp -= damage
	if current_hp <= 0:
		death()




func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		body.OnHit(damage)
>>>>>>> Stashed changes
