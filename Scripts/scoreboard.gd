class_name Scoreboard extends Node2D

@export var label : Label
var score_str : String = "Score: "

var score : int = 0 :
	set(value):
		score = value
		label.text = score_str + str(score)

func increase_score(value: int) -> void:
	score += value
	print("increasing score")
