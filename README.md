# Coders

An fun project for myself to experience all kinds of cool technologies (ES6 + ReactJS + Flue + browserify + Material Design + Elixir + Phoenix + RethinkDB + ...).

The features of the project is to collect data from Github to ananlyze a coder's behaviors, metrics, etc. But currently it's just a very basic implementation.

# Run

## Use Docker

This is the most convenient way to run this project.

  1. Install docker on your machine.
  2. Pull rethinkdb image with `sudo docker pull rethinkdb:2.1.1` (I'm developing against 2.1.1).
  3. Pull the phoenix image (search it on docker hub). Or, there is a phoenix docker file (`docker_files/phoenix`) which will build a phoenix 1.0.2 docker image for you. E.g.

    $> sudo docker build -f "/path/to/project/docker_files/phoenix" -t gimi/phoenix:1.0.2

  4. Run RethinkDB (check `bin/rundb`).
  5. Install elixir dependencies (check `bin/install_deps`).
  6. Install node modules (check `bin/install_node_modules`).
  7. Init DB (check `bin/initdb`).
  8. Start the app (check `bin/run`).

## Without Docker

Or you can run without docker by installing node + npm + elixir into your system. And follow the steps above except the docker related steps.

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: http://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## Author

Gimi Liang <`liang.gimi@gmail.com`>

## License

MIT
