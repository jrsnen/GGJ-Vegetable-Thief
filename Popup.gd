extends Sprite





func _process(delta):
    position.y -= delta*50


func _on_Timer_timeout():
    queue_free()
