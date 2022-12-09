Docker builds for [Stellaris Dashboard](https://github.com/eliasdoehne/stellaris-dashboard/)

# Setup

## Clone this repository

```
git clone https://github.com/chennin/stellaris-dashboard-docker.git
```

## config.yml

Most of the configuration settings can be edited in the dashboard itself, but the settings might be lost if you don't mount `config.yml` outside the container. Prepare for that with:

```
touch config.yml
chown 1000:1000 config.yml
```

## Output directories

### Localisation files required

As documented [here](https://github.com/eliasdoehne/stellaris-dashboard#names-and-localizations), you will need to know the location of and/or copy some of the game's localisation files to a place docker can access them.

### Save file location required

You'll need to know where your [saves are located](https://stellaris.paradoxwikis.com/Save-game_editing), or set something up to copy them. I use [Syncthing](https://syncthing.net/) to copy from Windows to Linux.

### Directory setup

Edit `./env` to point at your localisation and save folders. They must be readable by user ID 1000.

### Output directory

Create a dir for output (database files and galaxy timelapse images):

```
mkdir output
chown 1000:1000 output
```

## Run the image with docker-compose

Run:

```
docker-compose up -d
```

Then head to http://localhost:28053
