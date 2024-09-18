extends PointLight2D

var time_passed: float = 0.0
var noise: Noise = preload("res://Scenes/Props/sconce/noise.tres")

func _process(delta):
	time_passed += delta
	var sample_noise: float = noise.get_noise_1d(time_passed * 4.0)
	sample_noise = remap(abs(sample_noise), 0.0, 1.0, 0.6, 1.0)
	energy = sample_noise
