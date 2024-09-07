extends Control
var game_load = preload("res://game_level.tscn")
var credits_load = preload("res://Credits/GodotCredits.tscn")

func _ready():
	var style2: DialogicStyle = load("res://addons/dialogic/test-project/Style2.tres")
	style2.prepare()
	var style3: DialogicStyle = load("res://addons/dialogic/test-project/Style 2 BUT BIG.tres")
	style3.prepare()
	Dialogic.preload_timeline("res://addons/dialogic/test-project/Timelines/Player.dtl")
	Dialogic.preload_timeline("res://addons/dialogic/test-project/Timelines/Player Death.dtl")
	Dialogic.preload_timeline("res://addons/dialogic/test-project/Timelines/Epilogue.dtl")
	Dialogic.preload_timeline("res://addons/dialogic/test-project/Timelines/Preload.dtl")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if is_instance_valid("/root/Base"):
		var old_game_load = get_node("/root/Base")
		if is_instance_valid(old_game_load):
			old_game_load.queue_free()


func _on_button_pressed():
	$Start.hide()
	$"Anti-Start".hide()
	var game = game_load.instantiate()
	get_tree().root.add_child(game)
	$ColorRect/AnimationPlayer.play("Transition")
	await $ColorRect/AnimationPlayer.animation_finished
	queue_free()

func _on_anti_start_pressed():
	get_tree().quit()
