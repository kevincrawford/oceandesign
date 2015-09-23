{APP_NAME, BOWER_COMPONENTS, SCRIPTS, SCRIPTS_IE8, STYLES} = require './config.coffee'

bless                 = require 'gulp-bless'
bower                 = require 'bower'
childProcess          = require 'child_process'
coffeeScript          = require 'gulp-coffee'
coffeeLint            = require 'gulp-coffeelint'
concat                = require 'gulp-concat'
connect               = require 'gulp-connect'
conventionalChangelog = require 'conventional-changelog'
es                    = require 'event-stream'
flatten               = require 'gulp-flatten'
fs                    = require 'fs'
gulp                  = require 'gulp'
gutil                 = require 'gulp-util'
jsHint                = require 'gulp-jshint'
karma                 = require 'karma'
imagemin              = require 'gulp-imagemin'
less                  = require 'gulp-less'
markdown              = require 'gulp-markdown'
minifyCss             = require 'gulp-minify-css'
minifyHtml            = require 'gulp-minify-html'
notify                = require 'gulp-notify'
plato                 = require 'gulp-plato'
ngAnnotate            = require 'gulp-ng-annotate'
ngClassify            = require 'gulp-ng-classify'
open                  = require 'gulp-open'
path                  = require 'path'
pkg                   = require './package.json'
protractor            = require 'gulp-protractor'
q                     = require 'q'
rev                   = require 'gulp-rev'
rimraf                = require 'gulp-rimraf'
sass                  = require 'gulp-sass'
sourceMaps            = require 'gulp-sourcemaps'
template              = require 'gulp-template'
templateCache         = require 'gulp-angular-templatecache'
uglify                = require 'gulp-uglify'
yargs                 = require 'yargs'
urlAdjuster           = require 'gulp-css-url-adjuster'
karma_ie_launcher     = require 'karma-ie-launcher'
stripDebug            = require 'gulp-strip-debug'
gulpIf                = require 'gulp-if'

BOWER_DIRECTORY       = 'bower_components/'
BOWER_FILE            = 'bower.json'
CHANGELOG_FILE        = 'CHANGELOG.md'
COMPONENTS_DIRECTORY  = "#{BOWER_DIRECTORY}_/"
DIST_DIRECTORY        = 'dist/'
E2E_DIRECTORY         = 'e2e/'
PORT                  = process.env.PORT ? 8182
SCRIPTS_MIN_DIRECTORY = 'scripts/'
SCRIPTS_MIN_FILE      = 'scripts.min.js'
SCRIPTS_IE8_MIN_FILE  = 'scripts.min.js'
SRC_DIRECTORY         = 'src/'
STATS_DIRECTORY       = 'stats/stats/'
STATS_DIST_DIRECTORY  = 'stats/'
STYLES_MIN_DIRECTORY  = 'styles/'
STYLES_MIN_FILE       = 'styles.min.css'
THIRD_PARTY_DIRECTORY = 'thirdParty/'
TEMP_DIRECTORY        = '.temp/'
VENDOR_DIRECTORY      = 'vendor/'
MEDIA_DIRECTORY      = 'media/'
FONTS_DIRECTORY       = 'contents/fonts/'
STYLES_TEMP_DIRECTORY = '.temp/temp_styles/'


FILES_VENDOR_THIRD_PARTY = [
	"**/InputMask/**"
	"**/jquery-ui-wheels/**"
	"**/Telerik/**"
	"**/SlickGrid/*.css"
	"**/SlickGrid/images/*"
	"**/SlickGrid/jquery.*.js"
	"**/SlickGrid/{slick.{grid,core,dataview},plugins/slick.{rowselectionmodel,checkboxselectcolumn}}.js"
]

EXTENSIONS =
	FONTS:
		COMPILED: [
			'.eot'
			'.svg'
			'.ttf'
			'.woff'
			'.otf'
		]
	IMAGES:
		COMPILED: [
			'.gif'
			'.jpeg'
			'.jpg'
			'.png'
			'.ico'
		]
	SCRIPTS:
		COMPILED: [
			'.js'
		]
		UNCOMPILED: [
			'.coffee'
			'.ls'
			'.ts'
		]
	STYLES:
		COMPILED: [
			'.css'
		]
		UNCOMPILED: [
			'.less'
			'.scss'
		]
	VIEWS:
		COMPILED: [
			'.html'
		]
		UNCOMPILED: [
			'.markdown'
			'.md'
		]

