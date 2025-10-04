extends Node

@export var mob_scene: PackedScene
@export var powerup_scene: PackedScene

var score

#TODO Mob Spawn Timer -> 0.5s

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$PowerupTimer.stop()
	$Music.stop()
	$DeathSound.play()
	$HUD.show_game_over()
	$Player.reset()
	get_tree().call_group("power_ups", "queue_free")

func new_game():
	score = 0
	get_tree().call_group("mobs", "queue_free")
	$Player.start($StartPosition.position)
	$Music.play()
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")


func _on_mob_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)
		
func _on_powerup_timer_timeout() -> void:
	var powerup = powerup_scene.instantiate()
	
	powerup.position = Vector2(460 * randf() + 10 , 700 * randf() + 10 )
	print("powerup spwaning @  ", powerup.position)	
	
	add_child(powerup)
	pass

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
	$PowerupTimer.start()
