![Chaplin](http://s3.amazonaws.com/imgly_production/3401027/original.png)

# Chaplin Service Providers
In common.js. If you want to use AMD, you’ll need to slightly change stuff.

## Usage
1. Copy `controllers/session_controller` to your app and init session controller in application class (`new SessionController()`).
2. Copy all included `lib`, `models` and `views` to your directories.
3. Add providers to your `SessionController`, like this:

    ```coffeescript
    class SessionController extends Controller
      @serviceProviders =
        facebook: new Facebook()
    ```

Example application with the addon: https://github.com/paulmillr/ostio.

## [The Cast](https://github.com/chaplinjs/chaplin/blob/master/AUTHORS.md#the-cast)

## [The Producers](https://github.com/chaplinjs/chaplin/blob/master/AUTHORS.md#the-producers)
