extends Node2D

export (bool) var save_results := false


func _ready():
	var parser := XMLParser.new()
	assert(OK == parser.open("res://assets/textures/scifiRTS_spritesheet@2.xml"))

	var texture: StreamTexture
	var tiles := TileSet.new()

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
				if attr.name.find("Tile") < 0:
					continue

				var id = int(attr.name)
				tiles.create_tile(id)
				tiles.tile_set_texture(id, texture)
				tiles.tile_set_region(id, Rect2(attr.x, attr.y, attr.width, attr.height))
				tiles.tile_set_name(id, attr.name)

			_:
				continue

	prints("tiles", tiles, tiles.get_tiles_ids())
	if save_results:
		ResourceSaver.save("res://resources/ScifiTiles.tres", tiles)
