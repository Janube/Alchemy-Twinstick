extends CharacterBody2D
@onready var player = get_node("/root/Base/Player")
@onready var buffnode = get_node("/root/Base/Player/BuffNode")
@onready var bone_projectile_scene = preload("res://bone_projectile.tscn")
@onready var buff = 0
@onready var speed = 500
@onready var angle = 0
@onready var enemies
@onready var enemy
@onready var closest_node
@onready var closest_enemy


func _ready():
	add_to_group("mergeable")

func equip():
	buffnode._on_bone_equip(1)
	queue_free()

func despawn():
	queue_free() 

#func _on_reload_timeout():
	#ahoy()
