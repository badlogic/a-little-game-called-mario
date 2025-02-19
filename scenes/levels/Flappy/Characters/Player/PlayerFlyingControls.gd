extends RigidBody2D
class_name PlayerFlying

const ASCEND_FORCE = -200
const MAX_ROTATION_UP = -30.0
const MAX_ROTATION_DOWN = 90.0

var inventory = preload("res://scripts/resources/PlayerInventory.tres")

var GAMEOVER = preload("../../UI_flappy_gameover.tscn").instance()
var died = false

# Called when the node enters the scene tree for the first time.
func _ready():
	inventory.reset()
	EventBus.connect("heart_changed", self, "_on_heart_change")


func _physics_process(_delta: float) -> void:
	if !died && Input.is_action_just_pressed("jump"):
		linear_velocity.y = ASCEND_FORCE;
		angular_velocity = -10.0

	if rotation_degrees <= MAX_ROTATION_UP:
		angular_velocity = 0
		rotation_degrees = MAX_ROTATION_UP
		
	if linear_velocity.y > 0:
		if rotation_degrees <= MAX_ROTATION_DOWN:
			angular_velocity = 5
		else:
			angular_velocity = 0

func crash() -> void:
	inventory.hearts -= 1
	EventBus.emit_signal("heart_changed", {"value": -1})
	
	$CrashAudio.play()
	
	var value = inventory.hearts
	if value <= 0:
		gameOver()
	
func gameOver() -> void:
	get_parent().add_child(GAMEOVER)
	died = true
