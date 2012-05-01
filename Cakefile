DEV_DIRS = ['lib']
COFFEE_PATHS = DEV_DIRS.concat ['index.coffee']
JS_PATHS = DEV_DIRS.concat ['index.js']

u = require './index'

task 'compile', 'Compile All coffee files', ->
  u.coffee.compile COFFEE_PATHS

task 'compile:watch', 'Compile All coffee files and watch for changes', ->
  u.coffee.compile COFFEE_PATHS, true

task 'clean', 'Remove all js files', ->
  u.js.clean JS_PATHS 

task 'grep:dirty', 'Lookup for debugger and console.log in code', ->
  u.grep.debug()
  u.grep.log()
