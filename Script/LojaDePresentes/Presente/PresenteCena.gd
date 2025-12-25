extends Control

@onready var sprite: TextureRect = $Sprite

var drag : bool = false
var drag_offset : Vector2 = Vector2.ZERO

func configurar_presente(presente: Presente, posicao : Vector2) -> void:
	
	var imagem : Image = presente.textura.get_image()
	
	imagem.resize(64,64, Image.INTERPOLATE_LANCZOS)

	var nova_textura = ImageTexture.create_from_image(imagem)
	
	sprite.texture = nova_textura
	global_position = posicao

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and \
	event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			drag = true
			drag_offset = global_position - get_global_mouse_position()
			move_to_front()
		else:
			drag = false
	
	if event is InputEventMouseMotion and drag:
		global_position = get_global_mouse_position() + drag_offset
