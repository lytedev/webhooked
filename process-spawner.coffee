spawn = require('child_process').spawn

n = 0
procs = {}
spawnProcess = (process, args, onSpawn, onExit) =>
	if not args?
		args = []

	myN = n++
	strRep = '[' + myN + ']: ' + process + ' ' + JSON.stringify(args)
	console.log 'Spawning process', strRep
	proc = spawn process, args
	procs[proc.pid] = proc
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
	processes: procs
	spawnProcess: spawnProcess
