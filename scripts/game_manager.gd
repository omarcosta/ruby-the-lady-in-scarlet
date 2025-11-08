extends Node

# Game control
@onready var gameover = false
# @onready var activate_gameover_screen = false

# Player
@onready var player_position: Vector2 # Posição global do jogador
@onready var player_life_points: int = 100 # Vida do jogador
@onready var player_life_points_max: int = 100 # Vida máxima do jogador
# @onready var player_stamina_points: float = 100.0 # Vida do jogador
# @onready var player_stamina_points_max: int = 100 # Vida máxima do jogador
# @onready var player_magic_points: int = 100 # Vida do jogador
# @onready var player_magic_points_max: int = 100 # Vida máxima do jogador

# Skill Magic
# @onready var magic_available: bool = true
# @onready var magic_interval: float = 0
#@onready var magic_cooldown: float = 0

# Skills Technique
# @onready var technique_available: bool = true
# @onready var technique_interval: float = 0
# @onready var technique_reserve_ammo: int = 0
# @onready var technique_max_reserver_ammo: int = 0

# Stage
#@onready var waves: int = 0 # Ondas de inimigos
# @onready var enemies_defeated: int = 0 # Quantidade de inimigos derrotados
# @onready var game_time: String = "00:00"
# @onready var game_time_seconds: int = 0
# @onready var game_time_minutes: int = 0

func _process(delta):
	# player_lives()
	#if activate_gameover_screen:
		#var gameover_scene_prefab = preload("res://scenes/ui/ui_game_over.tscn")
		#var gameover_scene = gameover_scene_prefab.instantiate()
		#get_parent().add_child(gameover_scene)
		#activate_gameover_screen = false
		pass
	

func player_lives() -> void:
	if player_life_points <= 0:
		gameover = true
		# activate_gameover_screen = true


func reset():
	gameover = false
	player_position = Vector2.ZERO
	# magic_available = true
	# technique_available = true
	# enemies_defeated = 0
	# game_time = "00:00"
	# game_time_seconds = 0
	# game_time_minutes = 0
	# Reset signal
	# for connection in signal_name.get_connections():
		#signal_name.desconnect(connection)
