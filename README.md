# twitter_searcher
A simple RoR application for searching Twitter.

# Install
* bundle
* TODO - don't think we need this, but check - rails g foundation:install
* rake db:create
* rake db:migrate

# APIs
TODO

#Design methods and conciderations
This RoR app uses the idea of
[microservices](http://martinfowler.com/articles/microservices.html). Make a
pure microservice was new for me in RoR, although I've made RoR modular
components before. The idea for microservices is great, so the process will be:

1. Generate a rails component.
2. Develop the rails component's model, views, and controller for the Twitter
search.
3. Package the twitter_searcher_microservice component (MVC code) up as a gem remove it from
this repo. Then install the gem during our install process. This should help
manage coupling and satisfy the micoservice concept.

This leads us to a few design considerations/decisions:

1. We'll use sqlite3 instead of postgresql for migration simplification. We
loose performance but gain simplicity with the twitter_searcher_microservice.
For production code, ruby profilers should be used to then latter identify if
this area should be optimized with a better database.

# Rails issues
* `rails g model <...> hangs`
** Stop spring: `spring stop`