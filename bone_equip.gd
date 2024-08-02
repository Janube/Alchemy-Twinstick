extends CharacterBody2D
@onready var player = get_node("/root/Base/Player")
@onready var buffnode = get_node("/root/Base/BuffNode")
@onready var root = get_tree()
@onready var bone_projectile_scene = preload("res://bone_projectile.tscn")
@onready var speed = 500
@onready var angle = 0
@onready var enemies
@onready var enemy
@onready var closest_node
@onready var closest_enemy

func _ready():
	await root.physics_frame
	$Bone_Reload.start()
	
	
func _process(delta):
	#pass
	rotation_degrees += speed * delta
	#global_position = buffnode.global_position + Vector2.RIGHT.rotated(angle)*17
	#angle += 0.01
	

func ahoy():
	enemies = get_tree().get_nodes_in_group("enemy")
	var dis = 30000
	var temp_dis
	for n in enemies:
		temp_dis = player.position.distance_squared_to(n.position)
		if temp_dis < dis:
			dis = temp_dis
			closest_enemy = n
	if is_instance_valid(closest_enemy):
		var bone = bone_projectile_scene.instantiate()
		get_parent().add_child(bone)
		bone.global_position = global_position + Vector2($BoneSprite.offset).rotated((get_parent().rotation+rotation))
		bone.bone_velocity = closest_enemy.global_position - bone.global_position
		bone.rotation = (closest_enemy.global_position - bone.global_position).angle()
		$Bone_Reload.start()
		
		

func _on_bone_reload_timeout():
	ahoy()
