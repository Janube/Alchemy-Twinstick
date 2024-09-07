extends Area2D
@onready var victims
@onready var root = get_tree()
@onready var cheat

func _ready():
	separation()
	cheat = true
	
func _physics_process(_delta):
	if cheat == true:
		victims = get_overlapping_bodies()
		for victim in victims:
			if victim.is_in_group("enemy"):
				victim.alchemydeath()
		await root.physics_frame
		await root.physics_frame
		cheat = false

func separation():
	$AlchemyHitbox/Separate/AnimationPlayer.play("Separation2")
	


	await $AlchemyHitbox/Separate/AnimationPlayer.animation_finished
	await root.physics_frame
	await root.physics_frame
	self.queue_free()
