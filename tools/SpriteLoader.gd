extends Node2D

export (bool) var save_results := false

var results = []


func _ready():
	var parser := XMLParser.new()
	assert(OK == parser.open("res://assets/textures/scifiRTS_spritesheet@2.xml"))

	var texture: StreamTexture

	while parser.read() == OK:
		match parser.get_node_type():
			XMLParser.NODE_NONE:
				continue
			XMLParser.NODE_TEXT:
				continue

		var ac = parser.get_attribute_count()
		if ac == 0:
			continue
		var attr = {}
		for i in ac:
			attr[parser.get_attribute_name(i)] = parser.get_attribute_value(i)

		match parser.get_node_name():
			'TextureAtlas':
				assert(parser.has_attribute("imagePath"))
				texture = load("assets/textures/%s" % attr.imagePath)

			'SubTexture':
				assert(parser.has_attribute("x"))
				assert(parser.has_attribute("y"))
				assert(parser.has_attribute("width"))
				assert(parser.has_attribute("height"))
				assert(parser.has_attribute("name"))
				var at := AtlasTexture.new()
				at.atlas = texture
				at.region = Rect2(attr.x, attr.y, attr.width, attr.height)
				results.append(at)
				if save_results:
					var path = "res://resources/textures/%s.tres" % attr.name
					var saved = ResourceSaver.save(path, at)
					assert(saved == OK)

			_:
				continue

	prints("results", results.size())

	var columns := 4
	var gap := 128

	for i in results.size():
		var s = Sprite.new()
		s.texture = results[i]
		s.position = gap * Vector2(i % columns, floor(i / columns))
		add_child(s)
