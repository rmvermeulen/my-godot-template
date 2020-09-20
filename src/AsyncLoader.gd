class_name AsyncLoader
extends Node

var current_scene

var mutex := Mutex.new()
var cache = {}


func _init():
	pause_mode = Node.PAUSE_MODE_PROCESS

	var thread_pool: ThreadPool = Singletons.fetch(ThreadPool)
	assert(thread_pool.discard_finished_tasks, "ThreadPool config incompatible with AsyncLoader")
	assert(OK == thread_pool.connect("task_discarded", self, "_on_task_discarded"))

	prints('AsyncLoader ready')


func load(path: String, node: Node, callback: String):
	if cache.has(path):
		return cache[path]

	var thread_pool := Singletons.fetch(ThreadPool)
	thread_pool.submit_task(self, "_sync_load", path, path)

	while true:
		var task = yield(thread_pool, 'task_discarded')
		if task.tag == path:
			# resource is now loaded
			node.call_deferred(callback, path, task.result)
			return


func _on_task_discarded(task: ThreadPool.Task):
	cache[task.tag] = task.result


func _sync_load(path: String):
	return load(path)
