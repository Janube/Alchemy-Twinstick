extends Control
var game_load = preload("res://game_level.tscn")
var credits_load = preload("res://Credits/GodotCredits.tscn")
@onready var old_game_load = get_node("/root/Base")

func _ready():
	Input.mouse_mode = 0
	if is_instance_valid(old_game_load):
		old_game_load.queue_free()

func _on_button_pressed():
	$Start.hide()
	$"Anti-Start".hide()
	var game = game_load.instantiate()
	get_tree().root.add_child(game)
	$ColorRect/AnimationPlayer.play("Transition")
	await $ColorRect/AnimationPlayer.animation_finished
	free()

func _on_anti_start_pressed():
	get_tree().quit()
