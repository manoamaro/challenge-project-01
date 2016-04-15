#README


## Challenge Description
This is an app of a job application challenge. The main idea of the challenge is
to create a realtime search box, with every typed character the search box should
send the query to the server. But the focus is not to perform the search itself,
but to keep the analytics of the search. For example, the user starts to type,
and the server will receive:

- How
- How to
- How to change
- How to change me
- How to change my
- **How to change my password**

The server should only save the full query, in this case, **How to change my password**.

#### Good
- **How to change my password** (5 times)
- **How to close my account** (3 times)
- **Where is the my account info** (10 times)

#### Bad
- **How to change** (5 times)
- **How to change my password** (5 times)
- **How to** (3 times)
- **How to close my** (3 times)
- **How to close my account** (3 times)

### Considerations
You can use any database (Redis, Postgresql, MongoDB), and Sidekiq if you think it fits. But the server should be **rails >= 4**.

A well documented and clean code, nice UX, and have the server deployed in a live environment (Heroku for eg.) is a plus.

## How to run

The application is "dockerized", with **docker-compose** only for the development environment. To run all the containers, you can execute

`sh ./scripts/docker-production-start.sh`

It will run all the containers, that include the Postgres, Redis, Nginx as load balancer, Sidekiq worker and the Web server.

You can scale the application easily with docker, just extract and run the command related to run the container from the file `docker-production-start.sh` that runs the desired container, changing the name.

*TODO: improve this script to receive args and do the scaling. Docker-compose could be used here, but I had some problems in a Windows environment when I was testing.*).

Or, if you want to run each app outside Docker, you first have to configure the database in `./config/database.yml`, make sure there is a Redis Server up and running, and run:

`bundle exec sidekiq -C config/sidekiq.yml`

`bundle exec puma -C config/puma.rb`

## Approach

To keep it simple, I prefered to use a easy approach to this challenge. First of all, I couldn't know in the server side when the client really stopped to type your question, as the queries keep coming in real time.

So, I simply created a timeout by the user session using Sidekiq jobs. When the user starts to type, the server creates a new Job and schedule it to 3 seconds from now. If the user keeps typing, the job is updated and rescheduled to 3 seconds after, until the user stops to type, and after 3 seconds the Job executes and updates the analytics.

Only Redis was used. The Postgresql dependency is for Heroku deployment.

I could have used other sofisticated approaches, for example, NLP (Natural Language Processing) to figure out what the user searched after all the received query parts. Another idea is to use machine learning algorithms to analyze, after a block of received queries, what is the real query, based, for example, on the timestamp of each query part, or the syntatic proximity of each query part. These are all future works.