PREDEFINED_GLOBALS = [
	'angular'
	'beforeEach'
	'describe'
	'it'
]

getSwitchOption = (switches) ->
	isArray = Array.isArray switches
	keys    = if isArray then switches else [switches]
	key     = keys[0]

	for k in keys
		hasSwitch = !!yargs.argv[k]
		key       = k if hasSwitch

	set = yargs.argv[key]
	def = yargs.parse([])[key]

	value =
		if set is 'false' or set is false
			false
		else if set is 'true' or set is true
			true
		else
			def

yargs
.usage 'Run $0 with the following options.'

yargs.options 'backend',
	default     : false
	description : 'Use your own backend.  No backendless.'
	type        : 'boolean'

yargs.options 'help',
	default     : false
	description : 'Show help'
	type        : 'boolean'

yargs.options 'prod',
	default     : false
	description : 'Execute with all optimzations.  App will open in the browser but no file watching.'
	type        : 'boolean'

yargs.options 'serve',
	default     : true
	description : 'Serve the app'
	type        : 'boolean'

yargs.options 'specs',
	default     : true
	description : 'Run specs'
	type        : 'boolean'

yargs.options 'stats',
	default     :  false
	description : 'Run statistics'
	type        : 'boolean'

yargs.options 'ie9',
	default     : false
	description : 'Run unit tests on locally installed IE changing the Document mode to IE9'
	type        : 'boolean'

yargs.options 'stripDebug',
	default     : false
	description : 'Remove Console.log, alerts or $log.debug from the code'
	type        : 'boolean'


appUrl         = "http://localhost:#{PORT}"
env            = gutil.env
isProd         = getSwitchOption 'prod'
isWindows      = /^win/.test(process.platform)
manifest       = {}
runStats       = !isProd and getSwitchOption 'stats'
useBackendless = not (isProd or getSwitchOption 'backend')
runServer      = getSwitchOption 'serve'
runSpecs       = !isProd and useBackendless and getSwitchOption 'specs'
runWatch       = !isProd and runServer
showHelp       = getSwitchOption 'help'
testIE9        = getSwitchOption 'ie9'
rmDebug        = getSwitchOption 'stripDebug'
return if showHelp
	# console.log task for task, options of gulp.tasks
	console.log '\n' + yargs.help()

templateOptions =
	appName: APP_NAME
	useBackendless: useBackendless
	scripts: []
	styles: []
	scriptsIe8: []
	examples: []
	# inject the fs object so we can read files where necessary, and provide one useful shortcut for including files as strings
	fs: fs
	#TODO turn this into an actual string...
	readFileAsString: (filename) -> "'" + fs.readFileSync(filename, { encoding: "utf8" }).replace("\r\n"," ").replace("\r"," ").replace("\n"," ").replace("'","\\'") + "'"

# After adding Kendo, minification takes forever without some optimizations
# Options based on http://lisperator.net/uglifyjs/compress and http://lisperator.net/uglifyjs/codegen
uglifyOptions =
	mangle: false # saves ~7s
	compress:
		unused: false # saves > 4 min (wasn't willing to wait any longer without it)
		booleans: false # breaks structure picker's use of slickgrid
		cascade: false # renders bad JS, maybe related to structure picker?

getScriptSources = (ext) ->
	["**/*#{ext}"]
	.concat if not useBackendless then ["!**/*.backend#{ext}"] else []
	.concat if not runSpecs       then ["!**/*.spec#{ext}"]    else []

onError = (e) ->
	isArray  = Array.isArray e
	err      = e.message or e
	errors   = if isArray then err else [err]
	messages = (error for error in errors)

	gutil.log gutil.colors.red message for message in messages
	@emit 'end'

onRev = (file) ->
	from           = path.relative file.revOrigBase, file.revOrigPath
	to             = path.relative file.revOrigBase, file.path
	manifest[from] = to

	file

onScript = (file) ->
	filePath = path.relative file.base, file.path
	filePath = path.join SCRIPTS_MIN_DIRECTORY, filePath if file.revOrigBase
	filePath = unixifyPath filePath
	endsWith = '.spec.js'
	isSpec   = filePath.slice(-endsWith.length) is endsWith

	templateOptions.scripts.push filePath if not isSpec

onScriptIe8 = (file) ->
	filePath = path.relative file.base, file.path
	filePath = path.join SCRIPTS_MIN_DIRECTORY, filePath if file.revOrigBase
	filePath = unixifyPath filePath
	endsWith = '.spec.js'
	isSpec   = filePath.slice(-endsWith.length) is endsWith

	templateOptions.scriptsIe8.push filePath if not isSpec

	file

