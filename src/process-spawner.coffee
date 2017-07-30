path = require 'path'
spawn = require('child_process').spawn
_ = require 'lodash'

procs = {}

dedupTrack = {}
dedupQueue = {}

n = 0
spawnProcess = (process, args, options) ->
	if not args?
		args = []

	if not Array.isArray args
		args = [args]

	myN = n++
	strRep = '[' + myN + ']: ' + process + ' ' + JSON.stringify(args)
	console.log 'Spawning process', strRep
	proc = spawn process, args

	# TODO:
	# procs[proc.pid] = proc
	# if we want to store a process history, we probably need a way to make sure
	# we clean it out every once in a while...

	if onSpawn?
		onSpawn process, args, proc

	console.log 'PID:', proc.pid

	stdout = ''
	stderr = ''

	proc.stdout.on 'data', (data) ->
		stdout += "\n" + data
		console.log strRep, 'STDOUT:', data.toString()
		if options.onOut? then options.onOut data

	proc.stderr.on 'data', (data) ->
		stderr += "\n" + data
		console.log strRep, 'STDERR:', data.toString()
		if options.onErr? then options.onErr data

	proc.on 'exit', (code) ->
		console.log strRep, "exited with code", code
		if options.onExit?
			options.onExit { process, args, proc, stdout, stderr, code }
	
	return proc

simpleProcessSpawner = (options) ->
	scriptPath = path.resolve __dirname, '../scripts/', options.script
	return spawnProcess options.exec, scriptPath, options

dedupProcessSpawner = (options) ->
	# the same as spawnProcess, only it will wait for existing spawn process
	# requests with the same process/args combinations to finish before running
	# again. if this function is called multiple times, it will still only spawn
	# 1 of the processes after the current one finishes - this is especially
	# useful for build scripts
	options = _.clone options
	key = options.exec + ' ' + options.script
	# console.log 'DEDUP:', key
	if key of dedupTrack
		# console.log 'DEDUP: Received duplicate request for ' + key + ' -- queueing...'
		dedupQueue[key] = options
		return
	else
		originalOnExit = options.onExit
		options.onExit = (e) ->
			# console.log 'DEDUP: A process completed:', key
			delete dedupTrack[key]
			if originalOnExit?
				originalOnExit(e)
			if dedupQueue[key]
				# console.log 'DEDUP: Running queue\'d process...'
				newOptions = dedupQueue[key]
				delete dedupQueue[key]
				dedupProcessSpawner newOptions
		dedupTrack[key] = simpleProcessSpawner options

module.exports =
	# TODO: processes: procs
	spawnProcess: spawnProcess
	dedupProcessSpawner: dedupProcessSpawner
	simpleProcessSpawner: simpleProcessSpawner
