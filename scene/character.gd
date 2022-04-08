extends KinematicBody

onready var head : Spatial = $head

var velocity : Vector3

func _ready() :
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta) :
	var move_axis := Vector2(
		int(Input.is_action_pressed("move_forward")) - int(Input.is_action_pressed("move_back")),
		int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	)
	var jump = Input.is_action_pressed("jump")
	
	var direction := Vector3()
	var aim = get_global_transform().basis
	if move_axis.x >= 0.5 :
		direction -= aim.z
	if move_axis.x <= -0.5 :
		direction += aim.z
	if move_axis.y <= -0.5 :
		direction -= aim.x
	if move_axis.y >= 0.5 :
		direction += aim.x
	direction = direction.normalized()
	
	direction.y = 0
	var _y : float = velocity.y
	velocity = velocity.linear_interpolate(direction * 10, delta * 15)
	velocity.y = _y
	
	
	if !is_on_floor() :
		velocity.y -= 1
	else :
		if jump and false : # disabled
			velocity.y += 15
			
	velocity = move_and_slide(velocity, Vector3.UP)

func _input(event : InputEvent) :
	if event is InputEventMouseMotion :
		rotate_y(-event.relative.x / 512)
		head.rotate_x(-event.relative.y / 512)
		
		head.rotation.x = clamp(head.rotation.x, -PI/2, PI/2)
