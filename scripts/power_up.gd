extends Area2D

signal hit

func _ready() -> void:
	pass
	
func _on_body_entered(_body: Area2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	pass
	
