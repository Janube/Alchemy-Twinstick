extends CharacterBody2D
<<<<<<< Updated upstream
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
=======
@onready var buffnode = get_node("/root/Base/Player/BuffNode")
>>>>>>> Stashed changes

func _ready():
	add_to_group("mergeable")
	await get_tree().create_timer(15.0).timeout
	despawn()

func equip():
	buff = 1
	set_collision_mask_value(10,1)
	remove_from_group("mergeable")

func despawn():
<<<<<<< Updated upstream
	queue_free()
#Can be fused three times. 
=======
	queue_free() 


>>>>>>> Stashed changes
