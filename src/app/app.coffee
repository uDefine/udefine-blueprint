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

			$stateProvider
				.state('app',
					url: "/"
					views:
						'sidebar':
							templateUrl: '/templates/sidebar.html'
				)

				.state('app.dashboard',
					url: 'dashboard'
					views:
						'body@':
							templateUrl: '/templates/home/home-view.html'
				)
				.state('app.wallet',
					url: 'wallet'
					views:
						'body@':
							templateUrl: '/templates/wallet/wallet-overview-view.html'
				)
				# .state('app.wallet.overview',
				# 	url: '/overview'
				# 	views:
				# 		'body@':
				# 			templateUrl: '/templates/wallet/wallet-overview-view.html'
				# )
				.state('app.wallet.overview.detail',
					url: '/detail'
					views:
						'body@':
							templateUrl: '/templates/wallet/wallet-overview-view.html'
				)
				.state('app.wallet.goals',
					url: '/goals'
					views:
						'body@':
							templateUrl: '/templates/wallet/wallet-goals-view.html'
				)
				.state('app.stocks',
					url: 'stocks'
					views:
						'body@':
							templateUrl: '/templates/stocks/stocks-view.html'
				)
				.state('app.login',
					url: 'login'
					views:
						'body@':
							templateUrl: '/templates/login/login-view.html'
				)
	)
