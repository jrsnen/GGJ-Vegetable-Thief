extends Node2D

export var vegetable_textures : Array
export var max_resources = 5
export var win_when_full : bool = false

var current_resources = 0

signal win

func _ready():
    for n in range(1, max_resources + 1):
        var sprite_child = Sprite.new()
        sprite_child.position.y = -32*n
        add_child(sprite_child)

func give_resource(var index : int):
    if current_resources == max_resources:
        return false
    
    current_resources += 1
    get_child(current_resources - 1).texture = vegetable_textures[index]
    
    if win_when_full and current_resources == max_resources:
        emit_signal("win")
    
    return true

func transfer_contents(var holder : Node2D):
    for n in  holder.get_current_resource():
        give_resource(0) # TODO: vegetable types
        
    holder.empty_this()

func empty_this():
    for n in range(0, current_resources):
        get_child(n).texture = null
    
    current_resources = 0

func get_current_resource():
    return current_resources
