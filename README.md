# docker-foswiki

## Why I created this dockerfile?
I've found no one create a new version of foswiki with docker, so I created one.
And I minized the size of docker with alpinelinux, the total size for this image is `144MB`.

## How to use
```bash
docker run -idt -p 80:80 timlegge/docker-foswiki
```
### Running with persist storage

```bash
docker run --rm --name docker-foswiki -idt -p 80:80 -v foswiki_www:/var/www/foswiki:z timlegge/docker-foswiki
```

  * The assumption avove is that the user running the command is in the docker group otherwise sudo is required
  * The -rm removes the container after it stops running (useful for testing)
  * The -v says to create a docker volume on the host system named foswiki_www and mount it to /var/www/foswiki in the running container
  * The :z after the volume is necessary with selinux on RedHat to set the permissions correctly

The volume is located on the host at /var/lib/docker/volumes/foswili_www and will keep any change you make when configuring the container

## How to Build
You can build the docker image yourself from the git clone.  Dimply do the following in the git directory:
```bash
sudo docker build --no-cache -t docker-foswiki .
```
Building the docker image requires parts of the build process to get access to the internet so if you have a proxy server you will need to follow the directions below to pass the proxy settings to the bulid prodess
```bash
sudo docker build --no-cache  --build-arg https_proxy=http://proxy.example.com:8080 --build-arg http_proxy=http://proxy.example.com:8080 --build-arg HTTPS_PROXY=http://proxy.example.com:8080 --build-arg HTTP_PROXY=http://proxy.example.com:8080 -t docker-foswiki .
```
Unfortunately as the build use's wget, perl LWP and apk from AlpineLinux all four environment variables are necessary as each uses a different case or protocol to download the proper files.

## How to run the Build
```bash
sudo docker run --name docker-foswiki -d  -p 80:80 docker-foswiki
```
## How to access the running container as root
```bash
sudo docker exec -it docker-foswiki /bin/sh
``` 
## How to stop the container
```bash
sudo docker stop docker-foswiki
``` 
## How to remove the container
```bash
sudo docker rm docker-foswiki
``` 
## How to publish image to Docker Hub
```bash
sudo docker login
sudo docker tag docker-foswiki $DOCKER_ID_USER/docker-foswiki
sudo docker push timlegge/docker-foswiki
``` 

## License
MIT
