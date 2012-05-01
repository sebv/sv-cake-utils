DEV_DIRS = ['lib']
COFFEE_PATHS = DEV_DIRS.concat ['index.coffee']
JS_PATHS = DEV_DIRS.concat ['index.js']

u = require './index'

task 'compile', 'Compile All coffee files', ->
  u.coffee.compile COFFEE_PATHS

task 'clean', 'Remove all js files', ->
  u.js.clean JS_PATHS 
