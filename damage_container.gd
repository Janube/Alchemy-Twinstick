extends RigidBody2D
@onready var fade = false

func _process(_delta):
	if fade == true:
		freeze = true
		modulate.a -= 0.02
	if modulate.a == 0:
		queue_free()

func pop(damage):
	$Damage.text = str(damage)
	await get_tree().create_timer(0.3).timeout
	fade = true