onStyle = (file) ->
	filePath = path.relative file.base, file.path
	filePath = path.join STYLES_MIN_DIRECTORY, filePath if file.revOrigBase
	filePath = unixifyPath filePath

	templateOptions.styles.push filePath

	file

replaceCSSUrls = () ->
	transform = (file, cb) ->
		filePath = path.relative file.base, file.path
		#filePath = path.join MEDIA_DIRECTORY, filePath
		filePath = unixifyPath filePath
		imageDir  = path.dirname filePath
		fileName = path.basename filePath
		gulp.src file.path
		.pipe urlAdjuster
			prepend: '../' + imageDir + '/'
		.pipe gulp.dest STYLES_TEMP_DIRECTORY
		.on 'data', (newFile) ->
			# wait to call this until *after* urlAdjuster has run
			cb(null, file)
	require('event-stream').map(transform)

openApp = ->
	sources = 'index.html'

	options =
		open:
			url: appUrl

	gulp
	.src sources, cwd: DIST_DIRECTORY
	.on 'error', onError

	.pipe notify "Launching browser...."

	.pipe open '', options.open
	.on 'error', onError

startServer = ->
	connect.server
		livereload: if isProd then false else { port: 35730 } # different port than Ocean itself
		port: PORT
		root: DIST_DIRECTORY

unixifyPath = (p) ->
	p.replace /\\/g, '/'

windowsify = (windowsCommand, nonWindowsCommand) ->
	if isWindows then windowsCommand else nonWindowsCommand

# Get components via Bower
gulp.task 'bower', ['clean:working'], ->
	options =
		directory: BOWER_DIRECTORY

	components = []

	components.push "#{component}##{version}" for version, files of value for component, value of BOWER_COMPONENTS

	bower
	.commands.install components, {}, options
	.on 'error', onError

# build the app
gulp.task 'build', ['spa', 'fonts', 'images'], ->
	extensions = []
	.concat EXTENSIONS.FONTS.COMPILED
	.concat EXTENSIONS.IMAGES.COMPILED
	.concat EXTENSIONS.SCRIPTS.COMPILED
	.concat EXTENSIONS.STYLES.COMPILED
	.concat EXTENSIONS.VIEWS.COMPILED

	getSources = ->
		['**/*.*'].concat ("!**/*#{extension}" for extension in extensions)

	srcs = []

	if not isProd
		srcs.push src =
			gulp
			.src '**', cwd: STATS_DIST_DIRECTORY
			.on 'error', onError

	if not isProd
		srcs.push src =
			gulp
			.src getSources(), cwd: TEMP_DIRECTORY
			.on 'error', onError

	extensions = extensions
	.concat EXTENSIONS.SCRIPTS.UNCOMPILED
	.concat EXTENSIONS.STYLES.UNCOMPILED
	.concat EXTENSIONS.VIEWS.UNCOMPILED

	sources = getSources()

	srcs.push src =
		gulp
		.src sources, cwd: SRC_DIRECTORY
		.on 'error', onError

	srcs.push src =
		gulp
		.src sources, cwd: COMPONENTS_DIRECTORY
		.on 'error', onError

	es
	.merge.apply @, srcs
	.on 'error', onError

	.pipe gulp.dest DIST_DIRECTORY
	.on 'error', onError

# Generate CHANGELOG
gulp.task 'changelog', ['normalizeComponents', 'stats'], ->
	options =
		repository: pkg.repository.url
		version: pkg.version
		file: CHANGELOG_FILE
		log: gutil.log

	conventionalChangelog options, (err, log) ->
		fs.writeFile CHANGELOG_FILE, log

# Clean all build directories
gulp.task 'clean', ['clean:working'], ->
	sources = BOWER_DIRECTORY

	gulp
	.src sources, {read: false}
	.on 'error', onError

	.pipe rimraf()
	.on 'error', onError
# Clean working directories
gulp.task 'clean:working', ->
	sources = [COMPONENTS_DIRECTORY, TEMP_DIRECTORY, DIST_DIRECTORY, BOWER_FILE]

	gulp
	.src sources, {read: false}
	.on 'error', onError

	.pipe notify {message: "Starting build", onLast: true}

	.pipe rimraf()
	.on 'error', onError

