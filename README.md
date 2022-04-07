# pfc-hello-docker

This repository contains an example how to create a basic Docker image for WAGO PFC200 G2 devices.

## Quichstart

### Prerequisites

- on host PC, the following tools must be installed
  - Docker
  - Make
  - SSH
- on PFC200 G2 device
  - install FW21
  - run firmware from internal memory
  - activate Docker

### Create Image

````
make
````

Use make to create the docker image. The first build will take some time, consecutive builds will be faster. After successful build, the resulting image can be found at `build/pfc-hello.dockerimage`.

### Run Image

- copy the image to PFC200 G2 device  
  `scp build/pfc-hello.dockerimage root@pfc:/tmp`
- load the image
  `ssh root@pfc docker load -i /tmp/pfc-hello.dockerimage`
- run the image
  `ssh -t root@pfc docker run -it --rm pfc-hello`

## Build Logic

In order to build the target image that runs on PFC200 G2, a two staged build is performed.

The first stage is used to create the so-called builder image. The build image contains a PFC200 G2 development environment based on [https://github.com/WAGO/pfc-firmware-sdk-G2](https://github.com/WAGO/pfc-firmware-sdk-G2). During creating the builder image, a first build is performed to cache build results and speedup consecutive builds.  
The builder image can be used as a standalone image during development. Use `make run` to enter build environment.

The second stage created the target image. Therefore, the builder image is used. The source files contained in the `src` directory is bind-mounted into the container an the build is performed to create a root filesystem. Afterwards, the target image is created from the root filesystem.

## Makefile Wrapper

A Makefile wrapper is used as convenience to ease creating the image.

| Command       | Description |
| ------------- | ----------- |
| make          | creates the target image `build/pfc-hello.dockerimage` |
| make run      | enters the build environment |
| make clean    | cleans up build results |
| make disclean | cleans up build results and removes builder and target images |

### src Directory

During build and also when the build environment is entered using `make run` the `src` directory is bind-mounted into the builder container at `/home/user/ptxproj/local_src/hello`. This can be used during development to edit source files localy with our favorite editor while accessing the build environment of the running container.

### build Directory

During uild and also when the build environment is entered using `make run` the `build` directory is bind-mounted into the builder container at `/backup`. This can be used to exchange data between host and the running container.

## Handling large user IDs

When the builder image is created, the user ID of the user `user` inside the container is changed to match the user ID of the user running the Makefile. This is done to ease data exchange between the host PC and the running container.

However, this might trigger an error when large user IDs are used (see [https://github.com/moby/moby/issues/5419](https://github.com/moby/moby/issues/5419) for further information). To prevent this, the user ID can be specfied when the Makefile is called:

````
make USERID=1000
````

Alternatively, a file named `config.mk` can be created in the project's root directory that contains the user ID:

````
USERID?=1000
````

## License

The Dockerfile and the make wrapper are released to the public domain in terms of [the Unlicense](http://unlicense.org).

However, the resulting docker image is comprised of software using different licenses including GPL, MPL and others. Please use the docker image with respect to that.
