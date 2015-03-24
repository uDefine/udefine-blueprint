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
			$urlRouterProvider.otherwise('/dashboard')

			# $locationProvider.html5Mode(
			# 	enabled: false
			# 	requireBase: false
			# )

			# $locationProvider.hashPrefix('!')
			
			$stateProvider
				.state('app',
					url: "/"
					views:
						'header':
							templateUrl: '/templates/header.html'
						'footer':
							templateUrl: '/templates/footer.html'
				)

				.state('app.dashboard',
					url: 'dashboard'
					views:
						'body@':
							templateUrl: '/templates/home/home-view.html'
				)
				.state('app.stocks',
					url: 'stocks'
					views:
						'body@':
							templateUrl: '/templates/stocks/stocks-view.html'
				)
	)
