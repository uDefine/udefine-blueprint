### Http Interceptor ###
## Redirects to login if a user isnt authenticated ##

services.factory('httpInterceptor', ($q, $injector, $location) ->
	
	'response': (response) ->
		if response.status is 401
			$injector.get('$state').go('sign_in')
			$q.reject(response)
		response or $q.when(response)

	'responseError': (response) ->
		if response.status is 401 or response.status is 403
			$injector.get('$state').go('sign_in')

		$q.reject(response)

)