extends Node2D

func _process(delta):
    if Input.is_action_just_pressed("ui_exit"):
        get_tree().change_scene("res://Main Menu.tscn")


func _on_Show_Timer_timeout():
    get_tree().change_scene("res://Main Menu.tscn")
