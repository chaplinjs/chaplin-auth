![Chaplin](http://s3.amazonaws.com/imgly_production/3401027/original.png)

# Chaplin Service Providers

## Usage
1. Clone the repository to your application `lib/services` directory.
2. Add providers to your `SessionController`, like this:

    ```coffeescript
    class SessionController extends Controller
      @serviceProviders =
        facebook: new Facebook()
    ```

3. Copy loadLib definition to your `lib/utils` from
[facebook example](https://github.com/chaplinjs/facebook-example/blob/master/coffee/lib/utils.coffee#L102-134).

## [The Cast](https://github.com/chaplinjs/chaplin/blob/master/AUTHORS.md#the-cast)

## [The Producers](https://github.com/chaplinjs/chaplin/blob/master/AUTHORS.md#the-producers)
