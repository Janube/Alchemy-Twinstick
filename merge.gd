extends Area2D
@onready var equips = 0
@onready var reagents
@onready var root = get_tree()
@onready var equip_check = get_node("/root/Base/Player")
@onready var cheat

func _ready():
	merge()
	cheat = true
	
func _physics_process(delta):
	if cheat == true:
		var reagents = get_overlapping_bodies()
		for reagent in reagents:
			if reagent.is_in_group("mergeable") and equip_check.equips <= 3:
				reagent.equip()
				equip_check.equips += 1
			elif reagent.is_in_group("mergeable") and equip_check.equips >= 3:
				reagent.despawn()
		await root.physics_frame
		await root.physics_frame
		cheat = false
	
func merge():
	$AlchemyHitbox/Merge/AnimationPlayer.play("Merge2")
	var reagents = get_overlapping_bodies()
	for reagent in reagents:
		if reagent.is_in_group("mergeable") and equips <= 3:
			reagent.equip()
			equips += 1
		elif reagent.is_in_group("mergeable") and equips >= 3:
			reagent.despawn()
	await $AlchemyHitbox/Merge/AnimationPlayer.animation_finished
	self.queue_free()
