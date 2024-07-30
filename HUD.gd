extends CanvasLayer
#signal start_game
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout
	
func update_score(score):
	$Score.text = str(score)
	
func update_health(escaped):
	$Escaped.text = str(escaped)
	
#func _on_start_pressed():
	#$Start.hide()
	#start_game.emit()
	
func _on_message_timer_timeout():
	$Message.hide()
