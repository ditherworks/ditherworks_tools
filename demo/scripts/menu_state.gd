class_name MenuState
extends GameState


# Export Members


# Private Members
var _save_file := SaveFile.new("config.txt")


# Default Callbacks
func _ready() -> void:
	(%Return as Button).pressed.connect(_on_button_pressed.bind(%Return))
	(%Exit as Button).pressed.connect(_on_button_pressed.bind(%Exit))
	
	_save_file.load(_save_file._path)
	_save_file.ensure_default_values(SaveFile.TEST_VALUES, true)
	_save_file.save(_save_file._path)

	
func _input(event: InputEvent) -> void:
	# quit request
	var key := event as InputEventKey
	if key and key.pressed and key.keycode == KEY_ESCAPE:
		get_tree().quit()


# Public Functions
func enter() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


# Private Functions
func _on_button_pressed(button: Button) -> void:
	if button == %Return:
		_game.request_state_transition(_game.get_state("GameplayState"))
	if button == %Exit:
		get_tree().quit()

