extends CharacterBody2D
@onready var player = get_node("/root/Base/Player")
@onready var buffnode = get_node("/root/Base/Player/BuffNode")
@onready var base = get_node("/root/Base")
@onready var root = get_tree()
@onready var bone_projectile_scene = preload("res://bone_projectile.tscn")
@onready var speed = 500
@onready var angle = 0
@onready var enemies
@onready var closest_enemy

func _ready():
	await root.physics_frame
	$Bone_Reload.start()
		 
func _process(delta): 
	$BoneSprite.rotation += delta * 10
	#global_position = get_parent().global_position # For using a Node2D instead of Bone offset
	#$BoneSprite.rotation += delta * 10 # For using a Node2D instead of Bone offset
	
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
		base.add_child(bone)
		bone.global_position = global_position + Vector2($BoneSprite.offset).rotated((get_parent().rotation+rotation)) #Old language for Character Body having offset instead of Node2D
		#bone.global_position = global_position # Language for Node2D having offset instead of Characterbody2D
		bone.bone_velocity = closest_enemy.global_position - bone.global_position
		bone.rotation = (closest_enemy.global_position - bone.global_position).angle()
		$Bone_Reload.start()
		#NEXT - Start by retrying the Node2D idea again. We're still shooting from body somehow
		

func _on_bone_reload_timeout():
	ahoy()
