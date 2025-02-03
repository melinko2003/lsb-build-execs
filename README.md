# lsb-build-execs
Ephemeral Build Environment for Land Sand Boat Server Executables. 

# Build Execs
## Build the Init Container
```bash
$ git clone https://github.com/melinko2003/lsb-vanilla-init
$ cd lsb-vanilla-init
$ docker buildx build --build-arg LSB_BRANCH=base -t lsb-vanilla-init:latest -f Dockerfile.init .
```
Use the Container from CLI. This will create the lsb/ffxi directories, and files to build the project.
```bash
$ docker run -it -v ./lsb/ffxi:/opt/ffxi ffxi-vanilla-lsb-init:latest
```
## Build the Execs Builder Container
```bash
$ git clone https://github.com/melinko2003/lsb-build-exec
$ docker buildx build -t lsb-build-exec:latest -f Dockerfile .
```
Use the Container from CLI. This will create the lsb/ffxi Execs, and back them up.
```bash
$ docker run -it -v ./lsb/ffxi:/opt/ffxi lsb-build-exec:latest
```
## Build the Execs with Compose
Local Build
```bash
$ docker-compose build -f compose-build.yml
$ docker-compose up -f compose-build.yml
```
Use the Container in compose-build.yml
```yaml
--- 
version: '3.1'

services:

  # Grab all the Resources:
  init:
    image: ghcr.io/melinko2003/lsb-vanilla-init:latest
    restart: "no"
    volumes:
      - ./lsb/ffxi:/opt/ffxi

  build:
    depends_on:
      - init
    # image: ghcr.io/melinko2003/lsb-build-execs:latest
    image: lsb-build-execs
    build:
      context: .
      dockerfile: Dockerfile
    restart: "no"
    volumes:
      - ./lsb/ffxi:/opt/ffxi
```
Full Container Build
```bash
$ docker-compose up -f compose.yml
```
Use the Container in compose.yml
```yaml
--- 
version: '3.1'

services:

  # Grab all the Resources:
  init:
    image: ghcr.io/melinko2003/lsb-vanilla-init:latest
    restart: "no"
    volumes:
      - ./lsb/ffxi:/opt/ffxi

  build:
    image: ghcr.io/melinko2003/lsb-build-execs:latest
    restart: "no"
    volumes:
      - ./lsb/ffxi:/opt/ffxi
```
# Misc Accounting
```bash
$ du -h --max-depth=1
3.5G    ./lsb
200K    ./.git
3.5G    .
```