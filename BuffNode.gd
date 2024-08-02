extends Node2D

const bone_equip = preload("res://bone_equip.tscn")

func _position_children():
	var child_orbs = get_children()
	var total_children = child_orbs.size()
	for index in total_children:
		var rotato = (360/float(total_children)) * index
		child_orbs[index].rotation_degrees = rotato

# Called when the node enters the scene tree for the first time.
func _ready():
	var bone = bone_equip.instantiate()
	add_child(bone)
	_position_children()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation += 1.5*delta


func _on_bone_equip(count:int):
	for i in count:
		var bone = bone_equip.instantiate()
		add_child(bone)
	_position_children()
	
func _remove_orbs(count:int):
	if count > get_child_count():
		count = get_child_count()
	var child_orbs = get_children()
	for i in count:
		var orb = child_orbs[i]
		remove_child(orb)
		orb.queue_free()
	_position_children()
