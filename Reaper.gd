extends CharacterBody2D
@onready var root = get_node("/root/Base")
@onready var enemyspeed = 0
@onready var navigation_agent = $NavigationAgent2D
@onready var Healthbar = $CanvasLayer/Control/Healthbar
@onready var scalesize = 0.01
@onready var playerlocation = get_node("/root/Base/Player")
@onready var fight_is_on = 1
@onready var move = 0
@onready var attack_damage = 1
@onready var can_attack = 0
var max_hp = 2000
var current_hp
var healthbar_anim

func _ready():
	$CanvasLayer.hide()
	current_hp = max_hp
	$Sprite2D/AnimationPlayer.play("spawn")
	await $Sprite2D/AnimationPlayer.animation_finished
	movement()
	add_to_group("enemy")
	Healthbar.value = 0

func _physics_process(_delta):
	if move == 1:
		navigation_agent.target_position = playerlocation.global_position
		velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * enemyspeed * fight_is_on
		if velocity.x <= 0:
			$Sprite2D.scale.x = -1
		else:
			$Sprite2D.scale.x = 1
	if fight_is_on == 3:
		if position.distance_squared_to(navigation_agent.target_position) <= 1200:
			attack()
	move_and_slide()

func _process(_delta):
	if healthbar_anim == 1 and Healthbar.value <2000:
		Healthbar.value += 2
	if healthbar_anim == 1 and Healthbar.value >= 2000:
		healthbar_anim = 0
	
	
func attack():
	if can_attack == 1:
		move = 0
		velocity = Vector2.ZERO
		$Sprite2D/AnimationPlayer.play("attack")
		await $Sprite2D/AnimationPlayer.animation_finished
		movement()
	
	
func movement():
	$Sprite2D/AnimationPlayer.play("walk")
	move = 1
	enemyspeed = 40
	

func alchemydeath():
	if fight_is_on == 1:
		root.on_target_death()
		enemyspeed = 0
		$FakeDeath.play()
		$CollisionShape2D.set_deferred("disabled", true)
		$Laugh.play()
		$Sprite2D/AnimationPlayer.play("fakedeath")
		await get_tree().create_timer(1.0).timeout
		root.on_target_undeath()
		await get_tree().create_timer(2.0).timeout
		$CanvasLayer.show()
		healthbar_anim = 1
		await $Sprite2D/AnimationPlayer.animation_finished
		grow()
		await get_tree().create_timer(6.0).timeout
		$CollisionShape2D.set_deferred("disabled", false)
		fight_is_on = 3
		enemyspeed = 40
		movement()
		set_collision_mask_value(1,0)
		can_attack = 1

func grow():
	if scale.x <= 1.4:
		self.scale.x += scalesize
		self.scale.y += scalesize
		await get_tree().create_timer(0.1).timeout
		grow()

func death():
	enemyspeed = 0
	can_attack = 0
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D/AnimationPlayer.play("death")
	await $Sprite2D/AnimationPlayer.animation_finished
	root.on_target_boss_death()
	queue_free()

func OnHit(damage):
	if fight_is_on == 3:
		$Impact.pitch_scale = randf_range(.95,1.05)
		$Impact.play()
		current_hp -= damage
		Healthbar.value = current_hp
	elif fight_is_on != 3:
		$Immune.pitch_scale = randf_range(.95,1.05)
		$Immune.play()
	if current_hp <= 0:
		death()

func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		body.OnHit(attack_damage)
