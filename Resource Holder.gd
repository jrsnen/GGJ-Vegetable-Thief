extends Node2D

export var max_resources = 5
export var win_when_full : bool = false
export var vegetable_sprites : PackedScene

var current_resources = 0

signal win

func _ready():
    for n in range(1, max_resources + 1):
        var sprite : AnimatedSprite = vegetable_sprites.instance()
        sprite.position.y = -32*n
        add_child(sprite)

func give_resource(var index : String):
    if current_resources == max_resources:
        return false
    
    current_resources += 1
    
    get_child(current_resources - 1).animation = index
    
    if win_when_full and current_resources == max_resources:
        emit_signal("win")
    
    return true

func transfer_contents(var holder : Node2D):
    var resource_amount = holder.get_current_resource()
    for n in resource_amount:
        give_resource(holder.take_resource())
        

func take_resource():
    var animation_type = "Empty"
    if current_resources > 0:
        animation_type = get_child(current_resources - 1).animation
        get_child(current_resources - 1).animation = "Empty"
        current_resources -= 1
    return animation_type

func get_current_resource():
    return current_resources
