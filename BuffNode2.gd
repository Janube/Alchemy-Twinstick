extends Node2D

#@onready var player = get_node("/root/Base/Player")
@onready var bone_equip_scene = preload("res://bone_equip.tscn")
@onready var root = get_tree()
@onready var bone_projectile_scene = preload("res://bone_projectile.tscn")
@onready var buff = 0
#@onready var speed = 100
@onready var angle = 0
@onready var enemies
@onready var enemy
@onready var closest_node
@onready var closest_enemy
var child_orbs

#func _process(delta):

func _ready():
	pass
	
	
func _process(delta):
				# get all the children of the orb parent - these are all the orbs
	child_orbs = get_children()
	# go through all the index values of the children
	for index in child_orbs.size():
	#      change the rotation        ( circle/total children ) * child index
		#child_orbs[index].position = player.position + Vector2.RIGHT.rotated(5)
		child_orbs[index].rotation_degrees = (360/child_orbs.size()) * index
	#rotation_degrees += speed * delta
	

#func _on_bone_equip():
	#bone.instantiate()
	#bone.position = global_position + Vector2.RIGHT.rotated(0)*17

#func _on_bone_equip():
	#var bone = bone_equip_scene.instantiate()
	#get_parent().add_child(bone)
	#bone.position = global_position + Vector2.RIGHT.rotated(0)*17
	#reorganize()
	

func despawn():
	queue_free() 
