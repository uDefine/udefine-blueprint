'use strict'

gulp = require('gulp')
plugins = require('gulp-load-plugins')()

# Variables
isDist = plugins.util.env.type is 'dist'
outputFolder = if isDist then 'dist' else 'build'

globs =
	sass: 'src/assets/css/**/*.scss'
	templates: 'src/app/**/*.jade'
	coffee: 'src/app/**/*.coffee'
	images: 'src/app/assets/img'
	fonts: 'src/app/assets/fonts'
	index: 'src/index.html'

destinations =
	css: outputFolder + '/assets/css'
	js: outputFolder + '/assets/js'
	assets: outputFolder + '/assets'
	index: outputFolder

vendorLibs = {
	'bower_components/angular/angular.js'
	'bower_components/angular-resource/angular-resource.js'
	'bower_components/angular-animate/angular-animate.js'
	'bower_components/angular-sanitize/angular-sanitize.js'
	'bower_components/angular-ui-router/release/angular-ui-router.js'
	'bower_components/angular-i18n/angular-locale_nl-nl.js'
	'bower_components/angular-materialize/src/angular-materialize.js'
	'bower_components/jquery/dist/jquery.js'
	'bower_components/materialize/dist/js/materialize.js'
}

injectLibsPaths = 
	dev: []
	dist: []

injectPaths = 
	dev: []
	dist: []

## Tasks

gulp.task('sass', ->
	gulp.src(globs.sass)
		.pipe(plugins.sass(
			style: 'compressed'
			errLogToConsole: true
		))
		.pipe(plugins.autoprefixer()) # defauls to > 1%, last 2 versions, Firefox ESR, Opera 12.1
		.pipe(gulp.dest(destinations.css))
)

gulp.task('templates', ->
	gulp.src(globs.templates)
		.pipe(plugins.jade(
			locals: {}
		).on('error', (error) ->
			plugins.notify().write(error)
			this.emit('end')
		))
		.pipe(plugins.angularTemplatecache(
			module: 'app.template'
			root: '/templates'
			standalone: true
		))
		.pipe(if isDist then plugins.uglify() else plugins.util.noop())
		.pipe(gulp.dest(destinations.js))
)

gulp.task('coffee', ->
	gulp.src(globs.coffee)
		.pipe(plugins.coffee(
			bare: true
		).on('error', (error) ->
			plugins.notify().write(error)
		))
		.pipe(plugins.ngAnnotate())
		.pipe(plugins.concat('app.js'))
		.pipe(if isDist then plugins.uglify() else plugins.util.noop())
		.pipe(gulp.dest(destinations.js))
)

gulp.task('index', ->
	target = gulp.src(globs.index)
	_injectPaths = if isDist then injectPaths.dist else injectPaths.dev
)

gulp.task('default', ['templates', 'sass', 'coffee'])