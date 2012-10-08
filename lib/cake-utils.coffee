binDir = './node_modules/.bin'
cp = require 'child_process'

exports.coffee =
  compile: (paths, opts) ->    
    args = ['--compile']
    if(opts?.output?)
      args.push('--output')
      args.push(opts.output)
    args.push('--watch') if(opts?.watch is true)
    args = args.concat paths
    spawn "#{binDir}/coffee", args

exports.mocha =
  test: (dir, done) ->
    cp.execFile 'find', [ dir ] , (err, stdout, stderr) ->
      files = (stdout.split '\n').filter( (name) -> name.match /.+\.coffee/ )
      args = ['-R', 'spec', '--colors'].concat files
      proc = spawn "#{binDir}/mocha", args
      proc.on 'exit', (status) ->    
        done status if done?
        
exports.vows =   
  test: (dir, done) ->    
    cp.execFile 'find', [ dir ] , (err, stdout, stderr) ->
      files = (stdout.split '\n').filter( (name) -> name.match /.+\.coffee/ )
      args = ['--spec'].concat files
      proc = spawn "#{binDir}/vows", args
      proc.on 'exit', (status) ->    
        done status if done?

exports.nodeunit =
  test: (dir, done) ->
    cp.execFile 'find', [ dir ] , (err, stdout, stderr) ->
      files = (stdout.split '\n').filter( (name) -> name.match /.+\.coffee/ )
      args = files
      proc = spawn "#{binDir}/nodeunit", args
      proc.on 'exit', (status) ->    
        done status if done?
      
exports.js =
  clean: (dirs , files, excludePatterns) ->
    dirs.concat(files) if file?
    cp.execFile 'find', dirs , (err, stdout, stderr) ->
      _files = (stdout.split '\n').filter( (name) -> name.match /.+\.js/ )
      if(excludePatterns?)
        excludePatterns = [excludePatterns] unless excludePatterns instanceof Array
        for excludePattern in excludePatterns
          _files = _files.filter (name) -> not(name.match excludePatterns)
      spawn 'rm', _files if _files.length > 0 

exports.grep =
  debug: -> grepInSource('debugger')
  log: -> grepInSource('console.log')

exports.grepInSource = grepInSource = (word) ->
  cp.execFile 'find', [ '.' ] , (err, stdout, stderr) ->
    files = (stdout.split '\n')\
      .filter( (name) -> not name.match /\/node_modules\//)\
      .filter( (name) -> not name.match /\/examples\//)\
      .filter( (name) -> not name.match /\/\.git\//)\
      .filter( (name) -> 
        ( name.match /\.js$/) or 
        (name.match /\.coffee$/ ) )
    spawn 'grep', ([word].concat files) 

exports.killAllProc = (procName, done) ->
  cmd = "kill -9 `ps -el | grep #{procName} | grep -v grep | awk '{ print $2 }'`"
  exec cmd, done

exports.spawn = spawn = (cmd,args, done) ->
  proc = cp.spawn cmd, args, (err) ->
    done err if done?    
  proc.stdout.on 'data', (buffer) -> process.stdout.write buffer.toString()
  proc.stderr.on 'data', (buffer) -> process.stderr.write buffer.toString()
  proc

exports.exec = exec = (cmd, done) ->
  proc = cp.exec cmd, (err) ->
    done err if done?
  proc.stdout.on 'data', (buffer) -> process.stdout.write buffer.toString()
  proc.stderr.on 'data', (buffer) -> process.stderr.write buffer.toString()
  