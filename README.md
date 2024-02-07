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
  export SECRET_KEY_BASE=GEN_secret
   ```



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

![Alt text](.github/workflows/Flow_diagram.png "System Flow")


The Phoenix app is hosted on a vm with scale count set to 2 and connected to a Postgres instance on Fly.io.

## Special Considerations and Improvements: 

### Scalability : 

- Scaling in Fly.io as far as I can understand happens automatically when the soft limit/hard limit is hit for the concurrency numbers set, so for now there are 2 VMs running with a soft limit of 300 and a hard limit of 500. Eyeballing these numbers for now, but a more accurate number will require some load testing and observing traffic further. 

- Min machines available set to 1 to prevent issues due to cold start.

- Rolling strategy set by default should make sure the service doesn't go down totally during deployment. 

- If there are multiple elixir nodes which aren't clustered, this solution should be scalable but with the exception of being able to update the live view only in the node the GenServer is attached to as the PubSub call won't propogate to other nodes. 

- On the other hand if the elixir nodes are connected as a cluster, there would be a problem with all Genserver processes across the cluster intercepting a PubSub call from any one of the nodes. This would need to be handled before scaling up. 

- Possible solutions: 
     * Database locking to prevent concurrent writes of metrics.
     * Pushing to a common queue maintained in Redis that the GenServer can probably pick off of and store metrics later.  
     * A possible way to manage these GenServer processes using PG2 

Probably have to look into these further to better understand solutions to concurrency.

### Security:
- All routes with the exception of the home page, login pages and redirection URLs can only be accessed by authorized users.

- Using static code analysis tool Sobelow recommended by the community to look for any vulnerabilities. 

- Look further into enabling SSL with the app and adding CSP as recommended by Sobelow warnings.


### Metrics: 

- Add currently displayed aggregate metrics and daily impressions etc further per specific URL, haven't done it now due to time constraints and keeping things simple.  

### Demo 

Demo-URL: https://events-url-shortener.fly.dev

Username: admins@events.inc
</br>
Password: adminuser123!
</br>
Demo Shrink URL: https://events-url-shortener.fly.dev/ZMmf


