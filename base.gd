extends Node2D

@onready var score = 0
var escaped
@onready var skelington_scene = preload("skelington.tscn")
@onready var player = get_node("Player")
@onready var spawntimer

func _ready():
	Input.mouse_mode = 4
	$Enemy_timer.start()

func on_target_death():
	score += 1
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
	$Enemy_timer.wait_time *= 0.98
	$Enemy_timer.start()
