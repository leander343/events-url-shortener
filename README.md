# EventsUrlShortener


## Pre-requisites: 

- Elixir and Phoenix framework setup.
- PostgreSQL for database management.
- GeoIP API key from a supported IP lookup service
- Sendgrid key 

## To start your Phoenix dev server:

- Setup system env variables or add these in .env file and run `source .env`

  ```
  export POSTGRES_USERNAME=<username>
  export POSTGRES_PASSWORD=<password>
  export POSTGRES_DATABASE=<database-name>
  export GEOIP_API_KEY=<key>
  export SENDGRID_API_KEY=<key>
  export SECRET_KEY_BASE=<gen_secret>
   ```
SECRET_KEY_BASE can be generated using `mix phx.gen.secret`



- Run `mix setup` to install and setup dependencies
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## To start build for prod and run the project:


- Setup system variables

  ```
   export MIX_ENV=prod
   export SECRET_KEY_BASE=GEN_secret
   export DATABASE_URL=ecto://USER:PASS@HOST/database
   export GEOIP_API_KEY=<key>
   export SENDGRID_API_KEY=<key>
   ```

- Install and run compile release
   `mix deps.get --only prod`

    `mix compile`

- Compile assets

   `mix assets.deploy`

- Custom tasks (like DB migrations)

   `mix ecto.migrate`

- Finally run the server

   `mix phx.server`


## Architecture and flow: 

![Alt text](.github/workflows/flowDiagram.png "System Flow")


The Phoenix app is hosted on a vm with scale count set to 2 and connected to a dev Postgres cluster on Fly.io. 
Load balacing to the machines are handled by Fly.io and doesn't require any additonal setup. 

## Special Considerations and Improvements: 

### Scalability & Reliability : 

- Scaling in Fly.io as far as I can understand has to be done manually for current versions, have to a bit of load testing to determine maximum concurrent connections. 

- There are 2 Vm's running right now with a Soft limit of 300 and Hard limit of 500 concurrent connections. These values are based on an assumption for now, an optimal can be arrived at by observing metrics based on traffic. 

- Min machines available set to 1 to keep a server running at all times and to keep costs low while preventing delays caused by cold start.

- Rolling strategy set by default by Fly.io to prevent service from going down during deployments. 

- If there are multiple elixir nodes which aren't clustered, this solution can be scalable but with the exception of not being able to propogate the pub sub call across all nodes and updating live view.  

- On the other hand if the elixir nodes are connected as a cluster, pub sub calls will be intercepted by every Gen Server subscribed to the topic resulting in multiple writes of the same metric. 

- Possible solutions: 
     * Database locking to prevent concurrent writes of metrics.
     * Using a process registry so only a GenServer handles the PubSub call.

The second case might be a bit more preferrable preventing connections being made to the Database server by every GenServer process on a pubsub call. 

Probably have to look into these further to better understand these solutions and building it using Elixir. 

### Security:
- All routes with the exception of the home page, login pages and redirection URLs can only be accessed by authorized users.

- Using static code analysis tool Sobelow recommended by the community to look for any vulnerabilities. 

- Look further into enabling SSL with the app and adding CSP as recommended by Sobelow warnings.


### Metrics: 

- Add to currently displayed aggregate metrics, daily impressions, failure rates etc further per specific URL, haven't done it now due to time constraints and keeping things simple.  

### Demo 

Demo-URL: https://events-url-shortener.fly.dev

Username: admin@events.inc
</br>
Password: adminuser123!
</br>
Demo Shrink URL: https://events-url-shortener.fly.dev/ZMmf


