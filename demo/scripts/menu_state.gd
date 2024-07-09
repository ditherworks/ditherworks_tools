class_name MenuState
extends GameState


# Constants
const SAVE_PATH := "user://config.txt"
const TEST_VALUES := {
	"display": {
		"fullscreen": false,
		"fps_limit": 60,
	},
	"audio": {
		"master": 100,
		"gameplay": 80,
		"music": 20,
	},
}

# Export Members


# Private Members
var _save_file := SaveFile.new()


# Default Callbacks
func _ready() -> void:
	(%Return as Button).pressed.connect(_on_button_pressed.bind(%Return))
	(%Exit as Button).pressed.connect(_on_button_pressed.bind(%Exit))
	
	_save_file.load(SAVE_PATH)
	_save_file.ensure_default_values(TEST_VALUES, true)
	_save_file.save(SAVE_PATH)

	
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

