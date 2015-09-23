APP_NAME = 'app'

BOWER_COMPONENTS =
  'jquery': '1.11.1':
    scripts: 'dist/jquery.min.js'
  'angular': '1.2.22':
    scripts: 'angular.min.js'
  'lodash': '2.4.1':
    scripts: 'dist/lodash.compat.js'
  'restangular': '1.4.0':
    scripts: 'dist/restangular.min.js'
  'angular-animate': '1.2.22':
    scripts: 'angular-animate.min.js'
  'angular-mocks': '1.2.22':
    scripts: 'angular-mocks.js'
  'angular-route': '1.2.22':
    scripts: 'angular-route.min.js'
  'angular-cookies': '1.2.22':
    scripts: 'angular-cookies.min.js'
  'angular-loading-bar': '0.5.0':
    scripts: 'build/loading-bar.min.js'
    styles:  'build/loading-bar.min.css'
  'angular-local-storage': '0.0.7':
    scripts: 'angular-local-storage.js'
  'bootstrap': '3.2.0':
    fonts:   'dist/fonts/**/*.{eot,svg,ttf,woff,otf}'
    #styles:  'dist/css/*.min.css'
    scripts: 'dist/js/bootstrap.min.js'
  'google-code-prettify': '1.0.3':
    scripts: 'src/prettify.js'
    styles:  'src/prettify.css'
  'showdown': '0.3.1':
    scripts: 'src/showdown.js'
  'html5shiv': '3.7.2':
    scripts: 'dist/html5shiv{,-printshiv}.min.js'
  'respond': '1.4.2':
    scripts: 'dest/respond{,.matchmedia.addListener}.min.js'
  'highcharts-release': 'v4.0.4':
    'scripts': 'highcharts{,-3d,-more}.src.js'
  'highmaps-release': 'v1.0.4':
    'scripts': 'modules/map.src.js'
  'proj4': '2.3.3':
    'scripts': 'dist/proj4-src.js'
  'angular-sanitize': '1.2.22':
    scripts: 'angular-sanitize.min.js'
  'ace-builds': '1.1.6':
    scripts: 'src-noconflict/{ace,{{mode,worker}-html,mode-{coffee,css,javascript,json}}}.js'
  'angular-ui-ace': '0.1.1':
    scripts: 'ui-ace.js'
  'angular-file-upload': '1.1.5':
    scripts: 'angular-file-upload.js'
  'leaflet': 'v0.7.3':
    scripts: 'dist/leaflet-src.js'
    styles: 'dist/leaflet.css'
    'styles/images': 'dist/images/*'
  'leaflet.markercluster': 'v0.4.0':
    scripts: 'dist/leaflet.markercluster-src.js'
    styles: 'dist/MarkerCluster{,.Default}.css'
  'Leaflet.label': 'master': # the ability to pick the pane isn't in a release yet
    scripts: 'dist/leaflet.label-src.js'
    styles: 'dist/leaflet.label.css'


SCRIPTS = [
  '**/jquery.min.js'
  '**/angular.min.js'
  '**/angular-animate.min.js'
  '**/angular-mocks.js'
  '**/angular-route.min.js'
  '**/angular-cookies.min.js'
  '**/angular-sanitize.min.js'
  '**/loading-bar.min.js'
  '**/lodash.compat.js'
  '**/restangular.min.js'
  '**/angular-local-storage.js'
  '**/highcharts.src.js'
  '**/foreach.js'
  '**/app.js'
  '**/leaflet-src.js'
  '**/*.js'
  '!**/*shiv*.js'
  '!**/*respond*.js'
  '!**/utils/scriptsIe8/*.js'
  '**/bootstrap.min.js'
]

SCRIPTS_IE8 = [
	'**/*shiv*.js'
	'**/*respond*.js'
	'**/utils/scriptsIe8/*.js'
]

# control the order of the CSS -- bootstrap, then wheels, then app
STYLES = [
	'**/bootstrap-wheels.css'
	'**/font-awesome.css'
	'**/wheels.css'
	'**/app.css'
	'**/*.css'
]

module.exports = {APP_NAME, BOWER_COMPONENTS, SCRIPTS, SCRIPTS_IE8, STYLES}