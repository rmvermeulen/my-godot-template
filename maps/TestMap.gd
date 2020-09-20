extends Node2D


func _ready():
	var loader: AsyncLoader = Singletons.fetch(AsyncLoader)
	prints("got loader", loader)
