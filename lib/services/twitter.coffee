utils = require 'lib/utils'
ServiceProvider = require 'lib/services/service_provider'

class Twitter extends ServiceProvider
  consumerKey = 'w0uohox91TgpKETJmscYIQ'
  name: 'twitter'

  constructor: ->
    super
    @subscribeEvent '!logout', @logout

  loadSDK: ->
    return if @state() is 'resolved' or @loading
    @loading = true

    utils.loadLib "http://platform.twitter.com/anywhere.js?id=#{consumerKey}&v=1", @sdkLoadHandler, @reject

  sdkLoadHandler: =>
    @loading = false
    # Init the SDK, then resolve
    twttr.anywhere (T) =>
      @publishEvent 'sdkLoaded'
      @T = T
      @resolve()

  isLoaded: ->
    Boolean window.twttr

  publish: (event, callback) ->
    @T.trigger event, callback

  subscribe: (event, callback) ->
    @T.bind event, callback

  unsubscribe: (event) ->
    @T.unbind event

  # Trigger login popup
  triggerLogin: (loginContext) ->
    callback = _(@loginHandler).bind(this, loginContext)
    @T.signIn()
    @subscribe 'authComplete', (event, currentUser, accessToken) ->
      callback {currentUser, accessToken}
    @subscribe 'signOut', ->
      callback()

  # Publish session & userData events and
  # add all twttr api methods to @api.
  publishSession: (response) ->
    user = response.currentUser

    @publishEvent 'serviceProviderSession',
      provider: this
      userId: user.id
      accessToken: response.accessToken or twttr.anywhere.token
    @publishEvent 'userData', user.attributes

  # Callback for the login popup
  loginHandler: (loginContext, response) =>
    if response
      # Publish successful login
      @publishEvent 'loginSuccessful',
        provider: this, loginContext: loginContext

      # Publish the session
      @publishSession response
    else
      @publishEvent 'loginFail', provider: this, loginContext: loginContext

  getLoginStatus: (callback = @loginStatusHandler, force = false) ->
    callback @T

  loginStatusHandler: (response) =>
    if response.currentUser
      @publishSession response
    else
      @publishEvent 'logout'

  # Handler for the global logout event
  logout: ->
    twttr?.anywhere?.signOut?()
