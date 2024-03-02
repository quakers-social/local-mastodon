## Running Mastodon Locally


cheat sheet of docker commands
```
docker compose up -d  # start everything
docker compose down   # stop everything
```

connect to the machine running Rails
```
docker exec -it local-mastodon-web-1 /bin/bash
```


## Restart from scratch

Remote volumes are mapped to these local directories:
```
rm -rf public redis postgres14
```

## Initial Setup

Seems like mastodon wants to know its own hostname
or maybe its just that its local ip address is different

add this line to `/etc/hosts`
```
127.0.0.1	mastodon.local
```

Not quite sure why the following particular environment vars are needed 
for setup. I initially tried using [these instructions](https://www.flynsarmy.com/2023/10/running-a-mastodon-instance-with-docker/) and then simplified by matching these
to what the setup script prompts for. 

```
mkdir -p public/system redis postgres14
cat << EOM > .env.production
DB_HOST=db
DB_PORT=5432
DB_NAME=postgres
DB_USER=postgres
DB_PASS=
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_PASSWORD=
EOM
```

Run the Rails mastodon setup:
```
docker-compose run --rm web bundle exec rake mastodon:setup
```

Output including the answers that seem to work for me:

```
Your instance is identified by its domain name. Changing it afterward will break things.
Domain name: mastodon.local

Single user mode disables registrations and redirects the landing page to your public profile.
Do you want to enable single user mode? No

Are you using Docker to run Mastodon? Yes

PostgreSQL host: db
PostgreSQL port: 5432
Name of PostgreSQL database: postgres
Name of PostgreSQL user: postgres
Password of PostgreSQL user: 
Database configuration works! 🎆

Redis host: redis
Redis port: 6379
Redis password: 
Redis configuration works! 🎆

Do you want to store uploaded files on the cloud? No

Do you want to send e-mails from localhost? yes
E-mail address to send e-mails "from": Mastodon <notifications@mastodon.local>
Send a test e-mail with this configuration right now? no

Do you want Mastodon to periodically check for important updates and notify you? (Recommended) no

This configuration will be written to .env.production
Save configuration? Yes
Below is your configuration, save it to an .env.production file outside Docker:

# Generated with mastodon:setup on 2024-03-02 12:11:58 UTC

# Some variables in this file will be interpreted differently whether you are
# using docker-compose or not.
```

... all your variables here ... **copy into local `.env.production` file**

```
It is also saved within this container so you can proceed with this wizard.

Now that configuration is saved, the database schema must be loaded.
If the database already exists, this will erase its contents.
Prepare the database now? Yes
Running `RAILS_ENV=production rails db:setup` ...


Database 'postgres' already exists
Done!

All done! You can now power on the Mastodon server 🐘

Do you want to create an admin user straight away? Yes
Username: admin
E-mail: admin@mastodon.local
```

Now all the servers can be started up:
```
docker compose up -d
```

If you are using Chrome, it doesn't like to use http, but using incognito 
window will prevent it from forcing https

go to: http://mastodon.local:3000/