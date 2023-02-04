extends Node2D

export var level1 : PackedScene

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass


func _on_Start_button_up():
    get_tree().change_scene(level1.resource_path)


func _on_Exit_button_up():
    print("Exit button pressed")
    get_tree().quit()


func _on_Credits_button_up():
    get_tree().change_scene("res://Credits.tscn")
