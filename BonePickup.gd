extends CharacterBody2D
@onready var player = get_node("/root/Base/Player")
@onready var bone_projectile_scene = preload("res://bone_projectile.tscn")
@onready var buff = 0
@onready var speed = 100
@onready var angle = 0
@onready var enemies
@onready var enemy
@onready var closest_node
@onready var closest_enemy

func _process(delta):
	if buff == 1:
		rotation_degrees += speed * delta
		global_position = player.global_position + Vector2.RIGHT.rotated(angle)*17
		angle += 0.01
		
		#velocity = (global_position - player.global_position).normalized().rotated(PI/2) * speed

func _ready():
	add_to_group("mergeable")

func equip():
	buff = 1
	set_collision_mask_value(10,1)
	remove_from_group("mergeable")
	$Reload.start()
	
	
func ahoy():
	enemies = get_tree().get_nodes_in_group("enemy")
	var dis = 30000
	var temp_dis
	var closest_enemy
	for n in enemies:
		temp_dis = player.position.distance_squared_to(n.position)
		if temp_dis < dis:
			dis = temp_dis
			closest_enemy = n
	if closest_enemy.is_in_group("enemy"):
		var bone = bone_projectile_scene.instantiate()
		get_parent().add_child(bone)
		bone.position = $BoneSprite.global_position
		bone.bone_velocity = closest_enemy.global_position - bone.position
		bone.rotation = (closest_enemy.global_position - bone.position).angle()
		$Reload.start()


func despawn():
	queue_free() 

func _on_reload_timeout():
	ahoy()
