extends KinematicBody2D


var speed : int = 300
var extra_speed : int = 0
var acceleration : int = 40
var jump_strength : int = 425
var extra_jump : int = 0
var small_jump : int = 180
var gravity : int = 20
var friction : int = 35

var light_encumbrance = 3
var heavy_encumbrance = 5

var half_encumbarance : int = 0
var extra_encumbarance : int = 0

var velocity : Vector2 = Vector2.ZERO

var level_x_min = 16
var level_x_max = 1264

export var vegetable_tiles : NodePath

export var basket : NodePath

export var SpeedPopup : PackedScene
export var JumpPopup : PackedScene

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
            velocity.y = -(jump_strength + extra_jump)*encumbrance_modifier.y
            $Jump.play()
    else:
        $AnimatedSprite.animation = "Jump"
        if Input.is_action_just_released("ui_up") and velocity.y < -small_jump*encumbrance_modifier.y:
            velocity.y = -small_jump*encumbrance_modifier.y
            $AnimatedSprite.animation = "Idle"
    
    if input.x == 0:
        velocity.x = move_toward(velocity.x, 0, friction)
        if is_on_floor():
            if Input.is_action_pressed("grab"):
                $AnimatedSprite.animation = "Pick"
            else:
                $AnimatedSprite.animation = "Idle"
    else:
        velocity.x = move_toward(velocity.x, encumbrance_modifier.x*(speed + extra_speed)*input.x, acceleration)
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
    var tile_position : Vector2 = convert_to_tilemap(position) + Vector2(-0.5, 0.0)
    tile_position = Vector2(floor(tile_position.x), floor(tile_position.y))
    
    var current_tile_type = get_node(vegetable_tiles).get_cellv(tile_position)
    var next_tile_type = get_node(vegetable_tiles).get_cellv(tile_position + Vector2(1.0, 0.0))
    
    var can_submit_to_basket : bool = current_tile_type == 1 or next_tile_type == 1
    
    if can_submit_to_basket:
        print("Adding vegetables to basket")
        get_node(basket).transfer_contents($"Resource Holder")
        half_encumbarance = 0
        extra_encumbarance = 0
        extra_jump = 0
        extra_speed = 0
        $Basket.play()
    elif current_tile_type == TileMap.INVALID_CELL:
        pass
    elif $"Resource Holder".get_current_resource() < 5:
        print("Stealing vegetable " + str(current_tile_type))
        get_node(vegetable_tiles).set_cellv(tile_position, TileMap.INVALID_CELL)
        $"Resource Holder".give_resource("Veg " + str(current_tile_type - 1))
        apply_bonus(current_tile_type - 1)
        $Pickup.play()

func convert_to_tilemap(var real_position : Vector2):
    return (real_position + Vector2(16,16))/32

func has_light_encumbrance():
    return $"Resource Holder".get_current_resource() - half_encumbarance/2  + extra_encumbarance >= light_encumbrance
    
func has_heavy_encumbrance():
    return $"Resource Holder".get_current_resource() - half_encumbarance/2 + extra_encumbarance >= heavy_encumbrance

func apply_bonus(var type):
    if type == 1:
        print("Normal vegetable")
        pass # nothing happens with first one
    elif type == 2:
        print("Heavy vegetable")
        extra_encumbarance += 1
    elif type == 3:
        print("High vegetable")
        extra_jump += 45
        var popup = JumpPopup.instance()
        popup.position = position + Vector2(- 16, -32)
        get_tree().root.get_child(0).add_child(popup)
    elif type == 4:
        print("Fast vegetable")
        extra_speed += 30
        var popup = SpeedPopup.instance()
        popup.position = position + Vector2(- 16, -32)
        get_tree().root.get_child(0).add_child(popup)
    else:
        print("Light vegetable")
        half_encumbarance += 1
