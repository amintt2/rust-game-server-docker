[![Poetry](https://img.shields.io/endpoint?url=https://python-poetry.org/badge/v0.json)](https://python-poetry.org/)
[![Ruff](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/astral-sh/ruff/main/assets/badge/v2.json)](https://github.com/astral-sh/ruff)
[![codecov](https://codecov.io/gh/max-pfeiffer/rust-game-server-docker/graph/badge.svg?token=RfzYdxhvCd)](https://codecov.io/gh/max-pfeiffer/rust-game-server-docker)
![pipeline workflow](https://github.com/max-pfeiffer/rust-game-server-docker/actions/workflows/pipeline.yaml/badge.svg)
![publish workflow](https://github.com/max-pfeiffer/rust-game-server-docker/actions/workflows/publish.yaml/badge.svg)
![Docker Image Size (latest semver)](https://img.shields.io/docker/image-size/pfeiffermax/rust-game-server?sort=semver)
![Docker Pulls](https://img.shields.io/docker/pulls/pfeiffermax/rust-game-server)

# Rust Dedicated Game Server - Docker Image
This Docker image provides a [Rust](https://rust.facepunch.com/) dedicated game server.

[Facepunch](https://facepunch.com/) releases an [update](https://rust.facepunch.com/changes) for Rust monthly every
first Thursday. Also, there are irregular updates every now and then. Each update requires players and servers to
update their versions of the game.

Therefore, an automation checks the [Rust release branch](https://steamdb.info/app/258550/depots/?branch=release) every
night. If a new release was published by [Facepunch](https://facepunch.com/), a new Docker image will be built with this
new version. Just use the `latest` tag and you will always have an up-to-date Docker image.

Kudus to:
* [@jonakoudijs](https://github.com/jonakoudijs) for providing the [Steamcmd Docker image](https://github.com/steamcmd/docker) which is used here
* [@detiam](https://github.com/detiam) for maintaining a working fork for the [Steam websocket client](https://github.com/detiam/steam_websocket) 

**Docker Hub:** https://hub.docker.com/r/pfeiffermax/rust-game-server

**GitHub Repository:** https://github.com/max-pfeiffer/rust-game-server-docker

## Oxide
Since v1.1.0 I provide an [Oxide](https://umod.org/games/rust) variant of this image. The automation checks for
[a new Oxide release on GitHub](https://github.com/OxideMod/Oxide.Rust/releases) every night and builds a new image
based on the latest version of my Rust Docker image.

The tag of these images is prefixed with `oxide-build`. So look out for these
[tags on Docker Hub](https://hub.docker.com/r/pfeiffermax/rust-game-server/tags) if you want to run Rust with Oxide.
There is also a `latest-oxide` tag, so you can use this to always run an up-to-date Docker image with Oxide.

This image aims to be a solid base to run any plugin. So please drop me a line if you are missing any Debian package
for a plugin.

## Usage
### Configuration
You can append all [server configuration options](https://www.corrosionhour.com/rust-admin-commands/) as commands
when running `RustDedicated` binary. Use the regular syntax like `+server.ip 0.0.0.0` or `-logfile`.

As the Rust server is running in the Docker container as a stateless application, you want to have all stateful server
data (map, config, blueprints etc.) stored in a [Docker volume](https://docs.docker.com/storage/volumes/)
which is persisted outside of the container. This can be configured with `+server.identity`: you can specify the
directory where this data is stored. You need to make sure that this directory is mounted on
a [Docker Volume](https://docs.docker.com/storage/volumes/).

This is especially important because you need to update the Rust server Docker image every month when Facepunch
releases a new software update. When you use a [Docker volume](https://docs.docker.com/storage/volumes/) to store
the `+server.identity`, all the data is still intact.

Check out the [docker compose](examples/docker-compose/README.md) and the
[docker compose production](examples/docker-compose-production/README.md) examples to learn about
the details. 

### Docker Run
For testing purposes, you can fire up a Docker container like this:
```shell
docker run -it --publish 28015:28015/udp --publish 28016:28016/tcp pfeiffermax/rust-game-server:latest +server.ip 0.0.0.0 +server.port 28015 +rcon.ip 0.0.0.0 +rcon.port 28016
```

### Docker Compose
With docker compose you have your own [Rust](https://rust.facepunch.com/) server up and running in no-time. For this,
just clone this repo (or just copy and paste the [compose.yaml](examples/docker-compose/compose.yaml) file to your
machine) and run the server with Docker compose like this:
```shell
git clone https://github.com/max-pfeiffer/rust-game-server-docker.git
cd rust-game-server-docker/examples/docker-compose
docker compose up
```
You can also run the [Rust](https://rust.facepunch.com/) server in the background with option `-d`:
```shell
docker compose up -d
```
And show the logs, option `-f` follows the logs:
```shell
docker compose logs -f
```

If you want to connect to [Rust](https://rust.facepunch.com/) server console via RCON use the [CLI client](https://github.com/gorcon/rcon-cli):
```shell
docker compose run -it --rm rcon-cli
[+] Creating 1/0
 ✔ Container rust-server  Running                                                                                                                                             0.0s 
Waiting commands for rust-server:28016 (or type :q to exit)
> 
```

### Production Deployment
If you want to deploy to a production (Linux) server, have a look at the
[docker compose production example documentation](examples/docker-compose-production/README.md).

## Additional Information Sources
* [SteamDB](https://steamdb.info/app/258550/info/)
* [Official Rust Wiki](https://wiki.facepunch.com/rust/)
* [Valve Wiki](https://developer.valvesoftware.com/wiki/Rust_Dedicated_Server)
* [Admin commands list](https://www.corrosionhour.com/rust-admin-commands/)

# Rust Game Server Docker

This repository contains Docker configurations for running a Rust game server.

## Coolify Deployment

The `docker-compose.yaml` in the root directory is optimized for deployment on Coolify.

### Features

- **Easy deployment**: Just point Coolify to this repository
- **Automatic environment variable handling**: Uses Coolify's predefined variables
- **Traefik integration**: Web-based RCON interface accessible through Coolify's reverse proxy
- **Direct port access**: Game server UDP port (28015) is exposed directly

### Environment Variables

The configuration uses hardcoded values for stability but can be customized in Coolify UI:

- `SERVER_NAME`: Name of your Rust server (default: RustServer)
- `RCON_PASSWORD`: Password for RCON access (default: rustpassword)

### Working with Coolify Variables

The deployment leverages Coolify's predefined variables:
- `COOLIFY_FQDN`: Used for the Traefik host rule
- `COOLIFY_URL` and `COOLIFY_RESOURCE_UUID`: Available to the application

You can also use Coolify's shared variables by defining them in:
- Team settings: Use as `${team.VARIABLE_NAME}`
- Project settings: Use as `${project.VARIABLE_NAME}`
- Environment settings: Use as `${environment.VARIABLE_NAME}`

### Quick Deployment Steps

1. In Coolify, create a new "Docker Compose" resource
2. Connect to this Git repository (use the root directory)
3. Configure any custom environment variables if needed
4. Deploy the resource
5. Make sure the following ports are accessible from the internet:
   - **28015/UDP**: The main Rust game server port
   - **28016/TCP**: RCON interface port (if accessing directly, not through the web interface)

### Networking in Coolify

- The **game server** (UDP port 28015) is exposed directly and **not** through the reverse proxy
- The **RCON web interface** is accessible through Coolify's Traefik proxy using the `COOLIFY_FQDN`
- If your server is behind NAT, make sure to forward port 28015/UDP to your server

### Notes

- Logs are stored in a `./logs` directory that will be automatically created
- Server data is persisted in a Docker volume
- The RCON web interface is enabled by default (set by `+rcon.web 1`)

### Advanced Configuration

If you need additional Docker options, you can add them in the Coolify UI under "Custom Docker Options", such as:
```
--ulimit nofile=1000000:1000000
```

For more detailed examples and configurations, see the `examples/` directory.
