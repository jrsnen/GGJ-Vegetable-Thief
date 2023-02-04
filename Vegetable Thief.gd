extends Node2D

export var level_number = 1

var max_level = 5

# Called when the node enters the scene tree for the first time.
func _ready():
    print("Starting level " + str(level_number))
    
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


func _on_win():
    if level_number == max_level:
        print("All levels completed!")
        get_tree().change_scene("res://Credits.tscn")
    else:
        print("Starting next level " + str(level_number + 1))
        get_tree().change_scene("res://L" + str(level_number + 1) + ".tscn")
