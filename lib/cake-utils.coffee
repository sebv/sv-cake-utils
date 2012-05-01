cp = require 'child_process'

exports.coffee =
  compile: (paths , watch = false) ->    
    args = ['--compile']
    args.push('--watch') if watch
    args = args.concat paths
    spawn 'coffee', args

exports.mocha =
  test: (dir) ->    
    cp.execFile 'find', [ dir ] , (err, stdout, stderr) ->
      files = (stdout.split '\n').filter( (name) -> name.match /.+\-test.coffee/ )
      params = ['-R', 'spec', '--colors'].concat files
      spawn 'mocha', params

exports.js =
  clean: (dirs , files) ->
    cp.execFile 'find', dirs.concat(files) , (err, stdout, stderr) ->
      _files = (stdout.split '\n').filter( (name) -> name.match /.+\.js/ )
      spawn 'rm', _files, false if _files.length > 0 

exports.grep =
  debug: -> grepInSource('debugger')
  log: -> grepInSource('console.log')

exports.grepInSource = grepInSource = (word) ->
  cp.execFile 'find', [ '.' ] , (err, stdout, stderr) ->
    files = (stdout.split '\n')\
      .filter( (name) -> not name.match /\/node_modules\//)\
      .filter( (name) -> not name.match /\/\.git\//)\
      .filter( (name) -> 
        ( name.match /\.js$/) or 
        (name.match /\.coffee$/ ) )
    spawn 'grep', ([word].concat files), false 

exports.spawn = spawn = (cmd,params,exitOnError=true) ->
  proc = cp.spawn cmd, params
  proc.stdout.on 'data', (buffer) -> process.stdout.write buffer.toString()
  proc.stderr.on 'data', (buffer) -> process.stderr.write buffer.toString()
  proc

  