# Compile CoffeeScript
gulp.task 'coffeeScript', ['prepare', 'examples-json'], ->
	options =
		coffeeLint:
			arrow_spacing:
				level: 'error'
			indentation:
				value: 1
			max_line_length:
				level: 'ignore'
			no_tabs:
				level: 'ignore'
		sourceMaps:
			sourceRoot: './'

	sources = getScriptSources '.coffee'
	srcs    = []

	srcs.push src =
		gulp
		.src sources, cwd: SRC_DIRECTORY
		.on 'error', onError

		.pipe gulp.dest TEMP_DIRECTORY
		.on 'error', onError

		.pipe coffeeLint options.coffeeLint
		.on 'error', onError

		.pipe template templateOptions
		.on 'error', onError

		.pipe ngClassify()
		.on 'error', onError

	srcs.push src =
		gulp
		.src sources, cwd: COMPONENTS_DIRECTORY
		.on 'error', onError

		.pipe gulp.dest TEMP_DIRECTORY
		.on 'error', onError

	es
	.merge.apply @, srcs
	.on 'error', onError

	.pipe sourceMaps.init()
	.on 'error', onError

	.pipe coffeeScript()
	.on 'error', onError

	.pipe sourceMaps.write './', options.sourceMaps
	.on 'error', onError

	.pipe gulp.dest TEMP_DIRECTORY
	.on 'error', onError

# Compile CSS
gulp.task 'css', ['prepare'], ->
	sources = '**/*.css'
	srcs    = []

	srcs.push src =
		gulp
		.src sources, cwd: SRC_DIRECTORY
		.on 'error', onError

		.pipe gulp.dest TEMP_DIRECTORY
		.on 'error', onError

		.pipe template templateOptions
		.on 'error', onError

	srcs.push src =
		gulp
		.src sources, cwd: COMPONENTS_DIRECTORY
		.on 'error', onError

	es
	.merge.apply @, srcs
	.on 'error', onError

	.pipe gulp.dest TEMP_DIRECTORY
	.on 'error', onError

# Default build
gulp.task 'default', [].concat(if runServer then ['open'] else ['build']).concat(if runWatch then ['watch'] else []).concat(if runSpecs then ['test'] else [])

# Execute E2E tests
gulp.task 'e2e', ->
	e2eConfigFile       = path.join './', TEMP_DIRECTORY, 'e2e-config.coffee'
	phantomjsBinaryPath = windowsify './node_modules/.bin/phantomjs.cmd', './node_modules/phantomjs/bin/phantomjs'
	sources             = '**/*.spec.{coffee,js}'

	# create temporary e2e-config file to avoid an additional config file
	# currently gulp-protractor requires one the existence of an e2e-config file
	do (e2eConfigFile) ->
		doesExist = fs.existsSync TEMP_DIRECTORY

		if !doesExist
			throw new Error 'The app must be currently running (gulp).'

		contents = 'exports.config = {}'

		fs.writeFileSync e2eConfigFile, contents

	options =
		protractor:
			configFile: e2eConfigFile
			args: [
				'--baseUrl', appUrl
				'--browser', 'phantomjs'
				'--capabilities.phantomjs.binary.path', phantomjsBinaryPath
			]

	gulp
	.src sources, {cwd: E2E_DIRECTORY, read: false}
	.on 'error', onError

	.pipe protractor.protractor options.protractor
	.on 'error', onError

# Start E2E driver
gulp.task 'e2e-driver', protractor.webdriver_standalone

# Update E2E driver
gulp.task 'e2e-driver-update', protractor.webdriver_update

# Process fonts
gulp.task 'fonts', ['fontTypes'], ->
	sources = [].concat ("**/*#{extension}" for extension in EXTENSIONS.FONTS.COMPILED)

	src =
		gulp
		.src sources, cwd: TEMP_DIRECTORY
		.on 'error', onError

	return if isProd
		src
		.pipe flatten()
		.on 'error', onError

		.pipe gulp.dest path.join DIST_DIRECTORY, FONTS_DIRECTORY
		.on 'error', onError

	src
	.pipe gulp.dest path.join DIST_DIRECTORY
	.on 'error', onError

# Compile fontTypes
gulp.task 'fontTypes', ['prepare'], ->
	sources = [].concat ("**/*#{extension}" for extension in EXTENSIONS.FONTS.COMPILED)
	srcs    = []

	srcs.push src =
		gulp
		.src sources, cwd: SRC_DIRECTORY
		.on 'error', onError

	srcs.push src =
		gulp
		.src sources, cwd: COMPONENTS_DIRECTORY
		.on 'error', onError

	es
	.merge.apply @, srcs
	.on 'error', onError

	.pipe gulp.dest TEMP_DIRECTORY
	.on 'error', onError

