extends CharacterBody2D
@onready var player = get_node("/root/Base/Player")
@onready var base = get_node("/root/Base")
@onready var root = get_tree()
@onready var bone_projectile_scene = preload("res://bone_projectile.tscn")
@onready var speed = 500
@onready var angle = 0
@onready var enemies
@onready var closest_enemy
@onready var playable = 1
@onready var auto_fire

func _ready():
	await root.physics_frame
	$Bone_Reload.start()
	Dialogic.signal_event.connect(_on_dialogic_signal)
	
		 
func _process(delta): 
	$BoneSprite.rotation += delta * 10
	auto_fire = player.toggle_fire
	
func ahoy():
	if playable == 1:
		enemies = get_tree().get_nodes_in_group("enemy")
		var dis = 30000
		var temp_dis
		for n in enemies:
			temp_dis = player.position.distance_squared_to(n.position)
			if temp_dis < dis:
				dis = temp_dis
				closest_enemy = n
		if is_instance_valid(closest_enemy) and auto_fire == 1:
			var bone = bone_projectile_scene.instantiate()
			base.add_child(bone)
			bone.global_position = global_position
			bone.bone_velocity = closest_enemy.global_position - bone.global_position
			bone.rotation = (closest_enemy.global_position - bone.global_position).angle()
			$Bone_Reload.start()
			
			

func _on_bone_reload_timeout():
	ahoy()
	

func _on_dialogic_signal(argument:String):
	if argument == "boss":
		playable = 1
	if argument == "boss off":
		playable = 2
