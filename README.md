Doctor-Dashboard
================

Add notes, pictures, or have a conversation in the context of an Electronic
Health Record.

Initial Setup
=============

1. Install rvm, following the instructions on the front page of http://rvm.io.
   If gpg is not a command on your system, ignore that step.

1. Open a new terminal, so the rvm script loads.

1. Install ruby:

        rvm install ruby

1. Clone the git repository, if you haven't already:

        git clone https://github.com/nilbus/handoff

   Note that this https URL requires you to enter your github credentials each
   time you authenticate. If you want to use passwordless SSH key based
   authentication isntead, follow GitHub's instructions here:
   https://help.github.com/articles/generating-ssh-keys/

1. cd into the handoff git repository

        cd handoff

1. Install ruby gems

        bundle install

1. Drop old instances of the database 

        bin/rake db:drop

1. Initialize the database

	    bin/rake db:setup

1. Seed the database

	    bin/rake db:seed


Running the application
=======================

1. `cd` into the project directory

1. Start the rails server

        bin/rails server

1. Visit http://localhost:3000

Deploying as a WAR file
=======================

1. (once) Install JRuby ~> 1.7.19 and bundler

   First install a Java JDK. Then:

        rvm install jruby-1.7.19
        rvm use jruby-1.7.19
        gem install bundler

1. Generate the war file handoff.war:

        bin/build-war

    or

        rvm use jruby-1.7.19                        # use JRuby and its gems for packaging
        bundle install --deployment                 # prepare gems for deployment
        RAILS_ENV=production rake assets:precompile # compile assets (js, css)
        bundle exec warble                          # generate the war file
        bundle install --no-deployment              # allow gems to be modified
        rvm use default                             # use standard Ruby for development

1. Deploy to a Tomcat app server:

    * `cd` into the tomcat directory (download and extract Tomcat 8 from http://tomcat.apache.org)

    * (once) Make the catalina startup script executable

            chmod +x bin/catalina.sh

    * Remove any old version of the app

            rm -rf webapps/handoff

    * Start the Tomcat app server

            bin/catalina.sh start

    * Copy or symlink the handoff.war file into the `tomcat/webapps/` directory
    * Visit http://localhost:8080/handoff/