# Compile html
gulp.task 'html', ['prepare'], ->
	sources = [
		'**/examples/**'
		'**/*.html'
		'!index.html'
	]

	srcs = []

	srcs.push src =
		gulp
		.src sources, cwd: SRC_DIRECTORY
		.on 'error', onError

		.pipe gulp.dest TEMP_DIRECTORY
		.on 'error', onError

		.pipe template templateOptions
		.on 'error', onError

	srcs.push src =
		gulp
		.src sources, cwd: COMPONENTS_DIRECTORY
		.on 'error', onError

	es
	.merge.apply @, srcs
	.on 'error', onError

	.pipe gulp.dest TEMP_DIRECTORY
	.on 'error', onError

# Process images
gulp.task 'images', ['imageTypes'], ->
	sources = [].concat ("**/*#{extension}" for extension in EXTENSIONS.IMAGES.COMPILED)

	src =
		gulp
		.src sources, cwd: TEMP_DIRECTORY
		.on 'error', onError

	return if isProd
		src
		.pipe imagemin()
		.on 'error', onError

		.pipe gulp.dest path.join DIST_DIRECTORY
		.on 'error', onError

	src
	.pipe gulp.dest path.join DIST_DIRECTORY
	.on 'error', onError

# Compile imageTypes
gulp.task 'imageTypes', ['prepare'], ->
	sources = [].concat ("**/*#{extension}" for extension in EXTENSIONS.IMAGES.COMPILED)
	srcs    = []

	srcs.push src =
		gulp
		.src sources, cwd: SRC_DIRECTORY
		.on 'error', onError

	srcs.push src =
		gulp
		.src sources, cwd: COMPONENTS_DIRECTORY
		.on 'error', onError

	es
	.merge.apply @, srcs
	.on 'error', onError

	.pipe gulp.dest TEMP_DIRECTORY
	.on 'error', onError

# Compile JavaScript
gulp.task 'javaScript', ['prepare'], ->
	options =
		jsHint:
			camelcase: true
			curly: true
			eqeqeq: true
			forin: true
			freeze: true
			immed: true
			indent: 1
			latedef: true
			newcap: true
			noarg: true
			noempty: true
			nonbsp: true
			nonew: true
			plusplus: true
			undef: true
			unused: true
			predef: PREDEFINED_GLOBALS

	sources = getScriptSources '.js'
	srcs    = []

	srcs.push src =
		gulp
		.src sources, cwd: SRC_DIRECTORY
		.on 'error', onError

		.pipe gulp.dest TEMP_DIRECTORY
		.on 'error', onError

		.pipe jsHint options.jsHint
		.on 'error', onError

		.pipe jsHint.reporter 'default'
		.on 'error', onError

		.pipe template templateOptions
		.on 'error', onError

	srcs.push src =
		gulp
		.src sources, cwd: COMPONENTS_DIRECTORY
		.on 'error', onError

	es
	.merge.apply @, srcs
	.on 'error', onError

	.pipe gulp.dest TEMP_DIRECTORY
	.on 'error', onError

# Copy templates for unit tests (so we don't have to have scripts depend on templateCache)
gulp.task 'copyTemplates', ->
  gulp
    .src ['**/templates.js'], cwd: TEMP_DIRECTORY
    .on 'error', onError

    .pipe gulp.dest DIST_DIRECTORY
    .on 'error', onError

# Execute karma unit tests
gulp.task 'karma', ['copyTemplates'], ->
	options =
		autoWatch: false
		background: true
		basePath: DIST_DIRECTORY
		browsers: [].concat if testIE9 then ['IE9'] else ['PhantomJS']
		customLaunchers:
			IE9:
				base: 'IE'
				'x-ua-compatible': 'IE=EmulateIE9'
		colors: true
		exclude: ["#{STATS_DIST_DIRECTORY}**"]
		files: SCRIPTS.filter (p) -> p.indexOf("!") < 0
		frameworks: [
			'jasmine'
		]
		keepalive: false
		logLevel: 'WARN'
		reporters: [
			'spec'
			'dots'
			'junit'
		]
		junitReporter: [
			outputFile: ['test-results.xml']
		]
		singleRun: true
		transports: [
			'flashsocket'
			'xhr-polling'
			'jsonp-polling'
		]
	karma.server.start options

