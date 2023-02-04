extends KinematicBody2D


var speed : int = 300
var acceleration : int = 40
var jump_strength : int = 425
var small_jump : int = 180
var gravity : int = 20
var friction : int = 20

var velocity : Vector2 = Vector2.ZERO

var level_x_min = 16
var level_x_max = 624

export var vegetable_tiles : NodePath

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _physics_process(delta):
    
    if (Input.is_action_just_pressed("grab")):
        pick_vegetable()
    
    velocity.y += gravity
    
    var input : Vector2 = Vector2.ZERO
    
    input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
    input.y = -0
    if is_on_floor():
        if Input.is_action_just_pressed("ui_up") or Input.is_action_pressed("ui_up"):
            velocity.y = -jump_strength
    else:
        if Input.is_action_just_released("ui_up") and velocity.y < -small_jump:
            velocity.y = -small_jump
    
    if input.x == 0:
        velocity.x = move_toward(velocity.x, 0, friction)
    else:
        velocity.x = move_toward(velocity.x, speed*input.x, acceleration)
    
    velocity = move_and_slide(velocity, Vector2.UP)
    print(get_node(vegetable_tiles).get_cellv(position))
    get_node(vegetable_tiles).set_cellv(position, 0)
    if position.x < level_x_min:
        position.x = level_x_min
    elif position.x > level_x_max:
        position.x = level_x_max
        
func pick_vegetable():
    print("Pick vegetable")
    if vegetable_tiles != null \
    and get_node(vegetable_tiles).get_cellv(convert_to_tilemap(position)) != TileMap.INVALID_CELL:
        get_node(vegetable_tiles).set_cellv(position, TileMap.INVALID_CELL)


func convert_to_tilemap(var real_position : Vector2):
    return (real_position + Vector2(16,16))/32
