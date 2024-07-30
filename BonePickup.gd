extends CharacterBody2D
@onready var player = get_node("/root/Base/Player")
@onready var buff = 0
@onready var speed = 100
@onready var angle = 0

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

func despawn():
	queue_free()
#Can be fused three times. 