# Compile Less
gulp.task 'less', ['prepare'], ->
	options =
		less:
			sourceMap: true
			sourceMapBasepath: path.resolve TEMP_DIRECTORY
			paths: [ SRC_DIRECTORY + "/contents/styles" ]

	sources = ['**/contents/styles/*.less', "!**/_*.*", "!**/**proximanova**/stylesheet.less" ]
	srcs    = []

	srcs.push src =
		gulp
		.src sources, cwd: SRC_DIRECTORY
		.on 'error', onError

		.pipe gulp.dest TEMP_DIRECTORY
		.on 'error', onError

		.pipe template templateOptions
		.on 'error', onError

	srcs.push src =
		gulp
		.src sources, cwd: COMPONENTS_DIRECTORY
		.on 'error', onError

		.pipe gulp.dest TEMP_DIRECTORY
		.on 'error', onError

	es
	.merge.apply @, srcs
	.on 'error', onError

	.pipe less options.less
	.on 'error', onError

	.pipe gulp.dest TEMP_DIRECTORY
	.on 'error', onError

# Compile Markdown
gulp.task 'markdown', ['prepare'], ->
	sources = '**/*.{md,markdown}'
	srcs    = []

	srcs.push src =
		gulp
		.src sources, cwd: SRC_DIRECTORY
		.on 'error', onError

		.pipe gulp.dest TEMP_DIRECTORY
		.on 'error', onError

		.pipe template templateOptions
		.on 'error', onError

	srcs.push src =
		gulp
		.src sources, cwd: COMPONENTS_DIRECTORY
		.on 'error', onError

		.pipe gulp.dest TEMP_DIRECTORY
		.on 'error', onError

	es
	.merge.apply @, srcs
	.on 'error', onError

	.pipe markdown()
	.on 'error', onError

	.pipe gulp.dest TEMP_DIRECTORY
	.on 'error', onError

# Proxy for Markdown
gulp.task 'md', ['markdown']

# Normalize Bower components
gulp.task 'normalizeComponents', ['bower'], ->
	bowerComponents = do ->
		bowerJson =
			_comment: 'THIS FILE IS AUTOMATICALLY GENERATED.  DO NOT EDIT.'
			name: pkg.name
			version: pkg.version
			devDependencies: {}

		components = {}

		for component, value of BOWER_COMPONENTS
			for version, componentTypes of value
				bowerJson.devDependencies[component] = version

				for componentType, files of componentTypes
					isArray         = Array.isArray files
					filesToAdd      = if isArray then files else [files]
					filesToAdd      = filesToAdd.map (file) -> path.join component, file
					key             = path.join component, componentType
					components[key] = [] if not components[key]
					components[key] = components[key].concat filesToAdd

		fs.writeFile 'bower.json', JSON.stringify bowerJson, {}, '\t'

		components

	srcs = for componentType, sources of bowerComponents
		gulp
		.src sources, cwd: BOWER_DIRECTORY
		.on 'error', onError

		.pipe gulp.dest path.join COMPONENTS_DIRECTORY, VENDOR_DIRECTORY, componentType
		.on 'error', onError

	srcs.push src =
		gulp
		.src FILES_VENDOR_THIRD_PARTY, cwd: THIRD_PARTY_DIRECTORY
		.on 'error', onError
		.pipe gulp.dest path.join COMPONENTS_DIRECTORY, THIRD_PARTY_DIRECTORY
		.on 'error', onError

	es.merge.apply @, srcs

# Open the app in the default browser
gulp.task 'open', ['server'], ->
	openApp()

# Execute Plato complexity analysis
gulp.task 'plato', ['clean:working'], ->
	options =
		plato:
			title: "#{pkg.name} v#{pkg.version}"

	srcs = []

	srcs.push src =
		gulp
		.src '**/*.coffee', cwd: SRC_DIRECTORY
		.on 'error', onError

		.pipe template templateOptions
		.on 'error', onError

		.pipe ngClassify()
		.on 'error', onError

		.pipe coffeeScript()
		.on 'error', onError

	srcs.push src =
		gulp
		.src '**/*.js', cwd: SRC_DIRECTORY
		.on 'error', onError

		.pipe template templateOptions
		.on 'error', onError

	es
	.merge.apply @, srcs
	.on 'error', onError

	.pipe gulp.dest DIST_DIRECTORY
	.on 'error', onError

	.pipe plato STATS_DIRECTORY, options.plato
	.on 'error', onError

# Prepare for compilation
gulp.task 'prepare', ['normalizeComponents', 'clean:working']

