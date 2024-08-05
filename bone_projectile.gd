extends CharacterBody2D
var bone_velocity = Vector2(0,0)
@onready var root = get_tree().get_current_scene()
var enemies
var speed = 300
var damage = 50

func _ready():
	add_to_group("weapon")
	#enemies = get_tree().get_nodes_in_group("enemy")

func _physics_process(delta):
	rotation_degrees += speed * delta
	var _collision_info = move_and_collide(bone_velocity.normalized() * delta * speed)

func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		body.OnHit(damage)
		queue_free()
	elif body.is_in_group("wall"):
		queue_free()
