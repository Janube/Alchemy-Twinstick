extends Node2D

@onready var score = 0
@onready var skelington_scene = preload("skelington.tscn")
<<<<<<< Updated upstream
@onready var skelfunc = get_node("/root/skelington")
=======
>>>>>>> Stashed changes
@onready var player = get_node("Player")
<<<<<<< Updated upstream
#@onready var ENEMY2_scene = load("ENEMY2.tscn")
@onready var spawntimer

func _ready():
	
	$Enemy_timer.start()

func on_target_death():
	score += 1
	$HUD.update_score(score)

func _on_enemy_timer_timeout():
	var skelington = skelington_scene.instantiate()
	get_parent().add_child(skelington)
	skelington.position = player.global_position + Vector2.RIGHT.rotated(randi_range(0,360))*100
	$Enemy_timer.wait_time *= 0.98
	$Enemy_timer.start()
=======
@onready var endgame = 0

func _ready():
	Input.mouse_mode = 4
	$BGM_Open/AnimationPlayer.play("Open Soft")
	cinematic()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func cinematic():
	$HUD.hide()
	$Player.playercinematic()

func on_target_death():
	score += 1
	$HUD.update_score(score)
	if score >= 25 and endgame == 0:
		boss()
	
func on_target_boss_death():
	score = 1
	$HUD.update_score(score)
	Dialogic.start("Epilogue")

	
func on_target_undeath():
	await get_tree().create_timer(1.2).timeout
	score = "?̹͕̐??" 
	$HUD.update_score(score)
	await get_tree().create_timer(1.2).timeout
	score = ""
	$HUD.update_score(score)
	await get_tree().create_timer(1.2).timeout
	score = "?̹͕̐??"
	$HUD.update_score(score)
	await get_tree().create_timer(1.2).timeout
	score = ""
	$HUD.update_score(score)
	await get_tree().create_timer(1.2).timeout
	score = "?̹͕̐??"
	$HUD.update_score(score)
	await get_tree().create_timer(1.2).timeout
	score = ""
	$HUD.update_score(score)
	await get_tree().create_timer(1.2).timeout
	score = "UH OH"
	$HUD.update_score(score)
	
#func _on_enemy_timer_timeout(): ORIGINAL MOB SPAWN LANGUAGE
	#var skelington = skelington_scene.instantiate()
	#get_parent().add_child(skelington)
	#skelington.position = player.global_position + Vector2.RIGHT.rotated(randi_range(0,360))*100
	#$Enemy_timer.wait_time *= 0.98
	#$Enemy_timer.start()

func _on_enemy_timer_timeout():
	var rect : Rect2 = $NavigationRegion2D/NavRegionArea/CollisionShape2D.shape.get_rect()
	var x = randf_range(rect.position.x+264, rect.position.x+rect.size.x+264)
	var y = randf_range(rect.position.y+190, rect.position.y+rect.size.y+145)
	var rand_point = global_position + Vector2(x,y) 
	var skelington = skelington_scene.instantiate()
	get_parent().add_child(skelington)
	skelington.position = rand_point
	if $Enemy_timer.wait_time != 0:
		$Enemy_timer.wait_time -= 0.08
	$Enemy_timer.start()
	
func boss():
	endgame = 1
	$Enemy_timer.stop()
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		if is_instance_valid(enemy):
			print(is_instance_valid(enemy))
			enemy.death()
	await get_tree().create_timer(1.2).timeout
	var reaper = reaper_scene.instantiate() 
	get_parent().add_child(reaper) 
	reaper.position = Vector2(275,175) #rand_point 
	#player.playable = 2
	#Dialogic.start("Player Boss")
	
>>>>>>> Stashed changes
