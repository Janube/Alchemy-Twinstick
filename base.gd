extends Node2D

@onready var score = 0
@onready var skelington_scene = preload("skelington.tscn")
@onready var reaper_scene = preload("reaper.tscn")
@onready var player = get_node("Player")
@onready var endgame = 0
@export var debug = false

func _ready():
	if debug == false:
		Dialogic.preload_timeline("res://addons/dialogic/test-project/Timelines/Player.dtl")
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
		$BGM_Open/AnimationPlayer.play("Open Soft")
		cinematic()
	else:
		$Player.global_position = Vector2(350,150)
		$Player.playable = 1
		%Enemy_timer.start()
		%BGM_Open.stop()
		%BGM_Boss.play()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func cinematic():
	%HUD.hide()
	%HUD/Autofire.self_modulate.a = 0.2
	$Player.playercinematic()

func on_target_death():
	score += 1
	$HUD.update_score(score)
	if score >= 25 and endgame == 0:
		boss()
	
func on_target_boss_death():
	$Player.playable = 2
	$Player.set_process_input(false)
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
	
func _on_enemy_timer_timeout(): 
	var rect : Rect2 = $NavigationRegion2D/NavRegionArea/CollisionShape2D.shape.get_rect()
	var x = randf_range(rect.position.x+264, rect.position.x+rect.size.x+264)
	var y = randf_range(rect.position.y+200, rect.position.y+rect.size.y+145)
	var rand_point = global_position + Vector2(x,y) 
	var skelington = skelington_scene.instantiate()
	get_parent().add_child(skelington)
	skelington.position = rand_point #player.global_position + Vector2.RIGHT.rotated(randi_range(0,360))*100
	$Enemy_timer.wait_time *= 0.98
	$Enemy_timer.start()

#func _on_enemy_timer_timeout():
	#spawn()
	#if $Enemy_timer.wait_time > 0.1:
	#	$Enemy_timer.wait_time -= 0.08
	#$Enemy_timer.start()
	
#func spawn(p_position: Vector2) -> void:
	#var skelington = skelington_scene.instantiate()
	#get_parent().add_child(skelington)
	#skelington.position = p_position
	
#func is_good_position(p_position: Vector2) -> bool:
	#var space_state := get_world_2d().direct_space_state
	#var params := PhysicsPointQueryParameters2D.new()
	#params.position = p_position
	#p_position.x > rect.position.x
	#p_position.x < rect.position.x+rect.size.x
	#p_position.y > rect.position.y
	#p_position.y < rect.position.y+rect.size.y
	#params.collision_mask = 1 # Obstacle layer has value 1
	#var collision := space_state.intersect_point(params)
	#return collision.is_empty()
	
func boss():
	endgame = 1
	$Enemy_timer.stop()
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.death()
	await get_tree().create_timer(1.2).timeout
	var reaper = reaper_scene.instantiate() 
	get_parent().add_child(reaper) 
	reaper.position = Vector2(275,175) #rand_point 
	#player.playable = 2
	#Dialogic.start("Player Boss")
	