# Reload the app in the default browser
gulp.task 'reload', ['build'], ->
	sources = 'index.html'

	gulp
	.src sources, {cwd: DIST_DIRECTORY, read: false}
	.on 'error', onError

	.pipe connect.reload()
	.on 'error', onError

	.pipe notify "Reloading...."

# Compile Sass
gulp.task 'sass', ['prepare'], ->
	options =
		sass:
			errLogToConsole: true, includePaths: [SRC_DIRECTORY + "/contents/styles"]

	sources = '**/*.scss'
	srcs    = []

	srcs.push src =
		gulp
		.src sources, cwd: SRC_DIRECTORY
		.on 'error', onError

		.pipe gulp.dest TEMP_DIRECTORY
		.on 'error', onError

		.pipe template templateOptions
		.on 'error', onError

	srcs.push src =
		gulp
		.src sources, cwd: COMPONENTS_DIRECTORY
		.on 'error', onError

		.pipe gulp.dest TEMP_DIRECTORY
		.on 'error', onError

	es
	.merge.apply @, srcs
	.on 'error', onError

	.pipe sass options.sass
	.on 'error', onError

	.pipe gulp.dest TEMP_DIRECTORY
	.on 'error', onError

# Process scripts
gulp.task 'scripts', ['scripts-ie8', 'coffeeScript', 'javaScript'].concat(if isProd then 'templateCache' else []), ->
	sources = do (ext ='.js') ->
		SCRIPTS
		.concat if not useBackendless then ["!**/angular-mocks#{ext}"] else []
		.concat if not useBackendless then ["!**/*.backend#{ext}"]     else []
		.concat if not runSpecs       then ["!**/*.spec#{ext}"]        else []

	src =
		gulp
		.src sources, cwd: TEMP_DIRECTORY
		.pipe gulpIf rmDebug, stripDebug()
		.on 'error', onError

	return if isProd
		src
		.pipe ngAnnotate()
		.on 'error', onError

		.pipe concat SCRIPTS_MIN_FILE
		.on 'error', onError

		.pipe uglify uglifyOptions
		.on 'error', onError

		.pipe rev()
		.on 'error', onError

		.on 'data', onRev
		.on 'error', onError

		.on 'data', onScript
		.on 'error', onError

		.pipe gulp.dest path.join DIST_DIRECTORY, SCRIPTS_MIN_DIRECTORY
		.on 'error', onError

	src
	.on 'data', onScript
	.on 'error', onError

	.pipe gulp.dest DIST_DIRECTORY
	.on 'error', onError

# Process scripts for IE8
gulp.task 'scripts-ie8', ['coffeeScript', 'javaScript'].concat(if isProd then 'templateCache' else []), ->
	sources = do (ext ='.js') ->
		SCRIPTS_IE8
		.concat if not useBackendless then ["!**/angular-mocks#{ext}"] else []
		.concat if not useBackendless then ["!**/*.backend#{ext}"]     else []
		.concat if not runSpecs       then ["!**/*.spec#{ext}"]        else []

	src =
		gulp
		.src sources, cwd: TEMP_DIRECTORY
		.on 'error', onError

	return if isProd
		src
		.pipe ngAnnotate()
		.on 'error', onError

		.pipe concat SCRIPTS_IE8_MIN_FILE
		.on 'error', onError

		.pipe uglify()
		.on 'error', onError

		.pipe rev()
		.on 'error', onError

		.on 'data', onRev
		.on 'error', onError

		.on 'data', onScriptIe8
		.on 'error', onError

		.pipe gulp.dest path.join DIST_DIRECTORY, SCRIPTS_MIN_DIRECTORY
		.on 'error', onError

	src
	.on 'data', onScriptIe8
	.on 'error', onError

	.pipe gulp.dest DIST_DIRECTORY
	.on 'error', onError

# Start a web server without rebuilding
gulp.task 'serve', ->
	startServer()
	openApp()

# Start a web server
gulp.task 'server', ['build'], ->
	startServer()

# Process SPA
gulp.task 'spa', ['scripts', 'styles'].concat(if isProd then 'templateCache' else 'views'), ->
	options =
		minifyHtml:
			empty: true
			quotes: true
			conditionals: true
			comments: true # conditionals isn't working, so we have to keep all the comments
		template: JSON.parse JSON.stringify templateOptions

	# clear scripts and styles for reload
	templateOptions.scripts = []
	templateOptions.styles  = []
	templateOptions.scriptsIe8  = []
	templateOptions.examples = []


	sources = 'index.html'

	src =
		gulp
		.src sources, cwd: SRC_DIRECTORY
		.on 'error', onError

		.pipe template options.template
		.on 'error', onError

	return if isProd
		src
		.pipe minifyHtml options.minifyHtml
		.on 'error', onError

		.pipe gulp.dest DIST_DIRECTORY
		.on 'error', onError

	src
	.pipe gulp.dest DIST_DIRECTORY
	.on 'error', onError

