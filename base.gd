extends Node2D

@onready var score = 0
var escaped
@onready var skelington_scene = preload("skelington.tscn")
@onready var reaper_scene = preload("reaper.tscn")
@onready var player = get_node("Player")
@onready var spawntimer
@onready var endgame = 0

func _ready():
	#Input.mouse_mode = 4 #return for real testing
	$Enemy_timer.start()


func on_target_death():
	score += 1
	$HUD.update_score(score)
	if score >= 5 and endgame == 0:
		boss()
	
func on_target_undeath():
	await get_tree().create_timer(1.2).timeout
	score = "?̹͕̐??" 
	$HUD.update_score(score)
	await get_tree().create_timer(1.2).timeout
	score = "0̼͑͛͘0̰̪̞͛͗ͯ1̤̬͞ͅ1̀11̸̡̤͓̘ͩ͘1͇̆̆1̮ͭ̃͞"
	$HUD.update_score(score)
	await get_tree().create_timer(1.2).timeout
	score = "Er̠͍̆̏r͌̋o͉_̸͈ͤ̄̌r"
	$HUD.update_score(score)
	await get_tree().create_timer(1.2).timeout
	score = "A p͖ͩ_̃͆̄͞řͤô̭̩b̰_l͋ͨe̷̲̾m͈̖̮̓̀͑ h͙̓a̘̞̯͠_s͔ͨ o̘ͅcͣͪ͌̊c̠͗͂u̱̅ͮͮr̥̮̔ͦͥͫr̢̙̂͟e̴̻̙̖d̺ͦͭ̎́͜"
	$HUD.update_score(score)
	await get_tree().create_timer(1.2).timeout
	score = ""
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
	var x = randi_range(rect.position.x+264.5, rect.position.x+rect.size.x+264.5)
	var y = randi_range(rect.position.y+173.5, rect.position.y+rect.size.y+145.5)
	var rand_point = global_position + Vector2(x,y) 
	var skelington = skelington_scene.instantiate()
	get_parent().add_child(skelington)
	skelington.position = rand_point
	$Enemy_timer.wait_time -= 0.1
	$Enemy_timer.start()
	
func boss():
	endgame = 1
	$Enemy_timer.stop()
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		if is_instance_valid(enemies):
			enemy.death()
		await get_tree().create_timer(1.2).timeout
	var rect : Rect2 = $NavigationRegion2D/NavRegionArea/CollisionShape2D.shape.get_rect()
	var x = randi_range(rect.position.x+264.5, rect.position.x+rect.size.x+264.5)
	var y = randi_range(rect.position.y+173.5, rect.position.y+rect.size.y+145.5)
	var rand_point = global_position + Vector2(x,y) 
	var reaper = reaper_scene.instantiate() 
	get_parent().add_child(reaper) 
	reaper.position = rand_point 
	
