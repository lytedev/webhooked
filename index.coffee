require('dotenv').config()

express = require 'express'

app = express()

PORT = process.env.PORT or 3010

app.get '/ci/', (req, res, next) ->
  res.send('Hello, world!')

app.listen PORT
