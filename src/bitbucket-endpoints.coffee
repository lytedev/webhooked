processSpawners = require('./process-spawner')

simpleProcessSpawner = processSpawners.simpleProcessSpawner
dedupProcessSpawner = processSpawners.dedupProcessSpawner

verifyBitbucketRequest = (req) =>
	# TODO: Bitbucket currently has no verification system
	retval = true
	req.isVerifiedBitbucketRequest = retval
	return retval

module.exports = (req, res, next) ->
	if req.method != 'POST' then return next()
	isVerified = verifyBitbucketRequest req
	req.isVerifiedBitbucketRequest = isVerified

	if isVerified
		n = 0
		for hook in req.app.locals.bitbucketRepositoryNameHooks
			if req.body.repository.full_name == hook.repositoryFullName
				if hook.noDedup? and hook.noDedup
					simpleProcessSpawner hook
				else
					dedupProcessSpawner hook
				n += 1
		if n == 0
			return res.status(200).send('No scripts to run')
		else
			return res.status(200).send('Verified - Running ' + n + ' jobs...')
	else
		return res.status(400).send('Failed to verify hub signature')

