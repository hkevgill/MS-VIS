# Docker Mass Spectrum App

mass-spectrum.com

## How to get Application working:

### Clone App

```
git clone https://github.com/hkevgill/docker-maldi-app.git
```
### Building App

```
docker build -t mass-spectrum-image
```

### Running App

```
docker run --rm -itd -p 8080:8080 mass-spectrum-image
```

## Heroku deploy

```
git push heroku main
```

## DigitalOcean

droplet root user password: anujbjorn2021Kevinmassspec
