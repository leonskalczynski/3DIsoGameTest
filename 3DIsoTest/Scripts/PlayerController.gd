extends CharacterBody3D

@onready var camera : Camera3D = get_parent().get_node("CameraStick/Camera3D")
@onready var viewport : Viewport = get_viewport()
@onready var fire_point : Marker3D = get_node("FireOrigin")
@onready var clock : Node = get_parent().get_node("Clock")
@onready var bullet_scene : PackedScene = preload("res://Scenes/bullet.tscn")

var horizontal_input : float = 0.0
var vertical_input : float = 0.0

const MOVE_SPEED : float = 13.0
const GRAVITY : float = 50.0
const FIRE_INTERVAL : float = 0.4
const DOWNWARD_FORCE : float = 5
const JUMP_FORCE : float = 25

const BULLET_SHOOT_VELOCITY : float = 26.0

var looking_position : Vector3 = Vector3.ZERO


func _ready():
	clock.repeat(FIRE_INTERVAL, self, "handle_shooting", [])


func _physics_process(delta):
	handle_input()
	handle_movement()
	#handle_shooting()
	
	velocity.y -= DOWNWARD_FORCE * delta
	rotate_to_mouse_position()
	move_and_slide()
	
	if is_on_floor():
		handle_jump()
	else:
		velocity.y -= GRAVITY * delta


func handle_input():
	horizontal_input = Input.get_action_strength("east") - Input.get_action_strength("west")
	vertical_input = Input.get_action_strength("south") - Input.get_action_strength("north")


func handle_jump():
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_FORCE


func handle_movement():
	var fall_speed : float = velocity.y
	var fall_direction : Vector3 = Vector3.UP * fall_speed
	velocity = Vector3(horizontal_input, 0.0, vertical_input).normalized() * MOVE_SPEED + fall_direction


func handle_shooting():
	if Input.is_action_pressed("fire"):
		var bullet : RigidBody3D = bullet_scene.instantiate()
		get_parent().add_child(bullet)
		bullet.position = fire_point.global_position
		bullet.linear_velocity = (looking_position - position).normalized() * BULLET_SHOOT_VELOCITY + velocity


func rotate_to_mouse_position():
	var mouse_pos : Vector2 = viewport.get_mouse_position()
	var ray_distance : float = 150.0
	var ray_start : Vector3 = camera.project_ray_origin(mouse_pos)
	var ray_end : Vector3 = ray_start + camera.project_ray_normal(mouse_pos) * ray_distance
	var space = get_world_3d().direct_space_state
	var ray_parameters : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	ray_parameters.from = ray_start
	ray_parameters.to = ray_end
	ray_parameters.collision_mask = 2
	
	var ray_hit = space.intersect_ray(ray_parameters)
	
	looking_position = ray_hit["position"]
	
	look_at(ray_hit["position"])
	rotation = rotation * Vector3.UP
