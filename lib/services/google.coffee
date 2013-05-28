utils = require 'lib/utils'
ServiceProvider = require 'lib/services/service_provider'

class Google extends ServiceProvider
  # Client-Side OAuth 2.0 login with Google
  # https://code.google.com/p/google-api-javascript-client/
  # https://code.google.com/p/google-api-javascript-client/wiki/Authentication

  # Note: This is the ID for an example Google API project.
  # You might change this to your own project ID.
  # See https://code.google.com/apis/console/
  clientId = '365800635017'
  apiKey = ''

  # The permissions we’re asking for. This is a space-separated list of URLs.
  # See https://developers.google.com/accounts/docs/OAuth2Login#scopeparameter
  # and the individual Google API documentations
  scopes = 'https://www.googleapis.com/auth/plus.me'

  name: 'google'

  load: ->
    return if @state() is 'resolved' or @loading
    @loading = true

    # Register load handler
    window.googleClientLoaded = @loadHandler

    # No success callback, there's googleClientLoaded
    utils.loadLib 'https://apis.google.com/js/client.js?onload=googleClientLoaded', null, @reject

  loadHandler: =>
    # Remove the global load handler
    gapi.client.setApiKey @apiKey
    
    try
      # IE 8 throws an exception
      delete window.googleClientLoaded
    catch error
      window.googleClientLoaded = undefined

    # Initialize
    gapi.auth.init @resolve

  isLoaded: ->
    Boolean window.gapi and gapi.auth and gapi.auth.authorize

  triggerLogin: =>
    gapi.auth.authorize
      client_id: clientId, scope: scopes, immediate: false
      @loginHandler

  loginHandler: (authResponse) =>
    if authResponse
      # Publish successful login
      @publishEvent 'loginSuccessful', {provider: this, authResponse}

      # Publish the session
      @publishEvent 'serviceProviderSession',
        provider: this
        accessToken: authResponse.access_token

      @getUserData @processUserData
      
    else
      @publishEvent 'loginFail', {provider: this, authResponse}

  getLoginStatus: =>
    gapi.auth.authorize
      client_id: clientId, scope: scopes, immediate: true
      @loginHandler

  getUserData: (callback) ->
    gapi.client.load 'plus', 'v1', ->
      request = gapi.client.plus.people.get {'userId': 'me'}
      request.execute callback

  processUserData: (response) =>
    @publishEvent 'userData',
      imageUrl: response.image.url
      name: response.displayName
      id: response.id

  parsePlusOneButton: (el) ->
    if window.gapi and gapi.plusone and gapi.plusone.go
      gapi.plusone.go el
    else
      window.___gcfg = parsetags: 'explicit'
      utils.loadLib 'https://apis.google.com/js/plusone.js', ->
        try
          # IE 8 throws an exception
          delete window.___gcfg
        catch error
          window.___gcfg = undefined

        gapi.plusone.go el
