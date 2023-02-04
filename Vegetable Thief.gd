extends Node2D

export var next_level : PackedScene



# Called when the node enters the scene tree for the first time.
func _ready():
    pass
    
func _process(delta):
    if Input.is_action_just_pressed("ui_exit"):
        get_tree().change_scene("res://Main Menu.tscn")
        
    
    var time_left = int(round($"Game time".time_left))
    var time_left_string = String(time_left)
    
    if time_left < 10:
        time_left_string = time_left_string
    
    $Timeout_label.text = "Time left until caught " + time_left_string + " s"


func _on_Game_time_timeout():
    get_tree().change_scene("res://Failure Screen.tscn")
