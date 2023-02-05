extends KinematicBody2D


var speed : int = 300
var acceleration : int = 40
var jump_strength : int = 425
var small_jump : int = 180
var gravity : int = 20
var friction : int = 35

var light_encumbrance = 3
var heavy_encumbrance = 5

var velocity : Vector2 = Vector2.ZERO

var level_x_min = 16
var level_x_max = 1264

export var vegetable_tiles : NodePath

export var basket : NodePath

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _physics_process(delta):
    
    if (Input.is_action_just_pressed("grab")):
        pick_vegetable()
    
    var encumbrance_modifier : Vector2 = Vector2(1.0, 1.0)
    
    if has_heavy_encumbrance():
        encumbrance_modifier = Vector2(0.3, 0.8)
    elif has_light_encumbrance():
        encumbrance_modifier = Vector2(0.5, 1.0)
        
    velocity.y += gravity
    
    var input : Vector2 = Vector2.ZERO
    
    input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
    input.y = -0
    if is_on_floor():
        if Input.is_action_just_pressed("ui_up") or Input.is_action_pressed("ui_up"):
            velocity.y = -jump_strength*encumbrance_modifier.y
    else:
        $AnimatedSprite.animation = "Jump"
        if Input.is_action_just_released("ui_up") and velocity.y < -small_jump*encumbrance_modifier.y:
            velocity.y = -small_jump*encumbrance_modifier.y
            $AnimatedSprite.animation = "Idle"
    
    if input.x == 0:
        velocity.x = move_toward(velocity.x, 0, friction)
        if is_on_floor():
            $AnimatedSprite.animation = "Idle"
    else:
        velocity.x = move_toward(velocity.x, encumbrance_modifier.x*speed*input.x, acceleration)
        if is_on_floor():
            $AnimatedSprite.animation = "Run"

    if input.x < 0:
        $AnimatedSprite.flip_h = true
    elif input.x > 0:
        $AnimatedSprite.flip_h = false
    velocity = move_and_slide(velocity, Vector2.UP)
    
    if position.x < level_x_min:
        position.x = level_x_min
    elif position.x > level_x_max:
        position.x = level_x_max
        
func pick_vegetable():
    var tile_position : Vector2 = convert_to_tilemap(position) + Vector2(-0.5, 1.0)
    tile_position = Vector2(floor(tile_position.x), floor(tile_position.y))
    
    var can_submit_to_basket : bool = get_node(vegetable_tiles).get_cellv(tile_position) == 1 \
        or get_node(vegetable_tiles).get_cellv(tile_position + Vector2(1.0,0.0)) == 1
    
    if can_submit_to_basket:
        print("Adding vegetables to basket")
        get_node(basket).transfer_contents($"Resource Holder")
    elif get_node(vegetable_tiles).get_cellv(tile_position) == TileMap.INVALID_CELL:
        pass
    else:
        print("Stealing vegetable")
        get_node(vegetable_tiles).set_cellv(tile_position, TileMap.INVALID_CELL)
        $"Resource Holder".give_resource(0)

func convert_to_tilemap(var real_position : Vector2):
    return (real_position + Vector2(16,16))/32

func has_light_encumbrance():
    return $"Resource Holder".get_current_resource() >= light_encumbrance
    
func has_heavy_encumbrance():
    return $"Resource Holder".get_current_resource() >= heavy_encumbrance