# Execute stats
gulp.task 'stats', ['plato']

gulp.task 'preprocessstyles', ['less', 'css', 'sass'], ->
	sources = STYLES
	return if isProd
		src =
			gulp
			.src sources, cwd: TEMP_DIRECTORY
			.on 'error', onError

			.pipe replaceCSSUrls()
			.on 'error', onError


# Process styles
gulp.task 'styles', ['preprocessstyles'], ->
	options =
		minifyCss:
			keepSpecialComments: 0

	sources = STYLES
	return if isProd
		src =
			gulp
			.src sources, cwd: STYLES_TEMP_DIRECTORY
			.on 'error', onError

			.pipe concat STYLES_MIN_FILE
			.on 'error', onError

			.pipe minifyCss options.minifyCss
			.on 'error', onError

			# gulp-bless is for IE compatibility
			.pipe bless { imports: false }
			.on 'error', onError

			.pipe rev()
			.on 'error', onError

			.on 'data', onRev
			.on 'error', onError

			.on 'data', onStyle
			.on 'error', onError

			.pipe gulp.dest path.join DIST_DIRECTORY, STYLES_MIN_DIRECTORY
			.on 'error', onError

	src =
		gulp
		.src sources, cwd: TEMP_DIRECTORY
		.on 'error', onError

		.on 'data', onStyle
		.on 'error', onError

		.pipe gulp.dest DIST_DIRECTORY
		.on 'error', onError

# Compile templateCache
gulp.task 'templateCache', ['html', 'markdown'], ->
	options =
		templateCache:
			module: APP_NAME

	sources = [
		'**/*.html'
		'**/*.coffee'
		'**/examples/**'
		'!index.html'
	]

	gulp
	.src sources, cwd: TEMP_DIRECTORY
	.on 'error', onError

	.pipe templateCache options.templateCache
	.on 'error', onError

	.pipe gulp.dest TEMP_DIRECTORY
	.on 'error', onError

# Execute unit tests
# Kanchan : 10/06/2014 :  added templateCache as dependencies so that we have templates availiable for jasmine tests
gulp.task 'test', ['build','templateCache'], ->
	# launch karma in a new process to avoid blocking gulp
	command = windowsify '.\\node_modules\\.bin\\gulp.cmd', 'gulp'

	# get args from parent process to pass on to child process
	args  = ("--#{key}=#{value}" for own key, value of yargs.argv when key isnt '_' and key isnt '$0')
	args  = ['karma'].concat args
	spawn = childProcess.spawn command, args, {stdio: 'inherit'}

# Process views
gulp.task 'views', ['html', 'markdown'], ->
	sources = [
		'**/*.html'
		'!index.html'
	]

	gulp
	.src sources, cwd: TEMP_DIRECTORY
	.on 'error', onError

	.pipe gulp.dest DIST_DIRECTORY
	.on 'error', onError

# Watch and recompile on-the-fly
gulp.task 'watch', ['build'], ->
	tasks = ['reload'].concat if runSpecs then ['test'] else []

	extensions = []
	.concat EXTENSIONS.FONTS.COMPILED
	.concat EXTENSIONS.IMAGES.COMPILED
	.concat EXTENSIONS.SCRIPTS.COMPILED
	.concat EXTENSIONS.SCRIPTS.UNCOMPILED
	.concat EXTENSIONS.STYLES.COMPILED
	.concat EXTENSIONS.STYLES.UNCOMPILED
	.concat EXTENSIONS.VIEWS.COMPILED
	.concat EXTENSIONS.VIEWS.UNCOMPILED

	sources = [].concat ("**/*#{extension}" for extension in extensions)

	gulp
	.watch sources, {cwd: SRC_DIRECTORY, maxListeners: 999}, tasks
	.on 'error', onError

gulp.task 'examples-json', [], ->
	sources = [
		'**/examples/**'
		'!**/_*'
	]

	gulp
	.src sources, cwd: SRC_DIRECTORY
	.on 'error', onError
	.on 'data', (file) ->
		filePath = path.relative file.base, file.path
		filePath = unixifyPath filePath
		templateOptions.examples.push filePath