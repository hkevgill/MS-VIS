# Docker Mass Spectrum App

www.mass-spectrum.com

## How to get Application working:

### Clone App

```
git clone https://github.com/hkevgill/docker-maldi-app.git
```
### Building App

```
docker build -t mass-spectrum-image .
```

### Running App

```
docker run --rm -it -p 8080:8080 mass-spectrum-image
```
