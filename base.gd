extends Node2D

@onready var score = 0
var escaped
@onready var skelington_scene = preload("skelington.tscn")
@onready var skelfunc = get_node("/root/skelington")
@onready var player = get_node("Player")
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
