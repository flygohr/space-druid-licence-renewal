extends Node2D

var score: int = 0

func _on_fruit_collision_meh_area_entered(area: Area2D) -> void:
	if area.is_in_group("LaserBeam"):
		print("Meh")
		score += 1

func _on_fruit_collision_good_area_entered(area: Area2D) -> void:
	if area.is_in_group("LaserBeam"):
		print("Good")
		score += 1

func _on_fruit_collision_perfect_area_entered(area: Area2D) -> void:
	if area.is_in_group("LaserBeam"):
		print("Perfect")
		score += 1

func return_score() -> int:
	return score
