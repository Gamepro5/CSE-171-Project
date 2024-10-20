extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	floor_snap_length = get_floor_angle()*abs(velocity.x+10)
	var direction := Input.get_axis("left", "right")
	if direction:
		%Sprite.set_animation("move")
		if direction > 0:
			%Sprite.flip_h = false
		else:
			%Sprite.flip_h = true
		
	else:
		%Sprite.set_animation("default")
		
	if !is_on_floor():
		if velocity.y < 0:
			%Sprite.set_animation("jump")
		else:
			%Sprite.set_animation("falling")
	if abs(velocity.x) < 1:
		velocity.x = 0
	
	if is_on_floor():
		if velocity.x == 0 or sign(direction) == sign(velocity.x): #acceleration
			velocity.x = lerp(velocity.x, direction * SPEED, 0.2)
		else: #deceleration
			velocity.x = lerp(velocity.x, direction * SPEED, 0.2)
	else:
		if direction != 0:
			if velocity.x != 0 and sign(direction) != sign(velocity.x): #deceleration
				velocity.x = lerp(velocity.x, direction * SPEED, 0.05)
			else: #acceleration
				velocity.x = lerp(velocity.x, direction * SPEED, 0.1)
	move_and_slide()
