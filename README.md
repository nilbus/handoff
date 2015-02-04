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

1. Generate the war file handoff.war:

        bin/build-war

    or

        rvm use jruby                               # use JRuby and its gems for packaging
        bundle install --deployment                 # prepare gems for deployment
        RAILS_ENV=production rake assets:precompile # compile assets (js, css)
        warble                                      # generate the war file
        bundle install --no-deployment              # allow gems to be modified
        rvm use default                             # use standard Ruby for development

2. Deploy to a Tomcat app server:

    * (once) Make the catalina startup script executable

            chmod +x bin/catalina.sh

    * Start the Tomcat app server

            bin/catalina.sh start

    * Copy or symlink the handoff.war file into the `tomcat/webapps/` directory
    * Visit http://localhost:8080/handoff/
