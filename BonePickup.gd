extends CharacterBody2D
@onready var buffnode = get_node("/root/Base/Player/BuffNode")

func _ready():
	add_to_group("mergeable")
	await get_tree().create_timer(15.0).timeout
	despawn()

func equip():
	buffnode._on_bone_equip(1)
	queue_free()

func despawn():
	queue_free() 


