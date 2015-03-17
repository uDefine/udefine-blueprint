'use strict'

angular.module('app', [
	'ngResource'
	'ngSanitize'
	'ngCookies'
	'ngAnimate'

	'ui.router'

	'app.directives'
	'app.filters'
	'app.controllers'
	'app.services'
	'app.templates'
])

	.run(($http, $rootScope, $state) ->

	)

	.config(($stateProvider, $urlRouterProvider, $httpProvider, $locationProvider) ->

			$httpProvider.interceptors.push('httpInterceptor')
			$urlRouterProvider.otherwise('/inloggen')

			$locationProvider.html5Mode(
				enabled: false
				requireBase: false
			)

			$locationProvider.hashPrefix('!')

			$stateProvider

				## Admin routing ##
				.state('app',
					url: '/'
					# abstract: true
					views:
						'header':
							templateUrl: '/templates/header.html'
							controller: 'HeaderController'
						'footer':
							templateUrl: '/templates/footer.html'

				)
				.state('app.page1',
					url: '/:page'
					views:
						'body@':
							templateUrl: '/templates/page1/page.html'
							controller: 'Controller'
				)
				.state('app.page2',
					url: '/page2'
					views:
						'body@':
							templateUrl: '/templates/page2/page.html'
							controller: 'Controller'
				)



	)
