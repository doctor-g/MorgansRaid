extends Node2D
tool

const _MAP_ASSET_PATH := "res://assets/Images/Map/"
const _TILE_SIZE :int = 512

func _init():
	_update_map()


func _update_map():
	print("Loading map...")
	for child in get_children():
		remove_child(child)
	for i in range(0,7):
		for j in range(0,9):
			var tile_image := load(_MAP_ASSET_PATH + "map_%d%d.png" % [i,j])
			var tile = Sprite.new()
			tile.centered = false
			tile.texture = tile_image
			tile.position = Vector2(j,i) * _TILE_SIZE
			add_child(tile)
