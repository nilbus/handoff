Doctor-Dashboard
================

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Installing RVM and the appropriate rubies (ruby and jruby)

* Using bundler to install dependencies

* Database initialization

* ...

Deploying as a WAR file
=======================

1. Generate the war file doctor-dashboard.war:

        rvm use jruby                  # use JRuby and its gems for packaging
        bundle install --deployment    # prepare gems for deployment
        warble                         # generate the war file
        bundle install --no-deployment # allow gems to be modified
        rvm use default                # use standard Ruby for development

2. Deploy to app server: TBD
