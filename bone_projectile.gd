extends CharacterBody2D
var bone_velocity = Vector2(0,0)
var speed = 300

func _ready():
	add_to_group("weapon")

func _physics_process(delta):
	rotation_degrees += speed * delta
	var collision_info = move_and_collide(bone_velocity.normalized() * delta * speed)
	if collision_info:
		queue_free()

#DON'T FORGET COLLISION LAYER/MASK
