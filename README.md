Docker builds for [Stellaris Dashboard](https://github.com/eliasdoehne/stellaris-dashboard/)

## Localisation files required

As documented [here](https://github.com/eliasdoehne/stellaris-dashboard#names-and-localizations), you will need to know the location of and/or copy some of the game's localisation files to the some place docker can access them.

## Docker Compose

An example `docker-compose.yaml` is provided. To use it:

```
mkdir saves localisation output
chown 1000:1000 output
chmod 755 localisation saves
```

Copy your localisation files (see above) to the `localisation` folder, or you can change the path in `docker-compose.yaml` if you already have them locally.

```
docker-compose up -d
```

Then head to http://localhost:28053


Most of the configuration settings can be edited in the dashboard itself. Optionally, you can mount it externally by uncommenting the volume in `docker-compose.yaml` and running:


```
touch config.yml
chown 1000:1000 config.yml
```
