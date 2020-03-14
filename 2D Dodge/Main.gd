extends Node

# Mob scene példányosításához
export (PackedScene) var Mob

var score

func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# A Player screen "hit" signal-jára fut le
func _on_Player_hit():
	pass # Replace with function body.


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")

# StartTimer lejártakor
func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

# ScoreTimer lejártakor
func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

# MobTimer lejártakor (új ellenségek spawnolása)
func _on_MobTimer_timeout():
	# Random hely választása a Path2D node-on
	$MobPath/MobSpawnLocation.offset = randi()
	
	# példányosítás és  screen-hez adás
	var mob = Mob.instance()
	add_child(mob)
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	mob.position = $MobPath/MobSpawnLocation.position
	
	# irány randomizálása
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction 
	
	# sebesség és irány beállítása
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)


