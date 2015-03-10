'use strict'

gulp = require('gulp')
plugins = require('gulp-load-plugins')()
del = require('del')

runSequence = require('run-sequence')
browserSync = require('browser-sync')

## Variables
isDist = plugins.util.env.type is 'dist'
outputFolder = if isDist then 'dist' else 'build'

globs =
	sass: 'src/assets/css/**/*.scss'
	templates: 'src/app/**/*.jade'
	assets: 'src/app/assets'
	coffee: 'src/app/**/*.coffee'
	images: 'src/app/assets/img'
	fonts: 'src/app/assets/fonts'
	index: 'src/index.html'

destinations =
	css: outputFolder + '/assets/css'
	js: outputFolder + '/assets/js'
	assets: outputFolder + '/assets'
	libs: outputFolder + '/vendor'
	index: outputFolder

vendorLibs = [
	'bower_components/angular/angular.js'
	'bower_components/angular-resource/angular-resource.js'
	'bower_components/angular-animate/angular-animate.js'
	'bower_components/angular-sanitize/angular-sanitize.js'
	'bower_components/angular-ui-router/release/angular-ui-router.js'
	'bower_components/angular-i18n/angular-locale_nl-nl.js'
	'bower_components/angular-materialize/src/angular-materialize.js'
	'bower_components/jquery/dist/jquery.js'
	'bower_components/materialize/dist/js/materialize.js'
]

vendorLibsMin = []

injectLibsPaths = 
	dev: []
	dist: []

injectPaths = 
	dev: []
	dist: []


for lib in vendorLibs
	# take the filename
	splittedPath = lib.split('/')
	filename = splittedPath[splittedPath.length-1]
	injectLibsPaths.dev.push(destinations.libs + '/' + filename)

	# And get the minified version
	filename = filename.split('.')[0] + '.min.js'
	splittedPath[splittedPath.length-1] = filename
	vendorLibsMin.push(splittedPath.join('/'))
	injectLibsPaths.dist.push(destinations.libs + '/' + filename)



for env in ['dev', 'dist']
	injectPaths[env] = injectLibsPaths[env].concat([
		if isDist then destinations.js + '/app.js' else destinations.js + "/app/**/*.js"
		if isDist then destinations.js + '/vendors.js' else destinations.js + "/app/**/*.js"
		destinations.js + '/templates.js'
		destinations.css + '/app.css'
	])

## Tasks

gulp.task('sass', ->
	gulp.src(globs.sass)
		.pipe(plugins.sass(
			style: 'compressed'
		).on('error', (error) ->
			plugins.notify().write(error)
			this.emit('end')
		))
		.pipe(plugins.autoprefixer()) # defauls to > 1%, last 2 versions, Firefox ESR, Opera 12.1
		.pipe(if isDist then plugins.minifyCss() else plugins.util.noop())
		.pipe(gulp.dest(destinations.css))
		.on('end', ->
			plugins.notify().write('Sass compiled')
		)
		.on('error', (error) ->
			plugins.notify().write(error)
		)
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
		.on('end', ->
			plugins.notify().write('Templates compiled')
		)
		.on('error', (error) ->
			plugins.notify().write(error)
		)

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

gulp.task('copy-vendor', ->
	gulp.src(if isDist then vendorLibsMin else vendorLibs)
		.pipe(if !isDist then gulp.dest(destinations.libs) else plugins.util.noop())
		.pipe(if isDist then plugins.uglify() else plugins.util.noop()) ## ng annotate?
		.pipe(if isDist then plugins.concat('vendors.js') else plugins.util.noop())
		.pipe(gulp.dest(destinations.js))
)

gulp.task('copy-assets', ->
	gulp.src(globs.assets)
		.pipe(gulp.dest(destinations.assets))
)

gulp.task('index', ->
	target = gulp.src(globs.index)
	_injectPaths = if isDist then injectPaths.dist else injectPaths.dev
	
	target.pipe(
		plugins.inject(gulp.src(_injectPaths, { read: false} ), {
			ignorePath: outputFolder
			addRootSlash: false
		})
	).pipe(gulp.dest(destinations.index))
)


gulp.task('clean', (cb) ->
	del(['dist/', 'build/'], cb)
)

gulp.task('watch', ->
	gulp.watch(globs.sass, ['sass'])
	gulp.watch(globs.coffee, ['coffee'])
	gulp.watch(globs.templates, ['templates'])
	gulp.watch(globs.index, ['index'])
	gulp.watch(globs.assets, ['copy-assets'])

)

gulp.task('build', ->
	runSequence(
		'clean',
		['sass', 'copy-assets', 'coffee', 'templates', 'copy-vendor'],
		'index'
	)
)

gulp.task('default', ['build'], ->
	runSequence(['watch'])
)