extends Camera2D

@export var target_node: Node2D
@export_range(0.01, 1.0) var lerp_weight: float = 0.1

func _physics_process(delta):
	if not target_node:
		return
	
	# 1. Calcula a posição suave (isso gera floats, ex: 100.3)
	global_position = global_position.lerp(target_node.global_position, lerp_weight)
	
	# 2. (A SOLUÇÃO) Arredonda a posição final para o pixel inteiro mais próximo
	global_position = global_position.round()
