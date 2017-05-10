path = require 'path'
spawn = require('child_process').spawn

procs = {}

n = 0
spawnProcess = (process, args, options) =>
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

	proc.stdout.on 'data', (data) =>
		stdout += "\n" + data
		console.log strRep, 'STDOUT:', data.toString()
		if options.onOut? then options.onOut data

	proc.stderr.on 'data', (data) =>
		stderr += "\n" + data
		console.log strRep, 'STDERR:', data.toString()
		if options.onErr? then options.onErr data

	proc.on 'exit', (code) =>
		console.log strRep, "exited with code", code
		if options.onExit?
			options.onExit { process, args, proc, stdout, stderr, code }
	
	return proc

simpleProcessSpawner = (options) =>
	scriptPath = path.resolve __dirname, '../scripts/', options.script
	return spawnProcess options.exec, scriptPath, options

module.exports =
	# TODO: processes: procs
	spawnProcess: spawnProcess
	simpleProcessSpawner: simpleProcessSpawner
