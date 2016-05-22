# twitter_searcher
A simple RoR application for searching Twitter. As see hosted on
[https://colbys-twitter-searcher.herokuapp.com/tweets/search](https://colbys-twitter-searcher.herokuapp.com/tweets/search).

# Install
* bundle
* rake db:create
* rake db:migrate

## On Heroku
For Heroku, you'll also have to the usual stuff:

* heroku run rake db:migrate

# Services (aka microservices)
The Tweets page (/tweets/index) shows all saved tweets. The Tweets Search page
(/tweets/search) provides an HTML interface to the Tweet Search API (see below).


# APIs
## Tweet Search
Search is done via a GET with application/json to /tweets/search. The JSON
request is of the following format:

    {
        "search" : {
                "value" : "<search term>"
        }
    }

We provide a minimum API for searching Twitter, just for the things we want
searchable. The currently supported search terms are:

    * "healthcare"
    * "nasa"
    * "open source"

The data that is returned is a list of tweets, with each element in the list
a column in the tweet data:

    {
        "data": [
            [
                "screen name",
                "tweet text/body"
            ]
        ]
    }

#Design methods and considerations
This RoR app uses the idea of
[microservices](http://martinfowler.com/articles/microservices.html). Make a
pure microservice was new for me in RoR, although I've made RoR modular
components before. The idea for microservices is great, so the process will be:

1. Generate a rails component.
2. Develop the rails component's model, views, and controller for the Twitter
search.
3. Package the twitter_searcher_microservice component (MVC code) up as a gem,
remove it from this repo. Then install the gem during our install process.
This should help manage coupling and satisfy the micoservice concept.


# Rails issues
* `rails g model <...> hangs`
 * Stop spring: `spring stop`