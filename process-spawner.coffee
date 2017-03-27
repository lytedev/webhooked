spawn = require('child_process').spawn

procs = {}

n = 0
spawnProcess = (process, args, onSpawn, onExit) =>
	if not args?
		args = []

	if not Array.isArray args
		args = [args]

	myN = n++
	strRep = '[' + myN + ']: ' + process + ' ' + JSON.stringify(args)
	console.log 'Spawning process', strRep
	proc = spawn process, args

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

	proc.stderr.on 'data', (data) =>
		stderr += "\n" + data
		console.log strRep, 'STDERR:', data.toString()

	proc.on 'exit', (code) =>
		console.log strRep, "exited with code", code
		if onExit?
			onExit process, args, proc, stdout, stderr, code

module.exports =
	# processes: procs
	spawnProcess: spawnProcess
